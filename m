Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DF6F4BCE
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfKHMgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfKHMgp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:45 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D44BF22459;
        Fri,  8 Nov 2019 12:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216604;
        bh=YzCMi3TeHCcH+wqR5ebGb0LtimXEmBMuwB8Q0EiuJjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCB4KTxv91NKWErKkpfqmwkzqp+qa8nRH5yYOIIRyX7+wOJy7tf6/e/z2tFFdD0Gk
         S5ED2/j3ajfVrwCYauUFzenAFpdrziBYqhNebFxTduDvCHDZ61kSUVLBJMR3TAOsN9
         QGlrTwG/Iild3TK2HKdcZPKyhdz8GnfQnVCXsPnQ=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 20/50] ARM: bugs: add support for per-processor bug checking
Date:   Fri,  8 Nov 2019 13:35:24 +0100
Message-Id: <20191108123554.29004-21-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 9d3a04925deeabb97c8e26d940b501a2873e8af3 upstream.

Add support for per-processor bug checking - each processor function
descriptor gains a function pointer for this check, which must not be
an __init function.  If non-NULL, this will be called whenever a CPU
enters the kernel via which ever path (boot CPU, secondary CPU startup,
CPU resuming, etc.)

This allows processor specific bug checks to validate that workaround
bits are properly enabled by firmware via all entry paths to the kernel.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/proc-fns.h | 4 ++++
 arch/arm/kernel/bugs.c          | 4 ++++
 arch/arm/mm/proc-macros.S       | 3 ++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index 8877ad5ffe10..f379f5f849a9 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -36,6 +36,10 @@ extern struct processor {
 	 * Set up any processor specifics
 	 */
 	void (*_proc_init)(void);
+	/*
+	 * Check for processor bugs
+	 */
+	void (*check_bugs)(void);
 	/*
 	 * Disable any processor specifics
 	 */
diff --git a/arch/arm/kernel/bugs.c b/arch/arm/kernel/bugs.c
index 16e7ba2a9cc4..7be511310191 100644
--- a/arch/arm/kernel/bugs.c
+++ b/arch/arm/kernel/bugs.c
@@ -5,6 +5,10 @@
 
 void check_other_bugs(void)
 {
+#ifdef MULTI_CPU
+	if (processor.check_bugs)
+		processor.check_bugs();
+#endif
 }
 
 void __init check_bugs(void)
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index c671f345266a..212147c78f4b 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -258,13 +258,14 @@
 	mcr	p15, 0, ip, c7, c10, 4		@ data write barrier
 	.endm
 
-.macro define_processor_functions name:req, dabort:req, pabort:req, nommu=0, suspend=0
+.macro define_processor_functions name:req, dabort:req, pabort:req, nommu=0, suspend=0, bugs=0
 	.type	\name\()_processor_functions, #object
 	.align 2
 ENTRY(\name\()_processor_functions)
 	.word	\dabort
 	.word	\pabort
 	.word	cpu_\name\()_proc_init
+	.word	\bugs
 	.word	cpu_\name\()_proc_fin
 	.word	cpu_\name\()_reset
 	.word	cpu_\name\()_do_idle
-- 
2.20.1

