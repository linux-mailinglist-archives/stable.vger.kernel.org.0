Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807413C2E5F
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbhGJC05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231990AbhGJC02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 033E5613E4;
        Sat, 10 Jul 2021 02:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883821;
        bh=0lu2ozF2u5FD94Y0WiATsNzTVs1Ed26bgS2aoatc3D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aa8Q4MQm3McAAK3D8CTPqoExM9b9ZeW/ZbMteIRmffkHqhke+0thkfcNv7HsguzPf
         fUKlNMqqeDT7yyFCMVRQ3e9/laoNdqShrnn4qqXTu660LQaQPMhDJsKjgy5Ln7F0DI
         Jl2utkD9+Q37RV9OrW/O6Y6TsfGxFwHd/nsiLgox62Ob0+4Un8oCspCXSyGswQ2qFM
         Vi5wIa02nGvbqRJs5EgMIvoC1zgF0fl6xwgnfErsmZ2bqgJdPTjkxZrjt17Ah2eNcK
         cLNIDbrtvbaZCP19OIDPnYl9ZD82diFRRkCNmJFXjF1yxvGVO6IT3QNmtpT7dYOxoM
         LSP8smpmBHeIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.12 070/104] powerpc/mm/book3s64: Fix possible build error
Date:   Fri,  9 Jul 2021 22:21:22 -0400
Message-Id: <20210710022156.3168825-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit 07d8ad6fd8a3d47f50595ca4826f41dbf4f3a0c6 ]

Update _tlbiel_pid() such that we can avoid build errors like below when
using this function in other places.

arch/powerpc/mm/book3s64/radix_tlb.c: In function ‘__radix__flush_tlb_range_psize’:
arch/powerpc/mm/book3s64/radix_tlb.c:114:2: warning: ‘asm’ operand 3 probably does not match constraints
  114 |  asm volatile(PPC_TLBIEL(%0, %4, %3, %2, %1)
      |  ^~~
arch/powerpc/mm/book3s64/radix_tlb.c:114:2: error: impossible constraint in ‘asm’
make[4]: *** [scripts/Makefile.build:271: arch/powerpc/mm/book3s64/radix_tlb.o] Error 1
m

With this fix, we can also drop the __always_inline in __radix_flush_tlb_range_psize
which was added by commit e12d6d7d46a6 ("powerpc/mm/radix: mark __radix__flush_tlb_range_psize() as __always_inline")

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210610083639.387365-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/radix_tlb.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 409e61210789..817a02ef6032 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -291,22 +291,30 @@ static inline void fixup_tlbie_lpid(unsigned long lpid)
 /*
  * We use 128 set in radix mode and 256 set in hpt mode.
  */
-static __always_inline void _tlbiel_pid(unsigned long pid, unsigned long ric)
+static inline void _tlbiel_pid(unsigned long pid, unsigned long ric)
 {
 	int set;
 
 	asm volatile("ptesync": : :"memory");
 
-	/*
-	 * Flush the first set of the TLB, and if we're doing a RIC_FLUSH_ALL,
-	 * also flush the entire Page Walk Cache.
-	 */
-	__tlbiel_pid(pid, 0, ric);
+	switch (ric) {
+	case RIC_FLUSH_PWC:
 
-	/* For PWC, only one flush is needed */
-	if (ric == RIC_FLUSH_PWC) {
+		/* For PWC, only one flush is needed */
+		__tlbiel_pid(pid, 0, RIC_FLUSH_PWC);
 		ppc_after_tlbiel_barrier();
 		return;
+	case RIC_FLUSH_TLB:
+		__tlbiel_pid(pid, 0, RIC_FLUSH_TLB);
+		break;
+	case RIC_FLUSH_ALL:
+	default:
+		/*
+		 * Flush the first set of the TLB, and if
+		 * we're doing a RIC_FLUSH_ALL, also flush
+		 * the entire Page Walk Cache.
+		 */
+		__tlbiel_pid(pid, 0, RIC_FLUSH_ALL);
 	}
 
 	if (!cpu_has_feature(CPU_FTR_ARCH_31)) {
@@ -1176,7 +1184,7 @@ void radix__tlb_flush(struct mmu_gather *tlb)
 	}
 }
 
-static __always_inline void __radix__flush_tlb_range_psize(struct mm_struct *mm,
+static void __radix__flush_tlb_range_psize(struct mm_struct *mm,
 				unsigned long start, unsigned long end,
 				int psize, bool also_pwc)
 {
-- 
2.30.2

