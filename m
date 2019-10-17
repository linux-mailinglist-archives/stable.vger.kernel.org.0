Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDBD1DA51F
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 07:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391234AbfJQF0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 01:26:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbfJQF0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 01:26:55 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9H5MJA4124436
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 01:26:53 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vpf3f4g3r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 01:26:52 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <sandipan@linux.ibm.com>;
        Thu, 17 Oct 2019 06:26:50 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 17 Oct 2019 06:26:49 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9H5Ql7c51577030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 05:26:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47CDAAE056;
        Thu, 17 Oct 2019 05:26:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA0E8AE045;
        Thu, 17 Oct 2019 05:26:45 +0000 (GMT)
Received: from tpad450.ibmuc.com (unknown [9.199.40.180])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Oct 2019 05:26:45 +0000 (GMT)
From:   Sandipan Das <sandipan@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        mpe@ellerman.id.au, desnesn@linux.ibm.com
Subject: [PATCH stable 4.19 1/3] powerpc/mm: Fixup tlbie vs mtpidr/mtlpidr ordering issue on POWER9
Date:   Thu, 17 Oct 2019 10:56:42 +0530
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19101705-0028-0000-0000-000003AAC7A9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101705-0029-0000-0000-0000246CE339
Message-Id: <20191017052644.7068-1-sandipan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-17_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910170042
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

commit 047e6575aec71d75b765c22111820c4776cd1c43 upstream.

On POWER9, under some circumstances, a broadcast TLB invalidation will
fail to invalidate the ERAT cache on some threads when there are
parallel mtpidr/mtlpidr happening on other threads of the same core.
This can cause stores to continue to go to a page after it's unmapped.

The workaround is to force an ERAT flush using PID=0 or LPID=0 tlbie
flush. This additional TLB flush will cause the ERAT cache
invalidation. Since we are using PID=0 or LPID=0, we don't get
filtered out by the TLB snoop filtering logic.

We need to still follow this up with another tlbie to take care of
store vs tlbie ordering issue explained in commit:
a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on
POWER9"). The presence of ERAT cache implies we can still get new
stores and they may miss store queue marking flush.

Cc: stable@vger.kernel.org # v4.19
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190924035254.24612-3-aneesh.kumar@linux.ibm.com
[sandipan: Backported to v4.19]
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
---
 arch/powerpc/include/asm/cputable.h |  3 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c   |  2 +
 arch/powerpc/kvm/book3s_hv_rm_mmu.c | 42 +++++++++++----
 arch/powerpc/mm/hash_native_64.c    | 29 +++++++++--
 arch/powerpc/mm/tlb-radix.c         | 80 ++++++++++++++++++++++++++---
 5 files changed, 134 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index 6a6804c2e1b0..3ce690e5f345 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -214,6 +214,7 @@ static inline void cpu_feature_keys_init(void) { }
 #define CPU_FTR_P9_TM_XER_SO_BUG	LONG_ASM_CONST(0x0000200000000000)
 #define CPU_FTR_P9_TLBIE_STQ_BUG	LONG_ASM_CONST(0x0000400000000000)
 #define CPU_FTR_P9_TIDR			LONG_ASM_CONST(0x0000800000000000)
+#define CPU_FTR_P9_TLBIE_ERAT_BUG	LONG_ASM_CONST(0x0001000000000000)
 
 #ifndef __ASSEMBLY__
 
@@ -460,7 +461,7 @@ static inline void cpu_feature_keys_init(void) { }
 	    CPU_FTR_CFAR | CPU_FTR_HVMODE | CPU_FTR_VMX_COPY | \
 	    CPU_FTR_DBELL | CPU_FTR_HAS_PPR | CPU_FTR_ARCH_207S | \
 	    CPU_FTR_TM_COMP | CPU_FTR_ARCH_300 | CPU_FTR_PKEY | \
