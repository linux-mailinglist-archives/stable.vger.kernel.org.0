Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C95DF6EE
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 22:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbfJUUnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 16:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730121AbfJUUnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 16:43:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2AD02067B;
        Mon, 21 Oct 2019 20:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571690600;
        bh=dt9hxPARFEfnClSIpf//vDAuWZqBRB4c2WGlZjpZMdo=;
        h=Date:From:To:Subject:From;
        b=AM0QuBIl+aMLzC558GaNU8eVpa+7XuvAW2dXoew7RfH8Jk5ID+3ySD5KKBmr1Jps3
         Wr8t6H+DOw3ZFWslBRRHs/HfHrlaKOQMFkvboD1VY5as3/+JrGku9gliZDSofe95gt
         jwC1sBwHUiF5hogyLAXx6dUr8+8HSjFZWMjWd7yw=
Date:   Mon, 21 Oct 2019 13:43:19 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@intel.com, guro@fb.com, hannes@cmpxchg.org,
        honglei.wang@oracle.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        tim.c.chen@linux.intel.com, tj@kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?mm-vmscan-get-number-of-pages-on-the-lru-list-in-memcgroup?=
 =?US-ASCII?Q?-base-on-lru=5Fzone=5Fsize.patch?= removed from -mm tree
Message-ID: <20191021204319.Z_Ki-qYq5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcg: get number of pages on the LRU list in memcgroup base on lru_zone_size
has been removed from the -mm tree.  Its filename was
     mm-vmscan-get-number-of-pages-on-the-lru-list-in-memcgroup-base-on-lru_zone_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Honglei Wang <honglei.wang@oracle.com>
Subject: mm: memcg: get number of pages on the LRU list in memcgroup base on lru_zone_size

1a61ab8038e72 ("mm: memcontrol: replace zone summing with
lruvec_page_state()") has made lruvec_page_state to use per-cpu counters
instead of calculating it directly from lru_zone_size with an idea that
this would be more effective.  Tim has reported that this is not really
the case for their database benchmark which is showing an opposite results
where lruvec_page_state is taking up a huge chunk of CPU cycles (about 25%
of the system time which is roughly 7% of total cpu cycles) on 5.3
kernels.  The workload is running on a larger machine (96cpus), it has
many cgroups (500) and it is heavily direct reclaim bound.

Tim Chen said:

: The problem can also be reproduced by running simple multi-threaded
: pmbench benchmark with a fast Optane SSD swap (see profile below).
: 
: 
: 6.15%     3.08%  pmbench          [kernel.vmlinux]            [k] lruvec_lru_size
:             |
:             |--3.07%--lruvec_lru_size
:             |          |
:             |          |--2.11%--cpumask_next
:             |          |          |
:             |          |           --1.66%--find_next_bit
:             |          |
:             |           --0.57%--call_function_interrupt
:             |                     |
:             |                      --0.55%--smp_call_function_interrupt
:             |
:             |--1.59%--0x441f0fc3d009
:             |          _ops_rdtsc_init_base_freq
:             |          access_histogram
:             |          page_fault
:             |          __do_page_fault
:             |          handle_mm_fault
:             |          __handle_mm_fault
:             |          |
:             |           --1.54%--do_swap_page
:             |                     swapin_readahead
:             |                     swap_cluster_readahead
:             |                     |
:             |                      --1.53%--read_swap_cache_async
:             |                                __read_swap_cache_async
:             |                                alloc_pages_vma
:             |                                __alloc_pages_nodemask
:             |                                __alloc_pages_slowpath
:             |                                try_to_free_pages
:             |                                do_try_to_free_pages
:             |                                shrink_node
:             |                                shrink_node_memcg
:             |                                |
:             |                                |--0.77%--lruvec_lru_size
:             |                                |
:             |                                 --0.76%--inactive_list_is_low
:             |                                           |
:             |                                            --0.76%--lruvec_lru_size
:             |
:              --1.50%--measure_read
:                        page_fault
:                        __do_page_fault
:                        handle_mm_fault
:                        __handle_mm_fault
:                        do_swap_page
:                        swapin_readahead
:                        swap_cluster_readahead
:                        |
:                         --1.48%--read_swap_cache_async
:                                   __read_swap_cache_async
:                                   alloc_pages_vma
:                                   __alloc_pages_nodemask
:                                   __alloc_pages_slowpath
:                                   try_to_free_pages
:                                   do_try_to_free_pages
:                                   shrink_node
:                                   shrink_node_memcg
:                                   |
:                                   |--0.75%--inactive_list_is_low
:                                   |          |
:                                   |           --0.75%--lruvec_lru_size
:                                   |
:                                    --0.73%--lruvec_lru_size


The likely culprit is the cache traffic the lruvec_page_state_local
generates. Dave Hansen says:

: I was thinking purely of the cache footprint.  If it's reading
: pn->lruvec_stat_local->count[idx] is three separate cachelines, so 192
: bytes of cache *96 CPUs = 18k of data, mostly read-only.  1 cgroup would
: be 18k of data for the whole system and the caching would be pretty
: efficient and all 18k would probably survive a tight page fault loop in
: the L1.  500 cgroups would be ~90k of data per CPU thread which doesn't
: fit in the L1 and probably wouldn't survive a tight page fault loop if
: both logical threads were banging on different cgroups.
: 
: It's just a theory, but it's why I noted the number of cgroups when I
: initially saw this show up in profiles

Fix the regression by partially reverting the said commit and calculate
the lru size explicitly.

Link: http://lkml.kernel.org/r/20190905071034.16822-1-honglei.wang@oracle.com
Fixes: 1a61ab8038e72 ("mm: memcontrol: replace zone summing with lruvec_page_state()")
Signed-off-by: Honglei Wang <honglei.wang@oracle.com>
Reported-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Tested-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: <stable@vger.kernel.org>	[5.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-get-number-of-pages-on-the-lru-list-in-memcgroup-base-on-lru_zone_size
+++ a/mm/vmscan.c
@@ -351,12 +351,13 @@ unsigned long zone_reclaimable_pages(str
  */
 unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
 {
-	unsigned long lru_size;
+	unsigned long lru_size = 0;
 	int zid;
 
-	if (!mem_cgroup_disabled())
-		lru_size = lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
-	else
+	if (!mem_cgroup_disabled()) {
+		for (zid = 0; zid < MAX_NR_ZONES; zid++)
+			lru_size += mem_cgroup_get_zone_lru_size(lruvec, lru, zid);
+	} else
 		lru_size = node_page_state(lruvec_pgdat(lruvec), NR_LRU_BASE + lru);
 
 	for (zid = zone_idx + 1; zid < MAX_NR_ZONES; zid++) {
_

Patches currently in -mm which might be from honglei.wang@oracle.com are


