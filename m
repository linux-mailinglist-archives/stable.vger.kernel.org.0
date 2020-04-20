Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8601B04ED
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 10:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgDTI4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 04:56:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725886AbgDTI4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 04:56:31 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03K8ZlIB034261
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 04:56:30 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30h72gjwv6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 04:56:30 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <hbathini@linux.ibm.com>;
        Mon, 20 Apr 2020 09:55:46 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 Apr 2020 09:55:44 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03K8uOB055705726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 08:56:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE9E052054;
        Mon, 20 Apr 2020 08:56:24 +0000 (GMT)
Received: from hbathini.in.ibm.com (unknown [9.102.25.223])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2825752050;
        Mon, 20 Apr 2020 08:56:22 +0000 (GMT)
Subject: [PATCH v3 2/2] powerpc/fadump: consider reserved ranges while
 reserving memory
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Cc:     Sourabh Jain <sourabhjain@linux.ibm.com>,
        Vasant Hegde <hegdevasant@linux.ibm.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
        stable@vger.kernel.org
Date:   Mon, 20 Apr 2020 14:26:22 +0530
In-Reply-To: <158737294432.26700.4830263187856221314.stgit@hbathini.in.ibm.com>
References: <158737294432.26700.4830263187856221314.stgit@hbathini.in.ibm.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042008-4275-0000-0000-000003C32A8E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042008-4276-0000-0000-000038D8AB98
Message-Id: <158737297693.26700.16193820746269425424.stgit@hbathini.in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_02:2020-04-17,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=2 spamscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200072
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 0962e8004e97 ("powerpc/prom: Scan reserved-ranges node for
memory reservations") enabled support to parse reserved-ranges DT
node and reserve kernel memory falling in these ranges for F/W
purposes. Memory reserved for FADump should not overlap with these
ranges as it could corrupt memory meant for F/W or crash'ed kernel
memory to be exported as vmcore.

But since commit 579ca1a27675 ("powerpc/fadump: make use of memblock's
bottom up allocation mode"), memblock_find_in_range() is being used to
find the appropriate area to reserve memory for FADump, which can't
account for reserved-ranges as these ranges are reserved only after
FADump memory reservation.

With reserved-ranges now being populated during early boot, look out
for these memory ranges while reserving memory for FADump. Without
this change, MPIPL on PowerNV systems aborts with hostboot failure,
when memory reserved for FADump is less than 4096MB.

Fixes: 579ca1a27675 ("powerpc/fadump: make use of memblock's bottom up allocation mode")
Cc: stable@vger.kernel.org
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
---

Changes in v3:
* Updated fadump_locate_reserve_mem() to use return '0' instead of an out parameter
  as suggested by Mahesh and added his 'Reviewed-by' tag with that change.


 arch/powerpc/kernel/fadump.c |   76 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 67 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 679277b..63aac8b 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -445,10 +445,72 @@ static int __init fadump_get_boot_mem_regions(void)
 	return ret;
 }
 
+/*
+ * Returns true, if the given range overlaps with reserved memory ranges
+ * starting at idx. Also, updates idx to index of overlapping memory range
+ * with the given memory range.
+ * False, otherwise.
+ */
+static bool overlaps_reserved_ranges(u64 base, u64 end, int *idx)
+{
+	bool ret = false;
+	int i;
+
+	for (i = *idx; i < reserved_mrange_info.mem_range_cnt; i++) {
+		u64 rbase = reserved_mrange_info.mem_ranges[i].base;
+		u64 rend = rbase + reserved_mrange_info.mem_ranges[i].size;
+
+		if (end <= rbase)
+			break;
+
+		if ((end > rbase) &&  (base < rend)) {
+			*idx = i;
+			ret = true;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * Locate a suitable memory area to reserve memory for FADump. While at it,
+ * lookup reserved-ranges & avoid overlap with them, as they are used by F/W.
+ */
+static u64 __init fadump_locate_reserve_mem(u64 base, u64 size)
+{
+	struct fadump_memory_range *mrngs;
+	phys_addr_t mstart, mend;
+	int idx = 0;
+	u64 i, ret = 0;
+
+	mrngs = reserved_mrange_info.mem_ranges;
+	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
+				&mstart, &mend, NULL) {
+		pr_debug("%llu) mstart: %llx, mend: %llx, base: %llx\n",
+			 i, mstart, mend, base);
+
+		if (mstart > base)
+			base = PAGE_ALIGN(mstart);
+
+		while ((mend > base) && ((mend - base) >= size)) {
+			if (!overlaps_reserved_ranges(base, base+size, &idx)) {
+				ret = base;
+				goto out;
+			}
+
+			base = mrngs[idx].base + mrngs[idx].size;
+			base = PAGE_ALIGN(base);
+		}
+	}
+
+out:
+	return ret;
+}
+
 int __init fadump_reserve_mem(void)
 {
-	u64 base, size, mem_boundary, bootmem_min, align = PAGE_SIZE;
-	bool is_memblock_bottom_up = memblock_bottom_up();
+	u64 base, size, mem_boundary, bootmem_min;
 	int ret = 1;
 
 	if (!fw_dump.fadump_enabled)
@@ -469,9 +531,9 @@ int __init fadump_reserve_mem(void)
 			PAGE_ALIGN(fadump_calculate_reserve_size());
 #ifdef CONFIG_CMA
 		if (!fw_dump.nocma) {
-			align = FADUMP_CMA_ALIGNMENT;
 			fw_dump.boot_memory_size =
-				ALIGN(fw_dump.boot_memory_size, align);
+				ALIGN(fw_dump.boot_memory_size,
+				      FADUMP_CMA_ALIGNMENT);
 		}
 #endif
 
@@ -539,11 +601,7 @@ int __init fadump_reserve_mem(void)
 		 * Reserve memory at an offset closer to bottom of the RAM to
 		 * minimize the impact of memory hot-remove operation.
 		 */
-		memblock_set_bottom_up(true);
-		base = memblock_find_in_range(base, mem_boundary, size, align);
-
-		/* Restore the previous allocation mode */
-		memblock_set_bottom_up(is_memblock_bottom_up);
+		base = fadump_locate_reserve_mem(base, size);
 
 		if (!base) {
 			pr_err("Failed to find memory chunk for reservation!\n");

