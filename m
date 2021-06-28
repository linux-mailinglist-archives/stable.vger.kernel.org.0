Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F943B63E9
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbhF1PCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236559AbhF1PAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7F5F61D6A;
        Mon, 28 Jun 2021 14:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891250;
        bh=uZyfuX32G7CuwX8x6aNHVMwxl4JJFgdrSeYG6YEZfb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBzMB7FYHBXXImj+XI9QvL4dRG3FLLtdfTLPuhrdWGzJ5czFe9Jpy1R7fO9HNqjM4
         6Ka5tXJBE0O+U9gGuOo8sh/H7xASICQWrQkAYc+LGfsv3g+E/difwbCWKy8Zepe3Dk
         FHSrS0ELNkc5Jd/no8YJJGCWR0+waYQm/IWQm2J9Vul1QXHT66PQB0TDJzaX7T84B1
         znXkRQ2tw7ee1Ti8OnF2KSTipzPgiL4XbFTWdjV5yCLGGC/6tag8s4Xh1qoRiBHZp9
         ZkGADMRiXtdswEb9RJpCpsNLqvFwxr7zG/Aq11PX5C8v7cVRuNQNrkxhi/gRCmiTqO
         A0Tp1HIc5Pd4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 52/71] ARM: 9081/1: fix gcc-10 thumb2-kernel regression
Date:   Mon, 28 Jun 2021 10:39:44 -0400
Message-Id: <20210628144003.34260-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index 4764742db7b0..627889ea89ef 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -547,9 +547,11 @@ void notrace cpu_init(void)
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
@@ -571,15 +573,15 @@ void notrace cpu_init(void)
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

