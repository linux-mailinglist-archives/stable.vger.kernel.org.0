Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B871FA2807
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 22:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfH2Ub5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 16:31:57 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:41961 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfH2Ub5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 16:31:57 -0400
Received: by mail-pl1-f202.google.com with SMTP id b23so2657459pls.8
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 13:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=geHtoFXurL0uoZHjOhgaOZVjBMzfZ9r5aS+mHaqaGKA=;
        b=clb8vgnfdAWejSqdYesxGEEQnx4giF3KnWD9AiidlIHSstMsGWsGy5pi0M0JJt14PR
         oYpbacQ7W+rsBrVExXVXJ4anZmp0jL84zhjJvFId3vj95RMAe8GdttHBbsWBaHuHcP42
         Q2LXVjKc27IwhIz/Qnb0Kbv8NlEskVG5j9GhD7dM/r0Gtg5Way7BtwKntEsyPOk5O8/Z
         cTWU+RZgNMJMHywTXWh3H8drfMAfUmysLJzfn4+Lj7kai3KiAhc7L5GtkVP61Eu1UKaY
         77K380nwQWhYnUgNtnUwbV1BJ4QvxkXmgSz6ZAvI8KB7LaKpCuzuuRb2HQxu1a0b649F
         shcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=geHtoFXurL0uoZHjOhgaOZVjBMzfZ9r5aS+mHaqaGKA=;
        b=MP4gUwOnbyL63at5ZngwEm0T4RM4WFCELIsUCLCV5tYc+fSJ/DEPg3Gg5N+0kWIobs
         X8mVinUi60wLWnCYY6fqjmEgI8PUnBPFCU6iUZDCQdJctDbymflzz85/1BnP5LadEVJE
         rMXxMtKRKDGKXz26BhJL4LHY2+CrUkvTtUv9TKnFGSjR59CGxt1mDuHROYuwblQ0MmRS
         V5gfsIrPphPeidUgEEEJ9W0IUkFzcLBH1URne3CcADu9gFzTiYKHkM0u42zfDI514lNq
         hWNh88mXAmpg5u+qEpbcplvzSOxVMqT5zl1e0r+pA4ZQTRVNPx7IE/XUW/W1DdiXTnYz
         +5xQ==
X-Gm-Message-State: APjAAAVnCq7Wny8onvayX5O0Pboe8zWCbK5MCNYFLxdH/vBt5tzPxeI7
        fefxjrPQ38lrz9wd1lxSN9Ms1cTUm5oKFA==
X-Google-Smtp-Source: APXvYqw6jTDiw5RFZN+vIR41RyOP9xsg4tXKrl+EiImbjrdsMxY4mqDerTnQl3fwg7DsBEt0qE524hAjLzYavg==
X-Received: by 2002:a63:30c6:: with SMTP id w189mr9624802pgw.398.1567110716648;
 Thu, 29 Aug 2019 13:31:56 -0700 (PDT)
Date:   Thu, 29 Aug 2019 13:31:10 -0700
Message-Id: <20190829203110.129263-1-shakeelb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH] mm: memcontrol: fix percpu vmstats and vmevents flush
From:   Shakeel Butt <shakeelb@google.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Instead of using raw_cpu_read() use per_cpu() to read the actual data of
the corresponding cpu otherwise we will be reading the data of the
current cpu for the number of online CPUs.

Fixes: bb65f89b7d3d ("mm: memcontrol: flush percpu vmevents before releasing memcg")
Fixes: c350a99ea2b1 ("mm: memcontrol: flush percpu vmstats before releasing memcg")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
---

Note: The buggy patches were marked for stable therefore adding Cc to
stable.

 mm/memcontrol.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 26e2999af608..f4e60ee8b845 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3271,7 +3271,7 @@ static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg)
 
 	for_each_online_cpu(cpu)
 		for (i = 0; i < MEMCG_NR_STAT; i++)
-			stat[i] += raw_cpu_read(memcg->vmstats_percpu->stat[i]);
+			stat[i] += per_cpu(memcg->vmstats_percpu->stat[i], cpu);
 
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
 		for (i = 0; i < MEMCG_NR_STAT; i++)
@@ -3286,8 +3286,8 @@ static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg)
 
 		for_each_online_cpu(cpu)
 			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-				stat[i] += raw_cpu_read(
-					pn->lruvec_stat_cpu->count[i]);
+				stat[i] += per_cpu(
+					pn->lruvec_stat_cpu->count[i], cpu);
 
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, node))
 			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
@@ -3306,8 +3306,8 @@ static void memcg_flush_percpu_vmevents(struct mem_cgroup *memcg)
 
 	for_each_online_cpu(cpu)
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
-			events[i] += raw_cpu_read(
-				memcg->vmstats_percpu->events[i]);
+			events[i] += per_cpu(memcg->vmstats_percpu->events[i],
+					     cpu);
 
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
-- 
2.23.0.187.g17f5b7556c-goog

