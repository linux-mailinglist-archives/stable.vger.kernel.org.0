Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4442F3C9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbfE3EcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729540AbfE3DNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:39 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 409732455A;
        Thu, 30 May 2019 03:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186019;
        bh=3Elnot2lwNaYAlunu3Em5A3sFbosURBUBeaxd2sUk6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXa7buRwQ6onAZ5nZfoL3+EP3M0Gt2G0I9XAkY1VW6DVXad9ugw+hqT7RsucULXDu
         gPSaNOygHU8mKcmlcQa+cIne0dPy63bAuHJMkW8nn9qHeq3yv5nt3eKoMg4On9RHdg
         tmTS/iM53a6RHXa/3U/iSZLsoDfq9EOclr8Il7Gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Robbie Ko <robbieko@synology.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 087/346] Btrfs: fix data bytes_may_use underflow with fallocate due to failed quota reserve
Date:   Wed, 29 May 2019 20:02:40 -0700
Message-Id: <20190530030545.573891276@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
index 5681c667a098f..7f082b019766c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3142,6 +3142,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 			ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
 					cur_offset, last_byte - cur_offset);
 			if (ret < 0) {
+				cur_offset = last_byte;
 				free_extent_map(em);
 				break;
 			}
@@ -3191,7 +3192,7 @@ static long btrfs_fallocate(struct file *file, int mode,
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



