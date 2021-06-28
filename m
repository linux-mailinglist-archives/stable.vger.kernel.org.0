Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8C13B6460
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbhF1PHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237288AbhF1PFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FF1661D69;
        Mon, 28 Jun 2021 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891415;
        bh=M/eZB3HtLGlWINjgA55EZF33v/2G8dDTM9N+yg3DodU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqJ5i1HR5tLnvRrsQeLNy1VOmMLYYhMB/oULhjGLCIuqt2jZ+sJJ1GBRWlya+PmWK
         Cyss47wfapvGPMPGa37vQOIpiahDqNEp17btUpIGtjwreNJzYljeTiaI8qdk4odxsQ
         2oRV/186DKP9w03JJe2/kBXM1OZbwENDSXQJkjPUPC0YYaJIMUG2NeMPdu4SH6gJpN
         5sEkzLF9luxjjEP7DgvoU1A3oXJmvDXp5pKB1ZbjtR9TDA7n280sLd/1DThXqp7Clr
         WS2Itguezpi4bXlU9dnX++t5mJfwmqGyxUAoTEiSLlvoTmKTSOpy6AV1fWpDxjzTD/
         9uTI+8gfnpTOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 43/57] ARM: 9081/1: fix gcc-10 thumb2-kernel regression
Date:   Mon, 28 Jun 2021 10:42:42 -0400
Message-Id: <20210628144256.34524-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit dad7b9896a5dbac5da8275d5a6147c65c81fb5f2 upstream.

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
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/setup.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index e9c3d38d995d..ad72e83e11d1 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -479,9 +479,11 @@ void notrace cpu_init(void)
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
@@ -503,15 +505,15 @@ void notrace cpu_init(void)
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
2.30.2

