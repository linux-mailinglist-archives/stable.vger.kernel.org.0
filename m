Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BEC59D35A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242142AbiHWIMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242067AbiHWIKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E21DBC;
        Tue, 23 Aug 2022 01:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE7D611A8;
        Tue, 23 Aug 2022 08:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E8CC433D6;
        Tue, 23 Aug 2022 08:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242046;
        bh=Nzx5ZWZeMQOcVPQf6W0t1rCPGf/p4QNBpJqKq6sU2FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePyXVgq6ILa8pY7Ec227kUFN8/4hEhqk9T8usxZXsHMM8jANF/iKxzrwwPPObQMqd
         1Wb2wZnfKKCTuNXY9k0WksDPt3VQKBTM59fvwDRux7nxdzK5001AhhRLlab7jVuSex
         Ky5TYe0H17o5hCh72MKOMyH/SFAW8pBPdh5zP9v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 011/101] proc: Pass file mode to proc_pid_make_inode
Date:   Tue, 23 Aug 2022 10:02:44 +0200
Message-Id: <20220823080035.008665489@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andreas Gruenbacher <agruenba@redhat.com>

commit db978da8fa1d0819b210c137d31a339149b88875 upstream.

Pass the file mode of the proc inode to be created to
proc_pid_make_inode.  In proc_pid_make_inode, initialize inode->i_mode
before calling security_task_to_inode.  This allows selinux to set
isec->sclass right away without introducing "half-initialized" inode
security structs.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/base.c           |   23 +++++++++--------------
 fs/proc/fd.c             |    6 ++----
 fs/proc/internal.h       |    2 +-
 fs/proc/namespaces.c     |    3 +--
 security/selinux/hooks.c |    1 +
 5 files changed, 14 insertions(+), 21 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1676,7 +1676,8 @@ const struct inode_operations proc_pid_l
 
 /* building an inode */
 
-struct inode *proc_pid_make_inode(struct super_block * sb, struct task_struct *task)
+struct inode *proc_pid_make_inode(struct super_block * sb,
+				  struct task_struct *task, umode_t mode)
 {
 	struct inode * inode;
 	struct proc_inode *ei;
@@ -1690,6 +1691,7 @@ struct inode *proc_pid_make_inode(struct
 
 	/* Common stuff */
 	ei = PROC_I(inode);
+	inode->i_mode = mode;
 	inode->i_ino = get_next_ino();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
 	inode->i_op = &proc_def_inode_operations;
@@ -2041,7 +2043,9 @@ proc_map_files_instantiate(struct inode
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFLNK |
+				    ((mode & FMODE_READ ) ? S_IRUSR : 0) |
+				    ((mode & FMODE_WRITE) ? S_IWUSR : 0));
 	if (!inode)
 		return -ENOENT;
 
@@ -2050,12 +2054,6 @@ proc_map_files_instantiate(struct inode
 
 	inode->i_op = &proc_map_files_link_inode_operations;
 	inode->i_size = 64;
-	inode->i_mode = S_IFLNK;
-
-	if (mode & FMODE_READ)
-		inode->i_mode |= S_IRUSR;
-	if (mode & FMODE_WRITE)
-		inode->i_mode |= S_IWUSR;
 
 	d_set_d_op(dentry, &tid_map_files_dentry_operations);
 	d_add(dentry, inode);
@@ -2409,12 +2407,11 @@ static int proc_pident_instantiate(struc
 	struct inode *inode;
 	struct proc_inode *ei;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, p->mode);
 	if (!inode)
 		goto out;
 
 	ei = PROC_I(inode);
-	inode->i_mode = p->mode;
 	if (S_ISDIR(inode->i_mode))
 		set_nlink(inode, 2);	/* Use getattr to fix if necessary */
 	if (p->iop)
@@ -3109,11 +3106,10 @@ static int proc_pid_instantiate(struct i
 {
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFDIR | S_IRUGO | S_IXUGO);
 	if (!inode)
 		goto out;
 
-	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
 	inode->i_op = &proc_tgid_base_inode_operations;
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
@@ -3404,11 +3400,10 @@ static int proc_task_instantiate(struct
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
 	struct inode *inode;
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFDIR | S_IRUGO | S_IXUGO);
 
 	if (!inode)
 		goto out;
-	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
 	inode->i_op = &proc_tid_base_inode_operations;
 	inode->i_fop = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -183,14 +183,13 @@ proc_fd_instantiate(struct inode *dir, s
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFLNK);
 	if (!inode)
 		goto out;
 
 	ei = PROC_I(inode);
 	ei->fd = fd;
 
-	inode->i_mode = S_IFLNK;
 	inode->i_op = &proc_pid_link_inode_operations;
 	inode->i_size = 64;
 
@@ -322,14 +321,13 @@ proc_fdinfo_instantiate(struct inode *di
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFREG | S_IRUSR);
 	if (!inode)
 		goto out;
 
 	ei = PROC_I(inode);
 	ei->fd = fd;
 
-	inode->i_mode = S_IFREG | S_IRUSR;
 	inode->i_fop = &proc_fdinfo_file_operations;
 
 	d_set_d_op(dentry, &tid_fd_dentry_operations);
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -163,7 +163,7 @@ extern int proc_pid_statm(struct seq_fil
 extern const struct dentry_operations pid_dentry_operations;
 extern int pid_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int proc_setattr(struct dentry *, struct iattr *);
-extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *);
+extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *, umode_t);
 extern int pid_revalidate(struct dentry *, unsigned int);
 extern int pid_delete_dentry(const struct dentry *);
 extern int proc_pid_readdir(struct file *, struct dir_context *);
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -92,12 +92,11 @@ static int proc_ns_instantiate(struct in
 	struct inode *inode;
 	struct proc_inode *ei;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFLNK | S_IRWXUGO);
 	if (!inode)
 		goto out;
 
 	ei = PROC_I(inode);
-	inode->i_mode = S_IFLNK|S_IRWXUGO;
 	inode->i_op = &proc_ns_link_inode_operations;
 	ei->ns_ops = ns_ops;
 
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3958,6 +3958,7 @@ static void selinux_task_to_inode(struct
 	struct inode_security_struct *isec = inode->i_security;
 	u32 sid = task_sid(p);
 
+	isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	isec->sid = sid;
 	isec->initialized = LABEL_INITIALIZED;
 }


