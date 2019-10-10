Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD91BD25A3
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388242AbfJJIlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388252AbfJJIlH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:41:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3162D21D6C;
        Thu, 10 Oct 2019 08:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696865;
        bh=kNT9IZoSLaW9n8PPv0pf5tORot56nKT64gIPrpGNV/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9B0pFILsvqCNnbgai9CxjSjFKJ6q1dGIVPmv88F6SsVpRCb0TIuUfT1EES/eFaha
         UBW+c2vIqYuQxLHCUunHmlEhASOQd94wzaQQwmxhB2L46hV3c0vQiB6m+WDrjh7WK0
         h5t3nOgmd2+AKjhdS6gMykXFL6BOm0ZHGlkKsEjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 036/148] powerpc/mm: Fixup tlbie vs mtpidr/mtlpidr ordering issue on POWER9
Date:   Thu, 10 Oct 2019 10:34:57 +0200
Message-Id: <20191010083613.340001156@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

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

Cc: stable@vger.kernel.org
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190924035254.24612-3-aneesh.kumar@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/cputable.h    |    3 -
 arch/powerpc/kernel/dt_cpu_ftrs.c      |    2 
 arch/powerpc/kvm/book3s_hv_rm_mmu.c    |   42 +++++++++++++----
 arch/powerpc/mm/book3s64/hash_native.c |   29 ++++++++++-
 arch/powerpc/mm/book3s64/radix_tlb.c   |   80 +++++++++++++++++++++++++++++----
 5 files changed, 134 insertions(+), 22 deletions(-)

--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -215,6 +215,7 @@ static inline void cpu_feature_keys_init
 #define CPU_FTR_P9_TM_XER_SO_BUG	LONG_ASM_CONST(0x0000200000000000)
 #define CPU_FTR_P9_TLBIE_STQ_BUG	LONG_ASM_CONST(0x0000400000000000)
 #define CPU_FTR_P9_TIDR			LONG_ASM_CONST(0x0000800000000000)
+#define CPU_FTR_P9_TLBIE_ERAT_BUG	LONG_ASM_CONST(0x0001000000000000)
 
 #ifndef __ASSEMBLY__
 
@@ -461,7 +462,7 @@ static inline void cpu_feature_keys_init
 	    CPU_FTR_CFAR | CPU_FTR_HVMODE | CPU_FTR_VMX_COPY | \
 	    CPU_FTR_DBELL | CPU_FTR_HAS_PPR | CPU_FTR_ARCH_207S | \
 	    CPU_FTR_TM_COMP | CPU_FTR_ARCH_300 | CPU_FTR_PKEY | \
-	    CPU_FTR_P9_TLBIE_STQ_BUG | CPU_FTR_P9_TIDR)
+	    CPU_FTR_P9_TLBIE_STQ_BUG | CPU_FTR_P9_TLBIE_ERAT_BUG | CPU_FTR_P9_TIDR)
 #define CPU_FTRS_POWER9_DD2_0 CPU_FTRS_POWER9
 #define CPU_FTRS_POWER9_DD2_1 (CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD2_1)
 #define CPU_FTRS_POWER9_DD2_2 (CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD2_1 | \
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -714,6 +714,8 @@ static __init void update_tlbie_feature_
 			WARN_ONCE(1, "Unknown PVR");
 			cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		}
