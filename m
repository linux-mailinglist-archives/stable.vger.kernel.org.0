Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53D4DD5FB
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 03:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfJSBdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 21:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfJSBdS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 21:33:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09623222C6;
        Sat, 19 Oct 2019 01:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571448797;
        bh=Ua6NPzx4B69nD41L09Heq7Vm57xcUVsMOV7nhNXn34E=;
        h=Date:From:To:Subject:From;
        b=1RR+c/t6kDv8jeL3zNQO3W757hmWILOLQ9JDWhlUagEaOd6RGlrNFr7IntcjG8w3h
         5deKaBbw8QysScaSmVbGVdVdT+5DJyaavJd1uNE7tSky784KhHp6K//KXAGsAZzM1n
         mjmpMbNTV1tHzgm1oriIn87taeh9Lp5MtLxIFEmM=
Date:   Fri, 18 Oct 2019 18:33:16 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, matt@codeblueprint.co.uk,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-pcp-share-common-code-between-memory-hotplug-and-percpu-?=
 =?US-ASCII?Q?sysctl-handler.patch?= added to -mm tree
Message-ID: <20191019013316.6KzA3V8vK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, pcp: share common code between memory hotplug and percpu sysctl handler
has been added to the -mm tree.  Its filename is
     mm-pcp-share-common-code-between-memory-hotplug-and-percpu-sysctl-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pcp-share-common-code-between-memory-hotplug-and-percpu-sysctl-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pcp-share-common-code-between-memory-hotplug-and-percpu-sysctl-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -7985,6 +7985,15 @@ int lowmem_reserve_ratio_sysctl_handler(
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
@@ -8016,13 +8025,8 @@ int percpu_pagelist_fraction_sysctl_hand
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
@@ -8521,11 +8525,8 @@ void free_contig_range(unsigned long pfn
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
 #endif
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-pcp-share-common-code-between-memory-hotplug-and-percpu-sysctl-handler.patch
mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.patch
mm-pcpu-make-zone-pcp-updates-and-reset-internal-to-the-mm.patch

