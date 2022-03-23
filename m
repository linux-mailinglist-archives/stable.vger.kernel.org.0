Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4842C4E55DC
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 17:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245352AbiCWQCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 12:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238310AbiCWQCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 12:02:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5A37B12A
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 09:01:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F15111F38D;
        Wed, 23 Mar 2022 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648051275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d+U5hiMJTtY4EEBH/g/7Sxn9pOATn9ix/kJvSwubgwE=;
        b=k2uO0rBBDg6Oq3kW+GTMCnUDiz/SpKcFTQ9d1QgJvd247G3m2dV+vHjet2n7O4ks48gW1f
        WCLirY/fGilexuw6jy6bxv1kTgeNIaR50KOunI/+fzz+osnIDrG06aGKdmdTS0BQDthDdG
        pty2J3+yL2wIsSyrWKwEvMuc0ivt0rk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C731C1331A;
        Wed, 23 Mar 2022 16:01:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2IlVL0tEO2KvegAAMHmgww
        (envelope-from <mkoutny@suse.com>); Wed, 23 Mar 2022 16:01:15 +0000
From:   =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
To:     gregkh@linuxfoundation.org
Cc:     masami.ichikawa@cybertrust.co.jp, mkoutny@suse.com,
        stable@vger.kernel.org, tj@kernel.org
Subject: [PATCH 2/3] cgroup: Use open-time cgroup namespace for process migration perm checks
Date:   Wed, 23 Mar 2022 17:01:01 +0100
Message-Id: <20220323160102.3347-2-mkoutny@suse.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323160102.3347-1-mkoutny@suse.com>
References: <YjseqrSJQd9412So@kroah.com>
 <20220323160102.3347-1-mkoutny@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
---
 kernel/cgroup/cgroup-internal.h |  2 ++
 kernel/cgroup/cgroup.c          | 32 ++++++++++++++++++++++----------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index cf637bc4ab45..6e36e854b512 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -68,6 +68,8 @@ static inline struct cgroup_fs_context *cgroup_fc2context(struct fs_context *fc)
 struct cgroup_pidlist;
 
 struct cgroup_file_ctx {
+	struct cgroup_namespace	*ns;
+
 	struct {
 		void			*trigger;
 	} psi;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ddfe6983ea7c..3f8447a5393e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3700,14 +3700,19 @@ static int cgroup_file_open(struct kernfs_open_file *of)
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
 
@@ -3718,13 +3723,14 @@ static void cgroup_file_release(struct kernfs_open_file *of)
 
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
@@ -3741,7 +3747,7 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	 */
 	if ((cgrp->root->flags & CGRP_ROOT_NS_DELEGATE) &&
 	    !(cft->flags & CFTYPE_NS_DELEGATABLE) &&
-	    ns != &init_cgroup_ns && ns->root_cset->dfl_cgrp == cgrp)
+	    ctx->ns != &init_cgroup_ns && ctx->ns->root_cset->dfl_cgrp == cgrp)
 		return -EPERM;
 
 	if (cft->write)
@@ -4726,9 +4732,9 @@ static int cgroup_may_write(const struct cgroup *cgrp, struct super_block *sb)
 
 static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 					 struct cgroup *dst_cgrp,
-					 struct super_block *sb)
+					 struct super_block *sb,
+					 struct cgroup_namespace *ns)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup *com_cgrp = src_cgrp;
 	int ret;
 
@@ -4757,11 +4763,12 @@ static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 
 static int cgroup_attach_permissions(struct cgroup *src_cgrp,
 				     struct cgroup *dst_cgrp,
-				     struct super_block *sb, bool threadgroup)
+				     struct super_block *sb, bool threadgroup,
+				     struct cgroup_namespace *ns)
 {
 	int ret = 0;
 
-	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp, sb);
+	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp, sb, ns);
 	if (ret)
 		return ret;
 
@@ -4778,6 +4785,7 @@ static int cgroup_attach_permissions(struct cgroup *src_cgrp,
 static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 				  char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	ssize_t ret;
@@ -4798,7 +4806,8 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	spin_unlock_irq(&css_set_lock);
 
 	ret = cgroup_attach_permissions(src_cgrp, dst_cgrp,
-					of->file->f_path.dentry->d_sb, true);
+					of->file->f_path.dentry->d_sb, true,
+					ctx->ns);
 	if (ret)
 		goto out_finish;
 
@@ -4820,6 +4829,7 @@ static void *cgroup_threads_start(struct seq_file *s, loff_t *pos)
 static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	ssize_t ret;
@@ -4843,7 +4853,8 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 
 	/* thread migrations follow the cgroup.procs delegation rule */
 	ret = cgroup_attach_permissions(src_cgrp, dst_cgrp,
-					of->file->f_path.dentry->d_sb, false);
+					of->file->f_path.dentry->d_sb, false,
+					ctx->ns);
 	if (ret)
 		goto out_finish;
 
@@ -6023,7 +6034,8 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 		goto err;
 
 	ret = cgroup_attach_permissions(cset->dfl_cgrp, dst_cgrp, sb,
-					!(kargs->flags & CLONE_THREAD));
+					!(kargs->flags & CLONE_THREAD),
+					current->nsproxy->cgroup_ns);
 	if (ret)
 		goto err;
 
-- 
2.35.1

