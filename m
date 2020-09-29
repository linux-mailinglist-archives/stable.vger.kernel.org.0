Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD2027D06F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 16:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbgI2ODf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 10:03:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5041 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730452AbgI2ODf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 10:03:35 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TE29Tt176359
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 10:03:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=RIqy5+BbgSIyM/PJ89dZ/V+3Ss9RKQmJdVwKLidx6cQ=;
 b=tNQXowBIVfe+v/sgFZzAsjRbSn4W1SdcwDs7VsCFxfIAgEgm/1lbo1fQ16EroullPeBr
 JFzrt1MaG7Vb1+rcGpHEPS8x/t8Ouf1rBSJVgWDXvplP9/rM+reFCk62zoTv9KzKh3MQ
 7tTjhlu5A6U0CWb5/aGuKFE0cpdzG3dWNmtjYILx48z+owqgHdLxVVWMvAMrhAnuFxvz
 rhtK7T7PiXzUhbPhXIfofZsAd4EvujbFmkoR64BWvGDSkQbGDa6P64+42YsX4+oRkKuB
 +tsLqs+rVUyvWfE1V23EJ74g7fenq+na1/pwaTVZFbEmHxsH1No6ZMtSnniDMic1uEeX 2g== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33v5223gye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 10:03:33 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TE2hgB007210
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 14:03:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 33sw981t15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 14:03:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TE3SvY21496172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 14:03:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7725452050;
        Tue, 29 Sep 2020 14:03:28 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.50.8])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5B5E35204E;
        Tue, 29 Sep 2020 14:03:28 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     stable@vger.kernel.org
Subject: [PATCH 1/2] mm: replace memmap_context by memplug_context
Date:   Tue, 29 Sep 2020 16:03:26 +0200
Message-Id: <20200929140327.31191-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_04:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=847 suspectscore=3
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290120
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport version to the 5.4-stable tree of the commit:

c1d0da83358a ("mm: replace memmap_context by meminit_context")

Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 arch/ia64/mm/init.c    |  6 +++---
 include/linux/mm.h     |  2 +-
 include/linux/mmzone.h | 11 ++++++++---
 mm/memory_hotplug.c    |  2 +-
 mm/page_alloc.c        | 11 ++++++-----
 5 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 79e5cc70f1fd..561e2573bd34 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -499,7 +499,7 @@ virtual_memmap_init(u64 start, u64 end, void *arg)
 	if (map_start < map_end)
 		memmap_init_zone((unsigned long)(map_end - map_start),
 				 args->nid, args->zone, page_to_pfn(map_start),
-				 MEMMAP_EARLY, NULL);
+				 MEMINIT_EARLY, NULL);
 	return 0;
 }
 
@@ -508,8 +508,8 @@ memmap_init (unsigned long size, int nid, unsigned long zone,
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
index 05bc5f25ab85..83828c118b6b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2179,7 +2179,7 @@ static inline void zero_resv_unavail(void) {}
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
-		enum memmap_context, struct vmem_altmap *);
+		enum meminit_context, struct vmem_altmap *);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fdd93a39f1fa..fa02014eba8e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -759,10 +759,15 @@ bool zone_watermark_ok(struct zone *z, unsigned int order,
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
index aae7ff485671..c839c4ad4871 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -733,7 +733,7 @@ void __ref move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
 	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn,
-			MEMMAP_HOTPLUG, altmap);
+			 MEMINIT_HOTPLUG, altmap);
 
 	set_zone_contiguous(zone);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5717ee66c8b3..545800433dfb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5480,7 +5480,7 @@ void __ref build_all_zonelists(pg_data_t *pgdat)
  * done. Non-atomic initialization, single-pass.
  */
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
-		unsigned long start_pfn, enum memmap_context context,
+		unsigned long start_pfn, enum meminit_context context,
 		struct vmem_altmap *altmap)
 {
 	unsigned long end_pfn = start_pfn + size;
@@ -5507,7 +5507,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
 		 */
-		if (context != MEMMAP_EARLY)
+		if (context != MEMINIT_EARLY)
 			goto not_early;
 
 		if (!early_pfn_valid(pfn))
@@ -5542,7 +5542,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 not_early:
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
-		if (context == MEMMAP_HOTPLUG)
+		if (context == MEMINIT_HOTPLUG)
 			SetPageReserved(page);
 
 		/*
@@ -5557,7 +5557,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		 * check here not to call set_pageblock_migratetype() against
 		 * pfn out of zone.
 		 *
-		 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
+		 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
 		 * because this is done early in sparse_add_one_section
 		 */
 		if (!(pfn & (pageblock_nr_pages - 1))) {
@@ -5578,7 +5578,8 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 
 #ifndef __HAVE_ARCH_MEMMAP_INIT
 #define memmap_init(size, nid, zone, start_pfn) \
-	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY, NULL)
+	memmap_init_zone((size), (nid), (zone), (start_pfn), \
+			 MEMINIT_EARLY, NULL)
 #endif
 
 static int zone_batchsize(struct zone *zone)
-- 
2.28.0

