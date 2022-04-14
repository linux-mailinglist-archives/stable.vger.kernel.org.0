Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B33501584
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245074AbiDNOHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347705AbiDNN7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1CBBB090;
        Thu, 14 Apr 2022 06:51:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98A2AB82990;
        Thu, 14 Apr 2022 13:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BEDC385A5;
        Thu, 14 Apr 2022 13:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944313;
        bh=OmgIsjOug7myOZCyIflNQrX3L6jXh7B6Y9Ee5Iy5RzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOMcTdJzRaWQ8KkzV4kUh3Oz7dbhFnJf9fY+GWL252oNrVIdj3c0TX4xilCPI4qJO
         ZICln7fhHNxlj2yl17Qow8+AvU0pTXXUkSpS9jS+JqH8Yvd3WEyEXAA19vPWZUv1lP
         E+R84rDwHXQHqgtagP8fxnr58mP5QiTUApAL9sTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 469/475] cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv
Date:   Thu, 14 Apr 2022 15:14:14 +0200
Message-Id: <20220414110908.180780735@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

commit 0d2b5955b36250a9428c832664f2079cbf723bec upstream.

of->priv is currently used by each interface file implementation to store
private information. This patch collects the current two private data usages
into struct cgroup_file_ctx which is allocated and freed by the common path.
This allows generic private data which applies to multiple files, which will
be used to in the following patch.

Note that cgroup_procs iterator is now embedded as procs.iter in the new
cgroup_file_ctx so that it doesn't need to be allocated and freed
separately.

v2: union dropped from cgroup_file_ctx and the procs iterator is embedded in
    cgroup_file_ctx as suggested by Linus.

v3: Michal pointed out that cgroup1's procs pidlist uses of->priv too.
    Converted. Didn't change to embedded allocation as cgroup1 pidlists get
    stored for caching.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
[mkoutny: v5.10: modify cgroup.pressure handlers, adjust context]
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup-internal.h |   17 ++++++++++++
 kernel/cgroup/cgroup-v1.c       |   26 ++++++++++---------
 kernel/cgroup/cgroup.c          |   54 +++++++++++++++++++++++++---------------
 3 files changed, 65 insertions(+), 32 deletions(-)

--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -65,6 +65,23 @@ static inline struct cgroup_fs_context *
 	return container_of(kfc, struct cgroup_fs_context, kfc);
 }
 
+struct cgroup_pidlist;
+
+struct cgroup_file_ctx {
+	struct {
+		void			*trigger;
+	} psi;
+
+	struct {
+		bool			started;
+		struct css_task_iter	iter;
+	} procs;
+
+	struct {
+		struct cgroup_pidlist	*pidlist;
+	} procs1;
+};
+
 /*
  * A cgroup can be associated with multiple css_sets as different tasks may
  * belong to different cgroups on different hierarchies.  In the other
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -398,6 +398,7 @@ static void *cgroup_pidlist_start(struct
 	 * next pid to display, if any
 	 */
 	struct kernfs_open_file *of = s->private;
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
 	struct cgroup_pidlist *l;
 	enum cgroup_filetype type = seq_cft(s)->private;
