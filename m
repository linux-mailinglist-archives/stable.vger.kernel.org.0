Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613C238AB98
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240738AbhETL0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:26:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241280AbhETLYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DAE861DA0;
        Thu, 20 May 2021 10:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505544;
        bh=JXmTuobwAbnhWAc/TeI1sLaB+hU4IUFukikAe6g+w/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4JekS26Nh4buDhhS6NV0QJ/Yi1iKUGPQHSYMjPaaGvp5Rrr2IE658quc33Y/heqa
         HhIcPFJomPwFXwy8pxNJer9sT3795r+6Fw5Pp+P3f3nm1yKVGRf6nxL7dIKoLOOF6o
         Z/fvlkt7ke4U4Ae9cB+I5YAiTA9RH/LO//lMaUfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 182/190] ARM: 9058/1: cache-v7: refactor v7_invalidate_l1 to avoid clobbering r5/r6
Date:   Thu, 20 May 2021 11:24:06 +0200
Message-Id: <20210520092108.190989085@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit f9e7a99fb6b86aa6a00e53b34ee6973840e005aa ]

The cache invalidation code in v7_invalidate_l1 can be tweaked to
re-read the associativity from CCSIDR, and keep the way identifier
component in a single register that is assigned in the outer loop. This
way, we need 2 registers less.

Given that the number of sets is typically much larger than the
associativity, rearrange the code so that the outer loop has the fewer
number of iterations, ensuring that the re-read of CCSIDR only occurs a
handful of times in practice.

Fix the whitespace while at it, and update the comment to indicate that
this code is no longer a clone of anything else.

Acked-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/cache-v7.S | 51 +++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index 11d699af30ed..db568be45946 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -27,41 +27,40 @@
  * processor.  We fix this by performing an invalidate, rather than a
  * clean + invalidate, before jumping into the kernel.
  *
- * This function is cloned from arch/arm/mach-tegra/headsmp.S, and needs
- * to be called for both secondary cores startup and primary core resume
- * procedures.
+ * This function needs to be called for both secondary cores startup and
+ * primary core resume procedures.
  */
 ENTRY(v7_invalidate_l1)
        mov     r0, #0
        mcr     p15, 2, r0, c0, c0, 0
        mrc     p15, 1, r0, c0, c0, 0
 
-       movw    r1, #0x7fff
-       and     r2, r1, r0, lsr #13
+	movw	r3, #0x3ff
+	and	r3, r3, r0, lsr #3	@ 'Associativity' in CCSIDR[12:3]
+	clz	r1, r3			@ WayShift
+	mov	r2, #1
+	mov	r3, r3, lsl r1		@ NumWays-1 shifted into bits [31:...]
+	movs	r1, r2, lsl r1		@ #1 shifted left by same amount
+	moveq	r1, #1			@ r1 needs value > 0 even if only 1 way
 
-       movw    r1, #0x3ff
+	and	r2, r0, #0x7
+	add	r2, r2, #4		@ SetShift
 
-       and     r3, r1, r0, lsr #3      @ NumWays - 1
-       add     r2, r2, #1              @ NumSets
+1:	movw	r4, #0x7fff
+	and	r0, r4, r0, lsr #13	@ 'NumSets' in CCSIDR[27:13]
 
-       and     r0, r0, #0x7
-       add     r0, r0, #4      @ SetShift
-
-       clz     r1, r3          @ WayShift
-       add     r4, r3, #1      @ NumWays
-1:     sub     r2, r2, #1      @ NumSets--
-       mov     r3, r4          @ Temp = NumWays
-2:     subs    r3, r3, #1      @ Temp--
-       mov     r5, r3, lsl r1
-       mov     r6, r2, lsl r0
-       orr     r5, r5, r6      @ Reg = (Temp<<WayShift)|(NumSets<<SetShift)
-       mcr     p15, 0, r5, c7, c6, 2
-       bgt     2b
-       cmp     r2, #0
-       bgt     1b
-       dsb     st
-       isb
-       ret     lr
+2:	mov	r4, r0, lsl r2		@ NumSet << SetShift
+	orr	r4, r4, r3		@ Reg = (Temp<<WayShift)|(NumSets<<SetShift)
+	mcr	p15, 0, r4, c7, c6, 2
+	subs	r0, r0, #1		@ Set--
+	bpl	2b
+	subs	r3, r3, r1		@ Way--
+	bcc	3f
+	mrc	p15, 1, r0, c0, c0, 0	@ re-read cache geometry from CCSIDR
+	b	1b
+3:	dsb	st
+	isb
+	ret	lr
 ENDPROC(v7_invalidate_l1)
 
 /*
-- 
2.30.2



