Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2586247316
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403920AbgHQSu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387785AbgHQPxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:53:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C115120885;
        Mon, 17 Aug 2020 15:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679589;
        bh=D5XWbLnGTaft+wcyGcv6thHPTE1uKy+ouO0akmgZaO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1U93xDBg4CYjXdYRoysNBg0cTVOOMXho17igTnXezYyGjKrktHmjcqOpsEM8bzblY
         GEBtUvcpW0hiEe/4Fv+tcItrJ/MFlQTEiOA3IdNsf1Hl1v3qTYu4HYGxxXmz9xDbgH
         KgqKNV7Y0XhEGWpCXMrwwyl/E+M7AEJtQeCcVVB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 267/393] powerpc/boot: Fix CONFIG_PPC_MPC52XX references
Date:   Mon, 17 Aug 2020 17:15:17 +0200
Message-Id: <20200817143832.568614572@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit e5eff89657e72a9050d95fde146b54c7dc165981 ]

Commit 866bfc75f40e ("powerpc: conditionally compile platform-specific
serial drivers") made some code depend on CONFIG_PPC_MPC52XX, which
doesn't exist.

Fix it to use CONFIG_PPC_MPC52xx.

Fixes: 866bfc75f40e ("powerpc: conditionally compile platform-specific serial drivers")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200724131728.1643966-7-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/Makefile | 2 +-
 arch/powerpc/boot/serial.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index c53a1b8bba8be..e32a9e40a522e 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -119,7 +119,7 @@ src-wlib-y := string.S crt0.S stdio.c decompress.c main.c \
 		elf_util.c $(zlib-y) devtree.c stdlib.c \
 		oflib.c ofconsole.c cuboot.c
 
-src-wlib-$(CONFIG_PPC_MPC52XX) += mpc52xx-psc.c
+src-wlib-$(CONFIG_PPC_MPC52xx) += mpc52xx-psc.c
 src-wlib-$(CONFIG_PPC64_BOOT_WRAPPER) += opal-calls.S opal.c
 ifndef CONFIG_PPC64_BOOT_WRAPPER
 src-wlib-y += crtsavres.S
diff --git a/arch/powerpc/boot/serial.c b/arch/powerpc/boot/serial.c
index 9457863147f9b..00179cd6bdd08 100644
--- a/arch/powerpc/boot/serial.c
+++ b/arch/powerpc/boot/serial.c
@@ -128,7 +128,7 @@ int serial_console_init(void)
 	         dt_is_compatible(devp, "fsl,cpm2-smc-uart"))
 		rc = cpm_console_init(devp, &serial_cd);
 #endif
-#ifdef CONFIG_PPC_MPC52XX
+#ifdef CONFIG_PPC_MPC52xx
 	else if (dt_is_compatible(devp, "fsl,mpc5200-psc-uart"))
 		rc = mpc5200_psc_console_init(devp, &serial_cd);
 #endif
-- 
2.25.1



