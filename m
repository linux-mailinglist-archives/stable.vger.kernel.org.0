Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C158F4BC1
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKHMgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfKHMgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:24 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B412245C;
        Fri,  8 Nov 2019 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216583;
        bh=6bqZlPT8NBhAyi0LMfQdCc5Q5v+8ZSpmETv9OECvFQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=us/C+Y783h+o22rtv3Xo/fcamJtHE7TqC0vyqKRwuNMcaaNIX+N4VeeN3c1JoQa3/
         5K3UolalunLDC2UMamH57TISJ9wNPsYFrTg2MtWvTMV8+5FTkHt94I2kK3ViJR5A9Q
         2oKC+wTe7HWt9L45fScLvwDe/rLnBtzbvV6s8f+A=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 07/50] ARM: Move system register accessors to asm/cp15.h
Date:   Fri,  8 Nov 2019 13:35:11 +0100
Message-Id: <20191108123554.29004-8-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

Commit 4f2546384150e78cad8045e59a9587fabcd9f9fe upstream.

Headers linux/irqchip/arm-gic.v3.h and arch/arm/include/asm/kvm_hyp.h
are included in virt/kvm/arm/hyp/vgic-v3-sr.c and both define macros
called __ACCESS_CP15 and __ACCESS_CP15_64 which obviously creates a
conflict. These macros were introduced independently for GIC and KVM
and, in fact, do the same thing.

As an option we could add prefixes to KVM and GIC version of macros so
they won't clash, but it'd introduce code duplication.  Alternatively,
we could keep macro in, say, GIC header and include it in KVM one (or
vice versa), but such dependency would not look nicer.

So we follow arm64 way (it handles this via sysreg.h) and move only
single set of macros to asm/cp15.h

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/arch_gicv3.h | 27 ++++++++------------
 arch/arm/include/asm/cp15.h       | 15 +++++++++++
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index e08d15184056..af25c32b1ccc 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -22,9 +22,7 @@
 
 #include <linux/io.h>
 #include <asm/barrier.h>
-
-#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
-#define __ACCESS_CP15_64(Op1, CRm)		p15, Op1, %Q0, %R0, CRm
+#include <asm/cp15.h>
 
 #define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
 #define ICC_DIR				__ACCESS_CP15(c12, 0, c11, 1)
@@ -102,58 +100,55 @@
 
 static inline void gic_write_eoir(u32 irq)
 {
-	asm volatile("mcr " __stringify(ICC_EOIR1) : : "r" (irq));
+	write_sysreg(irq, ICC_EOIR1);
 	isb();
 }
 
 static inline void gic_write_dir(u32 val)
 {
-	asm volatile("mcr " __stringify(ICC_DIR) : : "r" (val));
+	write_sysreg(val, ICC_DIR);
 	isb();
 }
 
 static inline u32 gic_read_iar(void)
 {
-	u32 irqstat;
+	u32 irqstat = read_sysreg(ICC_IAR1);
 
-	asm volatile("mrc " __stringify(ICC_IAR1) : "=r" (irqstat));
 	dsb(sy);
+
 	return irqstat;
 }
 
 static inline void gic_write_pmr(u32 val)
 {
-	asm volatile("mcr " __stringify(ICC_PMR) : : "r" (val));
+	write_sysreg(val, ICC_PMR);
 }
 
 static inline void gic_write_ctlr(u32 val)
 {
-	asm volatile("mcr " __stringify(ICC_CTLR) : : "r" (val));
+	write_sysreg(val, ICC_CTLR);
 	isb();
 }
 
 static inline void gic_write_grpen1(u32 val)
 {
-	asm volatile("mcr " __stringify(ICC_IGRPEN1) : : "r" (val));
+	write_sysreg(val, ICC_IGRPEN1);
 	isb();
 }
 
 static inline void gic_write_sgi1r(u64 val)
 {
-	asm volatile("mcrr " __stringify(ICC_SGI1R) : : "r" (val));
+	write_sysreg(val, ICC_SGI1R);
 }
 
 static inline u32 gic_read_sre(void)
 {
-	u32 val;
-
-	asm volatile("mrc " __stringify(ICC_SRE) : "=r" (val));
-	return val;
+	return read_sysreg(ICC_SRE);
 }
 
 static inline void gic_write_sre(u32 val)
 {
-	asm volatile("mcr " __stringify(ICC_SRE) : : "r" (val));
+	write_sysreg(val, ICC_SRE);
 	isb();
 }
 
diff --git a/arch/arm/include/asm/cp15.h b/arch/arm/include/asm/cp15.h
index c3f11524f10c..dbdbce1b3a72 100644
--- a/arch/arm/include/asm/cp15.h
+++ b/arch/arm/include/asm/cp15.h
@@ -49,6 +49,21 @@
 
 #ifdef CONFIG_CPU_CP15
 
+#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
+	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
+#define __ACCESS_CP15_64(Op1, CRm)		\
+	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
+
+#define __read_sysreg(r, w, c, t) ({				\
+	t __val;						\
+	asm volatile(r " " c : "=r" (__val));			\
+	__val;							\
+})
+#define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
+
+#define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
+#define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
+
 extern unsigned long cr_alignment;	/* defined in entry-armv.S */
 
 static inline unsigned long get_cr(void)
-- 
2.20.1

