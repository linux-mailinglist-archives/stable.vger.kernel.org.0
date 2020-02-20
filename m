Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3185C165972
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 09:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgBTIm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 03:42:59 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36242 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgBTIm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 03:42:59 -0500
Received: by mail-pj1-f65.google.com with SMTP id gv17so590059pjb.1
        for <stable@vger.kernel.org>; Thu, 20 Feb 2020 00:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KdtaFxthx9iPhMy2ohqJEjecxLIYoVpCS0yLmibZvXc=;
        b=mTuKSMlbPFszQ14d5AgKPCo+WUJ0YHH0WsbNSjuABFi+XLZgfCCBbPkOo/TIF4gjj4
         Xw7c/CqokrMwShyKYrbfZaocT+7Qt/l8d28W2U4+OFZfAoxoaqUmfd2yz/24lHHvCMSF
         MVv/bS3og/yJZzykjvUloUzpPgb9xM+AbQz5NI1LUgPnZ6eMa0nf/TRmylENBqnRha+q
         nBoZAhNu2B4byI6WdnHSQLRhRsADqk2TUUOq1zxTJTbb+uW8L/jrLlxt1k9lAG3ambGF
         Nr7cyLVftabUMKJ5XNU5b0t6YvONlrTFuehgoxqfku0F6DtBiiKdPVDnsCa/LtplaKpr
         tSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KdtaFxthx9iPhMy2ohqJEjecxLIYoVpCS0yLmibZvXc=;
        b=i0ukYwIy4L9KB3/4BGZFT8DBj2Tc2pfIr5FBWdCFaRnjW/CjNjsnOSXUqVt5AqB+NG
         vq8RywpAU0/mA7JZ8TA1Sh4QzD+EqZwlblTIB9/Z0y55fUJ91QO1+4if2dNkE28eTdUd
         ZU482Rff+50ngX+BZz8IJVzY4n+648Y5FjXdtCrBVSf26E4rOAE6vDZSj4jbHrS/Vwi/
         Ca5nDkN/vUeeN0h2dbJ5HBhyE0ORGaQbo7THmkduW5cbuno4svSGSwRVWf3YdR8mrzse
         Y5VMCYSAeUkNFYSglE390nVxm2WnEKxirRs0f6hwAAY1LmUT0H4oLSbEtEaE/3VQ+UAs
         rC+g==
X-Gm-Message-State: APjAAAUhS1gi+3GkJ0UvBm2voJlOCXUTG/AlF3LAe8YjUhOwCR7umTuy
        2vb1hJGr3fWuXQYZzkJ9d7X/WwvlOvE=
X-Google-Smtp-Source: APXvYqxxv4P1zh1mlDcMgKRuHqpQ9iLMyyz2sNat/BgPLJBDjHqALw9sfFBIwcIqHzFsnAsH+i80JQ==
X-Received: by 2002:a17:902:161:: with SMTP id 88mr30989554plb.129.1582188178735;
        Thu, 20 Feb 2020 00:42:58 -0800 (PST)
Received: from santosiv.in.ibm.com ([129.41.84.72])
        by smtp.gmail.com with ESMTPSA id r145sm2512381pfr.5.2020.02.20.00.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 00:42:58 -0800 (PST)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org
Cc:     peterz@infradead.org, aneesh.kumar@linux.ibm.com,
        akshay.adiga@linux.ibm.com, gregkh@linuxfoundation.org
Subject: [PATCH 3/6] asm-generic/tlb, arch: Invert CONFIG_HAVE_RCU_TABLE_INVALIDATE
Date:   Thu, 20 Feb 2020 14:12:26 +0530
Message-Id: <20200220084229.1278137-4-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220084229.1278137-1-santosh@fossix.org>
References: <20200220084229.1278137-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Make issuing a TLB invalidate for page-table pages the normal case.

The reason is twofold:

 - too many invalidates is safer than too few,
 - most architectures use the linux page-tables natively
   and would thus require this.

Make it an opt-out, instead of an opt-in.

No change in behavior intended.

96bc9567cbe1 in upstream.

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
index a80669209155..f7f046ff6407 100644
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

