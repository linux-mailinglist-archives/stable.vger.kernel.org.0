Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7852B6AEE4E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjCGSLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbjCGSKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1662057B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:05:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BAD361523
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8295FC433D2;
        Tue,  7 Mar 2023 18:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212338;
        bh=03EQTWxR0qI+54e7iONSRt49fVN2k0TjCoLcc0zCwxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJC6XG8LbK4z+xSUC2jbIeoJms90cO3aIdFGBo7IL0Gti59I6oPA/+Z8VWjKG2aot
         v+qWurN4vP4jZ+ttBGb1PM1Z93bYBs2WeOL7iiQ4iVc/4OcO5EluJVXyQCV6cAdAmX
         NNmbA0vUY6oQU+BtOpO7wrdlgxs7GmgSGsoBucLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Valentin Schneider <vschneid@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/885] workqueue: Protects wq_unbound_cpumask with wq_pool_attach_mutex
Date:   Tue,  7 Mar 2023 17:51:28 +0100
Message-Id: <20230307170008.602794038@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

[ Upstream commit 99c621ef243bda726fb8d982a274ded96570b410 ]

When unbind_workers() reads wq_unbound_cpumask to set the affinity of
freshly-unbound kworkers, it only holds wq_pool_attach_mutex. This isn't
sufficient as wq_unbound_cpumask is only protected by wq_pool_mutex.

Make wq_unbound_cpumask protected with wq_pool_attach_mutex and also
remove the need of temporary saved_cpumask.

Fixes: 10a5a651e3af ("workqueue: Restrict kworker in the offline CPU pool running on housekeeping CPUs")
Reported-by: Valentin Schneider <vschneid@redhat.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7cd5f5e7e0a1b..8e21c352c1558 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -326,7 +326,7 @@ static struct rcuwait manager_wait = __RCUWAIT_INITIALIZER(manager_wait);
 static LIST_HEAD(workqueues);		/* PR: list of all workqueues */
 static bool workqueue_freezing;		/* PL: have wqs started freezing? */
 
-/* PL: allowable cpus for unbound wqs and work items */
+/* PL&A: allowable cpus for unbound wqs and work items */
 static cpumask_var_t wq_unbound_cpumask;
 
 /* CPU where unbound work was last round robin scheduled from this CPU */
@@ -3952,7 +3952,8 @@ static void apply_wqattrs_cleanup(struct apply_wqattrs_ctx *ctx)
 /* allocate the attrs and pwqs for later installation */
 static struct apply_wqattrs_ctx *
 apply_wqattrs_prepare(struct workqueue_struct *wq,
-		      const struct workqueue_attrs *attrs)
+		      const struct workqueue_attrs *attrs,
+		      const cpumask_var_t unbound_cpumask)
 {
 	struct apply_wqattrs_ctx *ctx;
 	struct workqueue_attrs *new_attrs, *tmp_attrs;
@@ -3968,14 +3969,15 @@ apply_wqattrs_prepare(struct workqueue_struct *wq,
 		goto out_free;
 
 	/*
-	 * Calculate the attrs of the default pwq.
+	 * Calculate the attrs of the default pwq with unbound_cpumask
+	 * which is wq_unbound_cpumask or to set to wq_unbound_cpumask.
 	 * If the user configured cpumask doesn't overlap with the
 	 * wq_unbound_cpumask, we fallback to the wq_unbound_cpumask.
 	 */
 	copy_workqueue_attrs(new_attrs, attrs);
-	cpumask_and(new_attrs->cpumask, new_attrs->cpumask, wq_unbound_cpumask);
+	cpumask_and(new_attrs->cpumask, new_attrs->cpumask, unbound_cpumask);
 	if (unlikely(cpumask_empty(new_attrs->cpumask)))
-		cpumask_copy(new_attrs->cpumask, wq_unbound_cpumask);
+		cpumask_copy(new_attrs->cpumask, unbound_cpumask);
 
 	/*
 	 * We may create multiple pwqs with differing cpumasks.  Make a
@@ -4072,7 +4074,7 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
 		wq->flags &= ~__WQ_ORDERED;
 	}
 
-	ctx = apply_wqattrs_prepare(wq, attrs);
+	ctx = apply_wqattrs_prepare(wq, attrs, wq_unbound_cpumask);
 	if (!ctx)
 		return -ENOMEM;
 
@@ -5334,7 +5336,7 @@ void thaw_workqueues(void)
 }
 #endif /* CONFIG_FREEZER */
 
-static int workqueue_apply_unbound_cpumask(void)
+static int workqueue_apply_unbound_cpumask(const cpumask_var_t unbound_cpumask)
 {
 	LIST_HEAD(ctxs);
 	int ret = 0;
@@ -5350,7 +5352,7 @@ static int workqueue_apply_unbound_cpumask(void)
 		if (wq->flags & __WQ_ORDERED)
 			continue;
 
-		ctx = apply_wqattrs_prepare(wq, wq->unbound_attrs);
+		ctx = apply_wqattrs_prepare(wq, wq->unbound_attrs, unbound_cpumask);
 		if (!ctx) {
 			ret = -ENOMEM;
 			break;
@@ -5365,6 +5367,11 @@ static int workqueue_apply_unbound_cpumask(void)
 		apply_wqattrs_cleanup(ctx);
 	}
 
+	if (!ret) {
+		mutex_lock(&wq_pool_attach_mutex);
+		cpumask_copy(wq_unbound_cpumask, unbound_cpumask);
+		mutex_unlock(&wq_pool_attach_mutex);
+	}
 	return ret;
 }
 
@@ -5383,7 +5390,6 @@ static int workqueue_apply_unbound_cpumask(void)
 int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
 {
 	int ret = -EINVAL;
-	cpumask_var_t saved_cpumask;
 
 	/*
 	 * Not excluding isolated cpus on purpose.
@@ -5397,23 +5403,8 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
 			goto out_unlock;
 		}
 
-		if (!zalloc_cpumask_var(&saved_cpumask, GFP_KERNEL)) {
-			ret = -ENOMEM;
-			goto out_unlock;
-		}
-
-		/* save the old wq_unbound_cpumask. */
-		cpumask_copy(saved_cpumask, wq_unbound_cpumask);
-
-		/* update wq_unbound_cpumask at first and apply it to wqs. */
-		cpumask_copy(wq_unbound_cpumask, cpumask);
-		ret = workqueue_apply_unbound_cpumask();
-
-		/* restore the wq_unbound_cpumask when failed. */
-		if (ret < 0)
-			cpumask_copy(wq_unbound_cpumask, saved_cpumask);
+		ret = workqueue_apply_unbound_cpumask(cpumask);
 
-		free_cpumask_var(saved_cpumask);
 out_unlock:
 		apply_wqattrs_unlock();
 	}
-- 
2.39.2



