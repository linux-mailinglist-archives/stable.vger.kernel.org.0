Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C97C226F6A
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731870AbfEVT4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbfEVTZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:25:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F46C217D7;
        Wed, 22 May 2019 19:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553104;
        bh=SHTanGl498Jp+C/3CVisWEVSVFlCHF+CC9lNTtyLOMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htRO7uCpWnyztMJTjbp5cJMJeb1E2C7naW2bRGPU7LIRqWkQm+bJf+k1Lx5uQIbWu
         wfH3KmGdaFsih15vRW8nkwdcQayzEWDm87ofOSzMKIYo7CbUE9Bet/VHyrjOsqccnr
         FjYch7B/9Lg1S77Sdwigcgxof8abapt0gSZfWtA0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 049/317] Btrfs: fix data bytes_may_use underflow with fallocate due to failed quota reserve
Date:   Wed, 22 May 2019 15:19:10 -0400
Message-Id: <20190522192338.23715-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

[ Upstream commit 39ad317315887c2cb9a4347a93a8859326ddf136 ]

When doing fallocate, we first add the range to the reserve_list and
then reserve the quota.  If quota reservation fails, we'll release all
reserved parts of reserve_list.

However, cur_offset is not updated to indicate that this range is
already been inserted into the list.  Therefore, the same range is freed
twice.  Once at list_for_each_entry loop, and once at the end of the
function.  This will result in WARN_ON on bytes_may_use when we free the
remaining space.

At the end, under the 'out' label we have a call to:

   btrfs_free_reserved_data_space(inode, data_reserved, alloc_start, alloc_end - cur_offset);

The start offset, third argument, should be cur_offset.

Everything from alloc_start to cur_offset was freed by the
list_for_each_entry_safe_loop.

Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use timely")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d38dc8c315337..ab5caf87ef481 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3132,6 +3132,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 			ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
 					cur_offset, last_byte - cur_offset);
 			if (ret < 0) {
+				cur_offset = last_byte;
 				free_extent_map(em);
 				break;
 			}
@@ -3181,7 +3182,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	/* Let go of our reservation. */
 	if (ret != 0 && !(mode & FALLOC_FL_ZERO_RANGE))
 		btrfs_free_reserved_data_space(inode, data_reserved,
-				alloc_start, alloc_end - cur_offset);
+				cur_offset, alloc_end - cur_offset);
 	extent_changeset_free(data_reserved);
 	return ret;
 }
-- 
2.20.1

