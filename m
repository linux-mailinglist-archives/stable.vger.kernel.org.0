Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83741318DFC
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhBKPTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230116AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0476364EF5;
        Thu, 11 Feb 2021 15:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055897;
        bh=L4Jnks8p1JU8VycW6uKh2RtHtGeBGYuc8bTPfrayRQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=na1oCyAYZ+53FSagRaC15S4esgOQyDw6KdfXZYde/aHpSEbclWN/kfebil3f2+y4q
         qKbq9xkhkFNvZbvNj5wbYzd49+1VTKIP3usjkUiMGFdepgo8cztYUZOUj4/ZK2QVFZ
         dBHr7IWGC7B3ws7JWhkSkGDaunPiUMNH9Xyxwwuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>,
        Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>,
        Shakeel Butt <shakeelb@google.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 50/54] Revert "mm: memcontrol: avoid workload stalls when lowering memory.high"
Date:   Thu, 11 Feb 2021 16:02:34 +0100
Message-Id: <20210211150155.053820733@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit e82553c10b0899994153f9bf0af333c0a1550fd7 upstream.

This reverts commit 536d3bf261a2fc3b05b3e91e7eef7383443015cf, as it can
cause writers to memory.high to get stuck in the kernel forever,
performing page reclaim and consuming excessive amounts of CPU cycles.

Before the patch, a write to memory.high would first put the new limit
in place for the workload, and then reclaim the requested delta.  After
the patch, the kernel tries to reclaim the delta before putting the new
limit into place, in order to not overwhelm the workload with a sudden,
large excess over the limit.  However, if reclaim is actively racing
with new allocations from the uncurbed workload, it can keep the write()
working inside the kernel indefinitely.

This is causing problems in Facebook production.  A privileged
system-level daemon that adjusts memory.high for various workloads
running on a host can get unexpectedly stuck in the kernel and
essentially turn into a sort of involuntary kswapd for one of the
workloads.  We've observed that daemon busy-spin in a write() for
minutes at a time, neglecting its other duties on the system, and
expending privileged system resources on behalf of a workload.

To remedy this, we have first considered changing the reclaim logic to
break out after a couple of loops - whether the workload has converged
to the new limit or not - and bound the write() call this way.  However,
the root cause that inspired the sequence change in the first place has
been fixed through other means, and so a revert back to the proven
limit-setting sequence, also used by memory.max, is preferable.

The sequence was changed to avoid extreme latencies in the workload when
the limit was lowered: the sudden, large excess created by the limit
lowering would erroneously trigger the penalty sleeping code that is
meant to throttle excessive growth from below.  Allocating threads could
end up sleeping long after the write() had already reclaimed the delta
for which they were being punished.

However, erroneous throttling also caused problems in other scenarios at
around the same time.  This resulted in commit b3ff92916af3 ("mm, memcg:
reclaim more aggressively before high allocator throttling"), included
in the same release as the offending commit.  When allocating threads
now encounter large excess caused by a racing write() to memory.high,
instead of entering punitive sleeps, they will simply be tasked with
helping reclaim down the excess, and will be held no longer than it
takes to accomplish that.  This is in line with regular limit
enforcement - i.e.  if the workload allocates up against or over an
otherwise unchanged limit from below.

With the patch breaking userspace, and the root cause addressed by other
means already, revert it again.

Link: https://lkml.kernel.org/r/20210122184341.292461-1-hannes@cmpxchg.org
Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering memory.high")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: <stable@vger.kernel.org>	[5.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6320,6 +6320,8 @@ static ssize_t memory_high_write(struct
 	if (err)
 		return err;
 
+	page_counter_set_high(&memcg->memory, high);
+
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
@@ -6343,10 +6345,7 @@ static ssize_t memory_high_write(struct
 			break;
 	}
 
-	page_counter_set_high(&memcg->memory, high);
-
 	memcg_wb_domain_size_changed(memcg);
-
 	return nbytes;
 }
 


