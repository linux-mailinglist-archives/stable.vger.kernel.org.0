Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6DB1EAEAE
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgFAS4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729697AbgFASAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:00:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB34206E2;
        Mon,  1 Jun 2020 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034445;
        bh=2ZPjej86uWTbLn4JuUOXaDIYjHQwrcYDh8zvLp7nqxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7uauL5U9byjNVtvol6T1EhInkBTcOSUic8ojFEBbv77qr6Dzm5vYc9/ZvjimIxeE
         NGidboK+LUDoDQh+3Cmh2DIplCr1ypcblOK+pMuu06GBu269HwLjs3KRmHQr8lips2
         2yUvByZHp/z81CuRfe09LEPK9feCYNeT9SZQp1Ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Paukrt <tomas.paukrt@advantech.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/77] ARM: uaccess: fix DACR mismatch with nested exceptions
Date:   Mon,  1 Jun 2020 19:53:40 +0200
Message-Id: <20200601174022.834527993@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 71f8af1110101facfad68989ff91f88f8e2c3e22 ]

Tomas Paukrt reports that his SAM9X60 based system (ARM926, ARMv5TJ)
fails to fix up alignment faults, eventually resulting in a kernel
oops.

The problem occurs when using CONFIG_CPU_USE_DOMAINS with commit
e6978e4bf181 ("ARM: save and reset the address limit when entering an
exception").  This is because the address limit is set back to
TASK_SIZE on exception entry, and, although it is restored on exception
exit, the domain register is not.

Hence, this sequence can occur:

  interrupt
    pt_regs->addr_limit = addr_limit		// USER_DS
    addr_limit = USER_DS
    alignment exception
    __probe_kernel_read()
      old_fs = get_fs()				// USER_DS
      set_fs(KERNEL_DS)
        addr_limit = KERNEL_DS
        dacr.kernel = DOMAIN_MANAGER
        interrupt
          pt_regs->addr_limit = addr_limit	// KERNEL_DS
          addr_limit = USER_DS
          alignment exception
          __probe_kernel_read()
            old_fs = get_fs()			// USER_DS
            set_fs(KERNEL_DS)
              addr_limit = KERNEL_DS
              dacr.kernel = DOMAIN_MANAGER
            ...
            set_fs(old_fs)
              addr_limit = USER_DS
              dacr.kernel = DOMAIN_CLIENT
          ...
          addr_limit = pt_regs->addr_limit	// KERNEL_DS
        interrupt returns

At this point, addr_limit is correctly restored to KERNEL_DS for
__probe_kernel_read() to continue execution, but dacr.kernel is not,
it has been reset by the set_fs(old_fs) to DOMAIN_CLIENT.

This would not have happened prior to the mentioned commit, because
addr_limit would remain KERNEL_DS, so get_fs() would have returned
KERNEL_DS, and so would correctly nest.

This commit fixes the problem by also saving the DACR on exception
entry if either CONFIG_CPU_SW_DOMAIN_PAN or CONFIG_CPU_USE_DOMAINS are
enabled, and resetting the DACR appropriately on exception entry to
match addr_limit and PAN settings.

Fixes: e6978e4bf181 ("ARM: save and reset the address limit when entering an exception")
Reported-by: Tomas Paukrt <tomas.paukrt@advantech.cz>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/uaccess-asm.h | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/uaccess-asm.h b/arch/arm/include/asm/uaccess-asm.h
index e46468b91eaa..907571fd05c6 100644
--- a/arch/arm/include/asm/uaccess-asm.h
+++ b/arch/arm/include/asm/uaccess-asm.h
@@ -67,15 +67,21 @@
 #endif
 	.endm
 
-#ifdef CONFIG_CPU_SW_DOMAIN_PAN
+#if defined(CONFIG_CPU_SW_DOMAIN_PAN) || defined(CONFIG_CPU_USE_DOMAINS)
 #define DACR(x...)	x
 #else
 #define DACR(x...)
 #endif
 
 	/*
-	 * Save the address limit on entry to a privileged exception and
-	 * if using PAN, save and disable usermode access.
+	 * Save the address limit on entry to a privileged exception.
+	 *
+	 * If we are using the DACR for kernel access by the user accessors
+	 * (CONFIG_CPU_USE_DOMAINS=y), always reset the DACR kernel domain
+	 * back to client mode, whether or not \disable is set.
+	 *
+	 * If we are using SW PAN, set the DACR user domain to no access
+	 * if \disable is set.
 	 */
 	.macro	uaccess_entry, tsk, tmp0, tmp1, tmp2, disable
 	ldr	\tmp1, [\tsk, #TI_ADDR_LIMIT]
@@ -84,8 +90,17 @@
  DACR(	mrc	p15, 0, \tmp0, c3, c0, 0)
  DACR(	str	\tmp0, [sp, #SVC_DACR])
 	str	\tmp1, [sp, #SVC_ADDR_LIMIT]
-	.if \disable
-	uaccess_disable \tmp0
+	.if \disable && IS_ENABLED(CONFIG_CPU_SW_DOMAIN_PAN)
+	/* kernel=client, user=no access */
+	mov	\tmp2, #DACR_UACCESS_DISABLE
+	mcr	p15, 0, \tmp2, c3, c0, 0
+	instr_sync
+	.elseif IS_ENABLED(CONFIG_CPU_USE_DOMAINS)
+	/* kernel=client */
+	bic	\tmp2, \tmp0, #domain_mask(DOMAIN_KERNEL)
+	orr	\tmp2, \tmp2, #domain_val(DOMAIN_KERNEL, DOMAIN_CLIENT)
+	mcr	p15, 0, \tmp2, c3, c0, 0
+	instr_sync
 	.endif
 	.endm
 
-- 
2.25.1



