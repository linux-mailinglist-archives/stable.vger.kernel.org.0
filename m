Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF4910D091
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 03:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfK2CuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 21:50:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46374 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726734AbfK2CuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 21:50:22 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAT2nXoQ005610
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 18:50:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=5FJkgGgzCf1fgKCuaKhYHWk01hSQay6gqnMgij0j1qQ=;
 b=kf0mYkKH0z7KYevqMtSg8h6JwS2sQ2Q0Mh5dCW5JfjkZDBlYjfH4s18rDU7qohRftgm2
 1lCNb8qIBO7WvN0rjWPTCSFVLhSGCegLvHsViL5rlXl+vWV0IDGIW6gS57rtQiUWFZPg
 3pSR/2SrYR/MezKT2tJNPCefotLe39X3pF8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wj528waym-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 18:50:21 -0800
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 28 Nov 2019 18:50:17 -0800
Received: by devvm2643.prn2.facebook.com (Postfix, from userid 111017)
        id 15BFE1AFF72C0; Thu, 28 Nov 2019 18:50:17 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm2643.prn2.facebook.com
To:     <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
CC:     Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>, <stable@vger.kernel.org>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2] mm: memcg/slab: wait for !root kmem_cache refcnt killing on root kmem_cache destruction
Date:   Thu, 28 Nov 2019 18:50:11 -0800
Message-ID: <20191129025011.3076017-1-guro@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_08:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=960 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911290024
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christian reported a warning like the following obtained during running some
KVM-related tests on s390:

WARNING: CPU: 8 PID: 208 at lib/percpu-refcount.c:108 percpu_ref_exit+0x50/0x58
Modules linked in: kvm(-) xt_CHECKSUM xt_MASQUERADE bonding xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_na>
CPU: 8 PID: 208 Comm: kworker/8:1 Not tainted 5.2.0+ #66
Hardware name: IBM 2964 NC9 712 (LPAR)
Workqueue: events sysfs_slab_remove_workfn
Krnl PSW : 0704e00180000000 0000001529746850 (percpu_ref_exit+0x50/0x58)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
Krnl GPRS: 00000000ffff8808 0000001529746740 000003f4e30e8e18 0036008100000000
           0000001f00000000 0035008100000000 0000001fb3573ab8 0000000000000000
           0000001fbdb6de00 0000000000000000 0000001529f01328 0000001fb3573b00
           0000001fbb27e000 0000001fbdb69300 000003e009263d00 000003e009263cd0
Krnl Code: 0000001529746842: f0a0000407fe        srp        4(11,%r0),2046,0
           0000001529746848: 47000700            bc         0,1792
          #000000152974684c: a7f40001            brc        15,152974684e
          >0000001529746850: a7f4fff2            brc        15,1529746834
           0000001529746854: 0707                bcr        0,%r7
           0000001529746856: 0707                bcr        0,%r7
           0000001529746858: eb8ff0580024        stmg       %r8,%r15,88(%r15)
           000000152974685e: a738ffff            lhi        %r3,-1
Call Trace:
([<000003e009263d00>] 0x3e009263d00)
 [<00000015293252ea>] slab_kmem_cache_release+0x3a/0x70
 [<0000001529b04882>] kobject_put+0xaa/0xe8
 [<000000152918cf28>] process_one_work+0x1e8/0x428
 [<000000152918d1b0>] worker_thread+0x48/0x460
 [<00000015291942c6>] kthread+0x126/0x160
 [<0000001529b22344>] ret_from_fork+0x28/0x30
 [<0000001529b2234c>] kernel_thread_starter+0x0/0x10
Last Breaking-Event-Address:
 [<000000152974684c>] percpu_ref_exit+0x4c/0x58
---[ end trace b035e7da5788eb09 ]---

The problem occurs because kmem_cache_destroy() is called immediately
after deleting of a memcg, so it races with the memcg kmem_cache
deactivation.

flush_memcg_workqueue() at the beginning of kmem_cache_destroy()
is supposed to guarantee that all deactivation processes are finished,
but failed to do so. It waits for an rcu grace period, after which all
children kmem_caches should be deactivated. During the deactivation
percpu_ref_kill() is called for non root kmem_cache refcounters,
but it requires yet another rcu grace period to finish the transition
to the atomic (dead) state.

So in a rare case when not all children kmem_caches are destroyed
at the moment when the root kmem_cache is about to be gone, we need
to wait another rcu grace period before destroying the root
kmem_cache.

This issue can be triggered only with dynamically created kmem_caches
which are used with memcg accounting. In this case per-memcg child
kmem_caches are created. They are deactivated from the cgroup removing
path. If the destruction of the root kmem_cache is racing with the
removal of the cgroup (both are quite complicated multi-stage
processes), the described issue can occur. The only known way to
trigger it in the real life, is to unload some kernel module which
creates a dedicated kmem_cache, used from different memory cgroups
with GFP_ACCOUNT flag. If the unloading happens immediately after
calling rmdir on the corresponding cgroup, there is some chance to
trigger the issue.

v2: added a note to the commit log, proposed by Michal Hocko

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Fixes: f0a3a24b532d ("mm: memcg/slab: rework non-root kmem_cache lifecycle management")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: stable@vger.kernel.org
---
 mm/slab_common.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8afa188f6e20..f0ab6d4ceb4c 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -904,6 +904,18 @@ static void flush_memcg_workqueue(struct kmem_cache *s)
 	 * previous workitems on workqueue are processed.
 	 */
 	flush_workqueue(memcg_kmem_cache_wq);
+
+	/*
+	 * If we're racing with children kmem_cache deactivation, it might
+	 * take another rcu grace period to complete their destruction.
+	 * At this moment the corresponding percpu_ref_kill() call should be
+	 * done, but it might take another rcu grace period to complete
+	 * switching to the atomic mode.
+	 * Please, note that we check without grabbing the slab_mutex. It's safe
+	 * because at this moment the children list can't grow.
+	 */
+	if (!list_empty(&s->memcg_params.children))
+		rcu_barrier();
 }
 #else
 static inline int shutdown_memcg_caches(struct kmem_cache *s)
-- 
2.17.1

