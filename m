Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E978F60A7A0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbiJXMyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiJXMwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D45101E1;
        Mon, 24 Oct 2022 05:14:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8170B6128E;
        Mon, 24 Oct 2022 12:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98031C433C1;
        Mon, 24 Oct 2022 12:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613545;
        bh=P930n1nSM3z63KMYHL4L/pCD1C+IPjaalcWZsoat+3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3dV3cMRgtThcS3ympUH0KXVUxDn/8eDZmbrvl4yovmx0vfAgRBs9Km0Cb6XWNeXh
         chUhkJVygkj3k8vj5InIqAy/rbIPIesMZyTVybyC2j53xnCxkKSgAb10eaJZXHscs2
         j59DSxp9HjyzxvZHqqXnt2DjniSMHbY0/KEseZ9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 177/255] cgroup/cpuset: Enable update_tasks_cpumask() on top_cpuset
Date:   Mon, 24 Oct 2022 13:31:27 +0200
Message-Id: <20221024113008.721313707@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
index 9ba94a9a67aa..c7f4526ca64e 100644
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
@@ -1057,10 +1058,18 @@ static void update_tasks_cpumask(struct cpuset *cs)
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
 
@@ -2014,12 +2023,7 @@ static int update_prstate(struct cpuset *cs, int val)
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
 		update_sibling_cpumasks(parent, cs, &tmp);
-- 
2.35.1



