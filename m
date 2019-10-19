Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB437DD64E
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 05:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfJSDTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 23:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:32796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbfJSDTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 23:19:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D818222CC;
        Sat, 19 Oct 2019 03:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571455175;
        bh=3UWo0wmv2Y2fugCfhnrIFGKLkAdBi4wr/PywH0Bz/J8=;
        h=Date:From:To:Subject:From;
        b=O2FZgFp9m4dehj932K/UaLja6YYSgViSHuenwqMsRSpT+Li/Ki7DlHOU5/9bz11yQ
         2W0WAA2TxBDbL/DKDwsk7/oZoSvKrPpsWZ3Y8pLQ7ICHPrWHYXXgna10IJh1fvC9Ks
         8z7u+qarUz+ehm/mR5R+xHXfXsWVaRyABcFmP2cM=
Date:   Fri, 18 Oct 2019 20:19:33 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de,
        cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr,
        dalias@libc.org, damian.tometzki@gmail.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, fenghua.yu@intel.com, gerald.schaefer@de.ibm.com,
        glider@google.com, gor@linux.ibm.com, gregkh@linuxfoundation.org,
        heiko.carstens@de.ibm.com, hpa@zytor.com, ira.weiny@intel.com,
        jgg@ziepe.ca, linux-mm@kvack.org, logang@deltatee.com,
        luto@kernel.org, mark.rutland@arm.com, mgorman@techsingularity.net,
        mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, osalvador@suse.de, pagupta@redhat.com,
        pasha.tatashin@soleen.com, pasic@linux.ibm.com, paulus@samba.org,
        pavel.tatashin@microsoft.com, peterz@infradead.org,
        richard.weiyang@gmail.com, richardw.yang@linux.intel.com,
        robin.murphy@arm.com, rppt@linux.ibm.com, stable@vger.kernel.org,
        steve.capper@arm.com, tglx@linutronix.de, thomas.lendacky@amd.com,
        tony.luck@intel.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        will@kernel.org, willy@infradead.org,
        yamada.masahiro@socionext.com, yaojun8558363@gmail.com,
        ysato@users.sourceforge.jp, yuzhao@google.com
Subject:  [patch 06/26] mm/memory_hotplug: don't access
 uninitialized memmaps in shrink_pgdat_span()
Message-ID: <20191019031933.PakTLd2V_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: don't access uninitialized memmaps in shrink_pgdat_span()

We might use the nid of memmaps that were never initialized.  For example,
if the memmap was poisoned, we will crash the kernel in pfn_to_nid() right
now.  Let's use the calculated boundaries of the separate zones instead. 
This now also avoids having to iterate over a whole bunch of subsections
again, after shrinking one zone.

Before commit d0dc12e86b31 ("mm/memory_hotplug: optimize memory hotplug"),
the memmap was initialized to 0 and the node was set to the right value. 
After that commit, the node might be garbage.

We'll have to fix shrink_zone_span() next.

Link: http://lkml.kernel.org/r/20191006085646.5768-4-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[d0dc12e86b319]
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Damian Tometzki <damian.tometzki@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jun Yao <yaojun8558363@gmail.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Rich Felker <dalias@libc.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   74 +++++++++---------------------------------
 1 file changed, 16 insertions(+), 58 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-dont-access-uninitialized-memmaps-in-shrink_pgdat_span
+++ a/mm/memory_hotplug.c
@@ -436,67 +436,25 @@ static void shrink_zone_span(struct zone
 	zone_span_writeunlock(zone);
 }
 
-static void shrink_pgdat_span(struct pglist_data *pgdat,
-			      unsigned long start_pfn, unsigned long end_pfn)
+static void update_pgdat_span(struct pglist_data *pgdat)
 {
-	unsigned long pgdat_start_pfn = pgdat->node_start_pfn;
-	unsigned long p = pgdat_end_pfn(pgdat); /* pgdat_end_pfn namespace clash */
-	unsigned long pgdat_end_pfn = p;
-	unsigned long pfn;
-	int nid = pgdat->node_id;
-
-	if (pgdat_start_pfn == start_pfn) {
-		/*
-		 * If the section is smallest section in the pgdat, it need
-		 * shrink pgdat->node_start_pfn and pgdat->node_spanned_pages.
-		 * In this case, we find second smallest valid mem_section
-		 * for shrinking zone.
-		 */
-		pfn = find_smallest_section_pfn(nid, NULL, end_pfn,
-						pgdat_end_pfn);
-		if (pfn) {
-			pgdat->node_start_pfn = pfn;
-			pgdat->node_spanned_pages = pgdat_end_pfn - pfn;
-		}
-	} else if (pgdat_end_pfn == end_pfn) {
-		/*
-		 * If the section is biggest section in the pgdat, it need
-		 * shrink pgdat->node_spanned_pages.
-		 * In this case, we find second biggest valid mem_section for
-		 * shrinking zone.
-		 */
-		pfn = find_biggest_section_pfn(nid, NULL, pgdat_start_pfn,
-					       start_pfn);
-		if (pfn)
-			pgdat->node_spanned_pages = pfn - pgdat_start_pfn + 1;
-	}
-
-	/*
-	 * If the section is not biggest or smallest mem_section in the pgdat,
-	 * it only creates a hole in the pgdat. So in this case, we need not
-	 * change the pgdat.
-	 * But perhaps, the pgdat has only hole data. Thus it check the pgdat
-	 * has only hole or not.
-	 */
-	pfn = pgdat_start_pfn;
-	for (; pfn < pgdat_end_pfn; pfn += PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_valid(pfn)))
-			continue;
-
-		if (pfn_to_nid(pfn) != nid)
-			continue;
-
-		/* Skip range to be removed */
-		if (pfn >= start_pfn && pfn < end_pfn)
-			continue;
+	unsigned long node_start_pfn = 0, node_end_pfn = 0;
+	struct zone *zone;
 
-		/* If we find valid section, we have nothing to do */
-		return;
+	for (zone = pgdat->node_zones;
+	     zone < pgdat->node_zones + MAX_NR_ZONES; zone++) {
+		unsigned long zone_end_pfn = zone->zone_start_pfn +
+					     zone->spanned_pages;
+
+		/* No need to lock the zones, they can't change. */
+		if (zone_end_pfn > node_end_pfn)
+			node_end_pfn = zone_end_pfn;
+		if (zone->zone_start_pfn < node_start_pfn)
+			node_start_pfn = zone->zone_start_pfn;
 	}
 
-	/* The pgdat has no valid section */
-	pgdat->node_start_pfn = 0;
-	pgdat->node_spanned_pages = 0;
+	pgdat->node_start_pfn = node_start_pfn;
+	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 }
 
 static void __remove_zone(struct zone *zone, unsigned long start_pfn,
@@ -507,7 +465,7 @@ static void __remove_zone(struct zone *z
 
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
-	shrink_pgdat_span(pgdat, start_pfn, start_pfn + nr_pages);
+	update_pgdat_span(pgdat);
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 }
 
_
