Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC229F5785
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388666AbfKHTXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732884AbfKHSyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C61C42178F;
        Fri,  8 Nov 2019 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239249;
        bh=SiRX2WcJEqeeFkGkg/ORrfHEGEouVfa+skK4XZUnyiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5nalBcmpyZwlIK7cnwrxXVUfv5z0vNrvQHN4gragwF/ZVpgRfQiXO+GD/srdizzT
         Sh7N08G/EExB+N4EQUj0gQ6CKBJxTANoQITvF1/uHaVyDk3yC1TFMyfrzERUdfpU9V
         OzVHP11cYjx9drEbM+CiCAiqvsRCUuT7mQRbJoN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk, Ard Biesheuvel" 
        <ardb@kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        "David A. Long" <dave.long@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 51/75] ARM: spectre-v1: add array_index_mask_nospec() implementation
Date:   Fri,  8 Nov 2019 19:50:08 +0100
Message-Id: <20191108174754.520254735@linuxfoundation.org>
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

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 1d4238c56f9816ce0f9c8dbe42d7f2ad81cb6613 upstream.

Add an implementation of the array_index_mask_nospec() function for
mitigating Spectre variant 1 throughout the kernel.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/barrier.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -108,5 +108,26 @@ do {									\
 #define smp_mb__before_atomic()	smp_mb()
 #define smp_mb__after_atomic()	smp_mb()
 
+#ifdef CONFIG_CPU_SPECTRE
+static inline unsigned long array_index_mask_nospec(unsigned long idx,
+						    unsigned long sz)
+{
+	unsigned long mask;
+
+	asm volatile(
+		"cmp	%1, %2\n"
+	"	sbc	%0, %1, %1\n"
+	CSDB
+	: "=r" (mask)
+	: "r" (idx), "Ir" (sz)
+	: "cc");
+
+	return mask;
+}
+#define array_index_mask_nospec array_index_mask_nospec
+#endif
+
+#include <asm-generic/barrier.h>
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_BARRIER_H */


