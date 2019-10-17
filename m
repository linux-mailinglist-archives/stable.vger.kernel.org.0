Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E4FDA6E4
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 10:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389100AbfJQIFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 04:05:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727791AbfJQIFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 04:05:16 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9H840Oi054980
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 04:05:15 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vpk4ujnph-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 04:05:15 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <sandipan@linux.ibm.com>;
        Thu, 17 Oct 2019 09:05:13 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 17 Oct 2019 09:05:09 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9H84aWF39256518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 08:04:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 464F7A406B;
        Thu, 17 Oct 2019 08:05:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B8D5A4054;
        Thu, 17 Oct 2019 08:05:06 +0000 (GMT)
Received: from tpad450.ibmuc.com (unknown [9.199.32.220])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Oct 2019 08:05:06 +0000 (GMT)
From:   Sandipan Das <sandipan@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH stable 4.14 1/6] powerpc/mm: Fixup tlbie vs store ordering issue on POWER9
Date:   Thu, 17 Oct 2019 13:35:00 +0530
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19101708-0008-0000-0000-00000322D7E6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101708-0009-0000-0000-00004A41F476
Message-Id: <20191017080505.8348-1-sandipan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-17_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910170071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit a5d4b5891c2f1f865a2def1eb0030f534e77ff86 upstream.

On POWER9, under some circumstances, a broadcast TLB invalidation
might complete before all previous stores have drained, potentially
allowing stale stores from becoming visible after the invalidation.
This works around it by doubling up those TLB invalidations which was
verified by HW to be sufficient to close the risk window.

This will be documented in a yet-to-be-published errata.

Cc: stable@vger.kernel.org # v4.14
Fixes: 1a472c9dba6b ("powerpc/mm/radix: Add tlbflush routines")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
[mpe: Enable the feature in the DT CPU features code for all Power9,
      rename the feature to CPU_FTR_P9_TLBIE_BUG per benh.]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20180323045627.16800-3-aneesh.kumar@linux.vnet.ibm.com/
[sandipan: Backported to v4.14]
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
---
 arch/powerpc/include/asm/cputable.h    |  4 ++-
 arch/powerpc/kernel/dt_cpu_ftrs.c      |  3 ++
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  3 ++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c    | 11 +++++++
 arch/powerpc/mm/hash_native_64.c       | 16 +++++++++-
 arch/powerpc/mm/pgtable_64.c           |  1 +
 arch/powerpc/mm/tlb-radix.c            | 41 +++++++++++++++++++-------
 7 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index 53b31c2bcdf4..e143017d7549 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -215,6 +215,7 @@ enum {
 #define CPU_FTR_DAWR			LONG_ASM_CONST(0x0400000000000000)
 #define CPU_FTR_DABRX			LONG_ASM_CONST(0x0800000000000000)
 #define CPU_FTR_PMAO_BUG		LONG_ASM_CONST(0x1000000000000000)
+#define CPU_FTR_P9_TLBIE_BUG		LONG_ASM_CONST(0x2000000000000000)
 #define CPU_FTR_POWER9_DD1		LONG_ASM_CONST(0x4000000000000000)
 
 #ifndef __ASSEMBLY__
@@ -475,7 +476,8 @@ enum {
 	    CPU_FTR_STCX_CHECKS_ADDRESS | CPU_FTR_POPCNTB | CPU_FTR_POPCNTD | \
 	    CPU_FTR_CFAR | CPU_FTR_HVMODE | CPU_FTR_VMX_COPY | \
 	    CPU_FTR_DBELL | CPU_FTR_HAS_PPR | CPU_FTR_DAWR | \
-	    CPU_FTR_ARCH_207S | CPU_FTR_TM_COMP | CPU_FTR_ARCH_300)
+	    CPU_FTR_ARCH_207S | CPU_FTR_TM_COMP | CPU_FTR_ARCH_300 | \
+	    CPU_FTR_P9_TLBIE_BUG)
 #define CPU_FTRS_POWER9_DD1 ((CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD1) & \
 			     (~CPU_FTR_SAO))
 #define CPU_FTRS_CELL	(CPU_FTR_USE_TB | CPU_FTR_LWSYNC | \
diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index 2dba206b065a..15059e2446de 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -742,6 +742,9 @@ static __init void cpufeatures_cpu_quirks(void)
 	 */
 	if ((version & 0xffffff00) == 0x004e0100)
 		cur_cpu_spec->cpu_features |= CPU_FTR_POWER9_DD1;
+
+	if ((version & 0xffff0000) == 0x004e0000)
+		cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
 }
 
 static void __init cpufeatures_setup_finished(void)
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 27a41695fcfd..559cba16dbe0 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -160,6 +160,9 @@ static void kvmppc_radix_tlbie_page(struct kvm *kvm, unsigned long addr,
 	asm volatile("ptesync": : :"memory");
 	asm volatile(PPC_TLBIE_5(%0, %1, 0, 0, 1)
 		     : : "r" (addr), "r" (kvm->arch.lpid) : "memory");
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG))
+		asm volatile(PPC_TLBIE_5(%0, %1, 0, 0, 1)
+			     : : "r" (addr), "r" (kvm->arch.lpid) : "memory");
 	asm volatile("ptesync": : :"memory");
 }
 
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 4962d537c186..b18966a368af 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -448,6 +448,17 @@ static void do_tlbies(struct kvm *kvm, unsigned long *rbvalues,
 			asm volatile(PPC_TLBIE_5(%0,%1,0,0,0) : :
 				     "r" (rbvalues[i]), "r" (kvm->arch.lpid));
 		}
