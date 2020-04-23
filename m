Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8501B549F
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 08:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgDWGQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 02:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725562AbgDWGQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 02:16:48 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE15C03C1AB
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 23:16:48 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w65so2425241pfc.12
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 23:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AiUiWL9DurW7cWt61hni629aKzDiuXg4UvitEEzN4eM=;
        b=oOCsiYHaBQkCFBJwZosL19Urqncqa87XSh9WIGq91imxp4PBDF3acnNEYOVJgR/Utc
         B/dE2mBmprHy3nXCgO4gy7Kduk8+Glqa4RpkNVFZt0FKLzs4+7yKNeB0KOaKz/SZM+Qt
         Ddh1A0jtKV6Xb4pe4TJXmMLhngx4eZ3T81b0uCsjw7UZ1IKX3Xq0QYf4MrsiCMxlG8uO
         is5al36KxtmwA1KBceg/0dwagpuM2/YZ0fAK+K8jNkidVPWwMBhRQdAuWlbfckIpBFQZ
         s1vzgOLBitTEkLumwyNi12e2BUs4YVsndaA9xKdKLvp6oM9ejcT8T5Bcll3jj7yzavIN
         Zi3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AiUiWL9DurW7cWt61hni629aKzDiuXg4UvitEEzN4eM=;
        b=sxi0b0VZXXAuFocOC/Q5ObJHL2fVf8rE83c9mmnTp9TeHxkH9QOT1hbVSuLFLWBegp
         kjRZt4qyY4v9/+AzLH1u+x0EaALRexTpAxp9L5SXERMX68KN7PNuqQ+JU3HCuAdar/lW
         geAV9rQgPt38ajTnJajOdVQzhiVRMgdV0vkADLWPbc4ob7l+icY5olds1FpYBNqe8e+f
         2jl0yQyiy+24CwZUzQbVwF1/XY2+3WRk2MtTZf+CPbQPAM9hU5G9nH5mXON5oZO+AUtT
         I8VwWfpuWXjCIYgNQ6HipH9IAoyllqQjQRF73P/r9AhcTZy9fp8T6Atcc5CAygARizpw
         RlEg==
X-Gm-Message-State: AGi0PuZt37OvWN7JqI+gAhAOdRwwmCwnPecvZNJAL6xmatfJ7XdFn2Qj
        kZMjG+JvX/W2C2/RVAC0pEY=
X-Google-Smtp-Source: APiQypLOZhPenYQEd/BLUxjkkdN41vzd8yW8gFo0dM+Is6vtiO6t7xUEJDKavdqft2129oLlhFWNKA==
X-Received: by 2002:a63:b64e:: with SMTP id v14mr2620194pgt.164.1587622607973;
        Wed, 22 Apr 2020 23:16:47 -0700 (PDT)
Received: from localhost.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id w30sm1501141pfj.25.2020.04.22.23.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 23:16:47 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com
Cc:     linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Subject: [PATCH] mm, memcg: fix wrong mem cgroup protection
Date:   Thu, 23 Apr 2020 02:16:29 -0400
Message-Id: <20200423061629.24185-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch is an improvement of a previous version[1], as the previous
version is not easy to understand.
This issue persists in the newest kernel, I have to resend the fix. As
the implementation is changed, I drop Roman's ack from the previous
version.

Here's the explanation of this issue.
memory.{low,min} won't take effect if the to-be-reclaimed memcg is the
sc->target_mem_cgroup, that can also be proved by the implementation in
mem_cgroup_protected(), see bellow,
	mem_cgroup_protected
		if (memcg == root) [2]
			return MEMCG_PROT_NONE;

But this rule is ignored in mem_cgroup_protection(), which will read
memory.{emin, elow} as the protection whatever the memcg is.

How would this issue happen?
Because in mem_cgroup_protected() we forget to clear the
memory.{emin, elow} if the memcg is target_mem_cgroup [2].

An example to illustrate this issue.
   root_mem_cgroup
         /
        A   memory.max: 1024M
            memory.min: 512M
            memory.current: 800M ('current' must be greater than 'min')
Once kswapd starts to reclaim memcg A, it assigns 512M to memory.emin of A.
Then kswapd stops.
As a result of it, the memory values of A will be,
   root_mem_cgroup
         /
        A   memory.max: 1024M
            memory.min: 512M
            memory.current: 512M (approximately)
            memory.emin: 512M

Then a new workload starts to run in memcg A, and it will trigger memcg
relcaim in A soon. As memcg A is the target_mem_cgroup of this
reclaimer, so it return directly without touching memory.{emin, elow}.[2]
The memory values of A will be,
   root_mem_cgroup
         /
        A   memory.max: 1024M
            memory.min: 512M
            memory.current: 1024M (approximately)
            memory.emin: 512M
Then this memory.emin will be used in mem_cgroup_protection() to get the
scan count, which is obvoiusly a wrong scan count.

[1]. https://lore.kernel.org/linux-mm/20200216145249.6900-1-laoar.shao@gmail.com/

Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
Cc: Chris Down <chris@chrisdown.name>
Cc: Roman Gushchin <guro@fb.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h | 13 +++++++++++--
 mm/vmscan.c                |  4 ++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d275c72c4f8e..114cfe06bf60 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -344,12 +344,20 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
+static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
+						  struct mem_cgroup *memcg,
 						  bool in_low_reclaim)
 {
 	if (mem_cgroup_disabled())
 		return 0;
 
+	/*
+	 * Memcg protection won't take effect if the memcg is the target
+	 * root memcg.
+	 */
+	if (root == memcg)
+		return 0;
+
 	if (in_low_reclaim)
 		return READ_ONCE(memcg->memory.emin);
 
@@ -835,7 +843,8 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 {
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
+static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
+						  struct mem_cgroup *memcg,
 						  bool in_low_reclaim)
 {
 	return 0;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b06868fc4926..ad2782f754ab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2346,9 +2346,9 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 		unsigned long protection;
 
 		lruvec_size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
-		protection = mem_cgroup_protection(memcg,
+		protection = mem_cgroup_protection(sc->target_mem_cgroup,
+						   memcg,
 						   sc->memcg_low_reclaim);
-
 		if (protection) {
 			/*
 			 * Scale a cgroup's reclaim pressure by proportioning
-- 
2.18.2

