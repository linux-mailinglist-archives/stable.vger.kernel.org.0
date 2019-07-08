Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A368A621E6
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbfGHPUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387454AbfGHPUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:20:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 430C4216C4;
        Mon,  8 Jul 2019 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599229;
        bh=mFT7yPOGcmuMb1bVxFh0rKzv98iifujokqnuiIwQvzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8hFSPR1f0YJeY+Kz/BKTKjo5Kr7WitCP/nPO0CGtaZVQHZEngGEEUaA+UgQfXt6z
         8uV+nTaXCR73sBtvwKw0LK2qtRHte6Km8w1D5aJTnNQ++XnERkvjLn4iT4zNRcWalq
         LPpPo///tiV1QD4EBkLXyszTSQ/YfaL6rI86o8hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 008/102] ARC: fix build warnings with !CONFIG_KPROBES
Date:   Mon,  8 Jul 2019 17:12:01 +0200
Message-Id: <20190708150526.451314587@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



