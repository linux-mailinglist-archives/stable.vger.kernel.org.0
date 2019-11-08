Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7C5F4BEA
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfKHMhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:37:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfKHMhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:37:20 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC6A4224BD;
        Fri,  8 Nov 2019 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216639;
        bh=Ki9aEnDnL+qAauiZl1KpmDrg7BIFs2cclw7Id7tdNAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=la4Flkp4Io9K46Z18LFXB/z+SHy7g6hRH9REYL0DubetFcoHeajRV+ccz+J2wP4h0
         0pqzEy4WRrhbXAMnYUvORUFYNlGTR6N9m2ZnX47pDX/G4fNCBi31C3fEktRukTmwxR
         WSFlb7jxykSo/zaVBDT/Qg95th3rQm5k46LDBY1A=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Julien Thierry <julien.thierry@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 42/50] ARM: 8796/1: spectre-v1,v1.1: provide helpers for address sanitization
Date:   Fri,  8 Nov 2019 13:35:46 +0100
Message-Id: <20191108123554.29004-43-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit afaf6838f4bc896a711180b702b388b8cfa638fc upstream.

Introduce C and asm helpers to sanitize user address, taking the
address range they target into account.

Use asm helper for existing sanitization in __copy_from_user().

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/assembler.h | 11 +++++++++
 arch/arm/include/asm/uaccess.h   | 26 ++++++++++++++++++++
 arch/arm/lib/copy_from_user.S    |  6 +----
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 483481c6937e..f2624fbd0336 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -461,6 +461,17 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 #endif
 	.endm
 
+	.macro uaccess_mask_range_ptr, addr:req, size:req, limit:req, tmp:req
+#ifdef CONFIG_CPU_SPECTRE
+	sub	\tmp, \limit, #1
+	subs	\tmp, \tmp, \addr	@ tmp = limit - 1 - addr
+	addhs	\tmp, \tmp, #1		@ if (tmp >= 0) {
+	subhss	\tmp, \tmp, \size	@ tmp = limit - (addr + size) }
+	movlo	\addr, #0		@ if (tmp < 0) addr = NULL
+	csdb
+#endif
+	.endm
+
 	.macro	uaccess_disable, tmp, isb=1
 #ifdef CONFIG_CPU_SW_DOMAIN_PAN
 	/*
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 98bbf89763a6..9ae610bf5234 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -137,6 +137,32 @@ static inline void set_fs(mm_segment_t fs)
 #define __inttype(x) \
 	__typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 
+/*
+ * Sanitise a uaccess pointer such that it becomes NULL if addr+size
+ * is above the current addr_limit.
+ */
+#define uaccess_mask_range_ptr(ptr, size)			\
+	((__typeof__(ptr))__uaccess_mask_range_ptr(ptr, size))
+static inline void __user *__uaccess_mask_range_ptr(const void __user *ptr,
+						    size_t size)
+{
+	void __user *safe_ptr = (void __user *)ptr;
+	unsigned long tmp;
+
+	asm volatile(
+	"	sub	%1, %3, #1\n"
+	"	subs	%1, %1, %0\n"
+	"	addhs	%1, %1, #1\n"
+	"	subhss	%1, %1, %2\n"
+	"	movlo	%0, #0\n"
+	: "+r" (safe_ptr), "=&r" (tmp)
+	: "r" (size), "r" (current_thread_info()->addr_limit)
+	: "cc");
+
+	csdb();
+	return safe_ptr;
+}
+
 /*
  * Single-value transfer routines.  They automatically use the right
  * size if we just have the right pointer type.  Note that the functions
diff --git a/arch/arm/lib/copy_from_user.S b/arch/arm/lib/copy_from_user.S
index d36329cefedc..e32b51838439 100644
--- a/arch/arm/lib/copy_from_user.S
+++ b/arch/arm/lib/copy_from_user.S
@@ -93,11 +93,7 @@ ENTRY(arm_copy_from_user)
 #ifdef CONFIG_CPU_SPECTRE
 	get_thread_info r3
 	ldr	r3, [r3, #TI_ADDR_LIMIT]
-	adds	ip, r1, r2	@ ip=addr+size
-	sub	r3, r3, #1	@ addr_limit - 1
-	cmpcc	ip, r3		@ if (addr+size > addr_limit - 1)
-	movcs	r1, #0		@ addr = NULL
-	csdb
+	uaccess_mask_range_ptr r1, r2, r3, ip
 #endif
 
 #include "copy_template.S"
-- 
2.20.1

