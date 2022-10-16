Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D76B5FFF45
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 14:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJPMro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 08:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiJPMrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 08:47:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ED13DBE0
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 05:47:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B19D3B80CA7
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 12:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A5FC433D6;
        Sun, 16 Oct 2022 12:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665924453;
        bh=stEtZazh8PGuIXEJ/piCjIoDvGPMxjoFNoBAbMdKkRU=;
        h=Subject:To:Cc:From:Date:From;
        b=dOh7L4FwZfrWIJBPcIykIm6KBnIqIuS1O0B5UusxK3Ny4GG8Vk8fl3dvoS5frK7b9
         EVAONQEWp1TrlUxZRPjIHxQB7j8lu+iEMQsBcFvqhM0lwqe0sxWuSh5ddMG76r2Wb3
         Hv8Cu8LGmSOAOglnpgelXqAmuhbHAmXJ+1UC7APg=
Subject: FAILED: patch "[PATCH] f2fs: fix to do sanity check on summary info" failed to apply to 4.19-stable tree
To:     chao@kernel.org, jaegeuk@kernel.org, wenqingliu0120@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 14:48:19 +0200
Message-ID: <16659244995911@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c6ad7fd16657 ("f2fs: fix to do sanity check on summary info")
77900c45ee5c ("f2fs: fix to do sanity check in is_alive()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c6ad7fd16657ebd34a87a97d9588195aae87597d Mon Sep 17 00:00:00 2001
From: Chao Yu <chao@kernel.org>
Date: Wed, 14 Sep 2022 19:51:51 +0800
Subject: [PATCH] f2fs: fix to do sanity check on summary info

As Wenqing Liu reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=216456

BUG: KASAN: use-after-free in recover_data+0x63ae/0x6ae0 [f2fs]
Read of size 4 at addr ffff8881464dcd80 by task mount/1013

CPU: 3 PID: 1013 Comm: mount Tainted: G        W          6.0.0-rc4 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
Call Trace:
 dump_stack_lvl+0x45/0x5e
 print_report.cold+0xf3/0x68d
 kasan_report+0xa8/0x130
 recover_data+0x63ae/0x6ae0 [f2fs]
 f2fs_recover_fsync_data+0x120d/0x1fc0 [f2fs]
 f2fs_fill_super+0x4665/0x61e0 [f2fs]
 mount_bdev+0x2cf/0x3b0
 legacy_get_tree+0xed/0x1d0
 vfs_get_tree+0x81/0x2b0
 path_mount+0x47e/0x19d0
 do_mount+0xce/0xf0
 __x64_sys_mount+0x12c/0x1a0
 do_syscall_64+0x38/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The root cause is: in fuzzed image, SSA table is corrupted: ofs_in_node
is larger than ADDRS_PER_PAGE(), result in out-of-range access on 4k-size
page.

- recover_data
 - do_recover_data
  - check_index_in_prev_nodes
   - f2fs_data_blkaddr

This patch adds sanity check on summary info in recovery and GC flow
in where the flows rely on them.

After patch:
[   29.310883] F2FS-fs (loop0): Inconsistent ofs_in_node:65286 in summary, ino:0, nid:6, max:1018

Cc: stable@vger.kernel.org
Reported-by: Wenqing Liu <wenqingliu0120@gmail.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index fd400d148afb..3a820e5cdaee 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1078,7 +1078,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 {
 	struct page *node_page;
 	nid_t nid;
-	unsigned int ofs_in_node;
+	unsigned int ofs_in_node, max_addrs;
 	block_t source_blkaddr;
 
 	nid = le32_to_cpu(sum->nid);
@@ -1104,6 +1104,14 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		return false;
 	}
 
+	max_addrs = IS_INODE(node_page) ? DEF_ADDRS_PER_INODE :
+						DEF_ADDRS_PER_BLOCK;
+	if (ofs_in_node >= max_addrs) {
+		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
+			ofs_in_node, dni->ino, dni->nid, max_addrs);
+		return false;
+	}
+
 	*nofs = ofs_of_node(node_page);
 	source_blkaddr = data_blkaddr(NULL, node_page, ofs_in_node);
 	f2fs_put_page(node_page, 1);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 8326003e6918..5c9facec98f6 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -474,7 +474,7 @@ static int check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 	struct dnode_of_data tdn = *dn;
 	nid_t ino, nid;
 	struct inode *inode;
-	unsigned int offset;
+	unsigned int offset, ofs_in_node, max_addrs;
 	block_t bidx;
 	int i;
 
@@ -501,15 +501,24 @@ static int check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 got_it:
 	/* Use the locked dnode page and inode */
 	nid = le32_to_cpu(sum.nid);
+	ofs_in_node = le16_to_cpu(sum.ofs_in_node);
+
+	max_addrs = ADDRS_PER_PAGE(dn->node_page, dn->inode);
+	if (ofs_in_node >= max_addrs) {
+		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%lu, nid:%u, max:%u",
+			ofs_in_node, dn->inode->i_ino, nid, max_addrs);
+		return -EFSCORRUPTED;
+	}
+
 	if (dn->inode->i_ino == nid) {
 		tdn.nid = nid;
 		if (!dn->inode_page_locked)
 			lock_page(dn->inode_page);
 		tdn.node_page = dn->inode_page;
-		tdn.ofs_in_node = le16_to_cpu(sum.ofs_in_node);
+		tdn.ofs_in_node = ofs_in_node;
 		goto truncate_out;
 	} else if (dn->nid == nid) {
-		tdn.ofs_in_node = le16_to_cpu(sum.ofs_in_node);
+		tdn.ofs_in_node = ofs_in_node;
 		goto truncate_out;
 	}
 

