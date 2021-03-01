Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC038328BE0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbhCASlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:41:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239978AbhCASgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:36:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D41A465195;
        Mon,  1 Mar 2021 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618683;
        bh=/PPzW02UOMuKrTS27AFKolO34jLr6kzefiL5QelMfbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQCoXxjaMl62QXMnqpQPGHKzw/ZFCBet4f4TDIj8U+sFq0wp2xZzbNvERj7my+d1B
         kVeRfkmF9xY75RSAGEMcXVA0V2y4vS9qW2Ki0QOa8bn0hqjrGRxZnE/6n46C4tbhX0
         7EtFJdYNvzvMQgzhNgN5/gv9BYVcIzC+0ZLXMFqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/663] MIPS: properly stop .eh_frame generation
Date:   Mon,  1 Mar 2021 17:07:07 +0100
Message-Id: <20210301161150.630750167@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit 894ef530012fb5078466efdfb2c15d8b2f1565cd ]

Commit 866b6a89c6d1 ("MIPS: Add DWARF unwinding to assembly") added
-fno-asynchronous-unwind-tables to KBUILD_CFLAGS to prevent compiler
from emitting .eh_frame symbols.
However, as MIPS heavily uses CFI, that's not enough. Use the
approach taken for x86 (as it also uses CFI) and explicitly put CFI
symbols into the .debug_frame section (except for VDSO).
This allows us to drop .eh_frame from DISCARDS as it's no longer
being generated.

Fixes: 866b6a89c6d1 ("MIPS: Add DWARF unwinding to assembly")
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/asm.h    | 18 ++++++++++++++++++
 arch/mips/kernel/vmlinux.lds.S |  1 -
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/asm.h b/arch/mips/include/asm/asm.h
index 3682d1a0bb808..ea4b62ece3366 100644
--- a/arch/mips/include/asm/asm.h
+++ b/arch/mips/include/asm/asm.h
@@ -20,10 +20,27 @@
 #include <asm/sgidefs.h>
 #include <asm/asm-eva.h>
 
+#ifndef __VDSO__
+/*
+ * Emit CFI data in .debug_frame sections, not .eh_frame sections.
+ * We don't do DWARF unwinding at runtime, so only the offline DWARF
+ * information is useful to anyone. Note we should change this if we
+ * ever decide to enable DWARF unwinding at runtime.
+ */
+#define CFI_SECTIONS	.cfi_sections .debug_frame
+#else
+ /*
+  * For the vDSO, emit both runtime unwind information and debug
+  * symbols for the .dbg file.
+  */
+#define CFI_SECTIONS
+#endif
+
 /*
  * LEAF - declare leaf routine
  */
 #define LEAF(symbol)					\
+		CFI_SECTIONS;				\
 		.globl	symbol;				\
 		.align	2;				\
 		.type	symbol, @function;		\
@@ -36,6 +53,7 @@ symbol:		.frame	sp, 0, ra;			\
  * NESTED - declare nested routine entry point
  */
 #define NESTED(symbol, framesize, rpc)			\
+		CFI_SECTIONS;				\
 		.globl	symbol;				\
 		.align	2;				\
 		.type	symbol, @function;		\
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 83e27a181206a..09fa4705ce8eb 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -224,6 +224,5 @@ SECTIONS
 		*(.options)
 		*(.pdr)
 		*(.reginfo)
-		*(.eh_frame)
 	}
 }
-- 
2.27.0



