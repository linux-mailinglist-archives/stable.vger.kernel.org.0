Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B583CE0D2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346905AbhGSPST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346549AbhGSPOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:14:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C99E5613D8;
        Mon, 19 Jul 2021 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710115;
        bh=R33XyEw5FxFRJKtNMFHKwlWrVCVD5vApTROxi9XpiP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5gitPeBVaaQJ0y5G8+wZvu7hrt1Y2fD1tR7/TYTRuc+rWOcSaeeCVDBv1FHju81C
         SWVp9Q+jtH3ydAx/ET4a5Oti8TnsvP66SfQASK1aUlb091EnXDcNzYJ3tGngvZifZw
         glK1tPH5kpLBsuycN0PAkvTzSzxGUxCoJ1SvRehI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/243] powerpc/mm/book3s64: Fix possible build error
Date:   Mon, 19 Jul 2021 16:51:52 +0200
Message-Id: <20210719144943.580791941@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

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
index b487b489d4b6..4c2f75916a7e 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -282,22 +282,30 @@ static inline void fixup_tlbie_lpid(unsigned long lpid)
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
 
 	/* For the remaining sets, just flush the TLB */
@@ -1068,7 +1076,7 @@ void radix__tlb_flush(struct mmu_gather *tlb)
 	}
 }
 
-static __always_inline void __radix__flush_tlb_range_psize(struct mm_struct *mm,
+static void __radix__flush_tlb_range_psize(struct mm_struct *mm,
 				unsigned long start, unsigned long end,
 				int psize, bool also_pwc)
 {
-- 
2.30.2