+
+		if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+			/*
+			 * Need the extra ptesync to make sure we don't
+			 * re-order the tlbie
+			 */
+			asm volatile("ptesync": : :"memory");
+			asm volatile(PPC_TLBIE_5(%0,%1,0,0,0) : :
+				     "r" (rbvalues[0]), "r" (kvm->arch.lpid));
+		}
+
 		asm volatile("eieio; tlbsync; ptesync" : : : "memory");
 		kvm->arch.tlbie_lock = 0;
 	} else {
diff --git a/arch/powerpc/mm/hash_native_64.c b/arch/powerpc/mm/hash_native_64.c
index 640cf566e986..96797bff5937 100644
--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -104,6 +104,15 @@ static inline unsigned long  ___tlbie(unsigned long vpn, int psize,
 	return va;
 }
 
+static inline void fixup_tlbie(unsigned long vpn, int psize, int apsize, int ssize)
+{
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+		/* Need the extra ptesync to ensure we don't reorder tlbie*/
+		asm volatile("ptesync": : :"memory");
+		___tlbie(vpn, psize, apsize, ssize);
+	}
+}
+
 static inline void __tlbie(unsigned long vpn, int psize, int apsize, int ssize)
 {
 	unsigned long rb;
@@ -181,6 +190,7 @@ static inline void tlbie(unsigned long vpn, int psize, int apsize,
 		asm volatile("ptesync": : :"memory");
 	} else {
 		__tlbie(vpn, psize, apsize, ssize);
+		fixup_tlbie(vpn, psize, apsize, ssize);
 		asm volatile("eieio; tlbsync; ptesync": : :"memory");
 	}
 	if (lock_tlbie && !use_local)
@@ -674,7 +684,7 @@ static void native_hpte_clear(void)
  */
 static void native_flush_hash_range(unsigned long number, int local)
 {
-	unsigned long vpn;
+	unsigned long vpn = 0;
 	unsigned long hash, index, hidx, shift, slot;
 	struct hash_pte *hptep;
 	unsigned long hpte_v;
@@ -746,6 +756,10 @@ static void native_flush_hash_range(unsigned long number, int local)
 				__tlbie(vpn, psize, psize, ssize);
 			} pte_iterate_hashed_end();
 		}
+		/*
+		 * Just do one more with the last used values.
+		 */
+		fixup_tlbie(vpn, psize, psize, ssize);
 		asm volatile("eieio; tlbsync; ptesync":::"memory");
 
 		if (lock_tlbie)
diff --git a/arch/powerpc/mm/pgtable_64.c b/arch/powerpc/mm/pgtable_64.c
index 12f95b1f7d07..48ed34d52ffd 100644
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -491,6 +491,7 @@ void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
 			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
 		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
 	}
+	/* do we need fixup here ?*/
 	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
 }
 EXPORT_SYMBOL_GPL(mmu_partition_table_set_entry);
diff --git a/arch/powerpc/mm/tlb-radix.c b/arch/powerpc/mm/tlb-radix.c
index 4b295cfd5f7e..1a4912c5e5a2 100644
--- a/arch/powerpc/mm/tlb-radix.c
+++ b/arch/powerpc/mm/tlb-radix.c
@@ -23,6 +23,33 @@
 #define RIC_FLUSH_PWC 1
 #define RIC_FLUSH_ALL 2
 
+static inline void __tlbie_va(unsigned long va, unsigned long pid,
+			      unsigned long ap, unsigned long ric)
+{
+	unsigned long rb,rs,prs,r;
+
+	rb = va & ~(PPC_BITMASK(52, 63));
+	rb |= ap << PPC_BITLSHIFT(58);
+	rs = pid << PPC_BITLSHIFT(31);
+	prs = 1; /* process scoped */
+	r = 1;   /* raidx format */
+
+	asm volatile(PPC_TLBIE_5(%0, %4, %3, %2, %1)
+		     : : "r"(rb), "i"(r), "i"(prs), "i"(ric), "r"(rs) : "memory");
+	trace_tlbie(0, 0, rb, rs, ric, prs, r);
+}
+
+static inline void fixup_tlbie(void)
+{
+	unsigned long pid = 0;
+	unsigned long va = ((1UL << 52) - 1);
+
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+		asm volatile("ptesync": : :"memory");
+		__tlbie_va(va, pid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
+	}
+}
+
 static inline void __tlbiel_pid(unsigned long pid, int set,
 				unsigned long ric)
 {
@@ -80,6 +107,7 @@ static inline void _tlbie_pid(unsigned long pid, unsigned long ric)
 	asm volatile("ptesync": : :"memory");
 	asm volatile(PPC_TLBIE_5(%0, %4, %3, %2, %1)
 		     : : "r"(rb), "i"(r), "i"(prs), "i"(ric), "r"(rs) : "memory");
+	fixup_tlbie();
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 	trace_tlbie(0, 0, rb, rs, ric, prs, r);
 }
@@ -105,19 +133,10 @@ static inline void _tlbiel_va(unsigned long va, unsigned long pid,
 static inline void _tlbie_va(unsigned long va, unsigned long pid,
 			     unsigned long ap, unsigned long ric)
 {
-	unsigned long rb,rs,prs,r;
-
-	rb = va & ~(PPC_BITMASK(52, 63));
-	rb |= ap << PPC_BITLSHIFT(58);
-	rs = pid << PPC_BITLSHIFT(31);
-	prs = 1; /* process scoped */
-	r = 1;   /* raidx format */
-
 	asm volatile("ptesync": : :"memory");
-	asm volatile(PPC_TLBIE_5(%0, %4, %3, %2, %1)
-		     : : "r"(rb), "i"(r), "i"(prs), "i"(ric), "r"(rs) : "memory");
+	__tlbie_va(va, pid, ap, ric);
+	fixup_tlbie();
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
-	trace_tlbie(0, 0, rb, rs, ric, prs, r);
 }
 
 /*
-- 
2.21.0

