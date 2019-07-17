Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4D1C6C094
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 19:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfGQRpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 13:45:39 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:45366 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727255AbfGQRpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 13:45:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0TX8wp0U_1563385527;
Received: from e19h19392.et15sqa.tbsite.net(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TX8wp0U_1563385527)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Jul 2019 01:45:33 +0800
From:   Yang Shi <yang.shi@linux.alibaba.com>
To:     shakeelb@google.com, vdavydov.dev@gmail.com, hannes@cmpxchg.org,
        mhocko@suse.com, ktkhai@virtuozzo.com, guro@fb.com,
        hughd@google.com, cai@lca.pw, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
Cc:     yang.shi@linux.alibaba.com, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: vmscan: check if mem cgroup is disabled or not before calling memcg slab shrinker
Date:   Thu, 18 Jul 2019 01:45:26 +0800
Message-Id: <1563385526-20805-1-git-send-email-yang.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Shakeel Butt reported premature oom on kernel with
"cgroup_disable=memory" since mem_cgroup_is_root() returns false even
though memcg is actually NULL.  The drop_caches is also broken.

It is because commit aeed1d325d42 ("mm/vmscan.c: generalize shrink_slab()
calls in shrink_node()") removed the !memcg check before
!mem_cgroup_is_root().  And, surprisingly root memcg is allocated even
though memory cgroup is disabled by kernel boot parameter.

Add mem_cgroup_disabled() check to make reclaimer work as expected.

Fixes: aeed1d325d42 ("mm/vmscan.c: generalize shrink_slab() calls in shrink_node()")
Reported-by: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: stable@vger.kernel.org  4.19+
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
---
 mm/vmscan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f8e3dcd..c10dc02 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -684,7 +684,14 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
 	unsigned long ret, freed = 0;
 	struct shrinker *shrinker;
 
-	if (!mem_cgroup_is_root(memcg))
+	/*
+	 * The root memcg might be allocated even though memcg is disabled
+	 * via "cgroup_disable=memory" boot parameter.  This could make
+	 * mem_cgroup_is_root() return false, then just run memcg slab
+	 * shrink, but skip global shrink.  This may result in premature
+	 * oom.
+	 */
+	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
 		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
 
 	if (!down_read_trylock(&shrinker_rwsem))
-- 
1.8.3.1

