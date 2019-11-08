Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A60F4BE3
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfKHMhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:37:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbfKHMhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:37:07 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E426224BF;
        Fri,  8 Nov 2019 12:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216627;
        bh=jZlVLHBVuRLLVNmGvaaQaFyzgmj1VGPlCuiTfqSwmDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GH6Af8UIreFNmkHwm2v58QC+Uy6l39ZPkmMv75M+mOSyvZW+3cS6zoMDHFHRtmpKt
         PkHSRu78Gh1FNiBceltzo176FV9Y8NaeLRpq/7QIqvePE3xI0tkhskkLY8gbD1Mube
         Cgw1SY1IX9dx1R17h70E464APGUN893TxKjLDCuc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 35/50] ARM: spectre-v1: mitigate user accesses
Date:   Fri,  8 Nov 2019 13:35:39 +0100
Message-Id: <20191108123554.29004-36-ardb@kernel.org>
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

Commit a3c0f84765bb429ba0fd23de1c57b5e1591c9389 upstream.

Spectre variant 1 attacks are about this sequence of pseudo-code:

	index = load(user-manipulated pointer);
	access(base + index * stride);

In order for the cache side-channel to work, the access() must me made
to memory which userspace can detect whether cache lines have been
loaded.  On 32-bit ARM, this must be either user accessible memory, or
a kernel mapping of that same user accessible memory.

The problem occurs when the load() speculatively loads privileged data,
and the subsequent access() is made to user accessible memory.

Any load() which makes use of a user-maniplated pointer is a potential
problem if the data it has loaded is used in a subsequent access.  This
also applies for the access() if the data loaded by that access is used
by a subsequent access.

Harden the get_user() accessors against Spectre attacks by forcing out
of bounds addresses to a NULL pointer.  This prevents get_user() being
used as the load() step above.  As a side effect, put_user() will also
be affected even though it isn't implicated.

Also harden copy_from_user() by redoing the bounds check within the
arm_copy_from_user() code, and NULLing the pointer if out of bounds.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/assembler.h | 4 ++++
 arch/arm/lib/copy_from_user.S    | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 307901f88a1e..483481c6937e 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -454,6 +454,10 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 	adds	\tmp, \addr, #\size - 1
 	sbcccs	\tmp, \tmp, \limit
 	bcs	\bad
+#ifdef CONFIG_CPU_SPECTRE
+	movcs	\addr, #0
+	csdb
+#endif
 #endif
 	.endm
 
diff --git a/arch/arm/lib/copy_from_user.S b/arch/arm/lib/copy_from_user.S
index 1512bebfbf1b..d36329cefedc 100644
--- a/arch/arm/lib/copy_from_user.S
+++ b/arch/arm/lib/copy_from_user.S
@@ -90,6 +90,15 @@
 	.text
 
 ENTRY(arm_copy_from_user)
+#ifdef CONFIG_CPU_SPECTRE
+	get_thread_info r3
+	ldr	r3, [r3, #TI_ADDR_LIMIT]
+	adds	ip, r1, r2	@ ip=addr+size
+	sub	r3, r3, #1	@ addr_limit - 1
+	cmpcc	ip, r3		@ if (addr+size > addr_limit - 1)
+	movcs	r1, #0		@ addr = NULL
+	csdb
+#endif
 
 #include "copy_template.S"
 
-- 
2.20.1

