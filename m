Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08E257995E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237964AbiGSMCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237891AbiGSMBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:01:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4674045F51;
        Tue, 19 Jul 2022 04:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DBB9ECE1BDE;
        Tue, 19 Jul 2022 11:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03C4C341C6;
        Tue, 19 Jul 2022 11:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231910;
        bh=YppTL7lZyK/8Xub0dvfH2aOxcuSTkXtqCNfpV++wGP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9uuSSM8LjuRnRGbHBxm7WR51BZl5MDOCyG1vyrF2cJlMME0e/4+ZrJOm5YLoUGAy
         0wjgNCW+Dn52PHKrLAyPonGqlYwRR3sbCdYjE6v+6SrlpGpSO1yBhTKyVMSGO8ofDI
         UCRu/OlnQZiNlrNYLPvwSmat03j6tO3j09MsUOMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        shisiyuan <shisiyuan19870131@gmail.com>
Subject: [PATCH 4.14 07/43] cgroup: Use separate src/dst nodes when preloading css_sets for migration
Date:   Tue, 19 Jul 2022 13:53:38 +0200
Message-Id: <20220719114522.727899896@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 07fd5b6cdf3cc30bfde8fe0f644771688be04447 upstream.

Each cset (css_set) is pinned by its tasks. When we're moving tasks around
across csets for a migration, we need to hold the source and destination
csets to ensure that they don't go away while we're moving tasks about. This
is done by linking cset->mg_preload_node on either the
mgctx->preloaded_src_csets or mgctx->preloaded_dst_csets list. Using the
same cset->mg_preload_node for both the src and dst lists was deemed okay as
a cset can't be both the source and destination at the same time.

Unfortunately, this overloading becomes problematic when multiple tasks are
involved in a migration and some of them are identity noop migrations while
others are actually moving across cgroups. For example, this can happen with
the following sequence on cgroup1:

 #1> mkdir -p /sys/fs/cgroup/misc/a/b
 #2> echo $$ > /sys/fs/cgroup/misc/a/cgroup.procs
 #3> RUN_A_COMMAND_WHICH_CREATES_MULTIPLE_THREADS &
 #4> PID=$!
 #5> echo $PID > /sys/fs/cgroup/misc/a/b/tasks
 #6> echo $PID > /sys/fs/cgroup/misc/a/cgroup.procs

the process including the group leader back into a. In this final migration,
non-leader threads would be doing identity migration while the group leader
is doing an actual one.

After #3, let's say the whole process was in cset A, and that after #4, the
leader moves to cset B. Then, during #6, the following happens:

 1. cgroup_migrate_add_src() is called on B for the leader.

 2. cgroup_migrate_add_src() is called on A for the other threads.

 3. cgroup_migrate_prepare_dst() is called. It scans the src list.

 4. It notices that B wants to migrate to A, so it tries to A to the dst
    list but realizes that its ->mg_preload_node is already busy.

 5. and then it notices A wants to migrate to A as it's an identity
    migration, it culls it by list_del_init()'ing its ->mg_preload_node and
    putting references accordingly.

 6. The rest of migration takes place with B on the src list but nothing on
    the dst list.

This means that A isn't held while migration is in progress. If all tasks
leave A before the migration finishes and the incoming task pins it, the
cset will be destroyed leading to use-after-free.

This is caused by overloading cset->mg_preload_node for both src and dst
preload lists. We wanted to exclude the cset from the src list but ended up
inadvertently excluding it from the dst list too.

