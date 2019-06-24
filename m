Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393D1506FE
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbfFXKDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbfFXKDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:03:11 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F8BE205ED;
        Mon, 24 Jun 2019 10:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370590;
        bh=aPO68/KiexhH73GsYWwDWHSuOWmov594Nfp7HgCCThg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amV5OC7KydpsyvPZYWxXTUYVjLQ5wM0zE0oGBu58OXYP48OrQox1MmurYCVXQK9sg
         +sW8T4M1Nzmtu2L3SUeShQUs981JjPj0lvLMAU6FelB6Lwy7vdnWWtVdc1ggBR8jMd
         0nYHSfNmfFJ7LYywBqgVOP71w2Xu7XRG1NJyDY2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/90] ARC: fix build warnings
Date:   Mon, 24 Jun 2019 17:56:20 +0800
Message-Id: <20190624092316.242626964@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 89c92142f75eb80064f5b9f1111484b1b4d81790 ]

| arch/arc/mm/tlb.c:914:2: warning: variable length array 'pd0' is used [-Wvla]
| arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not used [-Wunused-value]

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
index 4097764fea23..fa18c00b0cfd 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -911,9 +911,11 @@ void do_tlb_overlap_fault(unsigned long cause, unsigned long address,
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
 
@@ -921,9 +923,10 @@ void do_tlb_overlap_fault(unsigned long cause, unsigned long address,
 	for (set = 0; set < mmu->sets; set++) {
 
 		int is_valid, way;
+		unsigned int pd0[4];
 
 		/* read out all the ways of current set */
-		for (way = 0, is_valid = 0; way < mmu->ways; way++) {
+		for (way = 0, is_valid = 0; way < n_ways; way++) {
 			write_aux_reg(ARC_REG_TLBINDEX,
 					  SET_WAY_TO_IDX(mmu, set, way));
 			write_aux_reg(ARC_REG_TLBCOMMAND, TLBRead);
@@ -937,14 +940,14 @@ void do_tlb_overlap_fault(unsigned long cause, unsigned long address,
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



