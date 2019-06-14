Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C5546975
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfFNUdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbfFNUai (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:38 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F14C2189F;
        Fri, 14 Jun 2019 20:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544237;
        bh=gtJhGptvzKRaP8nzyQ6AGpVP109t+GdppfIOsXKEbr8=;
        h=From:To:Cc:Subject:Date:From;
        b=e/MAvX563AH66bmfK4exjN86xKfEcB7MM4A8N7zFJEOdhPC2Hr8bWWX31cef2Q6YI
         rCF8uBKtSKXnjee/+xp6fO+KippySEjIVobC/q6Vj2ao/rlHmvFP8cAqFOO0UKbbc1
         ACjsfRSZGIz1PnTTxvYRJrfRCaEf7O0k+7W9rPqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 01/18] ARC: fix build warnings with !CONFIG_KPROBES
Date:   Fri, 14 Jun 2019 16:30:17 -0400
Message-Id: <20190614203037.27910-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit 4c6fabda1ad1dec6d274c098ef0a91809c74f2e3 ]

|   CC      lib/nmi_backtrace.o
| In file included from ../include/linux/kprobes.h:43:0,
|                  from ../lib/nmi_backtrace.c:17:
| ../arch/arc/include/asm/kprobes.h:57:13: warning: 'trap_is_kprobe' defined but not used [-Wunused-function]
|  static void trap_is_kprobe(unsigned long address, struct pt_regs *regs)
|              ^~~~~~~~~~~~~~

The warning started with 7d134b2ce6 ("kprobes: move kprobe declarations
to asm-generic/kprobes.h") which started including <asm/kprobes.h>
unconditionally into <linux/kprobes.h> exposing a stub function for
!CONFIG_KPROBES to rest of world. Fix that by making the stub a macro

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/cmpxchg.h | 14 ++++++++++----
 arch/arc/mm/tlb.c              | 13 ++++++++-----
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/arc/include/asm/cmpxchg.h b/arch/arc/include/asm/cmpxchg.h
index d819de1c5d10..3ea4112c8302 100644
--- a/arch/arc/include/asm/cmpxchg.h
+++ b/arch/arc/include/asm/cmpxchg.h
@@ -92,8 +92,11 @@ __cmpxchg(volatile void *ptr, unsigned long expected, unsigned long new)
 
 #endif /* CONFIG_ARC_HAS_LLSC */
 
-#define cmpxchg(ptr, o, n) ((typeof(*(ptr)))__cmpxchg((ptr), \
-				(unsigned long)(o), (unsigned long)(n)))
+#define cmpxchg(ptr, o, n) ({				\
+	(typeof(*(ptr)))__cmpxchg((ptr),		\
+				  (unsigned long)(o),	\
+				  (unsigned long)(n));	\
+})
 
 /*
  * atomic_cmpxchg is same as cmpxchg
@@ -198,8 +201,11 @@ static inline unsigned long __xchg(unsigned long val, volatile void *ptr,
 	return __xchg_bad_pointer();
 }
 
-#define xchg(ptr, with) ((typeof(*(ptr)))__xchg((unsigned long)(with), (ptr), \
-						 sizeof(*(ptr))))
+#define xchg(ptr, with) ({				\
+	(typeof(*(ptr)))__xchg((unsigned long)(with),	\
+			       (ptr),			\
+			       sizeof(*(ptr)));		\
+})
 
 #endif /* CONFIG_ARC_PLAT_EZNPS */
 
diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
index a4dc881da277..3c88ccbe01af 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -890,9 +890,11 @@ void do_tlb_overlap_fault(unsigned long cause, unsigned long address,
 			  struct pt_regs *regs)
 {
 	struct cpuinfo_arc_mmu *mmu = &cpuinfo_arc700[smp_processor_id()].mmu;
-	unsigned int pd0[mmu->ways];
 	unsigned long flags;
-	int set;
+	int set, n_ways = mmu->ways;
+
+	n_ways = min(n_ways, 4);
+	BUG_ON(mmu->ways > 4);
 
 	local_irq_save(flags);
 
@@ -900,9 +902,10 @@ void do_tlb_overlap_fault(unsigned long cause, unsigned long address,
 	for (set = 0; set < mmu->sets; set++) {
 
 		int is_valid, way;
+		unsigned int pd0[4];
 
 		/* read out all the ways of current set */
-		for (way = 0, is_valid = 0; way < mmu->ways; way++) {
+		for (way = 0, is_valid = 0; way < n_ways; way++) {
 			write_aux_reg(ARC_REG_TLBINDEX,
 					  SET_WAY_TO_IDX(mmu, set, way));
 			write_aux_reg(ARC_REG_TLBCOMMAND, TLBRead);
@@ -916,14 +919,14 @@ void do_tlb_overlap_fault(unsigned long cause, unsigned long address,
 			continue;
 
 		/* Scan the set for duplicate ways: needs a nested loop */
-		for (way = 0; way < mmu->ways - 1; way++) {
+		for (way = 0; way < n_ways - 1; way++) {
 
 			int n;
 
 			if (!pd0[way])
 				continue;
 
-			for (n = way + 1; n < mmu->ways; n++) {
+			for (n = way + 1; n < n_ways; n++) {
 				if (pd0[way] != pd0[n])
 					continue;
 
-- 
2.20.1