This patch fixes the issue by separating out cset->mg_preload_node into
->mg_src_preload_node and ->mg_dst_preload_node, so that the src and dst
preloadings don't interfere with each other.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reported-by: shisiyuan <shisiyuan19870131@gmail.com>
Link: http://lkml.kernel.org/r/1654187688-27411-1-git-send-email-shisiyuan@xiaomi.com
Link: https://www.spinics.net/lists/cgroups/msg33313.html
Fixes: f817de98513d ("cgroup: prepare migration path for unified hierarchy")
Cc: stable@vger.kernel.org # v3.16+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup-defs.h |    3 ++-
 kernel/cgroup/cgroup.c      |   37 +++++++++++++++++++++++--------------
 2 files changed, 25 insertions(+), 15 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -235,7 +235,8 @@ struct css_set {
 	 * List of csets participating in the on-going migration either as
 	 * source or destination.  Protected by cgroup_mutex.
 	 */
-	struct list_head mg_preload_node;
+	struct list_head mg_src_preload_node;
+	struct list_head mg_dst_preload_node;
 	struct list_head mg_node;
 
 	/*
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -647,7 +647,8 @@ struct css_set init_css_set = {
 	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
 	.threaded_csets		= LIST_HEAD_INIT(init_css_set.threaded_csets),
 	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
-	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
+	.mg_src_preload_node	= LIST_HEAD_INIT(init_css_set.mg_src_preload_node),
+	.mg_dst_preload_node	= LIST_HEAD_INIT(init_css_set.mg_dst_preload_node),
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
 };
 
@@ -1113,7 +1114,8 @@ static struct css_set *find_css_set(stru
 	INIT_LIST_HEAD(&cset->threaded_csets);
 	INIT_HLIST_NODE(&cset->hlist);
 	INIT_LIST_HEAD(&cset->cgrp_links);
-	INIT_LIST_HEAD(&cset->mg_preload_node);
+	INIT_LIST_HEAD(&cset->mg_src_preload_node);
+	INIT_LIST_HEAD(&cset->mg_dst_preload_node);
 	INIT_LIST_HEAD(&cset->mg_node);
 
 	/* Copy the set of subsystem state objects generated in
@@ -2399,21 +2401,27 @@ int cgroup_migrate_vet_dst(struct cgroup
  */
 void cgroup_migrate_finish(struct cgroup_mgctx *mgctx)
 {
-	LIST_HEAD(preloaded);
 	struct css_set *cset, *tmp_cset;
 
 	lockdep_assert_held(&cgroup_mutex);
 
 	spin_lock_irq(&css_set_lock);
 
-	list_splice_tail_init(&mgctx->preloaded_src_csets, &preloaded);
-	list_splice_tail_init(&mgctx->preloaded_dst_csets, &preloaded);
+	list_for_each_entry_safe(cset, tmp_cset, &mgctx->preloaded_src_csets,
+				 mg_src_preload_node) {
+		cset->mg_src_cgrp = NULL;
+		cset->mg_dst_cgrp = NULL;
+		cset->mg_dst_cset = NULL;
+		list_del_init(&cset->mg_src_preload_node);
+		put_css_set_locked(cset);
+	}
 
-	list_for_each_entry_safe(cset, tmp_cset, &preloaded, mg_preload_node) {
+	list_for_each_entry_safe(cset, tmp_cset, &mgctx->preloaded_dst_csets,
+				 mg_dst_preload_node) {
 		cset->mg_src_cgrp = NULL;
 		cset->mg_dst_cgrp = NULL;
 		cset->mg_dst_cset = NULL;
-		list_del_init(&cset->mg_preload_node);
+		list_del_init(&cset->mg_dst_preload_node);
 		put_css_set_locked(cset);
 	}
 
@@ -2455,7 +2463,7 @@ void cgroup_migrate_add_src(struct css_s
 
 	src_cgrp = cset_cgroup_from_root(src_cset, dst_cgrp->root);
 
-	if (!list_empty(&src_cset->mg_preload_node))
+	if (!list_empty(&src_cset->mg_src_preload_node))
 		return;
 
 	WARN_ON(src_cset->mg_src_cgrp);
@@ -2466,7 +2474,7 @@ void cgroup_migrate_add_src(struct css_s
 	src_cset->mg_src_cgrp = src_cgrp;
 	src_cset->mg_dst_cgrp = dst_cgrp;
 	get_css_set(src_cset);
-	list_add_tail(&src_cset->mg_preload_node, &mgctx->preloaded_src_csets);
+	list_add_tail(&src_cset->mg_src_preload_node, &mgctx->preloaded_src_csets);
 }
 
 /**
@@ -2491,7 +2499,7 @@ int cgroup_migrate_prepare_dst(struct cg
 
 	/* look up the dst cset for each src cset and link it to src */
 	list_for_each_entry_safe(src_cset, tmp_cset, &mgctx->preloaded_src_csets,
-				 mg_preload_node) {
+				 mg_src_preload_node) {
 		struct css_set *dst_cset;
 		struct cgroup_subsys *ss;
 		int ssid;
@@ -2510,7 +2518,7 @@ int cgroup_migrate_prepare_dst(struct cg
 		if (src_cset == dst_cset) {
 			src_cset->mg_src_cgrp = NULL;
 			src_cset->mg_dst_cgrp = NULL;
-			list_del_init(&src_cset->mg_preload_node);
+			list_del_init(&src_cset->mg_src_preload_node);
 			put_css_set(src_cset);
 			put_css_set(dst_cset);
 			continue;
@@ -2518,8 +2526,8 @@ int cgroup_migrate_prepare_dst(struct cg
 
 		src_cset->mg_dst_cset = dst_cset;
 
-		if (list_empty(&dst_cset->mg_preload_node))
-			list_add_tail(&dst_cset->mg_preload_node,
+		if (list_empty(&dst_cset->mg_dst_preload_node))
+			list_add_tail(&dst_cset->mg_dst_preload_node,
 				      &mgctx->preloaded_dst_csets);
 		else
 			put_css_set(dst_cset);
@@ -2753,7 +2761,8 @@ static int cgroup_update_dfl_csses(struc
 		goto out_finish;
 
 	spin_lock_irq(&css_set_lock);
-	list_for_each_entry(src_cset, &mgctx.preloaded_src_csets, mg_preload_node) {
+	list_for_each_entry(src_cset, &mgctx.preloaded_src_csets,
+			    mg_src_preload_node) {
 		struct task_struct *task, *ntask;
 
 		/* all tasks in src_csets need to be migrated */


