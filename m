Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EDE1B02DE
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 09:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgDTH0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 03:26:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22840 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTH0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 03:26:36 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03K73rQf054878
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 03:26:34 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30gcs2w6e5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 03:26:34 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <hbathini@linux.ibm.com>;
        Mon, 20 Apr 2020 08:25:49 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 Apr 2020 08:25:46 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03K7QSqt35324388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 07:26:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52730AE045;
        Mon, 20 Apr 2020 07:26:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF52BAE055;
        Mon, 20 Apr 2020 07:26:26 +0000 (GMT)
Received: from hbathini.in.ibm.com (unknown [9.102.25.223])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 07:26:26 +0000 (GMT)
Subject: [PATCH v2 2/2] powerpc/fadump: consider reserved ranges while
 reserving memory
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Cc:     Sourabh Jain <sourabhjain@linux.ibm.com>,
        Vasant Hegde <hegdevasant@linux.ibm.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
        stable@vger.kernel.org
Date:   Mon, 20 Apr 2020 12:56:25 +0530
In-Reply-To: <158736754835.20831.15003408332721022400.stgit@hbathini.in.ibm.com>
References: <158736754835.20831.15003408332721022400.stgit@hbathini.in.ibm.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042007-0016-0000-0000-00000307C6C9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042007-0017-0000-0000-0000336BD6F2
Message-Id: <158736755834.20831.6987298467765783948.stgit@hbathini.in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_02:2020-04-17,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 adultscore=0 clxscore=1015 spamscore=0 mlxscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200058
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
---

Changes in v2:
* Add an out parameter 'found' for fadump_locate_reserve_mem() and set it to "true"
  when a suitable memory area is located.


 arch/powerpc/kernel/fadump.c |   81 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 71 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 679277b..0ffe69c 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -445,10 +445,73 @@ static int __init fadump_get_boot_mem_regions(void)
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
+static u64 __init fadump_locate_reserve_mem(u64 base, u64 size, bool *found)
+{
+	struct fadump_memory_range *mrngs;
+	phys_addr_t mstart, mend;
+	int idx = 0;
+	u64 i;
+
+	*found = false;
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
+				*found = true;
+				goto out;
+			}
+
+			base = mrngs[idx].base + mrngs[idx].size;
+			base = PAGE_ALIGN(base);
+		}
+	}
+
+out:
+	return base;
+}
+
 int __init fadump_reserve_mem(void)
 {
-	u64 base, size, mem_boundary, bootmem_min, align = PAGE_SIZE;
-	bool is_memblock_bottom_up = memblock_bottom_up();
+	u64 base, size, mem_boundary, bootmem_min;
 	int ret = 1;
 
 	if (!fw_dump.fadump_enabled)
@@ -469,9 +532,9 @@ int __init fadump_reserve_mem(void)
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
 
@@ -535,17 +598,15 @@ int __init fadump_reserve_mem(void)
 		pr_debug("Reserve dump area start address: 0x%lx\n",
 			 fw_dump.reserve_dump_area_start);
 	} else {
+		bool found = false;
+
 		/*
 		 * Reserve memory at an offset closer to bottom of the RAM to
 		 * minimize the impact of memory hot-remove operation.
 		 */
-		memblock_set_bottom_up(true);
-		base = memblock_find_in_range(base, mem_boundary, size, align);
-
-		/* Restore the previous allocation mode */
-		memblock_set_bottom_up(is_memblock_bottom_up);
+		base = fadump_locate_reserve_mem(base, size, &found);
 
-		if (!base) {
+		if (!found || (base > (mem_boundary - size))) {
 			pr_err("Failed to find memory chunk for reservation!\n");
 			goto error_out;
 		}

