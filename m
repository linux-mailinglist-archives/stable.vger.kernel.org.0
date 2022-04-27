Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7166511B83
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 16:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238746AbiD0O6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 10:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238808AbiD0O6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 10:58:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 881DB5F650
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 07:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651071295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0IQvTcMEBnE+yly3Jqj1m7ej/vPl078aXENmc+H4j+E=;
        b=SbWrfMzfDkn1DxuPq4J5ZjOQZ2etBpuIYwsVQqaFopRyh4aBjkZXsZvNaVpT4iN0oW4Z/C
        efqX8dJZGScNCgJW5VLH1tHmP0ig/nehmGfQDHo/LsScCjHTiQFK0Qt7dtsw9RenBYvu2O
        3Pnvm/JKAb7oEfAJR3UZ8JumX1AlAp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-Ady9gyINNF6aO5JBgqcudA-1; Wed, 27 Apr 2022 10:54:51 -0400
X-MC-Unique: Ady9gyINNF6aO5JBgqcudA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E42185A5BE;
        Wed, 27 Apr 2022 14:54:50 +0000 (UTC)
Received: from llong.com (unknown [10.22.11.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A33FD20296A5;
        Wed, 27 Apr 2022 14:54:41 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc:     cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v3] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()
Date:   Wed, 27 Apr 2022 10:54:28 -0400
Message-Id: <20220427145428.1411867-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,TVD_SUBJ_WIPE_DEBT autolearn=no
        autolearn_force=no version=3.4.6
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

The first cpuset_init() call just sets all the bits in the masks.
The second cpuset_bind() call sets cpus_allowed and mems_allowed to the
default v2 values. The third cpuset_init_smp() call sets them back to
v1 values.

For systems with cgroup v2 setup, cpuset_bind() is called once.  As a
result, cpu and memory node hot add may fail to update the cpu and node
masks of the top cpuset to include the newly added cpu or node in a
cgroup v2 environment.

For systems with cgroup v1 setup, cpuset_bind() is called again by
rebind_subsystem() when the v1 cpuset filesystem is mounted as shown
in the dmesg log below with an instrumented kernel.

  [    2.609781] cpuset_bind() called - v2 = 1
  [    3.079473] cpuset_init_smp() called
  [    7.103710] cpuset_bind() called - v2 = 0

smp_init() is called after the first two init functions.  So we don't
have a complete list of active cpus and memory nodes until later in
cpuset_init_smp() which is the right time to set up effective_cpus
and effective_mems.

To fix this cgroup v2 mask setup problem, the potentially incorrect
cpus_allowed & mems_allowed setting in cpuset_init_smp() are removed.
For cgroup v2 systems, the initial cpuset_bind() call will set the masks
correctly.  For cgroup v1 systems, the second call to cpuset_bind()
will do the right setup.

cc: stable@vger.kernel.org
Signed-off-by: Waiman Long <longman@redhat.com>
Tested-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
---
 kernel/cgroup/cpuset.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9390bfd9f1cd..71a418858a5e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3390,8 +3390,11 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
  */
 void __init cpuset_init_smp(void)
 {
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_MEMORY];
+	/*
+	 * cpus_allowd/mems_allowed set to v2 values in the initial
+	 * cpuset_bind() call will be reset to v1 values in another
+	 * cpuset_bind() call when v1 cpuset is mounted.
+	 */
 	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
 
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
-- 
2.27.0