+
+		cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_ERAT_BUG;
 	}
 }
 
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -433,6 +433,37 @@ static inline int is_mmio_hpte(unsigned
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
@@ -451,16 +482,7 @@ static void do_tlbies(struct kvm *kvm, u
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
--- a/arch/powerpc/mm/book3s64/hash_native.c
+++ b/arch/powerpc/mm/book3s64/hash_native.c
@@ -197,8 +197,31 @@ static inline unsigned long  ___tlbie(un
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
@@ -283,7 +306,7 @@ static inline void tlbie(unsigned long v
 		asm volatile("ptesync": : :"memory");
 	} else {
 		__tlbie(vpn, psize, apsize, ssize);
-		fixup_tlbie(vpn, psize, apsize, ssize);
+		fixup_tlbie_vpn(vpn, psize, apsize, ssize);
 		asm volatile("eieio; tlbsync; ptesync": : :"memory");
 	}
 	if (lock_tlbie && !use_local)
@@ -856,7 +879,7 @@ static void native_flush_hash_range(unsi
 		/*
 		 * Just do one more with the last used values.
 		 */
-		fixup_tlbie(vpn, psize, psize, ssize);
+		fixup_tlbie_vpn(vpn, psize, psize, ssize);
 		asm volatile("eieio; tlbsync; ptesync":::"memory");
 
 		if (lock_tlbie)
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -211,21 +211,82 @@ static __always_inline void __tlbie_lpid
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
@@ -273,6 +334,7 @@ static inline void _tlbie_pid(unsigned l
 	switch (ric) {
 	case RIC_FLUSH_TLB:
 		__tlbie_pid(pid, RIC_FLUSH_TLB);
+		fixup_tlbie_pid(pid);
 		break;
 	case RIC_FLUSH_PWC:
 		__tlbie_pid(pid, RIC_FLUSH_PWC);
@@ -280,8 +342,8 @@ static inline void _tlbie_pid(unsigned l
 	case RIC_FLUSH_ALL:
 	default:
 		__tlbie_pid(pid, RIC_FLUSH_ALL);
+		fixup_tlbie_pid(pid);
 	}
-	fixup_tlbie();
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -325,6 +387,7 @@ static inline void _tlbie_lpid(unsigned
 	switch (ric) {
 	case RIC_FLUSH_TLB:
 		__tlbie_lpid(lpid, RIC_FLUSH_TLB);
+		fixup_tlbie_lpid(lpid);
 		break;
 	case RIC_FLUSH_PWC:
 		__tlbie_lpid(lpid, RIC_FLUSH_PWC);
@@ -332,8 +395,8 @@ static inline void _tlbie_lpid(unsigned
 	case RIC_FLUSH_ALL:
 	default:
 		__tlbie_lpid(lpid, RIC_FLUSH_ALL);
+		fixup_tlbie_lpid(lpid);
 	}
-	fixup_tlbie_lpid(lpid);
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -407,6 +470,8 @@ static inline void __tlbie_va_range(unsi
 
 	for (addr = start; addr < end; addr += page_size)
 		__tlbie_va(addr, pid, ap, RIC_FLUSH_TLB);
+
+	fixup_tlbie_va_range(addr - page_size, pid, ap);
 }
 
 static __always_inline void _tlbie_va(unsigned long va, unsigned long pid,
@@ -416,7 +481,7 @@ static __always_inline void _tlbie_va(un
 
 	asm volatile("ptesync": : :"memory");
 	__tlbie_va(va, pid, ap, ric);
-	fixup_tlbie();
+	fixup_tlbie_va(va, pid, ap);
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -427,7 +492,7 @@ static __always_inline void _tlbie_lpid_
 
 	asm volatile("ptesync": : :"memory");
 	__tlbie_lpid_va(va, lpid, ap, ric);
-	fixup_tlbie_lpid(lpid);
+	fixup_tlbie_lpid_va(va, lpid, ap);
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -439,7 +504,6 @@ static inline void _tlbie_va_range(unsig
 	if (also_pwc)
 		__tlbie_pid(pid, RIC_FLUSH_PWC);
 	__tlbie_va_range(start, end, pid, page_size, psize);
-	fixup_tlbie();
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -775,7 +839,7 @@ is_local:
 			if (gflush)
 				__tlbie_va_range(gstart, gend, pid,
 						PUD_SIZE, MMU_PAGE_1G);
-			fixup_tlbie();
+
 			asm volatile("eieio; tlbsync; ptesync": : :"memory");
 		}
 	}