@@ -407,25 +408,24 @@ static void *cgroup_pidlist_start(struct
 	mutex_lock(&cgrp->pidlist_mutex);
 
 	/*
-	 * !NULL @of->priv indicates that this isn't the first start()
-	 * after open.  If the matching pidlist is around, we can use that.
-	 * Look for it.  Note that @of->priv can't be used directly.  It
-	 * could already have been destroyed.
+	 * !NULL @ctx->procs1.pidlist indicates that this isn't the first
+	 * start() after open. If the matching pidlist is around, we can use
+	 * that. Look for it. Note that @ctx->procs1.pidlist can't be used
+	 * directly. It could already have been destroyed.
 	 */
-	if (of->priv)
-		of->priv = cgroup_pidlist_find(cgrp, type);
+	if (ctx->procs1.pidlist)
+		ctx->procs1.pidlist = cgroup_pidlist_find(cgrp, type);
 
 	/*
 	 * Either this is the first start() after open or the matching
 	 * pidlist has been destroyed inbetween.  Create a new one.
 	 */
-	if (!of->priv) {
-		ret = pidlist_array_load(cgrp, type,
-					 (struct cgroup_pidlist **)&of->priv);
+	if (!ctx->procs1.pidlist) {
+		ret = pidlist_array_load(cgrp, type, &ctx->procs1.pidlist);
 		if (ret)
 			return ERR_PTR(ret);
 	}
-	l = of->priv;
+	l = ctx->procs1.pidlist;
 
 	if (pid) {
 		int end = l->length;
@@ -453,7 +453,8 @@ static void *cgroup_pidlist_start(struct
 static void cgroup_pidlist_stop(struct seq_file *s, void *v)
 {
 	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct cgroup_pidlist *l = ctx->procs1.pidlist;
 
 	if (l)
 		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork,
@@ -464,7 +465,8 @@ static void cgroup_pidlist_stop(struct s
 static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct cgroup_pidlist *l = ctx->procs1.pidlist;
 	pid_t *p = v;
 	pid_t *end = l->list + l->length;
 	/*
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3648,6 +3648,7 @@ static int cgroup_cpu_pressure_show(stru
 static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 					  size_t nbytes, enum psi_res res)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct psi_trigger *new;
 	struct cgroup *cgrp;
 	struct psi_group *psi;
@@ -3660,7 +3661,7 @@ static ssize_t cgroup_pressure_write(str
 	cgroup_kn_unlock(of->kn);
 
 	/* Allow only one trigger per file descriptor */
-	if (of->priv) {
+	if (ctx->psi.trigger) {
 		cgroup_put(cgrp);
 		return -EBUSY;
 	}
@@ -3672,7 +3673,7 @@ static ssize_t cgroup_pressure_write(str
 		return PTR_ERR(new);
 	}
 
-	smp_store_release(&of->priv, new);
+	smp_store_release(&ctx->psi.trigger, new);
 	cgroup_put(cgrp);
 
 	return nbytes;
@@ -3702,12 +3703,15 @@ static ssize_t cgroup_cpu_pressure_write
 static __poll_t cgroup_pressure_poll(struct kernfs_open_file *of,
 					  poll_table *pt)
 {
-	return psi_trigger_poll(&of->priv, of->file, pt);
+	struct cgroup_file_ctx *ctx = of->priv;
+	return psi_trigger_poll(&ctx->psi.trigger, of->file, pt);
 }
 
 static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
-	psi_trigger_destroy(of->priv);
+	struct cgroup_file_ctx *ctx = of->priv;
+
+	psi_trigger_destroy(ctx->psi.trigger);
 }
 #endif /* CONFIG_PSI */
 
@@ -3748,18 +3752,31 @@ static ssize_t cgroup_freeze_write(struc
 static int cgroup_file_open(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
+	struct cgroup_file_ctx *ctx;
+	int ret;
 
-	if (cft->open)
-		return cft->open(of);
-	return 0;
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	of->priv = ctx;
+
+	if (!cft->open)
+		return 0;
+
+	ret = cft->open(of);
+	if (ret)
+		kfree(ctx);
+	return ret;
 }
 
 static void cgroup_file_release(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
 
 	if (cft->release)
 		cft->release(of);
+	kfree(ctx);
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
@@ -4687,21 +4704,21 @@ void css_task_iter_end(struct css_task_i
 
 static void cgroup_procs_release(struct kernfs_open_file *of)
 {
-	if (of->priv) {
-		css_task_iter_end(of->priv);
-		kfree(of->priv);
-	}
+	struct cgroup_file_ctx *ctx = of->priv;
+
+	if (ctx->procs.started)
+		css_task_iter_end(&ctx->procs.iter);
 }
 
 static void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kernfs_open_file *of = s->private;
-	struct css_task_iter *it = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
 
 	if (pos)
 		(*pos)++;
 
-	return css_task_iter_next(it);
+	return css_task_iter_next(&ctx->procs.iter);
 }
 
 static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
@@ -4709,21 +4726,18 @@ static void *__cgroup_procs_start(struct
 {
 	struct kernfs_open_file *of = s->private;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
-	struct css_task_iter *it = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct css_task_iter *it = &ctx->procs.iter;
 
 	/*
 	 * When a seq_file is seeked, it's always traversed sequentially
 	 * from position 0, so we can simply keep iterating on !0 *pos.
 	 */
-	if (!it) {
+	if (!ctx->procs.started) {
 		if (WARN_ON_ONCE((*pos)))
 			return ERR_PTR(-EINVAL);
-
-		it = kzalloc(sizeof(*it), GFP_KERNEL);
-		if (!it)
-			return ERR_PTR(-ENOMEM);
-		of->priv = it;
 		css_task_iter_start(&cgrp->self, iter_flags, it);
+		ctx->procs.started = true;
 	} else if (!(*pos)) {
 		css_task_iter_end(it);
 		css_task_iter_start(&cgrp->self, iter_flags, it);


