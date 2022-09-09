Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910D95B3ED2
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiIISbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiIISbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:31:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4403124609
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 163C66200E
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 18:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298ACC433D6;
        Fri,  9 Sep 2022 18:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662748273;
        bh=Yn+6LE8Jka+Z4JDrUdv4NXACgUejpNLDcdvp1KM6s+Y=;
        h=Subject:To:Cc:From:Date:From;
        b=MJZNzgak7ToSfQVtSdl2Ia3/zI9nbdlqPtF/B5Z1Z1uIz3ju4bYX4Hp2+MNZXbaa8
         VCqJx1IR8JUCEwRv212T+gFfF+L/yjMypgZliUAtrZTqa1n7hdQWAwQfPrW0ofX5HI
         /IJ1dEpE3UEkeOrlYBpuzTfhSVvyjJDcFyI34Awg=
Subject: FAILED: patch "[PATCH] tracefs: Only clobber mode/uid/gid on remount if asked" failed to apply to 5.10-stable tree
To:     briannorris@chromium.org, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Sep 2022 20:31:02 +0200
Message-ID: <1662748262160129@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

47311db8e8f3 ("tracefs: Only clobber mode/uid/gid on remount if asked")
851e99ebeec3 ("tracefs: Set the group ownership in apply_options() not parse_options()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 47311db8e8f33011d90dee76b39c8886120cdda4 Mon Sep 17 00:00:00 2001
From: Brian Norris <briannorris@chromium.org>
Date: Fri, 26 Aug 2022 17:44:17 -0700
Subject: [PATCH] tracefs: Only clobber mode/uid/gid on remount if asked

Users may have explicitly configured their tracefs permissions; we
shouldn't overwrite those just because a second mount appeared.

Only clobber if the options were provided at mount time.

Note: the previous behavior was especially surprising in the presence of
automounted /sys/kernel/debug/tracing/.

Existing behavior:

  ## Pre-existing status: tracefs is 0755.
  # stat -c '%A' /sys/kernel/tracing/
  drwxr-xr-x

  ## (Re)trigger the automount.
  # umount /sys/kernel/debug/tracing
  # stat -c '%A' /sys/kernel/debug/tracing/.
  drwx------

  ## Unexpected: the automount changed mode for other mount instances.
  # stat -c '%A' /sys/kernel/tracing/
  drwx------

New behavior (after this change):

  ## Pre-existing status: tracefs is 0755.
  # stat -c '%A' /sys/kernel/tracing/
  drwxr-xr-x

  ## (Re)trigger the automount.
  # umount /sys/kernel/debug/tracing
  # stat -c '%A' /sys/kernel/debug/tracing/.
  drwxr-xr-x

  ## Expected: the automount does not change other mount instances.
  # stat -c '%A' /sys/kernel/tracing/
  drwxr-xr-x

Link: https://lkml.kernel.org/r/20220826174353.2.Iab6e5ea57963d6deca5311b27fb7226790d44406@changeid

Cc: stable@vger.kernel.org
Fixes: 4282d60689d4f ("tracefs: Add new tracefs file system")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 81d26abf486f..da85b3979195 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -141,6 +141,8 @@ struct tracefs_mount_opts {
 	kuid_t uid;
 	kgid_t gid;
 	umode_t mode;
+	/* Opt_* bitfield. */
+	unsigned int opts;
 };
 
 enum {
@@ -241,6 +243,7 @@ static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 	kgid_t gid;
 	char *p;
 
+	opts->opts = 0;
 	opts->mode = TRACEFS_DEFAULT_MODE;
 
 	while ((p = strsep(&data, ",")) != NULL) {
@@ -275,24 +278,36 @@ static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 		 * but traditionally tracefs has ignored all mount options
 		 */
 		}
+
+		opts->opts |= BIT(token);
 	}
 
 	return 0;
 }
 
-static int tracefs_apply_options(struct super_block *sb)
+static int tracefs_apply_options(struct super_block *sb, bool remount)
 {
 	struct tracefs_fs_info *fsi = sb->s_fs_info;
 	struct inode *inode = d_inode(sb->s_root);
 	struct tracefs_mount_opts *opts = &fsi->mount_opts;
 
-	inode->i_mode &= ~S_IALLUGO;
-	inode->i_mode |= opts->mode;
+	/*
+	 * On remount, only reset mode/uid/gid if they were provided as mount
+	 * options.
+	 */
+
+	if (!remount || opts->opts & BIT(Opt_mode)) {
+		inode->i_mode &= ~S_IALLUGO;
+		inode->i_mode |= opts->mode;
+	}
 
-	inode->i_uid = opts->uid;
+	if (!remount || opts->opts & BIT(Opt_uid))
+		inode->i_uid = opts->uid;
 
-	/* Set all the group ids to the mount option */
-	set_gid(sb->s_root, opts->gid);
+	if (!remount || opts->opts & BIT(Opt_gid)) {
+		/* Set all the group ids to the mount option */
+		set_gid(sb->s_root, opts->gid);
+	}
 
 	return 0;
 }
@@ -307,7 +322,7 @@ static int tracefs_remount(struct super_block *sb, int *flags, char *data)
 	if (err)
 		goto fail;
 
-	tracefs_apply_options(sb);
+	tracefs_apply_options(sb, true);
 
 fail:
 	return err;
@@ -359,7 +374,7 @@ static int trace_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_op = &tracefs_super_operations;
 
-	tracefs_apply_options(sb);
+	tracefs_apply_options(sb, false);
 
 	return 0;
 

