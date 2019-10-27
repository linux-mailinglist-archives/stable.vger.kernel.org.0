Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08352E6636
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfJ0VJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbfJ0VJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:45 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E151F2064A;
        Sun, 27 Oct 2019 21:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210584;
        bh=uoJolbFr7OvIbu2blQ9jg1khCWXqzO03hk38WiCuQxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvygN+YW3rF832jJj2MHTR56ErBxPAQfHUsuBrPcbKpUhZz5uXSrH4Si1hcr4Fs2Y
         LD6p8Nen5BOTPZ0jB82voES6imX/CSzj1MBvIgy9Sje5DtcKA4xZ7xPLMk0XIZS0O4
         lmMwoyz4rqdeFMC7tSWSJ9lYVlGFIhXybjuGxywo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 067/119] arm64: Get rid of __smccc_workaround_1_hvc_*
Date:   Sun, 27 Oct 2019 22:00:44 +0100
Message-Id: <20191027203333.787221281@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit 22765f30dbaf1118c6ff0fcb8b99c9f2b4d396d5 ]

The very existence of __smccc_workaround_1_hvc_* is a thinko, as
KVM will never use a HVC call to perform the branch prediction
invalidation. Even as a nested hypervisor, it would use an SMC
instruction.

Let's get rid of it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/bpi.S        |   12 ++----------
 arch/arm64/kernel/cpu_errata.c |    9 +++------
 2 files changed, 5 insertions(+), 16 deletions(-)

--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -56,21 +56,13 @@ ENTRY(__bp_harden_hyp_vecs_start)
 ENTRY(__bp_harden_hyp_vecs_end)
 
 
-.macro smccc_workaround_1 inst
+ENTRY(__smccc_workaround_1_smc_start)
 	sub	sp, sp, #(8 * 4)
 	stp	x2, x3, [sp, #(8 * 0)]
 	stp	x0, x1, [sp, #(8 * 2)]
 	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
-	\inst	#0
+	smc	#0
 	ldp	x2, x3, [sp, #(8 * 0)]
 	ldp	x0, x1, [sp, #(8 * 2)]
 	add	sp, sp, #(8 * 4)
-.endm
-
-ENTRY(__smccc_workaround_1_smc_start)
-	smccc_workaround_1	smc
 ENTRY(__smccc_workaround_1_smc_end)
-
-ENTRY(__smccc_workaround_1_hvc_start)
-	smccc_workaround_1	hvc
-ENTRY(__smccc_workaround_1_hvc_end)
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -85,8 +85,6 @@ DEFINE_PER_CPU_READ_MOSTLY(struct bp_har
 #ifdef CONFIG_KVM
 extern char __smccc_workaround_1_smc_start[];
 extern char __smccc_workaround_1_smc_end[];
-extern char __smccc_workaround_1_hvc_start[];
-extern char __smccc_workaround_1_hvc_end[];
 
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
@@ -131,8 +129,6 @@ static void __install_bp_hardening_cb(bp
 #else
 #define __smccc_workaround_1_smc_start		NULL
 #define __smccc_workaround_1_smc_end		NULL
-#define __smccc_workaround_1_hvc_start		NULL
-#define __smccc_workaround_1_hvc_end		NULL
 
 static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 				      const char *hyp_vecs_start,
@@ -206,8 +202,9 @@ enable_smccc_arch_workaround_1(const str
 		if ((int)res.a0 < 0)
 			return;
 		cb = call_hvc_arch_workaround_1;
-		smccc_start = __smccc_workaround_1_hvc_start;
-		smccc_end = __smccc_workaround_1_hvc_end;
+		/* This is a guest, no need to patch KVM vectors */
+		smccc_start = NULL;
+		smccc_end = NULL;
 		break;
 
 	case PSCI_CONDUIT_SMC:


