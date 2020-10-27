Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CB029B990
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802597AbgJ0Pu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801356AbgJ0Pks (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:40:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B58A223B0;
        Tue, 27 Oct 2020 15:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813247;
        bh=bRa3DKGN75xJX+mpwXYHr6yuiZ8lIsqRuOaC0aBISJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVgLkYP1sON9wSG1fj39E4td7CtW3fEW2WbZaaBRjAwO4Kndi60ZlR5HtiwijbHCh
         CaOAiyQ9sq6ivkpkoUKpZ11td799rsGfa86IGVbm8K1soj56Lvy6wkKcrzIP2hZwKs
         NRps6lypjzUZlR0CJB/XXuHmPgJda26qyx0eTTo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 488/757] powerpc/security: Fix link stack flush instruction
Date:   Tue, 27 Oct 2020 14:52:18 +0100
Message-Id: <20201027135513.364884497@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 792254a77201453d9a77479e63dc216ad90462d2 ]

The inline execution path for the hardware assisted branch flush
instruction failed to set CTR to the correct value before bcctr,
causing a crash when the feature is enabled.

Fixes: 4d24e21cc694 ("powerpc/security: Allow for processors that flush the link stack using the special bcctr")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201007080605.64423-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/asm-prototypes.h |  4 ++-
 arch/powerpc/kernel/entry_64.S            |  8 ++++--
 arch/powerpc/kernel/security.c            | 34 ++++++++++++++++-------
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/include/asm/asm-prototypes.h b/arch/powerpc/include/asm/asm-prototypes.h
index de14b1a34d568..9652756b0694c 100644
--- a/arch/powerpc/include/asm/asm-prototypes.h
+++ b/arch/powerpc/include/asm/asm-prototypes.h
@@ -144,7 +144,9 @@ void _kvmppc_restore_tm_pr(struct kvm_vcpu *vcpu, u64 guest_msr);
 void _kvmppc_save_tm_pr(struct kvm_vcpu *vcpu, u64 guest_msr);
 
 /* Patch sites */
-extern s32 patch__call_flush_branch_caches;
+extern s32 patch__call_flush_branch_caches1;
+extern s32 patch__call_flush_branch_caches2;
+extern s32 patch__call_flush_branch_caches3;
 extern s32 patch__flush_count_cache_return;
 extern s32 patch__flush_link_stack_return;
 extern s32 patch__call_kvm_flush_link_stack;
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 733e40eba4ebe..2f3846192ec7d 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -430,7 +430,11 @@ _ASM_NOKPROBE_SYMBOL(save_nvgprs);
 
 #define FLUSH_COUNT_CACHE	\
 1:	nop;			\
-	patch_site 1b, patch__call_flush_branch_caches
+	patch_site 1b, patch__call_flush_branch_caches1; \
+1:	nop;			\
+	patch_site 1b, patch__call_flush_branch_caches2; \
+1:	nop;			\
+	patch_site 1b, patch__call_flush_branch_caches3
 
 .macro nops number
 	.rept \number
@@ -512,7 +516,7 @@ _GLOBAL(_switch)
 
 	kuap_check_amr r9, r10
 
-	FLUSH_COUNT_CACHE
+	FLUSH_COUNT_CACHE	/* Clobbers r9, ctr */
 
 	/*
 	 * On SMP kernels, care must be taken because a task may be
diff --git a/arch/powerpc/kernel/security.c b/arch/powerpc/kernel/security.c
index c9876aab31421..e4e1a94ccf6a6 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -430,30 +430,44 @@ device_initcall(stf_barrier_debugfs_init);
 
 static void update_branch_cache_flush(void)
 {
+	u32 *site;
+
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	site = &patch__call_kvm_flush_link_stack;
 	// This controls the branch from guest_exit_cont to kvm_flush_link_stack
 	if (link_stack_flush_type == BRANCH_CACHE_FLUSH_NONE) {
-		patch_instruction_site(&patch__call_kvm_flush_link_stack,
-				       ppc_inst(PPC_INST_NOP));
+		patch_instruction_site(site, ppc_inst(PPC_INST_NOP));
 	} else {
 		// Could use HW flush, but that could also flush count cache
-		patch_branch_site(&patch__call_kvm_flush_link_stack,
-				  (u64)&kvm_flush_link_stack, BRANCH_SET_LINK);
+		patch_branch_site(site, (u64)&kvm_flush_link_stack, BRANCH_SET_LINK);
 	}
 #endif
 
+	// Patch out the bcctr first, then nop the rest
+	site = &patch__call_flush_branch_caches3;
+	patch_instruction_site(site, ppc_inst(PPC_INST_NOP));
+	site = &patch__call_flush_branch_caches2;
+	patch_instruction_site(site, ppc_inst(PPC_INST_NOP));
+	site = &patch__call_flush_branch_caches1;
+	patch_instruction_site(site, ppc_inst(PPC_INST_NOP));
+
 	// This controls the branch from _switch to flush_branch_caches
 	if (count_cache_flush_type == BRANCH_CACHE_FLUSH_NONE &&
 	    link_stack_flush_type == BRANCH_CACHE_FLUSH_NONE) {
-		patch_instruction_site(&patch__call_flush_branch_caches,
-				       ppc_inst(PPC_INST_NOP));
+		// Nothing to be done
+
 	} else if (count_cache_flush_type == BRANCH_CACHE_FLUSH_HW &&
 		   link_stack_flush_type == BRANCH_CACHE_FLUSH_HW) {
-		patch_instruction_site(&patch__call_flush_branch_caches,
-				       ppc_inst(PPC_INST_BCCTR_FLUSH));
+		// Patch in the bcctr last
+		site = &patch__call_flush_branch_caches1;
+		patch_instruction_site(site, ppc_inst(0x39207fff)); // li r9,0x7fff
+		site = &patch__call_flush_branch_caches2;
+		patch_instruction_site(site, ppc_inst(0x7d2903a6)); // mtctr r9
+		site = &patch__call_flush_branch_caches3;
+		patch_instruction_site(site, ppc_inst(PPC_INST_BCCTR_FLUSH));
+
 	} else {
-		patch_branch_site(&patch__call_flush_branch_caches,
-				  (u64)&flush_branch_caches, BRANCH_SET_LINK);
+		patch_branch_site(site, (u64)&flush_branch_caches, BRANCH_SET_LINK);
 
 		// If we just need to flush the link stack, early return
 		if (count_cache_flush_type == BRANCH_CACHE_FLUSH_NONE) {
-- 
2.25.1



