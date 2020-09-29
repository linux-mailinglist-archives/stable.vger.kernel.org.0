Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA63B27D053
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 15:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbgI2N5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 09:57:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730730AbgI2N5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 09:57:45 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TDuuIp029956
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 09:57:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=PXxflb3jWTvk/zWQC3USa8jx+MA5VXmXzDkQw1RYXVc=;
 b=sMEtv7bnV3LDSrOcJBb4H5A6i1p4TJap/nryQmsV3tJzW8b9oUDL0duuEJu1++ZQK321
 5kvlzHzlf3zYME9OBlCXuRYG3UNnSbODvHrOxxEg0svLo8NxdDUEQwCMsGRc5th4zNEg
 qq1+zgzfhxYOZ4cdWuMA6CVKqgXn8BtYSAusgS9rvJaYXVr9DXBQ2ooEey9796NXv3CO
 IGNn5d6s4/QYVTXBldcCTbDxRxTM18eUap+EGFzk/Iqsdonamgz+fsFyAgRO1U5ljfdL
 kuwfFNGWLEkT3VwYLsNCEFRTmAhEHb45Q8k1P7dmRGSpY+3J9JI5KjyeJ+z43katmudJ uQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v68er0g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 09:57:45 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TDrGdX005522
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 13:57:43 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw983cxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 13:57:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TDvepL15204856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 13:57:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14D9A52050;
        Tue, 29 Sep 2020 13:57:40 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.50.8])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E517152054;
        Tue, 29 Sep 2020 13:57:39 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     stable@vger.kernel.org
Subject: [PATCH 1/2] mm: replace memmap_context by memplug_context
Date:   Tue, 29 Sep 2020 15:57:37 +0200
Message-Id: <20200929135738.28697-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_04:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 clxscore=1015
 mlxlogscore=899 priorityscore=1501 suspectscore=3 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290115
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport version to the 5.4-stable tree of the commit:

c1d0da83358a ("mm: replace memmap_context by meminit_context")

Cc: <stable@vger.kernel.org> # 5.4.y
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 arch/ia64/mm/init.c    |  6 +++---
 include/linux/mm.h     |  2 +-
 include/linux/mmzone.h | 11 ++++++++---
 mm/memory_hotplug.c    |  2 +-
 mm/page_alloc.c        | 10 +++++-----
 5 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index a6dd80a2c939..ee50506d86f4 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -518,7 +518,7 @@ virtual_memmap_init(u64 start, u64 end, void *arg)
 	if (map_start < map_end)
 		memmap_init_zone((unsigned long)(map_end - map_start),
 				 args->nid, args->zone, page_to_pfn(map_start),
-				 MEMMAP_EARLY, NULL);
+				 MEMINIT_EARLY, NULL);
 	return 0;
 }
 
@@ -527,8 +527,8 @@ memmap_init (unsigned long size, int nid, unsigned long zone,
 	     unsigned long start_pfn)
 {
 	if (!vmem_map) {
-		memmap_init_zone(size, nid, zone, start_pfn, MEMMAP_EARLY,
-				NULL);
+		memmap_init_zone(size, nid, zone, start_pfn,
+				 MEMINIT_EARLY, NULL);
 	} else {
 		struct page *start;
 		struct memmap_init_callback_data args;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3285dae06c03..34119f393a80 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2208,7 +2208,7 @@ static inline void zero_resv_unavail(void) {}
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
-		enum memmap_context, struct vmem_altmap *);
+		enum meminit_context, struct vmem_altmap *);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 85804ba62215..a90aba3d6afb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -822,10 +822,15 @@ bool zone_watermark_ok(struct zone *z, unsigned int order,
 		unsigned int alloc_flags);
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
 		unsigned long mark, int classzone_idx);
-enum memmap_context {
-	MEMMAP_EARLY,
-	MEMMAP_HOTPLUG,
+/*
+ * Memory initialization context, use to differentiate memory added by
+ * the platform statically or via memory hotplug interface.
+ */
+enum meminit_context {
+	MEMINIT_EARLY,
+	MEMINIT_HOTPLUG,
 };
+
 extern void init_currently_empty_zone(struct zone *zone, unsigned long start_pfn,
 				     unsigned long size);
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 3eb0b311b4a1..6a4b3a01e1b6 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -725,7 +725,7 @@ void __ref move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
 	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn,
-			MEMMAP_HOTPLUG, altmap);
+			 MEMINIT_HOTPLUG, altmap);
 
 	set_zone_contiguous(zone);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 67a9943aa595..373ca5780758 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5875,7 +5875,7 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
  * done. Non-atomic initialization, single-pass.
  */
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
-		unsigned long start_pfn, enum memmap_context context,
+		unsigned long start_pfn, enum meminit_context context,
 		struct vmem_altmap *altmap)
 {
 	unsigned long pfn, end_pfn = start_pfn + size;
@@ -5907,7 +5907,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
 		 */
-		if (context == MEMMAP_EARLY) {
+		if (context == MEMINIT_EARLY) {
 			if (!early_pfn_valid(pfn))
 				continue;
 			if (!early_pfn_in_nid(pfn, nid))
@@ -5920,7 +5920,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
-		if (context == MEMMAP_HOTPLUG)
+		if (context == MEMINIT_HOTPLUG)
 			__SetPageReserved(page);
 
 		/*
@@ -6002,7 +6002,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		 * check here not to call set_pageblock_migratetype() against
 		 * pfn out of zone.
 		 *
-		 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
+		 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
 		 * because this is done early in section_activate()
 		 */
 		if (!(pfn & (pageblock_nr_pages - 1))) {
@@ -6028,7 +6028,7 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 void __meminit __weak memmap_init(unsigned long size, int nid,
 				  unsigned long zone, unsigned long start_pfn)
 {
-	memmap_init_zone(size, nid, zone, start_pfn, MEMMAP_EARLY, NULL);
+	memmap_init_zone(size, nid, zone, start_pfn, MEMINIT_EARLY, NULL);
 }
 
 static int zone_batchsize(struct zone *zone)
-- 
2.28.0

