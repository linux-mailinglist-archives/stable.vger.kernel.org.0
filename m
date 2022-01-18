Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D5F492A20
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346316AbiARQHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:07:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38544 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346332AbiARQHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:07:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C60E0612ED;
        Tue, 18 Jan 2022 16:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5F7C00446;
        Tue, 18 Jan 2022 16:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522023;
        bh=kMDpxjCdg706EV3OMK18iNmKo7NJ4xqzejuxVw2I2lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOd1SpAMY4qeemSGE6hy9auIvhsj/vmiPC/XcnvydQNLLYQAC8VOL8mhcHPf6DEB6
         QMBk0D/4GJJTNil9lYDAyjzDHJb1xLL/9grXACXeCG/yQrTH4ccQProAaBOcTKhWYL
         2Pdwwuk0KmWEsT1N2XyVTnxBgzQ6PNr+XEoG+BXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Al Viro <viro@zeniv.linux.org.uk>, NeilBrown <neilb@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 02/15] devtmpfs regression fix: reconfigure on each mount
Date:   Tue, 18 Jan 2022 17:05:41 +0100
Message-Id: <20220118160450.143738373@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160450.062004175@linuxfoundation.org>
References: <20220118160450.062004175@linuxfoundation.org>
User-Agent: quilt/0.66
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
 drivers/base/devtmpfs.c    |    8 ++++++++
 fs/super.c                 |    4 ++--
 include/linux/fs_context.h |    2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
+#include <linux/fs_context.h>
 #include <uapi/linux/mount.h>
 #include "base.h"
 
@@ -62,8 +63,15 @@ static struct dentry *public_dev_mount(s
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
@@ -1470,8 +1470,8 @@ struct dentry *mount_nodev(struct file_s
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
@@ -135,6 +135,8 @@ extern int generic_parse_monolithic(stru
 extern int vfs_get_tree(struct fs_context *fc);
 extern void put_fs_context(struct fs_context *fc);
 extern void fc_drop_locked(struct fs_context *fc);
+int reconfigure_single(struct super_block *s,
+		       int flags, void *data);
 
 /*
  * sget() wrappers to be called from the ->get_tree() op.


