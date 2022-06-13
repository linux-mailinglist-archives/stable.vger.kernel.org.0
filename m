Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB0A5480AA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiFMHg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiFMHg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:36:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38765B46
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C82A360FAB
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA65CC34114;
        Mon, 13 Jun 2022 07:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655105783;
        bh=E+IcJpAuWtg6wz12T8zzJJ17Lf9hO3+t6/VqHnJ1AtY=;
        h=Subject:To:Cc:From:Date:From;
        b=nuCVZk+TP0APohqtoSUYs8pSES0ndff/ys/ksjEqOyZ/xcGnAeQMIby6VK4ZKmfQH
         1jyfu9nSazuaCzx/QvCZDO26EcP450/pE/gYGZ7Wyi6VvMwabmU8nYb+IzcbJ8Dkha
         7Gp3uSAv5xJ+HOqUUu9K4D85qNrYFzkeLrptYHpc=
Subject: FAILED: patch "[PATCH] zonefs: fix handling of explicit_open option on mount" failed to apply to 5.10-stable tree
To:     damien.lemoal@opensource.wdc.com, hch@lst.de,
        johannes.thumshirn@wdc.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:36:20 +0200
Message-ID: <1655105780141166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a2a513be7139b279f1b5b2cee59c6c4950c34346 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Thu, 2 Jun 2022 23:16:57 +0900
Subject: [PATCH] zonefs: fix handling of explicit_open option on mount

Ignoring the explicit_open mount option on mount for devices that do not
have a limit on the number of open zones must be done after the mount
options are parsed and set in s_mount_opts. Move the check to ignore
the explicit_open option after the call to zonefs_parse_options() in
zonefs_fill_super().

Fixes: b5c00e975779 ("zonefs: open/close zone on file open/close")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index bcb21aea990a..ecce84909ca1 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1760,12 +1760,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 
 	atomic_set(&sbi->s_wro_seq_files, 0);
 	sbi->s_max_wro_seq_files = bdev_max_open_zones(sb->s_bdev);
-	if (!sbi->s_max_wro_seq_files &&
-	    sbi->s_mount_opts & ZONEFS_MNTOPT_EXPLICIT_OPEN) {
-		zonefs_info(sb, "No open zones limit. Ignoring explicit_open mount option\n");
-		sbi->s_mount_opts &= ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
-	}
-
 	atomic_set(&sbi->s_active_seq_files, 0);
 	sbi->s_max_active_seq_files = bdev_max_active_zones(sb->s_bdev);
 
@@ -1790,6 +1784,12 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	zonefs_info(sb, "Mounting %u zones",
 		    blkdev_nr_zones(sb->s_bdev->bd_disk));
 
+	if (!sbi->s_max_wro_seq_files &&
+	    sbi->s_mount_opts & ZONEFS_MNTOPT_EXPLICIT_OPEN) {
+		zonefs_info(sb, "No open zones limit. Ignoring explicit_open mount option\n");
+		sbi->s_mount_opts &= ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
+	}
+
 	/* Create root directory inode */
 	ret = -ENOMEM;
 	inode = new_inode(sb);

