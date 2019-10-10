Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA734D25BE
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387917AbfJJIjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387932AbfJJIjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 920D220B7C;
        Thu, 10 Oct 2019 08:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696781;
        bh=lcfvZg2D+nWX4tQ0Ktw0J8gXOf+V1tNFCWd1K6KLb5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6HJcqa5/S3bjVKGlSZlboCxwR2G6lscrz1Q0AcmfgLS+mxbBp5oYlq1nssPy7mnR
         5wSpEHidhPcqjHzhcnJ9MztHsY68mGyi5hFO7p6k1dSeGjOVEI3iQ+rZlMxo6Kbnxy
         tRdIvzOCd8cqTS4Dkwp+AnDIKqPPrDAufloiH6KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 033/148] powerpc/book3s64/radix: Rename CPU_FTR_P9_TLBIE_BUG feature flag
Date:   Thu, 10 Oct 2019 10:34:54 +0200
Message-Id: <20191010083613.161863899@linuxfoundation.org>
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

commit 09ce98cacd51fcd0fa0af2f79d1e1d3192f4cbb0 upstream.

Rename the #define to indicate this is related to store vs tlbie
ordering issue. In the next patch, we will be adding another feature
flag that is used to handles ERAT flush vs tlbie ordering issue.

Fixes: a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on POWER9")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190924035254.24612-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/cputable.h    |    4 ++--
 arch/powerpc/kernel/dt_cpu_ftrs.c      |    6 +++---
 arch/powerpc/kvm/book3s_hv_rm_mmu.c    |    2 +-
 arch/powerpc/mm/book3s64/hash_native.c |    2 +-
 arch/powerpc/mm/book3s64/radix_tlb.c   |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -213,7 +213,7 @@ static inline void cpu_feature_keys_init
 #define CPU_FTR_POWER9_DD2_1		LONG_ASM_CONST(0x0000080000000000)
 #define CPU_FTR_P9_TM_HV_ASSIST		LONG_ASM_CONST(0x0000100000000000)
 #define CPU_FTR_P9_TM_XER_SO_BUG	LONG_ASM_CONST(0x0000200000000000)
-#define CPU_FTR_P9_TLBIE_BUG		LONG_ASM_CONST(0x0000400000000000)
+#define CPU_FTR_P9_TLBIE_STQ_BUG	LONG_ASM_CONST(0x0000400000000000)
 #define CPU_FTR_P9_TIDR			LONG_ASM_CONST(0x0000800000000000)
 
 #ifndef __ASSEMBLY__
@@ -461,7 +461,7 @@ static inline void cpu_feature_keys_init
 	    CPU_FTR_CFAR | CPU_FTR_HVMODE | CPU_FTR_VMX_COPY | \
 	    CPU_FTR_DBELL | CPU_FTR_HAS_PPR | CPU_FTR_ARCH_207S | \
 	    CPU_FTR_TM_COMP | CPU_FTR_ARCH_300 | CPU_FTR_PKEY | \
-	    CPU_FTR_P9_TLBIE_BUG | CPU_FTR_P9_TIDR)
+	    CPU_FTR_P9_TLBIE_STQ_BUG | CPU_FTR_P9_TIDR)
 #define CPU_FTRS_POWER9_DD2_0 CPU_FTRS_POWER9
 #define CPU_FTRS_POWER9_DD2_1 (CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD2_1)
 #define CPU_FTRS_POWER9_DD2_2 (CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD2_1 | \
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -705,14 +705,14 @@ static __init void update_tlbie_feature_
 		if ((pvr & 0xe000) == 0) {
 			/* Nimbus */
 			if ((pvr & 0xfff) < 0x203)
-				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		} else if ((pvr & 0xc000) == 0) {
 			/* Cumulus */
 			if ((pvr & 0xfff) < 0x103)
-				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		} else {
 			WARN_ONCE(1, "Unknown PVR");
-			cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+			cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		}
 	}
 }
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -451,7 +451,7 @@ static void do_tlbies(struct kvm *kvm, u
 				     "r" (rbvalues[i]), "r" (kvm->arch.lpid));
 		}
 
-		if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+		if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 			/*
 			 * Need the extra ptesync to make sure we don't
 			 * re-order the tlbie
--- a/arch/powerpc/mm/book3s64/hash_native.c
+++ b/arch/powerpc/mm/book3s64/hash_native.c
@@ -199,7 +199,7 @@ static inline unsigned long  ___tlbie(un
 
 static inline void fixup_tlbie(unsigned long vpn, int psize, int apsize, int ssize)
 {
-	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		/* Need the extra ptesync to ensure we don't reorder tlbie*/
 		asm volatile("ptesync": : :"memory");
 		___tlbie(vpn, psize, apsize, ssize);
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -216,7 +216,7 @@ static inline void fixup_tlbie(void)
 	unsigned long pid = 0;
 	unsigned long va = ((1UL << 52) - 1);
 
-	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync": : :"memory");
 		__tlbie_va(va, pid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
 	}
@@ -226,7 +226,7 @@ static inline void fixup_tlbie_lpid(unsi
 {
 	unsigned long va = ((1UL << 52) - 1);
 
-	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync": : :"memory");
 		__tlbie_lpid_va(va, lpid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
 	}


