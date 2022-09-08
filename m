Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93605B242D
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 19:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiIHREd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 13:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiIHRE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 13:04:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFD5E46
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 10:04:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AC54B80E1C
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 17:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66236C433C1;
        Thu,  8 Sep 2022 17:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662656662;
        bh=Mhj78v8/AS7ddQX8wGv80L+qGVbUVKT+pVCkgguMSeg=;
        h=Subject:To:Cc:From:Date:From;
        b=z4vCsuQJBolAsMocIzZHM8uYGvMZHt3ZOrUFHTdxZpE3mE2rw2Rr7oOWLxqil73Ry
         2EujlsPqS/EwNTnPKbii++CrtFA7VvCQntoGoNvBMMRbhfin6Mm4e5nfE+fTSRC7G9
         Qz2N5z60ImgbF4Qd/vwvywKZk1OC9W0wyTs3Xj5c=
Subject: FAILED: patch "[PATCH] ext4: fix super block checksum incorrect after mount" failed to apply to 5.10-stable tree
To:     yebin10@huawei.com, jack@suse.cz, ritesh.list@gmail.com,
        tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 08 Sep 2022 19:04:30 +0200
Message-ID: <166265667054225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

9b6641dd95a0 ("ext4: fix super block checksum incorrect after mount")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9b6641dd95a0c441b277dd72ba22fed8d61f76ad Mon Sep 17 00:00:00 2001
From: Ye Bin <yebin10@huawei.com>
Date: Wed, 25 May 2022 09:29:04 +0800
Subject: [PATCH] ext4: fix super block checksum incorrect after mount
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We got issue as follows:
[home]# mount  /dev/sda  test
EXT4-fs (sda): warning: mounting fs with errors, running e2fsck is recommended
[home]# dmesg
EXT4-fs (sda): warning: mounting fs with errors, running e2fsck is recommended
EXT4-fs (sda): Errors on filesystem, clearing orphan list.
EXT4-fs (sda): recovery complete
EXT4-fs (sda): mounted filesystem with ordered data mode. Quota mode: none.
[home]# debugfs /dev/sda
debugfs 1.46.5 (30-Dec-2021)
Checksum errors in superblock!  Retrying...

Reason is ext4_orphan_cleanup will reset ‘s_last_orphan’ but not update
super block checksum.

To solve above issue, defer update super block checksum after
ext4_orphan_cleanup.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Cc: stable@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220525012904.1604737-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b2ecae8adbfc..13d562d11235 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5302,14 +5302,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
 					  GFP_KERNEL);
 	}
-	/*
-	 * Update the checksum after updating free space/inode
-	 * counters.  Otherwise the superblock can have an incorrect
-	 * checksum in the buffer cache until it is written out and
-	 * e2fsprogs programs trying to open a file system immediately
-	 * after it is mounted can fail.
-	 */
-	ext4_superblock_csum_set(sb);
 	if (!err)
 		err = percpu_counter_init(&sbi->s_dirs_counter,
 					  ext4_count_dirs(sb), GFP_KERNEL);
@@ -5367,6 +5359,14 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
+	/*
+	 * Update the checksum after updating free space/inode counters and
+	 * ext4_orphan_cleanup. Otherwise the superblock can have an incorrect
+	 * checksum in the buffer cache until it is written out and
+	 * e2fsprogs programs trying to open a file system immediately
+	 * after it is mounted can fail.
+	 */
+	ext4_superblock_csum_set(sb);
 	if (needs_recovery) {
 		ext4_msg(sb, KERN_INFO, "recovery complete");
 		err = ext4_mark_recovery_complete(sb, es);

