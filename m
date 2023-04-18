Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACB16E643B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjDRMr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjDRMr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:47:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7CC167E0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04882633C1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B39C433EF;
        Tue, 18 Apr 2023 12:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822035;
        bh=0zMHn+vl8tZXqRQgDBJyi4OlnrsKBNpVUbt5VeKehX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fllECoqnEPM/Ix4jzCt7RLkNJzdw0NiYRcsaTRbmkYAtOLNANSOmqoLVs9FiCP+FZ
         igRH0hYf5ETsBqkxD7sa7+PkkRFTGqxKalaMthqPPxe2w1oTgTf1Jq1IvmU48YLvz2
         zcdTZdeNzzRnGgUf4YCYY7w3VCyFa8VhPkqi5gDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Waiman Long <longman@redhat.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/134] cgroup/cpuset: Skip spread flags update on v2
Date:   Tue, 18 Apr 2023 14:23:08 +0200
Message-Id: <20230418120317.768995962@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 18f9a4d47527772515ad6cbdac796422566e6440 ]

Cpuset v2 has no spread flags to set. So we can skip spread
flags update if cpuset v2 is being used. Also change the name to
cpuset_update_task_spread_flags() to indicate that there are multiple
spread flags.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 42a11bf5c543 ("cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4c0c317083d05..1c549452c4abb 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -550,11 +550,15 @@ static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 /*
  * update task's spread flag if cpuset's page/slab spread flag is set
  *
- * Call with callback_lock or cpuset_rwsem held.
+ * Call with callback_lock or cpuset_rwsem held. The check can be skipped
+ * if on default hierarchy.
  */
-static void cpuset_update_task_spread_flag(struct cpuset *cs,
+static void cpuset_update_task_spread_flags(struct cpuset *cs,
 					struct task_struct *tsk)
 {
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys))
+		return;
+
 	if (is_spread_page(cs))
 		task_set_spread_page(tsk);
 	else
@@ -2165,7 +2169,7 @@ static void update_tasks_flags(struct cpuset *cs)
 
 	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
-		cpuset_update_task_spread_flag(cs, task);
+		cpuset_update_task_spread_flags(cs, task);
 	css_task_iter_end(&it);
 }
 
@@ -2547,7 +2551,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
 
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
-		cpuset_update_task_spread_flag(cs, task);
+		cpuset_update_task_spread_flags(cs, task);
 	}
 
 	/*
-- 
2.39.2



