Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1527E90BCB
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 02:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfHQArv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 20:47:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25082 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725440AbfHQArv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 20:47:51 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7H0loO5007595
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 17:47:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=f0untXnGfzk5JYChmojS+SsOMJK63OBl74Lu74zjeYA=;
 b=bv3Wtcxvj4AyRQRkWCok1q7oTuqkJWfWBWRTOyOMva2Gq9I3/irczkxKjKZzXSRUAuKE
 tDuzGsn2sg1I0gfYd8ryZDh/2shlA9VjEzYm50/napxtlb8mN9u650oA3CRs3Ozwgna+
 vjtXrNp5k1Xk9Eo9z1oYyS/oEcXIoPrHb+E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ue2s611ha-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 17:47:50 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 16 Aug 2019 17:47:35 -0700
Received: by devvm2643.prn2.facebook.com (Postfix, from userid 111017)
        id D57C5166DC462; Fri, 16 Aug 2019 17:47:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm2643.prn2.facebook.com
To:     Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC:     Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <stable@vger.kernel.org>, Roman Gushchin <guro@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH] Partially revert "mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones"
Date:   Fri, 16 Aug 2019 17:47:26 -0700
Message-ID: <20190817004726.2530670-1-guro@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=996 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908170005
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync
with the hierarchical ones") effectively decreased the precision of
per-memcg vmstats_local and per-memcg-per-node lruvec percpu counters.

That's good for displaying in memory.stat, but brings a serious regression
into the reclaim process.

One issue I've discovered and debugged is the following:
lruvec_lru_size() can return 0 instead of the actual number of pages
in the lru list, preventing the kernel to reclaim last remaining
pages. Result is yet another dying memory cgroups flooding.
The opposite is also happening: scanning an empty lru list
is the waste of cpu time.

Also, inactive_list_is_low() can return incorrect values, preventing
the active lru from being scanned and freed. It can fail both because
the size of active and inactive lists are inaccurate, and because
the number of workingset refaults isn't precise. In other words,
the result is pretty random.

I'm not sure, if using the approximate number of slab pages in
count_shadow_number() is acceptable, but issues described above
are enough to partially revert the patch.

Let's keep per-memcg vmstat_local batched (they are only used for
displaying stats to the userspace), but keep lruvec stats precise.
This change fixes the dead memcg flooding on my setup.

Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones")
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 249187907339..3429340adb56 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -746,15 +746,13 @@ void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 	/* Update memcg */
 	__mod_memcg_state(memcg, idx, val);
 
+	/* Update lruvec */
+	__this_cpu_add(pn->lruvec_stat_local->count[idx], val);
+
 	x = val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
 	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
 		struct mem_cgroup_per_node *pi;
 
-		/*
-		 * Batch local counters to keep them in sync with
-		 * the hierarchical ones.
-		 */
-		__this_cpu_add(pn->lruvec_stat_local->count[idx], x);
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, pgdat->node_id))
 			atomic_long_add(x, &pi->lruvec_stat[idx]);
 		x = 0;
-- 
2.21.0

