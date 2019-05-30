Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A28B2F12A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfE3EKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729935AbfE3DQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:58 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC3032463F;
        Thu, 30 May 2019 03:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186218;
        bh=mB1JwBppuuYo9KbxWZGD36wEw4Y+aFhaE5D0Y/3vHP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BsVPh4lb43Cuz1pkWH0TJS96AsWBF79mhWbcVbr2Kcxk5xwpLtJ2I0e+e5a/UAq0
         Q66PuHoYDHapbbhOQ6UdHbwlRMDmIsHpfMJ7rRDxOBHNWGe9t75WSzb8dM99Z+8ncY
         FGbWfX8OJ/N5eUccyx86EVGErBzVCiQcqSUfDcYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Robbie Ko <robbieko@synology.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/276] Btrfs: fix data bytes_may_use underflow with fallocate due to failed quota reserve
Date:   Wed, 29 May 2019 20:03:58 -0700
Message-Id: <20190530030531.374696788@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index de4d3baec1616..e24c0a69ff5d4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3161,6 +3161,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 			ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
 					cur_offset, last_byte - cur_offset);
 			if (ret < 0) {
+				cur_offset = last_byte;
 				free_extent_map(em);
 				break;
 			}
@@ -3210,7 +3211,7 @@ static long btrfs_fallocate(struct file *file, int mode,
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



