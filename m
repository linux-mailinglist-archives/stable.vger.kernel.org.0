Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A70B5FFF77
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJPNLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJPNLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:11:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEE23C8CE
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 06:11:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADA3BB80CB6
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253DAC433C1;
        Sun, 16 Oct 2022 13:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665925880;
        bh=i94LAJwMm8hrQEmdh9o3oee7aH2D48Rrehsi1+gLIcQ=;
        h=Subject:To:Cc:From:Date:From;
        b=I9SAtSfLlgH1RTZk6qLfAXR7Cg4Ff6iV1x2ABgqzW/9cO97T9jLOkTH5RvVJMmA0N
         62H6H4GzpT0+TMh72QBble5nYrTQ1T/xKRd+JRXo9YiYE9O76kL6XheqhVNEVGtw93
         iMO753E1U4xSWepFM5NnZduyKvt1TlH2n1hVzhC8=
Subject: FAILED: patch "[PATCH] ext2: Add sanity checks for group and filesystem size" failed to apply to 4.14-stable tree
To:     jack@suse.cz, oliver.sang@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 15:11:58 +0200
Message-ID: <166592591851118@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d766f2d1e3e3 ("ext2: Add sanity checks for group and filesystem size")
d9e9866803f7 ("ext2: Adjust indentation in ext2_fill_super")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d766f2d1e3e3bd44024a7f971ffcf8b8fbb7c5d2 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Sep 2022 17:24:42 +0200
Subject: [PATCH] ext2: Add sanity checks for group and filesystem size

Add sanity check that filesystem size does not exceed the underlying
device size and that group size is big enough so that metadata can fit
into it. This avoid trying to mount some crafted filesystems with
extremely large group counts.

Reported-by: syzbot+0f2f7e65a3007d39539f@syzkaller.appspotmail.com
Reported-by: kernel test robot <oliver.sang@intel.com> # Test fixup
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 252c742379cf..afb31af9302d 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1052,6 +1052,13 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 			sbi->s_blocks_per_group);
 		goto failed_mount;
 	}
+	/* At least inode table, bitmaps, and sb have to fit in one group */
+	if (sbi->s_blocks_per_group <= sbi->s_itb_per_group + 3) {
+		ext2_msg(sb, KERN_ERR,
+			"error: #blocks per group smaller than metadata size: %lu <= %lu",
+			sbi->s_blocks_per_group, sbi->s_inodes_per_group + 3);
+		goto failed_mount;
+	}
 	if (sbi->s_frags_per_group > sb->s_blocksize * 8) {
 		ext2_msg(sb, KERN_ERR,
 			"error: #fragments per group too big: %lu",
@@ -1065,9 +1072,14 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 			sbi->s_inodes_per_group);
 		goto failed_mount;
 	}
+	if (sb_bdev_nr_blocks(sb) < le32_to_cpu(es->s_blocks_count)) {
+		ext2_msg(sb, KERN_ERR,
+			 "bad geometry: block count %u exceeds size of device (%u blocks)",
+			 le32_to_cpu(es->s_blocks_count),
+			 (unsigned)sb_bdev_nr_blocks(sb));
+		goto failed_mount;
+	}
 
-	if (EXT2_BLOCKS_PER_GROUP(sb) == 0)
-		goto cantfind_ext2;
 	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
 				le32_to_cpu(es->s_first_data_block) - 1)
 					/ EXT2_BLOCKS_PER_GROUP(sb)) + 1;

