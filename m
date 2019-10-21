Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF3BDF805
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 00:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbfJUWcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 18:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfJUWcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 18:32:42 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04EB62067B;
        Mon, 21 Oct 2019 22:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571697162;
        bh=qUoJsWhNDmVeiFXqs8ipHuksal8gXWue/H/+1X/+WgI=;
        h=Date:From:To:Subject:From;
        b=dQDoq2SEzWfpsxeD7NIzuQuPEz542W7+dgVij1mEYIcC0MCVRIiY/EkUuhnBCMjx9
         364Kq/84tfN0DagRvfLEY6DSIhX78UghiGo7eycBbdWAHlbYEUeChk1QySWWbp6lYk
         IGTPDQ4soQpndwnGgL/3wyFNwGMgzje7i5ayy1f0=
Date:   Mon, 21 Oct 2019 15:32:41 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tglx@linutronix.de,
        stable@vger.kernel.org, mhocko@suse.com, matt@codeblueprint.co.uk,
        bp@alien8.de, mgorman@techsingularity.net
Subject:  [to-be-updated]
 =?us-ascii?Q?mm-pcp-share-common-code-between-memory-hotplug-and-percpu-?=
 =?us-ascii?Q?sysctl-handler.patch?= removed from -mm tree
Message-ID: <20191021223241.exF1u%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, pcp: share common code between memory hotplug and percpu sysctl handler
has been removed from the -mm tree.  Its filename was
     mm-pcp-share-common-code-between-memory-hotplug-and-percpu-sysctl-handler.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, pcp: share common code between memory hotplug and percpu sysctl handler

Both the percpu_pagelist_fraction sysctl handler and memory hotplug have a
common requirement of updating the pcpu page allocation batch and high
values.  Split the relevant helper to share common code.

No functional change.

Link: http://lkml.kernel.org/r/20191018105606.3249-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Matt Fleming <matt@codeblueprint.co.uk>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: <stable@vger.kernel.org>	[4.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~mm-pcp-share-common-code-between-memory-hotplug-and-percpu-sysctl-handler
+++ a/mm/page_alloc.c
@@ -7993,6 +7993,15 @@ int lowmem_reserve_ratio_sysctl_handler(
 	return 0;
 }
 
+static void __zone_pcp_update(struct zone *zone)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu)
+		pageset_set_high_and_batch(zone,
+				per_cpu_ptr(zone->pageset, cpu));
+}
+
 /*
  * percpu_pagelist_fraction - changes the pcp->high for each zone on each
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu
@@ -8024,13 +8033,8 @@ int percpu_pagelist_fraction_sysctl_hand
 	if (percpu_pagelist_fraction == old_percpu_pagelist_fraction)
 		goto out;
 
-	for_each_populated_zone(zone) {
-		unsigned int cpu;
-
-		for_each_possible_cpu(cpu)
-			pageset_set_high_and_batch(zone,
-					per_cpu_ptr(zone->pageset, cpu));
-	}
+	for_each_populated_zone(zone)
+		__zone_pcp_update(zone);
 out:
 	mutex_unlock(&pcp_batch_high_lock);
 	return ret;
@@ -8528,11 +8532,8 @@ void free_contig_range(unsigned long pfn
  */
 void __meminit zone_pcp_update(struct zone *zone)
 {
-	unsigned cpu;
 	mutex_lock(&pcp_batch_high_lock);
-	for_each_possible_cpu(cpu)
-		pageset_set_high_and_batch(zone,
-				per_cpu_ptr(zone->pageset, cpu));
+	__zone_pcp_update(zone);
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-pcpu-make-zone-pcp-updates-and-reset-internal-to-the-mm.patch

