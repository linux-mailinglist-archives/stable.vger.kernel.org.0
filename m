Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9538A3A84A2
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhFOPvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231971AbhFOPvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AAAA6162D;
        Tue, 15 Jun 2021 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772145;
        bh=v1Shj5F8hMUeW+OTytwhZYkO9DtqxbdNhawBkXHVLsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5X//9F7EIhsrUNE8dGGofy+HZbg2lfKAZh2WypH2x60l9Ag+Lix0z1FaIphbPTrA
         4kYrUwrKr6ikoUAKodAFQT+M3h6fZ06jn9nKtr/cE0uZJAXPniqUTqnVCtlDyEy6qx
         leVA5R2kp86BqyC1vFtq/llNGS7j+CczS1Q48h2IkmGM2sNCFoocxdry+T30Akqs9n
         GLpGJQ+MuLtsGMPHinB0S2yMkJZ+hRn+uFx/6qxPHL5/LWNpy/1JoSMRow3CIgYAGI
         mholXh8Udw018Y8P9HtFN0z2qkz44+iSWBDXckZE1eDZ6VZ1MbPFIGHDlo2jKYi16N
         u/T0k8DbtZC/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 32/33] riscv: code patching only works on !XIP_KERNEL
Date:   Tue, 15 Jun 2021 11:48:23 -0400
Message-Id: <20210615154824.62044-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 42e0e0b453bc6ead49c573ed512502069627546b ]

Some features which need code patching such as KPROBES, DYNAMIC_FTRACE
KGDB can only work on !XIP_KERNEL. Add dependencies for these features
that rely on code patching.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d9522fc35ca5..4f116be9152f 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -54,11 +54,11 @@ config RISCV
 	select GENERIC_TIME_VSYSCALL if MMU && 64BIT
 	select HANDLE_DOMAIN_IRQ
 	select HAVE_ARCH_AUDITSYSCALL
-	select HAVE_ARCH_JUMP_LABEL
-	select HAVE_ARCH_JUMP_LABEL_RELATIVE
+	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
+	select HAVE_ARCH_JUMP_LABEL_RELATIVE if !XIP_KERNEL
 	select HAVE_ARCH_KASAN if MMU && 64BIT
 	select HAVE_ARCH_KASAN_VMALLOC if MMU && 64BIT
-	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_KGDB if !XIP_KERNEL
 	select HAVE_ARCH_KGDB_QXFER_PKT
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
 	select HAVE_ARCH_SECCOMP_FILTER
@@ -73,9 +73,9 @@ config RISCV
 	select HAVE_GCC_PLUGINS
 	select HAVE_GENERIC_VDSO if MMU && 64BIT
 	select HAVE_IRQ_TIME_ACCOUNTING
-	select HAVE_KPROBES
-	select HAVE_KPROBES_ON_FTRACE
-	select HAVE_KRETPROBES
+	select HAVE_KPROBES if !XIP_KERNEL
+	select HAVE_KPROBES_ON_FTRACE if !XIP_KERNEL
+	select HAVE_KRETPROBES if !XIP_KERNEL
 	select HAVE_PCI
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
@@ -227,11 +227,11 @@ config ARCH_RV64I
 	bool "RV64I"
 	select 64BIT
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && GCC_VERSION >= 50000
-	select HAVE_DYNAMIC_FTRACE if MMU && $(cc-option,-fpatchable-function-entry=8)
+	select HAVE_DYNAMIC_FTRACE if !XIP_KERNEL && MMU && $(cc-option,-fpatchable-function-entry=8)
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS if HAVE_DYNAMIC_FTRACE
-	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
 	select HAVE_FUNCTION_GRAPH_TRACER
-	select HAVE_FUNCTION_TRACER
+	select HAVE_FUNCTION_TRACER if !XIP_KERNEL
 	select SWIOTLB if MMU
 
 endchoice
-- 
2.30.2

