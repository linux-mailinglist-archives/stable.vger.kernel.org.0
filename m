Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EC017866C
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 00:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgCCXgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 18:36:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60878 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728126AbgCCXgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 18:36:03 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 023NTXXS002005
        for <stable@vger.kernel.org>; Tue, 3 Mar 2020 15:36:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=v54f4hvtEpOMZZj7Wq4+S30Pdqx6OVy19TrOKQ69H14=;
 b=ZLUPAVrVrvWOH07Sei5a8edivsFuryHz/mhmicFdCuYVrgEFGEAv1Bq9Y5CgWrF9qdIX
 3dB4VtAD0jC46moXjUuSGBtdKnWX3hCKSrhp8L/uuf8SR2tiNb9z7Ou50fgWt1oex0CO
 zxOxx13KFNf01gbbyi1P3olovII8Feslg8Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yhwxxh89r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 15:36:02 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 3 Mar 2020 15:36:01 -0800
Received: by devvm2643.prn2.facebook.com (Postfix, from userid 111017)
        id 971CA2FA13176; Tue,  3 Mar 2020 15:35:51 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm2643.prn2.facebook.com
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, <linux-mm@kvack.org>,
        <kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Roman Gushchin <guro@fb.com>, <stable@vger.kernel.org>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH] mm: fork: fix kernel_stack memcg stats for various stack implementations
Date:   Tue, 3 Mar 2020 15:35:50 -0800
Message-ID: <20200303233550.251375-1-guro@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_08:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1011
 malwarescore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030154
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Depending on CONFIG_VMAP_STACK and the THREAD_SIZE / PAGE_SIZE ratio
the space for task stacks can be allocated using __vmalloc_node_range(),
alloc_pages_node() and kmem_cache_alloc_node(). In the first and the
second cases page->mem_cgroup pointer is set, but in the third it's
not: memcg membership of a slab page should be determined using the
memcg_from_slab_page() function, which looks at
page->slab_cache->memcg_params.memcg . In this case, using
mod_memcg_page_state() (as in account_kernel_stack()) is incorrect:
page->mem_cgroup pointer is NULL even for pages charged to a non-root
memory cgroup.

It can lead to kernel_stack per-memcg counters permanently showing 0
on some architectures (depending on the configuration).

In order to fix it, let's introduce a mod_memcg_obj_state() helper,
which takes a pointer to a kernel object as a first argument, uses
mem_cgroup_from_obj() to get a RCU-protected memcg pointer and
calls mod_memcg_state(). It allows to handle all possible
configurations (CONFIG_VMAP_STACK and various THREAD_SIZE/PAGE_SIZE
values) without spilling any memcg/kmem specifics into fork.c .

Note: this patch has been first posted as a part of the new slab
controller patchset. This is a slightly updated version: the fixes
tag has been added and the commit log was extended by the advice
of Johannes Weiner. Because it's a fix that makes sense by itself,
I'm re-posting it as a standalone patch.

Fixes: 4d96ba353075 ("mm: memcg/slab: stop setting page->mem_cgroup pointer for slab pages")
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: stable@vger.kernel.org
---
 include/linux/memcontrol.h |  5 +++++
 kernel/fork.c              |  4 ++--
 mm/memcontrol.c            | 11 +++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 3253d5de8243..817ea1d93e0e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -695,6 +695,7 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
+void mod_memcg_obj_state(void *p, int idx, int val);
 
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
@@ -1129,6 +1130,10 @@ static inline void __mod_lruvec_slab_state(void *p, enum node_stat_item idx,
 	__mod_node_page_state(page_pgdat(page), idx, val);
 }
 
+static inline void mod_memcg_obj_state(void *p, int idx, int val)
+{
+}
+
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
diff --git a/kernel/fork.c b/kernel/fork.c
index a1f2f5205a61..bdc5004effa4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -404,8 +404,8 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 		mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
 				    THREAD_SIZE / 1024 * account);
 
-		mod_memcg_page_state(first_page, MEMCG_KERNEL_STACK_KB,
-				     account * (THREAD_SIZE / 1024));
+		mod_memcg_obj_state(stack, MEMCG_KERNEL_STACK_KB,
+				    account * (THREAD_SIZE / 1024));
 	}
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d1ae46838af1..6514df549433 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -776,6 +776,17 @@ void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
 	rcu_read_unlock();
 }
 
+void mod_memcg_obj_state(void *p, int idx, int val)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_obj(p);
+	if (memcg)
+		mod_memcg_state(memcg, idx, val);
+	rcu_read_unlock();
+}
+
 /**
  * __count_memcg_events - account VM events in a cgroup
  * @memcg: the memory cgroup
-- 
2.24.1

