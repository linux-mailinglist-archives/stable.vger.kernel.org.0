Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E0C3C2F57
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhGJCbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234405AbhGJC30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D00B613D9;
        Sat, 10 Jul 2021 02:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883989;
        bh=X2BiEr4jCZ3xAg2Dmz/MAgtJoQ2wHAd3YQ6VKLwqtv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkxymQNpq+8ni/vYhKqUeljUEkmMI59IO0byLY9J126SQj3Ro1rJX2Iws4Y+dqEX3
         qOnBti3GTDWTInUQjh2/JPWGEGWqGDMlXslPlmlZcoumsy0czT/bku2ld5SKAH9Cob
         fCXgfl8uH/xMNBXSDOcdDnexdAUJWOa05DKuu1+bYAiZrqArtazVqGTwZWrhwRGtg4
         t0Dyj1KuuT+ySesZDiPEw18ML2daps+Bq50b6weCULRCZXuUFPie7wx38xxNd49AG8
         mAs6eGJAvOebmfgiAE2l2Fn5SZGypJ7079qelyRMnQNWhrJxsbGtG9dSK574wZJTCz
         XNXjgsICF3/pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 65/93] powerpc/mm/book3s64: Fix possible build error
Date:   Fri,  9 Jul 2021 22:23:59 -0400
Message-Id: <20210710022428.3169839-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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

