Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3DE2F3EE1
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394094AbhALWFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 17:05:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394174AbhALWE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 17:04:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F37BA221F5;
        Tue, 12 Jan 2021 22:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610489057;
        bh=ZaSIXm2lumXBYNPeyk1NRRneKKe8XqoXpdNOY+1Mzys=;
        h=Date:From:To:Subject:From;
        b=kzOENaFulgHBk39exkhCBuxcEH/ux5X5rzmqk0l8+qWT5D3YxXfccRONjOeQx9P2l
         pWNRNfFC2Yrg0ZgdJx3NOHMNW9VI7Rk0FALOzLkEhRvoZ5lO2hV6+iTTx11qbmBMYH
         2DcSNBFdhUC6C+SASc8eqfqFkvFtD1/dMfIYWM3A=
Date:   Tue, 12 Jan 2021 14:04:16 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, tj@kernel.org
Subject:  +
 mm-memcontrol-prevent-starvation-when-writing-memoryhigh.patch added to -mm
 tree
Message-ID: <20210112220416.zrt4UTYJ2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: prevent starvation when writing memory.high
has been added to the -mm tree.  Its filename is
     mm-memcontrol-prevent-starvation-when-writing-memoryhigh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-prevent-starvation-when-writing-memoryhigh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-prevent-starvation-when-writing-memoryhigh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: prevent starvation when writing memory.high

When a value is written to a cgroup's memory.high control file, the
write() context first tries to reclaim the cgroup to size before putting
the limit in place for the workload.  Concurrent charges from the workload
can keep such a write() looping in reclaim indefinitely.

In the past, a write to memory.high would first put the limit in place for
the workload, then do targeted reclaim until the new limit has been met -
similar to how we do it for memory.max.  This wasn't prone to the
described starvation issue.  However, this sequence could cause excessive
latencies in the workload, when allocating threads could be put into long
penalty sleeps on the sudden memory.high overage created by the write(),
before that had a chance to work it off.

Now that memory_high_write() performs reclaim before enforcing the new
limit, reflect that the cgroup may well fail to converge due to concurrent
workload activity.  Bail out of the loop after a few tries.

Link: https://lkml.kernel.org/r/20210112163011.127833-1-hannes@cmpxchg.org
Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering memory.high")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[5.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-prevent-starvation-when-writing-memoryhigh
+++ a/mm/memcontrol.c
@@ -6273,7 +6273,6 @@ static ssize_t memory_high_write(struct
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
-		unsigned long reclaimed;
 
 		if (nr_pages <= high)
 			break;
@@ -6287,10 +6286,10 @@ static ssize_t memory_high_write(struct
 			continue;
 		}
 
-		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-							 GFP_KERNEL, true);
+		try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
+					     GFP_KERNEL, true);
 
-		if (!reclaimed && !nr_retries--)
+		if (!nr_retries--)
 			break;
 	}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-prevent-starvation-when-writing-memoryhigh.patch

