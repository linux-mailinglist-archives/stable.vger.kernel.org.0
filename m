Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47EE5B282E
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 23:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiIHVMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 17:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiIHVMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 17:12:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0107FE125D;
        Thu,  8 Sep 2022 14:12:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC3E5B8229B;
        Thu,  8 Sep 2022 21:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631BFC43470;
        Thu,  8 Sep 2022 21:12:38 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oWOps-00DB4i-2p;
        Thu, 08 Sep 2022 17:13:20 -0400
Message-ID: <20220908211320.708265647@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 08 Sep 2022 17:13:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>
Subject: [for-linus][PATCH 2/2] tracefs: Only clobber mode/uid/gid on remount if asked
References: <20220908211302.262245973@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

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
---
 fs/tracefs/inode.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

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
 
-- 
2.35.1
