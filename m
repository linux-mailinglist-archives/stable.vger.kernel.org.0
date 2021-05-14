Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4DF380723
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 12:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhENK03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 06:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhENK02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 06:26:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2739B61353;
        Fri, 14 May 2021 10:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620987917;
        bh=Z7qjumW/icN4UH3B4ep1Ak1pKgALbptrCj4nzrkykbk=;
        h=From:To:Cc:Subject:Date:From;
        b=IIbcgTjIXXic0Z/gayWh4cf4wOJwxe8lAxlHwlSuwfqC7fiszgR5g52APrGfjxAQG
         pfZ19A1V2I1m0z1D80GUx5N7oGLTqbPkm0vAE5h9uzayxbeMIg0MpL160A7jDmRcjC
         YqUYF6TcD9NVyWDEFxXpgVAzJt7gCmaHnawE/zJKQxHAidUTMnKheFMlxpHrJirqou
         ++5zN027BvmEHCwsvKGQ37EY+F8OqjoOggkKu4VkDtc0NBIE8y2Of68dZdo0eI1FlB
         0zTzx6dvop1RwTVg4kvLw0ynq/xeq8PHHwSckHaJeN2JSxvrYHYVl2kOMBzfrbLYHz
         oHZxYkk0/rKVQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     patches@armlinux.org.uk
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] ARM: fix gcc-10 thumb2-kernel regression
Date:   Fri, 14 May 2021 12:24:10 +0200
Message-Id: <20210514102411.3996120-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
KerneVersion: v5.13-rc1
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When building the kernel wtih gcc-10 or higher using the
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y flag, the compiler picks a slightly
different set of registers for the inline assembly in cpu_init() that
subsequently results in a corrupt kernel stack as well as remaining in
FIQ mode. If a banked register is used for the last argument, the wrong
version of that register gets loaded into CPSR_c.  When building in Arm
mode, the arguments are passed as immediate values and the bug cannot
happen.

This got introduced when Daniel reworked the FIQ handling and was
technically always broken, but happened to work with both clang and gcc
before gcc-10 as long as they picked one of the lower registers.
This is probably an indication that still very few people build the
kernel in Thumb2 mode.

Marek pointed out the problem on IRC, Arnd narrowed it down to this
inline assembly and Russell pinpointed the exact bug.

Change the constraints to force the final mode switch to use a non-banked
register for the argument to ensure that the correct constant gets loaded.
Another alternative would be to always use registers for the constant
arguments to avoid the #ifdef that has now become more complex.

Cc: <stable@vger.kernel.org> # v3.18+
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Reported-by: Marek Vasut <marek.vasut@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Fixes: c0e7f7ee717e ("ARM: 8150/3: fiq: Replace default FIQ handler")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/kernel/setup.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 1a5edf562e85..73ca7797b92f 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -545,9 +545,11 @@ void notrace cpu_init(void)
 	 * In Thumb-2, msr with an immediate value is not allowed.
 	 */
 #ifdef CONFIG_THUMB2_KERNEL
-#define PLC	"r"
+#define PLC_l	"l"
+#define PLC_r	"r"
 #else
-#define PLC	"I"
+#define PLC_l	"I"
+#define PLC_r	"I"
 #endif
 
 	/*
@@ -569,15 +571,15 @@ void notrace cpu_init(void)
 	"msr	cpsr_c, %9"
 	    :
 	    : "r" (stk),
-	      PLC (PSR_F_BIT | PSR_I_BIT | IRQ_MODE),
+	      PLC_r (PSR_F_BIT | PSR_I_BIT | IRQ_MODE),
 	      "I" (offsetof(struct stack, irq[0])),
-	      PLC (PSR_F_BIT | PSR_I_BIT | ABT_MODE),
+	      PLC_r (PSR_F_BIT | PSR_I_BIT | ABT_MODE),
 	      "I" (offsetof(struct stack, abt[0])),
-	      PLC (PSR_F_BIT | PSR_I_BIT | UND_MODE),
+	      PLC_r (PSR_F_BIT | PSR_I_BIT | UND_MODE),
 	      "I" (offsetof(struct stack, und[0])),
-	      PLC (PSR_F_BIT | PSR_I_BIT | FIQ_MODE),
+	      PLC_r (PSR_F_BIT | PSR_I_BIT | FIQ_MODE),
 	      "I" (offsetof(struct stack, fiq[0])),
-	      PLC (PSR_F_BIT | PSR_I_BIT | SVC_MODE)
+	      PLC_l (PSR_F_BIT | PSR_I_BIT | SVC_MODE)
 	    : "r14");
 #endif
 }
-- 
2.29.2

