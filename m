Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870EE26A26A
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 11:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgIOJmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 05:42:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIOJmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 05:42:04 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08F9WDs9156758;
        Tue, 15 Sep 2020 05:41:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zw6gJ56bbYnwdf3cWDWF60gfH1acPA/z8lAQb/Z9wpY=;
 b=F7lXfOCYXKkpcNvaehVh+FRinkNWZPRH1dnzwxqViUG8ILJE3hjhFOU7Mk4JKiVLOzn7
 Kzkv5VT3AS/scbh9gfz083ipaevtAacSs5NnxtsgzDfWsjlmZp4haqmLVpC8dE2nSa39
 cwhrYbSPKta8wWJNNIPZZouF2yxUloGMyBlO20PrfWO5PtWDMl2utSMTwRZaqipE3oUe
 Afn5p9FMg2Nt4EZh6S/kI8yzt2e4MMxSD+yNQT1/gGNnMVFhAz8pisocyKKN1/tnseIH
 8L5IPd8pkV3zDNrfy3v9a0XCaq62srsMBu/EdO8hyzgRNal9yViqMi9k7Ymz231Jbv9g Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jtbjhq04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 05:41:52 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08F9XcBB160716;
        Tue, 15 Sep 2020 05:41:52 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jtbjhpy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 05:41:51 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08F9YFrj026539;
        Tue, 15 Sep 2020 09:41:49 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 33h2r9aw1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 09:41:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08F9eCeI28443092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 09:40:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0DD9A4040;
        Tue, 15 Sep 2020 09:41:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36DC9A405D;
        Tue, 15 Sep 2020 09:41:46 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.72.89])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 09:41:46 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, mhocko@suse.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 3/3] mm: don't panic when links can't be created in sysfs
Date:   Tue, 15 Sep 2020 11:41:43 +0200
Message-Id: <20200915094143.79181-4-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915094143.79181-1-ldufour@linux.ibm.com>
References: <20200915094143.79181-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_05:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 suspectscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150084
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

At boot time, or when doing memory hot-add operations, if the links in
sysfs can't be created, the system is still able to run, so just report the
error in the kernel log rather than BUG_ON and potentially make system
unusable because the callpath can be called with locks held.

Since the number of memory blocks managed could be high, the messages are
rate limited.

As a consequence, link_mem_sections() has no status to report anymore.

Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/node.c  | 33 +++++++++++++++++++++------------
 include/linux/node.h | 16 +++++++---------
 mm/memory_hotplug.c  |  5 ++---
 3 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 50af16e68d98..9426b0f1f660 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -761,8 +761,8 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
 	return pfn_to_nid(pfn);
 }
 
-static int do_register_memory_block_under_node(int nid,
-					       struct memory_block *mem_blk)
+static void do_register_memory_block_under_node(int nid,
+						struct memory_block *mem_blk)
 {
 	int ret;
 
@@ -775,12 +775,19 @@ static int do_register_memory_block_under_node(int nid,
 	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
 				       &mem_blk->dev.kobj,
 				       kobject_name(&mem_blk->dev.kobj));
-	if (ret)
-		return ret;
+	if (ret && ret != -EEXIST)
+		dev_err_ratelimited(&node_devices[nid]->dev,
+				    "can't create link to %s in sysfs (%d)\n",
+				    kobject_name(&mem_blk->dev.kobj), ret);
 
-	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
+	ret = sysfs_create_link_nowarn(&mem_blk->dev.kobj,
 				&node_devices[nid]->dev.kobj,
 				kobject_name(&node_devices[nid]->dev.kobj));
+	if (ret && ret != -EEXIST)
+		dev_err_ratelimited(&mem_blk->dev,
+				    "can't create link to %s in sysfs (%d)\n",
+				    kobject_name(&node_devices[nid]->dev.kobj),
+				    ret);
 }
 
 /* register memory section under specified node if it spans that node */
@@ -816,7 +823,8 @@ static int register_mem_block_under_node_early(struct memory_block *mem_blk,
 		if (page_nid != nid)
 			continue;
 
-		return do_register_memory_block_under_node(nid, mem_blk);
+		do_register_memory_block_under_node(nid, mem_blk);
+		return 0;
 	}
 	/* mem section does not span the specified node */
 	return 0;
@@ -831,7 +839,8 @@ static int register_mem_block_under_node_hotplug(struct memory_block *mem_blk,
 {
 	int nid = *(int *)arg;
 
-	return do_register_memory_block_under_node(nid, mem_blk);
+	do_register_memory_block_under_node(nid, mem_blk);
+	return 0;
 }
 
 /*
@@ -849,8 +858,8 @@ void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
 			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
-int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
-		      enum meminit_context context)
+void link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
+		       enum meminit_context context)
 {
 	walk_memory_blocks_func_t func;
 
@@ -859,9 +868,9 @@ int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
 	else
 		func = register_mem_block_under_node_early;
 
-	return walk_memory_blocks(PFN_PHYS(start_pfn),
-				  PFN_PHYS(end_pfn - start_pfn), (void *)&nid,
-				  func);
+	walk_memory_blocks(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
+			   (void *)&nid, func);
+	return;
 }
 
 #ifdef CONFIG_HUGETLBFS
diff --git a/include/linux/node.h b/include/linux/node.h
index 014ba3ab2efd..8e5a29897936 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -99,15 +99,14 @@ extern struct node *node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
-int link_mem_sections(int nid, unsigned long start_pfn,
-		      unsigned long end_pfn,
-		      enum meminit_context context);
+void link_mem_sections(int nid, unsigned long start_pfn,
+		       unsigned long end_pfn,
+		       enum meminit_context context);
 #else
-static inline int link_mem_sections(int nid, unsigned long start_pfn,
-				    unsigned long end_pfn,
-				    enum meminit_context context)
+static inline void link_mem_sections(int nid, unsigned long start_pfn,
+				     unsigned long end_pfn,
+				     enum meminit_context context)
 {
-	return 0;
 }
 #endif
 
@@ -130,8 +129,7 @@ static inline int register_one_node(int nid)
 		if (error)
 			return error;
 		/* link memory sections under this node */
-		error = link_mem_sections(nid, start_pfn, end_pfn,
-					  MEMINIT_EARLY);
+		link_mem_sections(nid, start_pfn, end_pfn, MEMINIT_EARLY);
 	}
 
 	return error;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 03df20078827..01e01a530d38 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1080,9 +1080,8 @@ int __ref add_memory_resource(int nid, struct resource *res)
 	}
 
 	/* link memory sections under this node.*/
-	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
-				MEMINIT_HOTPLUG);
-	BUG_ON(ret);
+	link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
+			  MEMINIT_HOTPLUG);
 
 	/* create new memmap entry */
 	if (!strcmp(res->name, "System RAM"))
-- 
2.28.0

