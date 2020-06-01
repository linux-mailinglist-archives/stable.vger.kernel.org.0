Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8991EA9FE
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgFASEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:04:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730171AbgFASEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:04:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEE742077D;
        Mon,  1 Jun 2020 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034649;
        bh=4MGp3GhSPRW69gWgo1kGqYevai5ODOUvvSzkzf6cRa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDcxYIO62ehdqxanYkTiCUrv/Tc2VSIX4w9bLXcb+KTordZ4S+Qd+w32Qu+b1bLla
         Md7oSxBdsJTSJj4UQcTzB3Ryh5zeMxAINteqW9VcvSP4gJori9qkfBsD0LAQrd6Q+U
         p2UHk3O4xaXeBhXW5bofoOIqlrL7FKH/0ghOwa8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/95] ARM: uaccess: integrate uaccess_save and uaccess_restore
Date:   Mon,  1 Jun 2020 19:53:48 +0200
Message-Id: <20200601174028.426370178@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 8ede890b0bcebe8c760aacfe20e934d98c3dc6aa ]

Integrate uaccess_save / uaccess_restore macros into the new
uaccess_entry / uaccess_exit macros respectively.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/uaccess-asm.h | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/arm/include/asm/uaccess-asm.h b/arch/arm/include/asm/uaccess-asm.h
index d475e3e8145d..e46468b91eaa 100644
--- a/arch/arm/include/asm/uaccess-asm.h
+++ b/arch/arm/include/asm/uaccess-asm.h
@@ -67,30 +67,23 @@
 #endif
 	.endm
 
-	.macro	uaccess_save, tmp
 #ifdef CONFIG_CPU_SW_DOMAIN_PAN
-	mrc	p15, 0, \tmp, c3, c0, 0
-	str	\tmp, [sp, #SVC_DACR]
-#endif
-	.endm
-
-	.macro	uaccess_restore
-#ifdef CONFIG_CPU_SW_DOMAIN_PAN
-	ldr	r0, [sp, #SVC_DACR]
-	mcr	p15, 0, r0, c3, c0, 0
+#define DACR(x...)	x
+#else
+#define DACR(x...)
 #endif
-	.endm
 
 	/*
 	 * Save the address limit on entry to a privileged exception and
 	 * if using PAN, save and disable usermode access.
 	 */
 	.macro	uaccess_entry, tsk, tmp0, tmp1, tmp2, disable
-	ldr	\tmp0, [\tsk, #TI_ADDR_LIMIT]
-	mov	\tmp1, #TASK_SIZE
-	str	\tmp1, [\tsk, #TI_ADDR_LIMIT]
-	str	\tmp0, [sp, #SVC_ADDR_LIMIT]
-	uaccess_save \tmp0
+	ldr	\tmp1, [\tsk, #TI_ADDR_LIMIT]
+	mov	\tmp2, #TASK_SIZE
+	str	\tmp2, [\tsk, #TI_ADDR_LIMIT]
+ DACR(	mrc	p15, 0, \tmp0, c3, c0, 0)
+ DACR(	str	\tmp0, [sp, #SVC_DACR])
+	str	\tmp1, [sp, #SVC_ADDR_LIMIT]
 	.if \disable
 	uaccess_disable \tmp0
 	.endif
@@ -99,8 +92,11 @@
 	/* Restore the user access state previously saved by uaccess_entry */
 	.macro	uaccess_exit, tsk, tmp0, tmp1
 	ldr	\tmp1, [sp, #SVC_ADDR_LIMIT]
-	uaccess_restore
+ DACR(	ldr	\tmp0, [sp, #SVC_DACR])
 	str	\tmp1, [\tsk, #TI_ADDR_LIMIT]
+ DACR(	mcr	p15, 0, \tmp0, c3, c0, 0)
 	.endm
 
+#undef DACR
+
 #endif /* __ASM_UACCESS_ASM_H__ */
-- 
2.25.1



