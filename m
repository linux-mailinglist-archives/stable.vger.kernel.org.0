Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B126E4C5E
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 17:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjDQPHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 11:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDQPHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 11:07:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0725C10E
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 08:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681744006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wihp4uuCb0YZw+NiGtqGQClL5ZJ30LDIwuZ8XmYLCpQ=;
        b=erNtG24/Vl0UYCjyUtpdPt0ecGpRv0bNexfdR1ciRCcsqAizHAnn25VBrQmDoady5TrZdp
        y51Br8JuNwVSDnJjNXtFIR9SqI8H8OpS9kGSKA8sldfipTQXSkzcBFaQGy9kb1JELIgoEh
        ymVZ3CDK0xbtVd1e79y/mOo8Qo0Mu88=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-Lv8qfQNqNtenifX3p1_8ag-1; Mon, 17 Apr 2023 11:06:44 -0400
X-MC-Unique: Lv8qfQNqNtenifX3p1_8ag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51F8C29ABA1D;
        Mon, 17 Apr 2023 15:06:44 +0000 (UTC)
Received: from llong.com (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D99040C20FA;
        Mon, 17 Apr 2023 15:06:44 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH 6.1 1/3] cgroup/cpuset: Skip spread flags update on v2
Date:   Mon, 17 Apr 2023 11:06:28 -0400
Message-Id: <20230417150630.3369187-1-longman@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 18f9a4d47527772515ad6cbdac796422566e6440 upstream.

Cpuset v2 has no spread flags to set. So we can skip spread
flags update if cpuset v2 is being used. Also change the name to
cpuset_update_task_spread_flags() to indicate that there are multiple
spread flags.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cpuset.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index fac426036620..7c418ce4d3c9 100644
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
@@ -2157,7 +2161,7 @@ static void update_tasks_flags(struct cpuset *cs)
 
 	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
-		cpuset_update_task_spread_flag(cs, task);
+		cpuset_update_task_spread_flags(cs, task);
 	css_task_iter_end(&it);
 }
 
@@ -2535,7 +2539,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
 
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
-		cpuset_update_task_spread_flag(cs, task);
+		cpuset_update_task_spread_flags(cs, task);
 	}
 
 	/*
-- 
2.31.1

