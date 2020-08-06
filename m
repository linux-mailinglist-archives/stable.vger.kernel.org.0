Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBD023DE75
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbgHFR0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:26:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22440 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729382AbgHFRCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 13:02:11 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 076G3lXs090085;
        Thu, 6 Aug 2020 12:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=08+CvwZd3NBwkRf4jkw0qJZMdmj8MOEEF+dNWSwz6AQ=;
 b=XTZBpikGySfkheo243yhkllt9hZWhT+d3Iwlis6RYEGuPDol7I8u2/jQur2Idu9wUI/r
 TBC6P8W5fgIsj8QvdB0FA+cg1H0LaKnLvIAJtaEEV59s6dAQMp+O32ISJB0ozR+5s5lJ
 j2ZppiCjS1YXMGqX93ELYdbd0DQovfzWqBt7l110SiDQcxSI7bYTRI9cULGfmIXgxJM5
 4WHk/ouqxjsk56TcEwF2UjkWeD7WwRpTDNvmbUCnNbFEG/dU6CcYOP+D+OMCvmOZCy9y
 rLKaqtn6p9O3zne2laTHXrrG0nPChJCYhr5VA6iPDnAUmlNdlM2+jHwqZqjCnVwS6lY9 Jg== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32rgnf9qps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Aug 2020 12:23:54 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 076GKE8V008401;
        Thu, 6 Aug 2020 16:23:53 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 32n018jtcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Aug 2020 16:23:53 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 076GNqYZ58458380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Aug 2020 16:23:52 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FE867805E;
        Thu,  6 Aug 2020 16:23:52 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C73A7805C;
        Thu,  6 Aug 2020 16:23:50 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.37.237])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  6 Aug 2020 16:23:49 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
Cc:     Nathan Lynch <nathanl@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/4] powerpc/memhotplug: Make lmb size 64bit
Date:   Thu,  6 Aug 2020 21:53:28 +0530
Message-Id: <20200806162329.276534-3-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200806162329.276534-1-aneesh.kumar@linux.ibm.com>
References: <20200806162329.276534-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-06_13:2020-08-06,2020-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060112
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Similar to commit 89c140bbaeee ("pseries: Fix 64 bit logical memory block panic")
make sure different variables tracking lmb_size are updated to be 64 bit.

This was found by code audit.

Cc: stable@vger.kernel.org
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 .../platforms/pseries/hotplug-memory.c        | 37 +++++++++++--------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 5d545b78111f..1fe3204c843a 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -277,7 +277,7 @@ static int dlpar_offline_lmb(struct drmem_lmb *lmb)
 	return dlpar_change_lmb_state(lmb, false);
 }
 
-static int pseries_remove_memblock(unsigned long base, unsigned int memblock_size)
+static int pseries_remove_memblock(unsigned long base, unsigned long memblock_size)
 {
 	unsigned long block_sz, start_pfn;
 	int sections_per_block;
@@ -308,9 +308,9 @@ static int pseries_remove_memblock(unsigned long base, unsigned int memblock_siz
 
 static int pseries_remove_mem_node(struct device_node *np)
 {
-	const __be32 *regs;
+	const __be32 *prop;
 	unsigned long base;
-	unsigned int lmb_size;
+	unsigned long lmb_size;
 	int ret = -EINVAL;
 
 	/*
@@ -322,12 +322,16 @@ static int pseries_remove_mem_node(struct device_node *np)
 	/*
 	 * Find the base address and size of the memblock
 	 */
-	regs = of_get_property(np, "reg", NULL);
-	if (!regs)
+	prop = of_get_property(np, "reg", NULL);
+	if (!prop)
 		return ret;
 
-	base = be64_to_cpu(*(unsigned long *)regs);
-	lmb_size = be32_to_cpu(regs[3]);
+	/*
+	 * "reg" property represents (addr,size) tuple.
+	 */
+	base = of_read_number(prop, mem_addr_cells);
+	prop += mem_addr_cells;
+	lmb_size = of_read_number(prop, mem_size_cells);
 
 	pseries_remove_memblock(base, lmb_size);
 	return 0;
@@ -557,7 +561,7 @@ static int dlpar_memory_remove_by_ic(u32 lmbs_to_remove, u32 drc_index)
 
 #else
 static inline int pseries_remove_memblock(unsigned long base,
-					  unsigned int memblock_size)
+					  unsigned long memblock_size)
 {
 	return -EOPNOTSUPP;
 }
@@ -878,9 +882,9 @@ int dlpar_memory(struct pseries_hp_errorlog *hp_elog)
 
 static int pseries_add_mem_node(struct device_node *np)
 {
-	const __be32 *regs;
+	const __be32 *prop;
 	unsigned long base;
-	unsigned int lmb_size;
+	unsigned long lmb_size;
 	int ret = -EINVAL;
 
 	/*
@@ -892,12 +896,15 @@ static int pseries_add_mem_node(struct device_node *np)
 	/*
 	 * Find the base and size of the memblock
 	 */
-	regs = of_get_property(np, "reg", NULL);
-	if (!regs)
+	prop = of_get_property(np, "reg", NULL);
+	if (!prop)
 		return ret;
-
-	base = be64_to_cpu(*(unsigned long *)regs);
-	lmb_size = be32_to_cpu(regs[3]);
+	/*
+	 * "reg" property represents (addr,size) tuple.
+	 */
+	base = of_read_number(prop, mem_addr_cells);
+	prop += mem_addr_cells;
+	lmb_size = of_read_number(prop, mem_size_cells);
 
 	/*
 	 * Update memory region to represent the memory add
-- 
2.26.2

