Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE86178990
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 05:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgCDEa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 23:30:57 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33669 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCDEa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 23:30:57 -0500
Received: by mail-pg1-f196.google.com with SMTP id m5so377025pgg.0
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 20:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ptL293kyj8nSFPX5gOhpUcpQg2dEQmzdIA3eipuwDzk=;
        b=xldfMIVwMTRiVIGsJBkPipvxiCBcAgjKGtIWV8qBIZ86fq4JX4f2s5vSCj5UUXTT16
         PxdftiUxvdNBAfCZvcQFEG6TkROR5vvHNfTMpsqjfGFxLEWOzdVF56qSd+tii/4N22vS
         ozTUC8jp1vyCTUIIC1/4TYfmDWPhaMwuFKIor9iGNo/gGQZJbp+HSYyaWtlt5Op5jM8w
         tF2xrUHtucZEqNbuE2f921WARWfh0P2oKCICfsOU6reH8I+FyCdV1u+5Jq7IkhYWXIpN
         PDYI20uZBRdxgLLpJOxWn1dXfcFccZ83ZJkYr3p0J2kgXPJk833yN+y31nygv3ZMnf0D
         /8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ptL293kyj8nSFPX5gOhpUcpQg2dEQmzdIA3eipuwDzk=;
        b=DFAGo/EFeqO1syqBbTzO5lNCUCUPBV6PMR3BgIBcMKk64LtYvGErhW+TBq1qHxsFaW
         aEBzquDowIyxgL4+KuyWLNE076lWBo2sGUOItZpLI75VTlkiDfjTWIrhgmqeJ05WdWME
         RYB+OFkAe/dZYwOuhcls0bkEk8y1nqhoH52mgz0cH2xNQhX0Oka7QMdxkZ1/ZU7tn8aE
         0zDPMXTJv1bQaKVvanSLlK7pqaPORSuzrkn6OlPh8jqY7kZzwKSN22fYONwzWaQFQKiS
         OWl9/pTrdGEHXOcSV2SobVZAWv13QeXMvw/W2U3ZVC5jmZA2a4IuJ3kDsOD29Wnb0Uc6
         TTDQ==
X-Gm-Message-State: ANhLgQ2y+mHDzxFWZGpDU/rTE4pv8C1DPcqWw8ihSd2Gav7TI73UuT3J
        I2QfRY83T90y9uJo4BAPOw+i7gjKhnU=
X-Google-Smtp-Source: ADFU+vu/Npn7wVC76jxDWY2ire3Tfc65thCZW/QcLExjy57CopTWa0hAoW2Dy1KKS0bOhAr/JKpwFQ==
X-Received: by 2002:a65:5283:: with SMTP id y3mr843361pgp.370.1583296254544;
        Tue, 03 Mar 2020 20:30:54 -0800 (PST)
Received: from santosiv.in.ibm.com ([2401:4900:16ee:7b5f:eac:4364:ff14:3aaa])
        by smtp.gmail.com with ESMTPSA id y193sm10775723pfg.162.2020.03.03.20.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 20:30:53 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2 3/6] asm-generic/tlb, arch: Invert CONFIG_HAVE_RCU_TABLE_INVALIDATE
Date:   Wed,  4 Mar 2020 10:00:25 +0530
Message-Id: <20200304043028.280136-4-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304043028.280136-1-santosh@fossix.org>
References: <20200304043028.280136-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 96bc9567cbe112e9320250f01b9c060c882e8619 upstream.

Make issuing a TLB invalidate for page-table pages the normal case.

The reason is twofold:

 - too many invalidates is safer than too few,
 - most architectures use the linux page-tables natively
   and would thus require this.

Make it an opt-out, instead of an opt-in.

No change in behavior intended.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
[santosh: prerequisite for upcoming tlbflush backports]
---
 arch/Kconfig         | 2 +-
 arch/powerpc/Kconfig | 1 +
 arch/sparc/Kconfig   | 1 +
 arch/x86/Kconfig     | 1 -
 mm/memory.c          | 2 +-
 5 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index a336548487e6..061a12b8140e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -363,7 +363,7 @@ config HAVE_ARCH_JUMP_LABEL
 config HAVE_RCU_TABLE_FREE
 	bool
 
-config HAVE_RCU_TABLE_INVALIDATE
+config HAVE_RCU_TABLE_NO_INVALIDATE
 	bool
 
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6f475dc5829b..e09cfb109b8c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -216,6 +216,7 @@ config PPC
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_RCU_TABLE_FREE		if SMP
+	select HAVE_RCU_TABLE_NO_INVALIDATE	if HAVE_RCU_TABLE_FREE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if PPC64 && CPU_LITTLE_ENDIAN
 	select HAVE_SYSCALL_TRACEPOINTS
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e6f2a38d2e61..d90d632868aa 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -64,6 +64,7 @@ config SPARC64
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
 	select HAVE_RCU_TABLE_FREE if SMP
+	select HAVE_RCU_TABLE_NO_INVALIDATE if HAVE_RCU_TABLE_FREE
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_DYNAMIC_FTRACE
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index af35f5caadbe..181d0d522977 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -181,7 +181,6 @@ config X86
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_RCU_TABLE_FREE		if PARAVIRT
-	select HAVE_RCU_TABLE_INVALIDATE	if HAVE_RCU_TABLE_FREE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if X86_64 && (UNWINDER_FRAME_POINTER || UNWINDER_ORC) && STACK_VALIDATION
 	select HAVE_STACKPROTECTOR		if CC_HAS_SANE_STACKPROTECTOR
diff --git a/mm/memory.c b/mm/memory.c
index 1832c5ed6ac0..ba5689610c04 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -327,7 +327,7 @@ bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_
  */
 static inline void tlb_table_invalidate(struct mmu_gather *tlb)
 {
-#ifdef CONFIG_HAVE_RCU_TABLE_INVALIDATE
+#ifndef CONFIG_HAVE_RCU_TABLE_NO_INVALIDATE
 	/*
 	 * Invalidate page-table caches used by hardware walkers. Then we still
 	 * need to RCU-sched wait while freeing the pages because software
-- 
2.24.1

