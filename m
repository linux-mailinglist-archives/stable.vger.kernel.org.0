Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914861F2BFB
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgFIAT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730598AbgFHXSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 643162088E;
        Mon,  8 Jun 2020 23:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658296;
        bh=4MGp3GhSPRW69gWgo1kGqYevai5ODOUvvSzkzf6cRa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjL78svF+OXpefNn6lMuyKORGsyuLI2/Wv9pWgYxPj7Rly14Jh2JNfV9cnNg5vTIc
         L5s/Uo8wno69jAlFwv6V2w4Vtf5jYtdvzvemdKuXtrE7/DaBOUhntRqV4RO+VIWO+k
         3AeXH89UbBqNFjfypkNYKZafIbjLeWnuskccksTU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 299/606] ARM: uaccess: integrate uaccess_save and uaccess_restore
Date:   Mon,  8 Jun 2020 19:07:04 -0400
Message-Id: <20200608231211.3363633-299-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

