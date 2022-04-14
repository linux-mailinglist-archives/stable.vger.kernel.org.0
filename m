Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5665015DB
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244519AbiDNNmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344590AbiDNNcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:32:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57DA22298;
        Thu, 14 Apr 2022 06:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 962EBB82987;
        Thu, 14 Apr 2022 13:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9253C385A1;
        Thu, 14 Apr 2022 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943021;
        bh=l64fbXu5oJpiB2N4KEORd7MB1fVL/+z++mUt1fLa+po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqLo4dLzKUxxjJ+1SLetIClkx5SsIm/BU+57CG5iQJ/vXGfasdF142/1exfnus155
         oYDSEiuLZhJvI0d9vkMu7wzc0eovLUF37wyVD5yg4HpVFoMn3DtclPOulqpXXZaXvL
         PVy+hFvJE3EXxZjpTyogddouQut0+5T4dIUEfVFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Oleg Nesterov <oleg@redhat.com>,
        syzbot+50f5cf33a284ce738b62@syzkaller.appspotmail.com,
        Tejun Heo <tj@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 332/338] cgroup: Use open-time cgroup namespace for process migration perm checks
Date:   Thu, 14 Apr 2022 15:13:55 +0200
Message-Id: <20220414110848.340385277@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Tejun Heo <tj@kernel.org>

commit e57457641613fef0d147ede8bd6a3047df588b95 upstream.

cgroup process migration permission checks are performed at write time as
whether a given operation is allowed or not is dependent on the content of
the write - the PID. This currently uses current's cgroup namespace which is
a potential security weakness as it may allow scenarios where a less
privileged process tricks a more privileged one into writing into a fd that
it created.

This patch makes cgroup remember the cgroup namespace at the time of open
and uses it for migration permission checks instad of current's. Note that
this only applies to cgroup2 as cgroup1 doesn't have namespace support.

This also fixes a use-after-free bug on cgroupns reported in

 https://lore.kernel.org/r/00000000000048c15c05d0083397@google.com

Note that backporting this fix also requires the preceding patch.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Reported-by: syzbot+50f5cf33a284ce738b62@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/00000000000048c15c05d0083397@google.com
Fixes: 5136f6365ce3 ("cgroup: implement "nsdelegate" mount option")
Signed-off-by: Tejun Heo <tj@kernel.org>
[mkoutny: v5.10: duplicate ns check in procs/threads write handler, adjust context]
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to v4.19: drop changes to cgroup_attach_permissions() and
cgroup_css_set_fork(), adjust cgroup_procs_write_permission() calls]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup-internal.h |    2 ++
 kernel/cgroup/cgroup.c          |   24 +++++++++++++++++-------
 2 files changed, 19 insertions(+), 7 deletions(-)

--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -37,6 +37,8 @@ extern char trace_cgroup_path[TRACE_CGRO
 struct cgroup_pidlist;
 
 struct cgroup_file_ctx {
+	struct cgroup_namespace	*ns;
+
 	struct {
 		void			*trigger;
 	} psi;
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3457,14 +3457,19 @@ static int cgroup_file_open(struct kernf
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
+
+	ctx->ns = current->nsproxy->cgroup_ns;
+	get_cgroup_ns(ctx->ns);
 	of->priv = ctx;
 
 	if (!cft->open)
 		return 0;
 
 	ret = cft->open(of);
-	if (ret)
+	if (ret) {
+		put_cgroup_ns(ctx->ns);
 		kfree(ctx);
+	}
 	return ret;
 }
 
@@ -3475,13 +3480,14 @@ static void cgroup_file_release(struct k
 
 	if (cft->release)
 		cft->release(of);
+	put_cgroup_ns(ctx->ns);
 	kfree(ctx);
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 				 size_t nbytes, loff_t off)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *cgrp = of->kn->parent->priv;
 	struct cftype *cft = of->kn->priv;
 	struct cgroup_subsys_state *css;
@@ -3495,7 +3501,7 @@ static ssize_t cgroup_file_write(struct
 	 */
 	if ((cgrp->root->flags & CGRP_ROOT_NS_DELEGATE) &&
 	    !(cft->flags & CFTYPE_NS_DELEGATABLE) &&
-	    ns != &init_cgroup_ns && ns->root_cset->dfl_cgrp == cgrp)
+	    ctx->ns != &init_cgroup_ns && ctx->ns->root_cset->dfl_cgrp == cgrp)
 		return -EPERM;
 
 	if (cft->write)
@@ -4457,9 +4463,9 @@ static int cgroup_procs_show(struct seq_
 
 static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 					 struct cgroup *dst_cgrp,
-					 struct super_block *sb)
+					 struct super_block *sb,
+					 struct cgroup_namespace *ns)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup *com_cgrp = src_cgrp;
 	struct inode *inode;
 	int ret;
@@ -4495,6 +4501,7 @@ static int cgroup_procs_write_permission
 static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 				  char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	const struct cred *saved_cred;
@@ -4521,7 +4528,8 @@ static ssize_t cgroup_procs_write(struct
 	 */
 	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
-					    of->file->f_path.dentry->d_sb);
+					    of->file->f_path.dentry->d_sb,
+					    ctx->ns);
 	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
@@ -4544,6 +4552,7 @@ static void *cgroup_threads_start(struct
 static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	const struct cred *saved_cred;
@@ -4572,7 +4581,8 @@ static ssize_t cgroup_threads_write(stru
 	 */
 	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
-					    of->file->f_path.dentry->d_sb);
+					    of->file->f_path.dentry->d_sb,
+					    ctx->ns);
 	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;


