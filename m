Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4529D60B05F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiJXQFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiJXQEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:04:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C43C48C91;
        Mon, 24 Oct 2022 07:56:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12AD5B811BE;
        Mon, 24 Oct 2022 12:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62653C433C1;
        Mon, 24 Oct 2022 12:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614473;
        bh=TSjoHx9SAKNV0MMEJApepwgZRfRkoPzmJXeQfO9jPJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jh9LGlkc5xR5ChduVwXveTuJ+PXgGMnqLp2Auqg+sM1ZOCkPbO7SCosegAGznxnJZ
         aMNmE01vl+gVXhoMLSCu2mcAfM/ExOVJ8jTeTGem5I9601vU6dcSRRJH2ROJEGkucq
         8RcC4KQcJ7qH4NG7Gu90FDklcTOIjAa5XdaecOGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/390] cgroup/cpuset: Enable update_tasks_cpumask() on top_cpuset
Date:   Mon, 24 Oct 2022 13:31:11 +0200
Message-Id: <20221024113034.598799027@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit ec5fbdfb99d18482619ac42605cb80fbb56068ee ]

Previously, update_tasks_cpumask() is not supposed to be called with
top cpuset. With cpuset partition that takes CPUs away from the top
cpuset, adjusting the cpus_mask of the tasks in the top cpuset is
necessary. Percpu kthreads, however, are ignored.

Fixes: ee8dde0cd2ce ("cpuset: Add new v2 cpuset.sched.partition flag")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b7830f1f1f3a..43270b07b2e0 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -33,6 +33,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/kmod.h>
+#include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
@@ -1059,10 +1060,18 @@ static void update_tasks_cpumask(struct cpuset *cs)
 {
 	struct css_task_iter it;
 	struct task_struct *task;
+	bool top_cs = cs == &top_cpuset;
 
 	css_task_iter_start(&cs->css, 0, &it);
-	while ((task = css_task_iter_next(&it)))
+	while ((task = css_task_iter_next(&it))) {
+		/*
+		 * Percpu kthreads in top_cpuset are ignored
+		 */
+		if (top_cs && (task->flags & PF_KTHREAD) &&
+		    kthread_is_per_cpu(task))
+			continue;
 		set_cpus_allowed_ptr(task, cs->effective_cpus);
+	}
 	css_task_iter_end(&it);
 }
 
@@ -2016,12 +2025,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 	}
 
-	/*
-	 * Update cpumask of parent's tasks except when it is the top
-	 * cpuset as some system daemons cannot be mapped to other CPUs.
-	 */
-	if (parent != &top_cpuset)
-		update_tasks_cpumask(parent);
+	update_tasks_cpumask(parent);
 
 	if (parent->child_ecpus_count)
 		update_sibling_cpumasks(parent, cs, &tmpmask);
-- 
2.35.1



