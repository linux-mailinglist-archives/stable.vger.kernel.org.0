Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49107592E07
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbiHOLRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241949AbiHOLRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:17:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D200D1EC58
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87606B80DFC
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1B2C433C1;
        Mon, 15 Aug 2022 11:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660562245;
        bh=JA1oxm3Hial4IK4oNez1wznTJ/gcocyCA9Wapdp/Gw8=;
        h=Subject:To:Cc:From:Date:From;
        b=ewjy3Ma3KongQpfr8NCGPcBoqFza2QNXh4S8FCKbzg8DfBgkfWmpvraAl7zoPtJRU
         2amxareoW9mlyDOXmQIAUtxkgeYHN9EhKA3LtlOcvUR1ok8x7CQMKKq7HvJBKHABzO
         m6oIIimAdOQ1CKt82pM9eaaDp/uYOX2BFpG59TNs=
Subject: FAILED: patch "[PATCH] ext4: fix warning in ext4_iomap_begin as race between bmap" failed to apply to 4.19-stable tree
To:     yebin10@huawei.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:17:20 +0200
Message-ID: <1660562240252248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 51ae846cff568c8c29921b1b28eb2dfbcd4ac12d Mon Sep 17 00:00:00 2001
From: Ye Bin <yebin10@huawei.com>
Date: Fri, 17 Jun 2022 09:39:35 +0800
Subject: [PATCH] ext4: fix warning in ext4_iomap_begin as race between bmap
 and write

We got issue as follows:
------------[ cut here ]------------
WARNING: CPU: 3 PID: 9310 at fs/ext4/inode.c:3441 ext4_iomap_begin+0x182/0x5d0
RIP: 0010:ext4_iomap_begin+0x182/0x5d0
RSP: 0018:ffff88812460fa08 EFLAGS: 00010293
RAX: ffff88811f168000 RBX: 0000000000000000 RCX: ffffffff97793c12
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: ffff88812c669160 R08: ffff88811f168000 R09: ffffed10258cd20f
R10: ffff88812c669077 R11: ffffed10258cd20e R12: 0000000000000001
R13: 00000000000000a4 R14: 000000000000000c R15: ffff88812c6691ee
FS:  00007fd0d6ff3740(0000) GS:ffff8883af180000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd0d6dda290 CR3: 0000000104a62000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 iomap_apply+0x119/0x570
 iomap_bmap+0x124/0x150
 ext4_bmap+0x14f/0x250
 bmap+0x55/0x80
 do_vfs_ioctl+0x952/0xbd0
 __x64_sys_ioctl+0xc6/0x170
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Above issue may happen as follows:
          bmap                    write
bmap
  ext4_bmap
    iomap_bmap
      ext4_iomap_begin
                            ext4_file_write_iter
			      ext4_buffered_write_iter
			        generic_perform_write
				  ext4_da_write_begin
				    ext4_da_write_inline_data_begin
				      ext4_prepare_inline_data
				        ext4_create_inline_data
					  ext4_set_inode_flag(inode,
						EXT4_INODE_INLINE_DATA);
      if (WARN_ON_ONCE(ext4_has_inline_data(inode))) ->trigger bug_on

To solved above issue hold inode lock in ext4_bamp.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20220617013935.397596-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 641c9af91641..7db52defcb16 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3147,13 +3147,15 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 {
 	struct inode *inode = mapping->host;
 	journal_t *journal;
+	sector_t ret = 0;
 	int err;
 
+	inode_lock_shared(inode);
 	/*
 	 * We can get here for an inline file via the FIBMAP ioctl
 	 */
 	if (ext4_has_inline_data(inode))
-		return 0;
+		goto out;
 
 	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
 			test_opt(inode->i_sb, DELALLOC)) {
@@ -3192,10 +3194,14 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 		jbd2_journal_unlock_updates(journal);
 
 		if (err)
-			return 0;
+			goto out;
 	}
 
-	return iomap_bmap(mapping, block, &ext4_iomap_ops);
+	ret = iomap_bmap(mapping, block, &ext4_iomap_ops);
+
+out:
+	inode_unlock_shared(inode);
+	return ret;
 }
 
 static int ext4_read_folio(struct file *file, struct folio *folio)