-	    CPU_FTR_P9_TLBIE_STQ_BUG | CPU_FTR_P9_TIDR)
+	    CPU_FTR_P9_TLBIE_STQ_BUG | CPU_FTR_P9_TLBIE_ERAT_BUG | CPU_FTR_P9_TIDR)
 #define CPU_FTRS_POWER9_DD2_0 CPU_FTRS_POWER9
 #define CPU_FTRS_POWER9_DD2_1 (CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD2_1)
 #define CPU_FTRS_POWER9_DD2_2 (CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD2_1 | \
diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index f3b8e04eca9c..c6f41907f0d7 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -717,6 +717,8 @@ static __init void update_tlbie_feature_flag(unsigned long pvr)
 			WARN_ONCE(1, "Unknown PVR");
 			cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		}
+
+		cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_ERAT_BUG;
 	}
 }
 
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 7c68d834c94a..02ab86be9ded 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -434,6 +434,37 @@ static inline int is_mmio_hpte(unsigned long v, unsigned long r)
 		(HPTE_R_KEY_HI | HPTE_R_KEY_LO));
 }
 
+static inline void fixup_tlbie_lpid(unsigned long rb_value, unsigned long lpid)
+{
+
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_ERAT_BUG)) {
+		/* Radix flush for a hash guest */
+
+		unsigned long rb,rs,prs,r,ric;
+
+		rb = PPC_BIT(52); /* IS = 2 */
+		rs = 0;  /* lpid = 0 */
+		prs = 0; /* partition scoped */
+		r = 1;   /* radix format */
+		ric = 0; /* RIC_FLSUH_TLB */
+
+		/*
+		 * Need the extra ptesync to make sure we don't
+		 * re-order the tlbie
+		 */
+		asm volatile("ptesync": : :"memory");
+		asm volatile(PPC_TLBIE_5(%0, %4, %3, %2, %1)
+			     : : "r"(rb), "i"(r), "i"(prs),
+			       "i"(ric), "r"(rs) : "memory");
+	}
+
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
+		asm volatile("ptesync": : :"memory");
+		asm volatile(PPC_TLBIE_5(%0,%1,0,0,0) : :
+			     "r" (rb_value), "r" (lpid));
+	}
+}
+
 static void do_tlbies(struct kvm *kvm, unsigned long *rbvalues,
 		      long npages, int global, bool need_sync)
 {
@@ -452,16 +483,7 @@ static void do_tlbies(struct kvm *kvm, unsigned long *rbvalues,
 				     "r" (rbvalues[i]), "r" (kvm->arch.lpid));
 		}
 
-		if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
-			/*
-			 * Need the extra ptesync to make sure we don't
-			 * re-order the tlbie
-			 */
-			asm volatile("ptesync": : :"memory");
-			asm volatile(PPC_TLBIE_5(%0,%1,0,0,0) : :
-				     "r" (rbvalues[0]), "r" (kvm->arch.lpid));
-		}
-
+		fixup_tlbie_lpid(rbvalues[i - 1], kvm->arch.lpid);
 		asm volatile("eieio; tlbsync; ptesync" : : : "memory");
 	} else {
 		if (need_sync)
diff --git a/arch/powerpc/mm/hash_native_64.c b/arch/powerpc/mm/hash_native_64.c
index 0c13561d8b80..42a48c5f7b7f 100644
--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -201,8 +201,31 @@ static inline unsigned long  ___tlbie(unsigned long vpn, int psize,
 	return va;
 }
 
-static inline void fixup_tlbie(unsigned long vpn, int psize, int apsize, int ssize)
+static inline void fixup_tlbie_vpn(unsigned long vpn, int psize,
+				   int apsize, int ssize)
 {
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_ERAT_BUG)) {
+		/* Radix flush for a hash guest */
+
+		unsigned long rb,rs,prs,r,ric;
+
+		rb = PPC_BIT(52); /* IS = 2 */
+		rs = 0;  /* lpid = 0 */
+		prs = 0; /* partition scoped */
+		r = 1;   /* radix format */
+		ric = 0; /* RIC_FLSUH_TLB */
+
+		/*
+		 * Need the extra ptesync to make sure we don't
+		 * re-order the tlbie
+		 */
+		asm volatile("ptesync": : :"memory");
+		asm volatile(PPC_TLBIE_5(%0, %4, %3, %2, %1)
+			     : : "r"(rb), "i"(r), "i"(prs),
+			       "i"(ric), "r"(rs) : "memory");
+	}
+
+
 	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		/* Need the extra ptesync to ensure we don't reorder tlbie*/
 		asm volatile("ptesync": : :"memory");
