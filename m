Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72ED927D070
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 16:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgI2ODg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 10:03:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729073AbgI2ODf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 10:03:35 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TE29ZI176337
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 10:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Hf+/pMkcQ08HhS0y0Ue74TpnT84Eh/mtBP8r3c+7AOg=;
 b=tg9XZqd6fHpLPt1HhJIZwpwLFzbDrefyITzpHZmyf1kl5zkMidygsqfA2/xCF2K0LLAM
 JMTenEtwts265Ak6dr1opO9x8KaokUUlogf2DlhYe37Np8n085jXfLiG4PYj6EwU8SZv
 NsUS0wBDIHfx4/CxVwuKPRay8VJLFQmziIVcfMSBUijeowmogdQ9B1Zvt3g2HeYPJ7XO
 P9CKXIzKfuIwUVxSU0bFPfCrexxk94tNBMkRfztkR1eBriyygGd0RhVggKnxih3w0y1F
 OnFxhhk0le+fWviwiS8PLG0lELOTsFjvu79ONs4KC1PbpIWxrCRrWD9ipJt3JosQF8wp /A== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33v5223gyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 10:03:33 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TE21N1008110
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 14:03:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 33v5kg01fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 14:03:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TE3SHp16056674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 14:03:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D2345204E;
        Tue, 29 Sep 2020 14:03:28 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.50.8])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8307452069;
        Tue, 29 Sep 2020 14:03:28 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     stable@vger.kernel.org
Subject: [PATCH 2/2] mm: don't rely on system state to detect hot-plug operations
Date:   Tue, 29 Sep 2020 16:03:27 +0200
Message-Id: <20200929140327.31191-2-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929140327.31191-1-ldufour@linux.ibm.com>
References: <20200929140327.31191-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_04:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=899 suspectscore=1
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290120
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport version to the 5.4-stable tree of the commit:

f85086f95fa3 ("mm: don't rely on system state to detect hot-plug operations")

Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 drivers/base/node.c  | 84 ++++++++++++++++++++++++++++----------------
 include/linux/node.h | 11 +++---
 mm/memory_hotplug.c  |  3 +-
 3 files changed, 63 insertions(+), 35 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index f3565c2dbc52..503e2f90e58e 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -403,10 +403,32 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
 	return pfn_to_nid(pfn);
 }
 
+static int do_register_memory_block_under_node(int nid,
+					       struct memory_block *mem_blk)
+{
+	int ret;
+
+	/*
+	 * If this memory block spans multiple nodes, we only indicate
+	 * the last processed node.
+	 */
+	mem_blk->nid = nid;
+
+	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
+				       &mem_blk->dev.kobj,
+				       kobject_name(&mem_blk->dev.kobj));
+	if (ret)
+		return ret;
+
+	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
+				&node_devices[nid]->dev.kobj,
+				kobject_name(&node_devices[nid]->dev.kobj));
+}
+
 /* register memory section under specified node if it spans that node */
-int register_mem_sect_under_node(struct memory_block *mem_blk, void *arg)
+int register_mem_block_under_node_early(struct memory_block *mem_blk, void *arg)
 {
-	int ret, nid = *(int *)arg;
+	int nid = *(int *)arg;
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
 
 	sect_start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
@@ -426,38 +448,33 @@ int register_mem_sect_under_node(struct memory_block *mem_blk, void *arg)
 		}
 
 		/*
-		 * We need to check if page belongs to nid only for the boot
-		 * case, during hotplug we know that all pages in the memory
-		 * block belong to the same node.
-		 */
-		if (system_state == SYSTEM_BOOTING) {
-			page_nid = get_nid_for_pfn(pfn);
-			if (page_nid < 0)
-				continue;
-			if (page_nid != nid)
-				continue;
-		}
-
-		/*
-		 * If this memory block spans multiple nodes, we only indicate
-		 * the last processed node.
+		 * We need to check if page belongs to nid only at the boot
+		 * case because node's ranges can be interleaved.
 		 */
-		mem_blk->nid = nid;
-
-		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
-					&mem_blk->dev.kobj,
-					kobject_name(&mem_blk->dev.kobj));
-		if (ret)
-			return ret;
+		page_nid = get_nid_for_pfn(pfn);
+		if (page_nid < 0)
+			continue;
+		if (page_nid != nid)
+			continue;
 
-		return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
-				&node_devices[nid]->dev.kobj,
-				kobject_name(&node_devices[nid]->dev.kobj));
+		return do_register_memory_block_under_node(nid, mem_blk);
 	}
 	/* mem section does not span the specified node */
 	return 0;
 }
 
+/*
+ * During hotplug we know that all pages in the memory block belong to the same
+ * node.
+ */
+static int register_mem_block_under_node_hotplug(struct memory_block *mem_blk,
+						 void *arg)
+{
+	int nid = *(int *)arg;
+
+	return do_register_memory_block_under_node(nid, mem_blk);
+}
+
 /*
  * Unregister a memory block device under the node it spans. Memory blocks
  * with multiple nodes cannot be offlined and therefore also never be removed.
@@ -473,10 +490,17 @@ void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
 			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
-int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn)
+int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
+		      enum meminit_context context)
 {
-	return walk_memory_range(start_pfn, end_pfn, (void *)&nid,
-					register_mem_sect_under_node);
+	walk_memory_blocks_func_t func;
+
+	if (context == MEMINIT_HOTPLUG)
+		func = register_mem_block_under_node_hotplug;
+	else
+		func = register_mem_block_under_node_early;
+
+	return walk_memory_range(start_pfn, end_pfn, (void *)&nid, func);
 }
 
 #ifdef CONFIG_HUGETLBFS
diff --git a/include/linux/node.h b/include/linux/node.h
index 708939bae9aa..a79ec4492650 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -32,11 +32,13 @@ extern struct node *node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
-extern int link_mem_sections(int nid, unsigned long start_pfn,
-			     unsigned long end_pfn);
+int link_mem_sections(int nid, unsigned long start_pfn,
+		      unsigned long end_pfn,
+		      enum meminit_context context);
 #else
 static inline int link_mem_sections(int nid, unsigned long start_pfn,
-				    unsigned long end_pfn)
+				    unsigned long end_pfn,
+				    enum meminit_context context)
 {
 	return 0;
 }
@@ -61,7 +63,8 @@ static inline int register_one_node(int nid)
 		if (error)
 			return error;
 		/* link memory sections under this node */
-		error = link_mem_sections(nid, start_pfn, end_pfn);
+		error = link_mem_sections(nid, start_pfn, end_pfn,
+					  MEMINIT_EARLY);
 	}
 
 	return error;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c839c4ad4871..e60e28131f67 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1102,7 +1102,8 @@ int __ref add_memory_resource(int nid, struct resource *res, bool online)
 	}
 
 	/* link memory sections under this node.*/
-	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1));
+	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
+				MEMINIT_HOTPLUG);
 	BUG_ON(ret);
 
 	/* create new memmap entry */
-- 
2.28.0

