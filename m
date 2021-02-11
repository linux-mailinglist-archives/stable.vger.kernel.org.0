Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEB131925C
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 19:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhBKSfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 13:35:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhBKSdK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 13:33:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A6964E7E;
        Thu, 11 Feb 2021 18:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613068264;
        bh=Qm/sEYAW63qg3Gsypmbbzr936xN2O5xPoPLR3K0F52Y=;
        h=Date:From:To:Subject:From;
        b=VbcpN4fyNAowVyJNmxcg2liWc7DJOJ9vG6ICgW6JvmMWb1KZuQ5cMCeyAUGCSWiPB
         gLf/FqfGWuFltu7nP6wlN6ZnepZzEeZfeBqSnZdQc+AKIBhIKDNrg7apMf5RVrfKSo
         /N6aaPakpiGaTbGd3bbdKYfbzgomBqKEilW3PcCo=
Date:   Thu, 11 Feb 2021 10:31:04 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mkoutny@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org, tj@kernel.org
Subject:  [merged]
 revert-mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch
 removed from -mm tree
Message-ID: <20210211183104.pDInxyzku%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "mm: memcontrol: avoid workload stalls when lowering m=
emory.high"
has been removed from the -mm tree.  Its filename was
     revert-mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.pa=
tch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: Revert "mm: memcontrol: avoid workload stalls when lowering memory=
.high"

This reverts commit 536d3bf261a2fc3b05b3e91e7eef7383443015cf, as it can
cause writers to memory.high to get stuck in the kernel forever,
performing page reclaim and consuming excessive amounts of CPU cycles.

Before the patch, a write to memory.high would first put the new limit in
place for the workload, and then reclaim the requested delta.  After the
patch, the kernel tries to reclaim the delta before putting the new limit
into place, in order to not overwhelm the workload with a sudden, large
excess over the limit.  However, if reclaim is actively racing with new
allocations from the uncurbed workload, it can keep the write() working
inside the kernel indefinitely.

This is causing problems in Facebook production.  A privileged
system-level daemon that adjusts memory.high for various workloads running
on a host can get unexpectedly stuck in the kernel and essentially turn
into a sort of involuntary kswapd for one of the workloads.  We've
observed that daemon busy-spin in a write() for minutes at a time,
neglecting its other duties on the system, and expending privileged system
resources on behalf of a workload.

To remedy this, we have first considered changing the reclaim logic to
break out after a couple of loops - whether the workload has converged to
the new limit or not - and bound the write() call this way.  However, the
root cause that inspired the sequence change in the first place has been
fixed through other means, and so a revert back to the proven
limit-setting sequence, also used by memory.max, is preferable.

The sequence was changed to avoid extreme latencies in the workload when
the limit was lowered: the sudden, large excess created by the limit
lowering would erroneously trigger the penalty sleeping code that is meant
to throttle excessive growth from below.  Allocating threads could end up
sleeping long after the write() had already reclaimed the delta for which
they were being punished.

However, erroneous throttling also caused problems in other scenarios at
around the same time.  This resulted in commit b3ff92916af3 ("mm, memcg:
reclaim more aggressively before high allocator throttling"), included in
the same release as the offending commit.  When allocating threads now
encounter large excess caused by a racing write() to memory.high, instead
of entering punitive sleeps, they will simply be tasked with helping
reclaim down the excess, and will be held no longer than it takes to
accomplish that.  This is in line with regular limit enforcement - i.e.=20
if the workload allocates up against or over an otherwise unchanged limit
from below.

With the patch breaking userspace, and the root cause addressed by other
means already, revert it again.

Link: https://lkml.kernel.org/r/20210122184341.292461-1-hannes@cmpxchg.org
Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering m=
emory.high")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: <stable@vger.kernel.org>	[5.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~revert-mm-memcontrol-avoid-workload-stalls-when-lower=
ing-memoryhigh
+++ a/mm/memcontrol.c
@@ -6271,6 +6271,8 @@ static ssize_t memory_high_write(struct
 	if (err)
 		return err;
=20
+	page_counter_set_high(&memcg->memory, high);
+
 	for (;;) {
 		unsigned long nr_pages =3D page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
@@ -6294,10 +6296,7 @@ static ssize_t memory_high_write(struct
 			break;
 	}
=20
-	page_counter_set_high(&memcg->memory, high);
-
 	memcg_wb_domain_size_changed(memcg);
-
 	return nbytes;
 }
=20
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

fs-buffer-use-raw-page_memcg-on-locked-page.patch
mm-vmstat-fix-nohz-wakeups-for-node-stat-changes.patch
mm-vmstat-add-some-comments-on-internal-storage-of-byte-items.patch

