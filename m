Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2640C246A52
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbgHQPdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730383AbgHQPda (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:33:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDEB022D70;
        Mon, 17 Aug 2020 15:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678409;
        bh=xkpyY6I8Zhi0kMyrTuN+pP4gLQV21eoOEKpQZ8mG5Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKE+dnvUbHwXAsBj15PhyK93EwdR9Qb8J0eq93MLzNuR6Ji78ej8LUMdZVTw6Ibvf
         81PPZ69mn//yoammLOISte68DZ3ZcpBdT1hT4A3t9yBiQtaXwbupnoIXAxK9h9OBr3
         +I5cigika8XiluyizK3S68/YSYqlLX2JYfS50a34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 317/464] powerpc/boot: Fix CONFIG_PPC_MPC52XX references
Date:   Mon, 17 Aug 2020 17:14:30 +0200
Message-Id: <20200817143848.980474582@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index 63d7456b95180..2039ed41250df 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -117,7 +117,7 @@ src-wlib-y := string.S crt0.S stdio.c decompress.c main.c \
 		elf_util.c $(zlib-y) devtree.c stdlib.c \
 		oflib.c ofconsole.c cuboot.c
 
-src-wlib-$(CONFIG_PPC_MPC52XX) += mpc52xx-psc.c
+src-wlib-$(CONFIG_PPC_MPC52xx) += mpc52xx-psc.c
 src-wlib-$(CONFIG_PPC64_BOOT_WRAPPER) += opal-calls.S opal.c
 ifndef CONFIG_PPC64_BOOT_WRAPPER
 src-wlib-y += crtsavres.S
diff --git a/arch/powerpc/boot/serial.c b/arch/powerpc/boot/serial.c
index 0bfa7e87e5460..9a19e5905485c 100644
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



