Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF474A2981
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 00:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfH2WQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 18:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbfH2WQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 18:16:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 151922166E;
        Thu, 29 Aug 2019 22:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567116971;
        bh=70uwIyIQ6T1En7B+U+Y1fMaNs6qwOr4svK4HY4gj1NU=;
        h=Date:From:To:Subject:From;
        b=Id1VoN9NgZZjbe6SIDm9+rDduYWAaYxUSMFhAGZX3Av9dNV6a+1K8j2TAv+30RTcU
         eDPXweBBMRpclb4V1pX3HLMVNc2OQqitDNGoC4MWVGRS9NaA4fQjg71xS02/xEgwI2
         6bmg55BITwwDTVJwIZxAF7FDYBlufsB3DLileqLo=
Date:   Thu, 29 Aug 2019 15:16:10 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-fix-percpu-vmstats-and-vmevents-flush.patch added to -mm tree
Message-ID: <20190829221610.bZwUI5iIh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix percpu vmstats and vmevents flush
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-percpu-vmstats-and-vmevents-flush.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-percpu-vmstats-and-vmevents-flush.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-percpu-vmstats-and-vmevents-flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: memcontrol: fix percpu vmstats and vmevents flush

Instead of using raw_cpu_read() use per_cpu() to read the actual data of
the corresponding cpu otherwise we will be reading the data of the current
cpu for the number of online CPUs.

Link: http://lkml.kernel.org/r/20190829203110.129263-1-shakeelb@google.com
Fixes: bb65f89b7d3d ("mm: memcontrol: flush percpu vmevents before releasing memcg")
Fixes: c350a99ea2b1 ("mm: memcontrol: flush percpu vmstats before releasing memcg")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-percpu-vmstats-and-vmevents-flush
+++ a/mm/memcontrol.c
@@ -3278,7 +3278,7 @@ static void memcg_flush_percpu_vmstats(s
 
 	for_each_online_cpu(cpu)
 		for (i = min_idx; i < max_idx; i++)
-			stat[i] += raw_cpu_read(memcg->vmstats_percpu->stat[i]);
+			stat[i] += per_cpu(memcg->vmstats_percpu->stat[i], cpu);
 
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
 		for (i = min_idx; i < max_idx; i++)
@@ -3296,8 +3296,8 @@ static void memcg_flush_percpu_vmstats(s
 
 		for_each_online_cpu(cpu)
 			for (i = min_idx; i < max_idx; i++)
-				stat[i] += raw_cpu_read(
-					pn->lruvec_stat_cpu->count[i]);
+				stat[i] += per_cpu(
+					pn->lruvec_stat_cpu->count[i], cpu);
 
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, node))
 			for (i = min_idx; i < max_idx; i++)
@@ -3316,8 +3316,8 @@ static void memcg_flush_percpu_vmevents(
 
 	for_each_online_cpu(cpu)
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
-			events[i] += raw_cpu_read(
-				memcg->vmstats_percpu->events[i]);
+			events[i] += per_cpu(memcg->vmstats_percpu->events[i],
+					     cpu);
 
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-memcontrol-fix-percpu-vmstats-and-vmevents-flush.patch

