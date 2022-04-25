Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19F950E4DD
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 17:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiDYP63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 11:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243045AbiDYP62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 11:58:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FE7B3BA4F
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 08:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650902123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PVSYP5Mpz/Q9il9/k10rbzttz20c1zE5kV+uNj/q4Vs=;
        b=ZiwkWS92wKZzwc8apWDTcJ/sC2FbK0qtuttlw6XoEsy1WRLuYLld/H+4ldmuYRnLQnzqSR
        r342uCbi3uCElfDxKbkh3MZrLgT3W2TgGKkWnlMsJgKALI8RGZpCzMacWZmfKETJtylTaH
        s94lrSgj5C2e6LcrTo4eEc1IUp66A8o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-bSGNyslVMsafW4i05ZIK1A-1; Mon, 25 Apr 2022 11:55:21 -0400
X-MC-Unique: bSGNyslVMsafW4i05ZIK1A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8B183C025B7;
        Mon, 25 Apr 2022 15:55:20 +0000 (UTC)
Received: from llong.com (unknown [10.22.9.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0667A404D2DB;
        Mon, 25 Apr 2022 15:55:18 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc:     cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()
Date:   Mon, 25 Apr 2022 11:55:05 -0400
Message-Id: <20220425155505.1292896-1-longman@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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

The first cpuset_init() function just sets all the bits in the masks.
The last one executed is cpuset_init_smp() which sets up cpu and node
masks suitable for v1, but not v2.  cpuset_bind() does the right setup
for both v1 and v2.

For systems with cgroup v2 setup, cpuset_bind() is called once. For
systems with cgroup v1 setup, cpuset_bind() is called twice. It is
first called before cpuset_init_smp() in cgroup v2 mode.  Then it is
called again when cgroup v1 filesystem is mounted in v1 mode after
cpuset_init_smp().

  [    2.609781] cpuset_bind() called - v2 = 1
  [    3.079473] cpuset_init_smp() called
  [    7.103710] cpuset_bind() called - v2 = 0

As a result, cpu and memory node hot add may fail to update the cpu and
node masks of the top cpuset to include the newly added cpu or node in
a cgroup v2 environment.

smp_init() is called after the first two init functions.  So we don't
have a complete list of active cpus and memory nodes until later in
cpuset_init_smp() which is the right time to set up effective_cpus
and effective_mems.

To fix this problem, the potentially incorrect cpus_allowed &
mems_allowed setup in cpuset_init_smp() are removed.  For cgroup v2
systems, the initial cpuset_bind() call will set them up correctly.
For cgroup v1 systems, the second call to cpuset_bind() will do the
right setup.

cc: stable@vger.kernel.org
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9390bfd9f1cd..6bd8f5ef40fe 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3390,8 +3390,9 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
  */
 void __init cpuset_init_smp(void)
 {
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_MEMORY];
+	/*
+	 * cpus_allowd/mems_allowed will be properly set up in cpuset_bind().
+	 */
 	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
 
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
-- 
2.27.0

