Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766E32BA863
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgKTLH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:07:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728533AbgKTLHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11C5F206E3;
        Fri, 20 Nov 2020 11:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870443;
        bh=Zx6LwWrX+yP0uTz1SGQQB1VW0hkPewD97l1Zy0kYuro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7MiTGwS0kaBJpwksNDoWdqGnOzvULby7nRCD06a++P6gnrkhx5NyJkJgXm+5GlaI
         LaVIPZe86nvz+9zNhPndQcaDviPZFixsdJvL2X5tyrrcAjZsUdweaQ/164JRy1s45h
         7LR+YpIBNayZguBdhzi7+RzOTfC1WlxkrLPYzlis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 04/17] powerpc: Only include kup-radix.h for 64-bit Book3S
Date:   Fri, 20 Nov 2020 12:03:31 +0100
Message-Id: <20201120104541.287600992@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.058449969@linuxfoundation.org>
References: <20201120104541.058449969@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 178d52c6e89c38d0553b0ac8b99927b11eb995b0 upstream.

In kup.h we currently include kup-radix.h for all 64-bit builds, which
includes Book3S and Book3E. The latter doesn't make sense, Book3E
never uses the Radix MMU.

This has worked up until now, but almost by accident, and the recent
uaccess flush changes introduced a build breakage on Book3E because of
the bad structure of the code.

So disentangle things so that we only use kup-radix.h for Book3S. This
requires some more stubs in kup.h.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/book3s/64/kup-radix.h |    5 +++--
 arch/powerpc/include/asm/kup.h                 |   14 +++++++++++---
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -11,13 +11,12 @@
 
 #ifdef __ASSEMBLY__
 
-.macro kuap_restore_amr	gpr
 #ifdef CONFIG_PPC_KUAP
+.macro kuap_restore_amr	gpr
 	BEGIN_MMU_FTR_SECTION_NESTED(67)
 	ld	\gpr, STACK_REGS_KUAP(r1)
 	mtspr	SPRN_AMR, \gpr
 	END_MMU_FTR_SECTION_NESTED_IFSET(MMU_FTR_RADIX_KUAP, 67)
-#endif
 .endm
 
 .macro kuap_check_amr gpr1, gpr2
@@ -31,6 +30,7 @@
 	END_MMU_FTR_SECTION_NESTED_IFSET(MMU_FTR_RADIX_KUAP, 67)
 #endif
 .endm
+#endif
 
 .macro kuap_save_amr_and_lock gpr1, gpr2, use_cr, msr_pr_cr
 #ifdef CONFIG_PPC_KUAP
@@ -87,6 +87,7 @@ bad_kuap_fault(struct pt_regs *regs, uns
 		    "Bug: %s fault blocked by AMR!", is_write ? "Write" : "Read");
 }
 #else /* CONFIG_PPC_KUAP */
+static inline void kuap_restore_amr(struct pt_regs *regs, unsigned long amr) { }
 static inline void set_kuap(unsigned long value) { }
 #endif /* !CONFIG_PPC_KUAP */
 
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -6,7 +6,7 @@
 #define KUAP_WRITE	2
 #define KUAP_READ_WRITE	(KUAP_READ | KUAP_WRITE)
 
-#ifdef CONFIG_PPC64
+#ifdef CONFIG_PPC_BOOK3S_64
 #include <asm/book3s/64/kup-radix.h>
 #endif
 #ifdef CONFIG_PPC_8xx
@@ -24,9 +24,15 @@
 .macro kuap_restore	sp, current, gpr1, gpr2, gpr3
 .endm
 
+.macro kuap_restore_amr gpr
+.endm
+
 .macro kuap_check	current, gpr
 .endm
 
+.macro kuap_check_amr	gpr1, gpr2
+.endm
+
 #endif
 
 #else /* !__ASSEMBLY__ */
@@ -52,17 +58,19 @@ bad_kuap_fault(struct pt_regs *regs, uns
 	return false;
 }
 
+static inline void kuap_check_amr(void) { }
+
 /*
  * book3s/64/kup-radix.h defines these functions for the !KUAP case to flush
  * the L1D cache after user accesses. Only include the empty stubs for other
  * platforms.
  */
-#ifndef CONFIG_PPC64
+#ifndef CONFIG_PPC_BOOK3S_64
 static inline void allow_user_access(void __user *to, const void __user *from,
 				     unsigned long size, unsigned long dir) { }
 static inline void prevent_user_access(void __user *to, const void __user *from,
 				       unsigned long size, unsigned long dir) { }
-#endif /* CONFIG_PPC64 */
+#endif /* CONFIG_PPC_BOOK3S_64 */
 #endif /* CONFIG_PPC_KUAP */
 
 static inline void allow_read_from_user(const void __user *from, unsigned long size)


