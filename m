Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89EE4F5519
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389679AbfKHTAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:00:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389656AbfKHTAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1B9520865;
        Fri,  8 Nov 2019 19:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239618;
        bh=4YCugTghXdsjPoygDx9TfWL2nvIAxyKGM8jT3HDHLoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AM/XJyhAvDTZx3XMD+v4ckk2R11bBcS+V2q9ID2jp5AGNMXGRBmE3DmAlSUlRVWoo
         o19mcfc4VBBP69ckG5Os34TtGHzQqjegW8/96KBAmlv6AHU/uI7gQ1A5PuW8Dj3AgD
         U7x0ID9D17XNbazFx4574UCY6Pj79hWkUKpE1A+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Subject: [PATCH 4.14 57/62] powerpc/mm: Fixup tlbie vs store ordering issue on POWER9
Date:   Fri,  8 Nov 2019 19:50:45 +0100
Message-Id: <20191108174759.879781213@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/cputable.h    |    4 ++-
 arch/powerpc/kernel/dt_cpu_ftrs.c      |    3 ++
 arch/powerpc/kvm/book3s_64_mmu_radix.c |    3 ++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c    |   11 ++++++++
 arch/powerpc/mm/hash_native_64.c       |   16 ++++++++++++
 arch/powerpc/mm/pgtable_64.c           |    1 
 arch/powerpc/mm/tlb-radix.c            |   41 ++++++++++++++++++++++++---------
 7 files changed, 66 insertions(+), 13 deletions(-)

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
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -742,6 +742,9 @@ static __init void cpufeatures_cpu_quirk
 	 */
 	if ((version & 0xffffff00) == 0x004e0100)
 		cur_cpu_spec->cpu_features |= CPU_FTR_POWER9_DD1;
+
+	if ((version & 0xffff0000) == 0x004e0000)
+		cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
 }
 
 static void __init cpufeatures_setup_finished(void)
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -160,6 +160,9 @@ static void kvmppc_radix_tlbie_page(stru
 	asm volatile("ptesync": : :"memory");
 	asm volatile(PPC_TLBIE_5(%0, %1, 0, 0, 1)
 		     : : "r" (addr), "r" (kvm->arch.lpid) : "memory");
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG))
+		asm volatile(PPC_TLBIE_5(%0, %1, 0, 0, 1)
+			     : : "r" (addr), "r" (kvm->arch.lpid) : "memory");
 	asm volatile("ptesync": : :"memory");
 }
 
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -448,6 +448,17 @@ static void do_tlbies(struct kvm *kvm, u
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
--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -104,6 +104,15 @@ static inline unsigned long  ___tlbie(un
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
@@ -181,6 +190,7 @@ static inline void tlbie(unsigned long v
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
@@ -746,6 +756,10 @@ static void native_flush_hash_range(unsi
 				__tlbie(vpn, psize, psize, ssize);
 			} pte_iterate_hashed_end();
 		}
+		/*
+		 * Just do one more with the last used values.
+		 */
+		fixup_tlbie(vpn, psize, psize, ssize);
 		asm volatile("eieio; tlbsync; ptesync":::"memory");
 
 		if (lock_tlbie)
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -491,6 +491,7 @@ void mmu_partition_table_set_entry(unsig
 			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
 		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
 	}
+	/* do we need fixup here ?*/
 	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
 }
 EXPORT_SYMBOL_GPL(mmu_partition_table_set_entry);
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
@@ -80,6 +107,7 @@ static inline void _tlbie_pid(unsigned l
 	asm volatile("ptesync": : :"memory");
 	asm volatile(PPC_TLBIE_5(%0, %4, %3, %2, %1)
 		     : : "r"(rb), "i"(r), "i"(prs), "i"(ric), "r"(rs) : "memory");
+	fixup_tlbie();
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 	trace_tlbie(0, 0, rb, rs, ric, prs, r);
 }
@@ -105,19 +133,10 @@ static inline void _tlbiel_va(unsigned l
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


