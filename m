Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E4B29BC3C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801809AbgJ0PoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801042AbgJ0Ph1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4902220756;
        Tue, 27 Oct 2020 15:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813046;
        bh=k5az+Tye1LI23PPZx51zsoIDH2qObvT/M5XGTr3tRa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIr2hUcPmX8IYCgNjL2m4HevSTEtKHwk1gLYOfSgQ8zKo2Cf/igS9N2U6VFPk/LuK
         IFdnMxvhdGCnJADZuZ3TtJyTpi5Ik/xIk39CyLX9xVOfYTkApHbsicz/tLEr02k4bq
         mBSTiodUGTGbsIjtRPXZ7v8ADgwzzxAHYCn3bzmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Angelo Dureghello <angelo.dureghello@timesys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 420/757] m68knommu: include SDHC support only when hardware has it
Date:   Tue, 27 Oct 2020 14:51:10 +0100
Message-Id: <20201027135510.275799644@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Ungerer <gerg@linux-m68k.org>

[ Upstream commit 322c512f476f07e960cecd447ef22c15bed0e5f1 ]

The mere fact that the kernel has the MMC subsystem enabled (CONFIG_MMC
enabled) does not mean that the underlying hardware platform has the
SDHC hardware present. Within the ColdFire hardware defines that is
signified by MCFSDHC_BASE being defined with an address.

The platform data for the ColdFire parts is including the SDHC hardware
if CONFIG_MMC is enabled, instead of MCFSDHC_BASE. This means that if
you are compiling for a ColdFire target that does not support SDHC but
enable CONFIG_MMC you will fail to compile with errors like this:

    arch/m68k/coldfire/device.c:565:12: error: ‘MCFSDHC_BASE’ undeclared here (not in a function)
       .start = MCFSDHC_BASE,
            ^
    arch/m68k/coldfire/device.c:566:25: error: ‘MCFSDHC_SIZE’ undeclared here (not in a function)
       .end = MCFSDHC_BASE + MCFSDHC_SIZE - 1,
                         ^
    arch/m68k/coldfire/device.c:569:12: error: ‘MCF_IRQ_SDHC’ undeclared here (not in a function)
       .start = MCF_IRQ_SDHC,
            ^

Make the SDHC platform support depend on MCFSDHC_BASE, that is only
include it if the specific ColdFire SoC has that hardware module.

Fixes: 991f5c4dd2422881 ("m68k: mcf5441x: add support for esdhc mmc controller")
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Angelo Dureghello <angelo.dureghello@timesys.com>
Tested-by: Angelo Dureghello <angelo.dureghello@timesys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/coldfire/device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
index 9ef4ec0aea008..59f7dfe50a4d0 100644
--- a/arch/m68k/coldfire/device.c
+++ b/arch/m68k/coldfire/device.c
@@ -554,7 +554,7 @@ static struct platform_device mcf_edma = {
 };
 #endif /* IS_ENABLED(CONFIG_MCF_EDMA) */
 
-#if IS_ENABLED(CONFIG_MMC)
+#ifdef MCFSDHC_BASE
 static struct mcf_esdhc_platform_data mcf_esdhc_data = {
 	.max_bus_width = 4,
 	.cd_type = ESDHC_CD_NONE,
@@ -579,7 +579,7 @@ static struct platform_device mcf_esdhc = {
 	.resource		= mcf_esdhc_resources,
 	.dev.platform_data	= &mcf_esdhc_data,
 };
-#endif /* IS_ENABLED(CONFIG_MMC) */
+#endif /* MCFSDHC_BASE */
 
 static struct platform_device *mcf_devices[] __initdata = {
 	&mcf_uart,
@@ -613,7 +613,7 @@ static struct platform_device *mcf_devices[] __initdata = {
 #if IS_ENABLED(CONFIG_MCF_EDMA)
 	&mcf_edma,
 #endif
-#if IS_ENABLED(CONFIG_MMC)
+#ifdef MCFSDHC_BASE
 	&mcf_esdhc,
 #endif
 };
-- 
2.25.1