@@ -287,7 +310,7 @@ static inline void tlbie(unsigned long vpn, int psize, int apsize,
 		asm volatile("ptesync": : :"memory");
 	} else {
 		__tlbie(vpn, psize, apsize, ssize);
-		fixup_tlbie(vpn, psize, apsize, ssize);
+		fixup_tlbie_vpn(vpn, psize, apsize, ssize);
 		asm volatile("eieio; tlbsync; ptesync": : :"memory");
 	}
 	if (lock_tlbie && !use_local)
@@ -860,7 +883,7 @@ static void native_flush_hash_range(unsigned long number, int local)
 		/*
 		 * Just do one more with the last used values.
 		 */
-		fixup_tlbie(vpn, psize, psize, ssize);
+		fixup_tlbie_vpn(vpn, psize, psize, ssize);
 		asm volatile("eieio; tlbsync; ptesync":::"memory");
 
 		if (lock_tlbie)
diff --git a/arch/powerpc/mm/tlb-radix.c b/arch/powerpc/mm/tlb-radix.c
index 0cddae4263f9..62be0e5732b7 100644
--- a/arch/powerpc/mm/tlb-radix.c
+++ b/arch/powerpc/mm/tlb-radix.c
@@ -215,21 +215,82 @@ static inline void __tlbie_lpid_va(unsigned long va, unsigned long lpid,
 	trace_tlbie(lpid, 0, rb, rs, ric, prs, r);
 }
 
-static inline void fixup_tlbie(void)
+
+static inline void fixup_tlbie_va(unsigned long va, unsigned long pid,
+				  unsigned long ap)
 {
-	unsigned long pid = 0;
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_ERAT_BUG)) {
+		asm volatile("ptesync": : :"memory");
+		__tlbie_va(va, 0, ap, RIC_FLUSH_TLB);
+	}
+
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
+		asm volatile("ptesync": : :"memory");
+		__tlbie_va(va, pid, ap, RIC_FLUSH_TLB);
+	}
+}
+
+static inline void fixup_tlbie_va_range(unsigned long va, unsigned long pid,
+					unsigned long ap)
+{
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_ERAT_BUG)) {
+		asm volatile("ptesync": : :"memory");
+		__tlbie_pid(0, RIC_FLUSH_TLB);
+	}
+
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
+		asm volatile("ptesync": : :"memory");
+		__tlbie_va(va, pid, ap, RIC_FLUSH_TLB);
+	}
+}
+
+static inline void fixup_tlbie_pid(unsigned long pid)
+{
+	/*
+	 * We can use any address for the invalidation, pick one which is
+	 * probably unused as an optimisation.
+	 */
 	unsigned long va = ((1UL << 52) - 1);
 
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_ERAT_BUG)) {
+		asm volatile("ptesync": : :"memory");
+		__tlbie_pid(0, RIC_FLUSH_TLB);
+	}
+
 	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync": : :"memory");
 		__tlbie_va(va, pid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
 	}
 }
 
