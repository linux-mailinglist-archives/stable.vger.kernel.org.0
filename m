Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81875F4BD5
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfKHMg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHMgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:55 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E639224D7;
        Fri,  8 Nov 2019 12:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216615;
        bh=nNmyYFWblIAWRa2kPeefb4mmGEnJ+Eql14JXQEetbQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2j5seZnTyj6Olfv8QpHe0f4cD1oOIRvrle2M9DI/SE1nafOlZvAzQgY3thDbufRk
         PPJTYNPT/gG1I6fZRi5xlEb9TfWALycOehCsCPALfwt1jiPYTMtvtkhtQa+b6qYmhm
         hF9R7A1DTbbIXdmxCEO3ZRLghfi3AR43uzHjrGYw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 27/50] ARM: spectre-v1: add speculation barrier (csdb) macros
Date:   Fri,  8 Nov 2019 13:35:31 +0100
Message-Id: <20191108123554.29004-28-ardb@kernel.org>
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

Commit a78d156587931a2c3b354534aa772febf6c9e855 upstream.

Add assembly and C macros for the new CSDB instruction.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/assembler.h |  8 ++++++++
 arch/arm/include/asm/barrier.h   | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 4a275fba6059..307901f88a1e 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -441,6 +441,14 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 	.size \name , . - \name
 	.endm
 
+	.macro	csdb
+#ifdef CONFIG_THUMB2_KERNEL
+	.inst.w	0xf3af8014
+#else
+	.inst	0xe320f014
+#endif
+	.endm
+
 	.macro check_uaccess, addr:req, size:req, limit:req, tmp:req, bad:req
 #ifndef CONFIG_CPU_USE_DOMAINS
 	adds	\tmp, \addr, #\size - 1
diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index 27c1d26b05b5..edd9e633a84b 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -18,6 +18,12 @@
 #define isb(option) __asm__ __volatile__ ("isb " #option : : : "memory")
 #define dsb(option) __asm__ __volatile__ ("dsb " #option : : : "memory")
 #define dmb(option) __asm__ __volatile__ ("dmb " #option : : : "memory")
+#ifdef CONFIG_THUMB2_KERNEL
+#define CSDB	".inst.w 0xf3af8014"
+#else
+#define CSDB	".inst	0xe320f014"
+#endif
+#define csdb() __asm__ __volatile__(CSDB : : : "memory")
 #elif defined(CONFIG_CPU_XSC3) || __LINUX_ARM_ARCH__ == 6
 #define isb(x) __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
 				    : : "r" (0) : "memory")
@@ -38,6 +44,13 @@
 #define dmb(x) __asm__ __volatile__ ("" : : : "memory")
 #endif
 
+#ifndef CSDB
+#define CSDB
+#endif
+#ifndef csdb
+#define csdb()
+#endif
+
 #ifdef CONFIG_ARM_HEAVY_MB
 extern void (*soc_mb)(void);
 extern void arm_heavy_mb(void);
-- 
2.20.1

