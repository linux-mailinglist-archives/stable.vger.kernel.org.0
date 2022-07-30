Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01498585B55
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 19:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbiG3REl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 13:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiG3REj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 13:04:39 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CD713F13
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:38 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a89so9076591edf.5
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 10:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=qsaZNDTYZNoMo1WzxgtCrCqVV+PZ5bTxEW+MTbC0QjQ=;
        b=Lynksvhd5z2dXuCNZ68QRebbnA5EH+HcqeIpRP4AUZDhYaoWlw6QXk/ZOE04SvBg9x
         lm3SlXlPyluy7aBMNVsZKRNbO3nrdnWBklcYXFrsffTKK9L/2F4ABzR41faBuvmMgluV
         RqV6y/5zzNHnOqs8bjoRZKRAwnIWLBIVZV8YI82RHz3oxzn9xBfAro8TkD3eBwk3oxIx
         NAC4SFO/A84TcbmJIVcTC+TTGegCfFlmIZL735KE77YuKQ8Q/5oIy/ba74Cs+2PfrNWl
         hs8N2AXHc6ZpIPeg3mFWUKbDGGpOMfQN8SolpJU+WU0qtL8atwb9EzMIBRwUcNPcYUWQ
         +IwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=qsaZNDTYZNoMo1WzxgtCrCqVV+PZ5bTxEW+MTbC0QjQ=;
        b=MGSbcZTDIW2V0UoHkfLLp9Orx+xdtkLg80R4IBmlcNoQ8Ji6dArSo+YaxnHTEdi2i4
         osicBPH3rDvD0eJtr7sRsSrDd0Rjt+e8J1dwISzXubCwuulWDyuUQlfEFlWbw/nx/n2L
         FBrGuWaznWjMCeMMU6f4BfYdVqeM1Jlq4rfviOdyVtSEVXI4M0ItEmDWPtYWqjqINmNl
         7Lzq4Qx/iCnhrqr5wwCuMBNjmZhRpraYeYREFTXBCxfbgTlCeHreAJKHNWEStZA3+RRU
         bq8mcl/+dWow1e008d+CsNQhCCB5I/iJr08T4JeDyv2qROcdz0iBn70NjWatGBvRF7Bd
         bobg==
X-Gm-Message-State: AJIora8vMHZ+z2gjAERHf1Gbha2pamuow4GBO/2E4OCsVTjlfjI88LID
        5auUHYR92QutNnH/is5oFnlKfpqWScUKVA==
X-Google-Smtp-Source: AGRyM1vM0q5IhpqJrUoPtl+DP+Uy9Oj6slrB1EfHRxjbH0mwt0HvFzKPMBGiBk02Wkh9B4c0zUSrPg==
X-Received: by 2002:a05:6402:d05:b0:425:b7ab:776e with SMTP id eb5-20020a0564020d0500b00425b7ab776emr8678502edb.142.1659200676939;
        Sat, 30 Jul 2022 10:04:36 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af2fc300f82d90934ef08f18.dip0.t-ipconnect.de. [2003:f6:af2f:c300:f82d:9093:4ef0:8f18])
        by smtp.googlemail.com with ESMTPSA id b8-20020aa7c908000000b0043af8007e7fsm4101868edt.3.2022.07.30.10.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 10:04:36 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 2/6] proc: Pass file mode to proc_pid_make_inode
Date:   Sat, 30 Jul 2022 19:03:39 +0200
Message-Id: <20220730170343.11477-3-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220730170343.11477-1-theflamefire89@gmail.com>
References: <20220730170343.11477-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
---
 fs/proc/base.c           | 23 +++++++++--------------
 fs/proc/fd.c             |  6 ++----
 fs/proc/internal.h       |  2 +-
 fs/proc/namespaces.c     |  3 +--
 security/selinux/hooks.c |  1 +
 5 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 886e408f4769..2dd4a2b7222c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1676,7 +1676,8 @@ const struct inode_operations proc_pid_link_inode_operations = {
 
 /* building an inode */
 
-struct inode *proc_pid_make_inode(struct super_block * sb, struct task_struct *task)
+struct inode *proc_pid_make_inode(struct super_block * sb,
+				  struct task_struct *task, umode_t mode)
 {
 	struct inode * inode;
 	struct proc_inode *ei;
@@ -1690,6 +1691,7 @@ struct inode *proc_pid_make_inode(struct super_block * sb, struct task_struct *t
 
 	/* Common stuff */
 	ei = PROC_I(inode);
+	inode->i_mode = mode;
 	inode->i_ino = get_next_ino();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
 	inode->i_op = &proc_def_inode_operations;
@@ -2041,7 +2043,9 @@ proc_map_files_instantiate(struct inode *dir, struct dentry *dentry,
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFLNK |
+				    ((mode & FMODE_READ ) ? S_IRUSR : 0) |
+				    ((mode & FMODE_WRITE) ? S_IWUSR : 0));
 	if (!inode)
 		return -ENOENT;
 
@@ -2050,12 +2054,6 @@ proc_map_files_instantiate(struct inode *dir, struct dentry *dentry,
 
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
@@ -2409,12 +2407,11 @@ static int proc_pident_instantiate(struct inode *dir,
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
@@ -3109,11 +3106,10 @@ static int proc_pid_instantiate(struct inode *dir,
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
@@ -3404,11 +3400,10 @@ static int proc_task_instantiate(struct inode *dir,
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
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index d21dafef3102..4274f83bf100 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -183,14 +183,13 @@ proc_fd_instantiate(struct inode *dir, struct dentry *dentry,
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
 
@@ -322,14 +321,13 @@ proc_fdinfo_instantiate(struct inode *dir, struct dentry *dentry,
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
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c0bdeceaaeb6..5bc057be6fa3 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -163,7 +163,7 @@ extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
 extern const struct dentry_operations pid_dentry_operations;
 extern int pid_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int proc_setattr(struct dentry *, struct iattr *);
-extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *);
+extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *, umode_t);
 extern int pid_revalidate(struct dentry *, unsigned int);
 extern int pid_delete_dentry(const struct dentry *);
 extern int proc_pid_readdir(struct file *, struct dir_context *);
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 51b8b0a8ad91..766f0c637ad1 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -92,12 +92,11 @@ static int proc_ns_instantiate(struct inode *dir,
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
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 43f81db42169..1997d87b35d5 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3958,6 +3958,7 @@ static void selinux_task_to_inode(struct task_struct *p,
 	struct inode_security_struct *isec = inode->i_security;
 	u32 sid = task_sid(p);
 
+	isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	isec->sid = sid;
 	isec->initialized = LABEL_INITIALIZED;
 }
-- 
2.25.1

