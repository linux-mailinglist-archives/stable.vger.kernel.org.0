Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9059BF54D2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbfKHSyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:54:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733145AbfKHSyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12CC5222D4;
        Fri,  8 Nov 2019 18:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239292;
        bh=XyDUF0kGkyKuyMkjd9zEvhyjfXTmEIEko1RtdM/HBec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMqlPIex7j95EDft48j6AkAPT5L4E7bLybGNruOzZtPM7I5ttfrmKjMk70BnbO7n3
         715xMNtYYvlW5oSO29YKCS2fFxMaadLS0EDFDgGbJX13orLWe65/+fGn3j1oorvrxn
         Y2ZucAWohSFhiy7JzOQSgsTG3fEY7hWBLxypXYDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julien Thierry <julien.thierry@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David A. Long" <dave.long@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 65/75] ARM: 8796/1: spectre-v1,v1.1: provide helpers for address sanitization
Date:   Fri,  8 Nov 2019 19:50:22 +0100
Message-Id: <20191108174806.118003985@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/assembler.h |   11 +++++++++++
 arch/arm/include/asm/uaccess.h   |   26 ++++++++++++++++++++++++++
 arch/arm/lib/copy_from_user.S    |    6 +-----
 3 files changed, 38 insertions(+), 5 deletions(-)

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
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -138,6 +138,32 @@ static inline void set_fs(mm_segment_t f
 	__typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 
 /*
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
+/*
  * Single-value transfer routines.  They automatically use the right
  * size if we just have the right pointer type.  Note that the functions
  * which read from user space (*get_*) need to take care not to leak
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


