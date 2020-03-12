Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E584718315D
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 14:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgCLN2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 09:28:19 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52198 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgCLN2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 09:28:19 -0400
Received: by mail-pj1-f67.google.com with SMTP id y7so2564954pjn.1
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 06:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ptL293kyj8nSFPX5gOhpUcpQg2dEQmzdIA3eipuwDzk=;
        b=IbGHOA3sWoTfAV58TcG7+E3AhEpW57IQvk9yDRbkbKZzcOJtB0wa8x3Hm/czySSKWR
         +0c+d+bJgiwcQv0Vi0altJNp/v5SBggifoTlJEkXWtE6X0yKlElTnVsvG4vjmvWajgEp
         Oj7x75h7o9LBho0fwgP5lYTdpMeSRmvFu4uf+7FvyB6GsEFyYE2DJ1U09c3o6EclbRRo
         FbL3VGvuZg0+AaEkiO2yYs9y6fc+9lLU8rd6CthyHuGdxFu6rNsJvo5imIbskHrzXVsQ
         AfdDE101+Ie7EbLNbOI5qa7kmktJb+8d1zQNyNgXJtK2SNPKiiOZjIh5uBFmnuZgOab7
         siTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ptL293kyj8nSFPX5gOhpUcpQg2dEQmzdIA3eipuwDzk=;
        b=PNjoUUE19USOfBDTLdiqGQD946L5CwfeyfmdLCej2tUrIjT+hpmjRPXHmG30PEP0JI
         Pj/1BnzptQyr5k7zSAjF2gYDqRaxvbD2mv8TLL0AnDuCb9W3DCp8OgS0zMo8q+zTkL4q
         oFP5BDZPiICVcksS6mEK5pectP6R3h3+s1HsQVuqXFg/dQksQLL5jYlySOUr7bny9Rq+
         O/n1zbaUcBbXaM4j/FAfcABIC0jHrd6YoBdWiKw7QzqfXKN4ag8Mb7dGcUXWdpLKoi0m
         h7KOOFcUYTUTLbKOktB/j3uE7ngC1GY72RylvSolPn05XzIVQg/dHRYaVY0FogpwA9h1
         7YTQ==
X-Gm-Message-State: ANhLgQ1mp4LycEXgZEaNtqsBzQHUo8vRTWkxxyLfqv63txsxDMHFy3ji
        CNibHxOyQg56FjHOtI0B3K/ELvuMt1Y=
X-Google-Smtp-Source: ADFU+vst0ubOJ3OTPrlmehYL5+WoIBd645gGraJhFqONxy/bybPJuO7k0PfDYSHJ3OEs6iZnWB7pOQ==
X-Received: by 2002:a17:90a:34c6:: with SMTP id m6mr4265443pjf.13.1584019696597;
        Thu, 12 Mar 2020 06:28:16 -0700 (PDT)
Received: from santosiv.in.ibm.com ([111.125.206.208])
        by smtp.gmail.com with ESMTPSA id w206sm13007435pfc.54.2020.03.12.06.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 06:28:15 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     <stable@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Greg KH <greg@kroah.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 3/6] asm-generic/tlb, arch: Invert CONFIG_HAVE_RCU_TABLE_INVALIDATE
Date:   Thu, 12 Mar 2020 18:57:37 +0530
Message-Id: <20200312132740.225241-4-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312132740.225241-1-santosh@fossix.org>
References: <20200312132740.225241-1-santosh@fossix.org>
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

