Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6151850D6DF
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 04:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiDYCNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 22:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240346AbiDYCN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 22:13:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3C9F10E4
        for <stable@vger.kernel.org>; Sun, 24 Apr 2022 19:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650852608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IWt3Bi21zseUs/ls2Wi4USmCY2Ri5eVFWeb4jdyhkTo=;
        b=X5fNKqaAsmE182DHL6wtJG1+pbctajgbeQ/kRDGbFoznzE0oLAEMvmR0fddeMSD1hAlbeu
        7LLlcJNqemyfEl3SMLGVhnRb3MIxt9+8yTgc49KwAClg4Scp7QZetvById45TjePwEsOZN
        j9oaso1YSSXxD7nAuuk95XnTjGh318U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-3p3NdwLTNfuzW-O3zKYrLw-1; Sun, 24 Apr 2022 22:10:01 -0400
X-MC-Unique: 3p3NdwLTNfuzW-O3zKYrLw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8C44811E75;
        Mon, 25 Apr 2022 02:09:55 +0000 (UTC)
Received: from llong.com (unknown [10.22.8.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA0122026D6A;
        Mon, 25 Apr 2022 02:09:50 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc:     cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] cgroup/cpuset: Remove redundant cpu/node masks setup in cpuset_init_smp()
Date:   Sun, 24 Apr 2022 22:09:26 -0400
Message-Id: <20220425020926.1264611-1-longman@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are 3 places where the cpu and node masks of the top cpuset can
be initialized in the order they are executed:
 1) start_kernel -> cpuset_init()
 2) start_kernel -> cgroup_init() -> cpuset_bind()
 3) kernel_init_freeable() -> do_basic_setup() -> cpuset_init_smp()

The first cpuset_init() function just sets all the bits in the masks.
The last one executed is cpuset_init_smp() which sets up cpu and node
masks suitable for v1, but not v2.  cpuset_bind() does the right setup
for both v1 and v2 assuming that effective_mems and effective_cpus have
been set up properly which is not strictly the case here. As a result,
cpu and memory node hot add may fail to update the cpu and node masks
of the top cpuset to include the newly added cpu or node in a cgroup
v2 environment.

To fix this problem, the redundant cpus_allowed and mems_allowed
mask setup in cpuset_init_smp() are removed. The effective_cpus and
effective_mems setup there are moved to cpuset_bind().

cc: stable@vger.kernel.org
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9390bfd9f1cd..a2e15a43397e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2961,6 +2961,9 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
 	percpu_down_write(&cpuset_rwsem);
 	spin_lock_irq(&callback_lock);
 
+	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
+	top_cpuset.effective_mems = node_states[N_MEMORY];
+
 	if (is_in_v2_mode()) {
 		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
 		top_cpuset.mems_allowed = node_possible_map;
@@ -3390,13 +3393,6 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
  */
 void __init cpuset_init_smp(void)
 {
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_MEMORY];
-	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
-
-	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
-	top_cpuset.effective_mems = node_states[N_MEMORY];
-
 	register_hotmemory_notifier(&cpuset_track_online_nodes_nb);
 
 	cpuset_migrate_mm_wq = alloc_ordered_workqueue("cpuset_migrate_mm", 0);
-- 
2.27.0

