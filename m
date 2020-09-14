Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C605326921F
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 18:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgINQvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 12:51:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49230 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbgINQvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 12:51:06 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EGXQlO096925;
        Mon, 14 Sep 2020 12:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7nnRLAchoY05slVCAf/pdmF9IhyLdZIm6eOUbHbM1FQ=;
 b=b6aFYi1fpWcSukmMOJNb1HplQBsW1o7DLrlghMueCmvkxqko2Jf4Aou9AdAhvBiqIzT4
 rZY2Z+CqW2vzVLhbACN8SPeEHPGXI/g8MTaconiWpvkgwWU9jumT5M0qsCnRzAuvispj
 PNBTWZX22zBgzMt1zL37GfXyEr03AwS8OXGkYwZRO2XlBRwQhImw56DxH0gvVdlHWup9
 +WBw7gE6i2phwLMlGXVAMgTC4/GRFHpKAWMwoJ8vEldtr8WwGsFXE9aijdV+tnHS0fWd
 AYsxBJ1LUnY6FgOzU0i9Dj8/vRfTljeLr+Bn8dggMThChIEZ1Hx+77KFtZVvakupat1I SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jc4d0hgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 12:50:52 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08EGXhwb098032;
        Mon, 14 Sep 2020 12:50:52 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jc4d0hey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 12:50:52 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08EGm6Jh018178;
        Mon, 14 Sep 2020 16:50:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 33gny8agm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 16:50:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08EGokN028639718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 16:50:46 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A31BDA404D;
        Mon, 14 Sep 2020 16:50:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35214A406E;
        Mon, 14 Sep 2020 16:50:46 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.51.157])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Sep 2020 16:50:46 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, mhocko@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 3/3] mm: don't panic when links can't be created in sysfs
Date:   Mon, 14 Sep 2020 18:50:42 +0200
Message-Id: <20200914165042.96218-4-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914165042.96218-1-ldufour@linux.ibm.com>
References: <20200914165042.96218-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_06:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140133
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
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/node.c  | 33 +++++++++++++++++++++------------
 include/linux/node.h | 16 +++++++---------
 mm/memory_hotplug.c  |  5 ++---
 3 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 01ee73c9d675..249b2ba6dc81 100644
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
@@ -817,7 +824,8 @@ static int register_mem_block_under_node_early(struct memory_block *mem_blk,
 			continue;
 
 		/* The memory block is registered to the first matching node */
-		return do_register_memory_block_under_node(nid, mem_blk);
+		do_register_memory_block_under_node(nid, mem_blk);
+		return 0;
 	}
 	/* mem section does not span the specified node */
 	return 0;
@@ -832,7 +840,8 @@ static int register_mem_block_under_node_hotplug(struct memory_block *mem_blk,
 {
 	int nid = *(int *)arg;
 
-	return do_register_memory_block_under_node(nid, mem_blk);
+	do_register_memory_block_under_node(nid, mem_blk);
+	return 0;
 }
 
 /*
@@ -850,8 +859,8 @@ void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
 			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
-int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
-		      enum meminit_context context)
+void link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
+		       enum meminit_context context)
 {
 	walk_memory_blocks_func_t func;
 
@@ -860,9 +869,9 @@ int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
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

