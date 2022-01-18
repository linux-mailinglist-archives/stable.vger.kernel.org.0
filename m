Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566094920D7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245613AbiARICp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:02:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42068 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343849AbiARICp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:02:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53FD9B81052
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7B1C00446;
        Tue, 18 Jan 2022 08:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642492963;
        bh=axZSZeVMT7OCS/u2VoMt1ffxsMQB6Gbg/l/AJbri6yY=;
        h=Subject:To:Cc:From:Date:From;
        b=kmedcXfvmhxNrUVq8/Hw6vbwtkYqBDerwnw+T/kHJCXO731CsHDPSRUT1DpCvnVUg
         teWq/d97J9FMbxg0V9hPUyQ2y5Z3+LuRBOzonVoD2BTnSwrqjssMI1bWKoULhOnxk3
         fLWAS+mqZc0ZEzVuZXay7Igu4UMfAeirBiQCNvOw=
Subject: FAILED: patch "[PATCH] exfat: fix i_blocks for files truncated over 4 GiB" failed to apply to 5.16-stable tree
To:     christophe.vu-brugier@seagate.com, linkinjeon@kernel.org,
        sj1557.seo@samsung.com, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 09:02:29 +0100
Message-ID: <164249294999228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 92fba084b79e6bc7b12fc118209f1922c1a2df56 Mon Sep 17 00:00:00 2001
From: Christophe Vu-Brugier <christophe.vu-brugier@seagate.com>
Date: Mon, 22 Nov 2021 22:02:37 +0900
Subject: [PATCH] exfat: fix i_blocks for files truncated over 4 GiB

In exfat_truncate(), the computation of inode->i_blocks is wrong if
the file is larger than 4 GiB because a 32-bit variable is used as a
mask. This is fixed and simplified by using round_up().

Also fix the same buggy computation in exfat_read_root() and another
(correct) one in exfat_fill_inode(). The latter was fixed another way
last month but can be simplified by using round_up() as well. See:

  commit 0c336d6e33f4 ("exfat: fix incorrect loading of i_blocks for
                        large files")

Fixes: 98d917047e8b ("exfat: add file operations")
Cc: stable@vger.kernel.org # v5.7+
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Christophe Vu-Brugier <christophe.vu-brugier@seagate.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 848166d6d5e9..d890fd34bb2d 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -251,8 +251,8 @@ void exfat_truncate(struct inode *inode, loff_t size)
 	else
 		mark_inode_dirty(inode);
 
-	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1)) &
-			~(sbi->cluster_size - 1)) >> inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
+				inode->i_blkbits;
 write_size:
 	aligned_size = i_size_read(inode);
 	if (aligned_size & (blocksize - 1)) {
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 5c442182f516..df805bd05508 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -602,8 +602,8 @@ static int exfat_fill_inode(struct inode *inode, struct exfat_dir_entry *info)
 
 	exfat_save_attr(inode, info->attr);
 
-	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1)) &
-		~((loff_t)sbi->cluster_size - 1)) >> inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
+				inode->i_blkbits;
 	inode->i_mtime = info->mtime;
 	inode->i_ctime = info->mtime;
 	ei->i_crtime = info->crtime;
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 1a2115d73a48..4b5d02b1df58 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -364,8 +364,8 @@ static int exfat_read_root(struct inode *inode)
 	inode->i_op = &exfat_dir_inode_operations;
 	inode->i_fop = &exfat_dir_operations;
 
-	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1))
-			& ~(sbi->cluster_size - 1)) >> inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
+				inode->i_blkbits;
 	ei->i_pos = ((loff_t)sbi->root_dir << 32) | 0xffffffff;
 	ei->i_size_aligned = i_size_read(inode);
 	ei->i_size_ondisk = i_size_read(inode);