+
+static inline void fixup_tlbie_lpid_va(unsigned long va, unsigned long lpid,
+				       unsigned long ap)
+{
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_ERAT_BUG)) {
+		asm volatile("ptesync": : :"memory");
+		__tlbie_lpid_va(va, 0, ap, RIC_FLUSH_TLB);
+	}
+
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
+		asm volatile("ptesync": : :"memory");
+		__tlbie_lpid_va(va, lpid, ap, RIC_FLUSH_TLB);
+	}
+}
+
 static inline void fixup_tlbie_lpid(unsigned long lpid)
 {
+	/*
+	 * We can use any address for the invalidation, pick one which is
+	 * probably unused as an optimisation.
+	 */
 	unsigned long va = ((1UL << 52) - 1);
 
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_ERAT_BUG)) {
+		asm volatile("ptesync": : :"memory");
+		__tlbie_lpid(0, RIC_FLUSH_TLB);
+	}
+
 	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync": : :"memory");
 		__tlbie_lpid_va(va, lpid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
@@ -277,6 +338,7 @@ static inline void _tlbie_pid(unsigned long pid, unsigned long ric)
 	switch (ric) {
 	case RIC_FLUSH_TLB:
 		__tlbie_pid(pid, RIC_FLUSH_TLB);
+		fixup_tlbie_pid(pid);
 		break;
 	case RIC_FLUSH_PWC:
 		__tlbie_pid(pid, RIC_FLUSH_PWC);
@@ -284,8 +346,8 @@ static inline void _tlbie_pid(unsigned long pid, unsigned long ric)
 	case RIC_FLUSH_ALL:
 	default:
 		__tlbie_pid(pid, RIC_FLUSH_ALL);
+		fixup_tlbie_pid(pid);
 	}
-	fixup_tlbie();
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -329,6 +391,7 @@ static inline void _tlbie_lpid(unsigned long lpid, unsigned long ric)
 	switch (ric) {
 	case RIC_FLUSH_TLB:
 		__tlbie_lpid(lpid, RIC_FLUSH_TLB);
+		fixup_tlbie_lpid(lpid);
 		break;
 	case RIC_FLUSH_PWC:
 		__tlbie_lpid(lpid, RIC_FLUSH_PWC);
@@ -336,8 +399,8 @@ static inline void _tlbie_lpid(unsigned long lpid, unsigned long ric)
 	case RIC_FLUSH_ALL:
 	default:
 		__tlbie_lpid(lpid, RIC_FLUSH_ALL);
+		fixup_tlbie_lpid(lpid);
 	}
-	fixup_tlbie_lpid(lpid);
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -410,6 +473,8 @@ static inline void __tlbie_va_range(unsigned long start, unsigned long end,
 
 	for (addr = start; addr < end; addr += page_size)
 		__tlbie_va(addr, pid, ap, RIC_FLUSH_TLB);
+
+	fixup_tlbie_va_range(addr - page_size, pid, ap);
 }
 
 static inline void _tlbie_va(unsigned long va, unsigned long pid,
@@ -419,7 +484,7 @@ static inline void _tlbie_va(unsigned long va, unsigned long pid,
 
 	asm volatile("ptesync": : :"memory");
 	__tlbie_va(va, pid, ap, ric);
-	fixup_tlbie();
+	fixup_tlbie_va(va, pid, ap);
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -430,7 +495,7 @@ static inline void _tlbie_lpid_va(unsigned long va, unsigned long lpid,
 
 	asm volatile("ptesync": : :"memory");
 	__tlbie_lpid_va(va, lpid, ap, ric);
-	fixup_tlbie_lpid(lpid);
+	fixup_tlbie_lpid_va(va, lpid, ap);
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -442,7 +507,6 @@ static inline void _tlbie_va_range(unsigned long start, unsigned long end,
 	if (also_pwc)
 		__tlbie_pid(pid, RIC_FLUSH_PWC);
 	__tlbie_va_range(start, end, pid, page_size, psize);
-	fixup_tlbie();
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -773,7 +837,7 @@ static inline void __radix__flush_tlb_range(struct mm_struct *mm,
 			if (gflush)
 				__tlbie_va_range(gstart, gend, pid,
 						PUD_SIZE, MMU_PAGE_1G);
-			fixup_tlbie();
+
 			asm volatile("eieio; tlbsync; ptesync": : :"memory");
 		}
 	}
-- 
2.21.0

