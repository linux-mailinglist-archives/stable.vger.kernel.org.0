Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B0E26A274
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 11:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgIOJmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 05:42:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgIOJmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 05:42:04 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08F9XVS0061776;
        Tue, 15 Sep 2020 05:41:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DY3gBwYKoswju+NfwSjM4mpwqHinfXF7qoGuWnBFj8s=;
 b=KX2VRZq/JOwNuedzTWWl+gqXCRAqQFHvRMMfGBMwCCXm7OpXr3RcNxE8cTXjjhqSJj9q
 UVmKD/xZYfjsQndCosXALXmr4pCUVDDDGf9pzUS3Ng1rFClMcLEpSiCmUl63PBj8FxyD
 avT/Y9S+UeA+bERWg3JguzHt0gA3LsBFMXt+CrgH5gEoXfRwU9Yyki9XlBceY3T91INi
 gorgxnk5Vqo2132ovEWdmEOaSKpKBJ4W5t36O/9QAuIBG4cCZj3jhcE1lZW/+ptMmzUr
 nEFmKQZahZKi8sFHktj5khnm69PQrgh7aydW72DxGLm0prj1zrwI9BJ9ovb7Bt5UpOKX cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jr6bdmgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 05:41:51 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08F9YPBb064259;
        Tue, 15 Sep 2020 05:41:51 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jr6bdmfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 05:41:51 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08F9YDKe013628;
        Tue, 15 Sep 2020 09:41:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 33hjgds48p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 09:41:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08F9fj8I27197752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 09:41:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D3B5A4040;
        Tue, 15 Sep 2020 09:41:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B475A4055;
        Tue, 15 Sep 2020 09:41:45 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.72.89])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 09:41:45 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, mhocko@suse.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 1/3] mm: replace memmap_context by memplug_context
Date:   Tue, 15 Sep 2020 11:41:41 +0200
Message-Id: <20200915094143.79181-2-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915094143.79181-1-ldufour@linux.ibm.com>
References: <20200915094143.79181-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_05:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150087
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The memmap_context is used to detect whether a memory operation is due to a
hot-add operation or happening at boot time.

Make it general to the hotplug operation and rename it at memplug_context.

There is no functional change introduced by this patch

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 arch/ia64/mm/init.c    |  6 +++---
 include/linux/mm.h     |  2 +-
 include/linux/mmzone.h | 11 ++++++++---
 mm/memory_hotplug.c    |  2 +-
 mm/page_alloc.c        | 10 +++++-----
 5 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 0b3fb4c7af29..8e7b8c6c576e 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -538,7 +538,7 @@ virtual_memmap_init(u64 start, u64 end, void *arg)
 	if (map_start < map_end)
 		memmap_init_zone((unsigned long)(map_end - map_start),
 				 args->nid, args->zone, page_to_pfn(map_start),
-				 MEMMAP_EARLY, NULL);
+				 MEMINIT_EARLY, NULL);
 	return 0;
 }
 
@@ -547,8 +547,8 @@ memmap_init (unsigned long size, int nid, unsigned long zone,
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
index 1983e08f5906..e942f91ed155 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2409,7 +2409,7 @@ extern int __meminit __early_pfn_to_nid(unsigned long pfn,
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
-		enum memmap_context, struct vmem_altmap *);
+		enum meminit_context, struct vmem_altmap *);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8379432f4f2f..0f7a4ff4b059 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -824,10 +824,15 @@ bool zone_watermark_ok(struct zone *z, unsigned int order,
 		unsigned int alloc_flags);
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
 		unsigned long mark, int highest_zoneidx);
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
index e9d5ab5d3ca0..fc25886ad719 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -729,7 +729,7 @@ void __ref move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
 	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn,
-			MEMMAP_HOTPLUG, altmap);
+			 MEMINIT_HOTPLUG, altmap);
 
 	set_zone_contiguous(zone);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fab5e97dc9ca..5661fa164f13 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5975,7 +5975,7 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
  * done. Non-atomic initialization, single-pass.
  */
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
-		unsigned long start_pfn, enum memmap_context context,
+		unsigned long start_pfn, enum meminit_context context,
 		struct vmem_altmap *altmap)
 {
 	unsigned long pfn, end_pfn = start_pfn + size;
@@ -6007,7 +6007,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
 		 */
-		if (context == MEMMAP_EARLY) {
+		if (context == MEMINIT_EARLY) {
 			if (overlap_memmap_init(zone, &pfn))
 				continue;
 			if (defer_init(nid, pfn, end_pfn))
@@ -6016,7 +6016,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
-		if (context == MEMMAP_HOTPLUG)
+		if (context == MEMINIT_HOTPLUG)
 			__SetPageReserved(page);
 
 		/*
@@ -6099,7 +6099,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		 * check here not to call set_pageblock_migratetype() against
 		 * pfn out of zone.
 		 *
-		 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
+		 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
 		 * because this is done early in section_activate()
 		 */
 		if (!(pfn & (pageblock_nr_pages - 1))) {
@@ -6137,7 +6137,7 @@ void __meminit __weak memmap_init(unsigned long size, int nid,
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
 			memmap_init_zone(size, nid, zone, start_pfn,
-					 MEMMAP_EARLY, NULL);
+					 MEMINIT_EARLY, NULL);
 		}
 	}
 }
-- 
2.28.0

