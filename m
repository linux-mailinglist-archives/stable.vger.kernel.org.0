Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47831492A72
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346906AbiARQJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:09:57 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40958 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346828AbiARQIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:08:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 120AECE1A30;
        Tue, 18 Jan 2022 16:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5801C00446;
        Tue, 18 Jan 2022 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522128;
        bh=M04+IOqjZ8MjY1uWE3zqPozfZYLYhCtw3qbRPNTlDXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnCCgFFprtOHQ6PZxtUcEESMP+V6dKXdaVLa320wG+7ofHb5sTtQowqPkHIByUVg+
         CPN3ox9vyJwQ10Q0ozBMlOgUDIuSJZPRMd/M1bOpZsNBaL/QYzq8FE2hupyFqMUmLN
         zPc8fAHQptwVidCbeNlZnqHH6YuWBrZIb8wykikU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Al Viro <viro@zeniv.linux.org.uk>, NeilBrown <neilb@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 01/28] devtmpfs regression fix: reconfigure on each mount
Date:   Tue, 18 Jan 2022 17:05:47 +0100
Message-Id: <20220118160451.927235130@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

commit a6097180d884ddab769fb25588ea8598589c218c upstream.

Prior to Linux v5.4 devtmpfs used mount_single() which treats the given
mount options as "remount" options, so it updates the configuration of
the single super_block on each mount.

Since that was changed, the mount options used for devtmpfs are ignored.
This is a regression which affect systemd - which mounts devtmpfs with
"-o mode=755,size=4m,nr_inodes=1m".

This patch restores the "remount" effect by calling reconfigure_single()

Fixes: d401727ea0d7 ("devtmpfs: don't mix {ramfs,shmem}_fill_super() with mount_single()")
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/devtmpfs.c    |    7 +++++++
 fs/super.c                 |    4 ++--
 include/linux/fs_context.h |    2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -59,8 +59,15 @@ static struct dentry *public_dev_mount(s
 		      const char *dev_name, void *data)
 {
 	struct super_block *s = mnt->mnt_sb;
+	int err;
+
 	atomic_inc(&s->s_active);
 	down_write(&s->s_umount);
+	err = reconfigure_single(s, flags, data);
+	if (err < 0) {
+		deactivate_locked_super(s);
+		return ERR_PTR(err);
+	}
 	return dget(s->s_root);
 }
 
--- a/fs/super.c
+++ b/fs/super.c
@@ -1421,8 +1421,8 @@ struct dentry *mount_nodev(struct file_s
 }
 EXPORT_SYMBOL(mount_nodev);
 
-static int reconfigure_single(struct super_block *s,
-			      int flags, void *data)
+int reconfigure_single(struct super_block *s,
+		       int flags, void *data)
 {
 	struct fs_context *fc;
 	int ret;
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -142,6 +142,8 @@ extern void put_fs_context(struct fs_con
 extern int vfs_parse_fs_param_source(struct fs_context *fc,
 				     struct fs_parameter *param);
 extern void fc_drop_locked(struct fs_context *fc);
+int reconfigure_single(struct super_block *s,
+		       int flags, void *data);
 
 /*
  * sget() wrappers to be called from the ->get_tree() op.


