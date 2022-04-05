Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965574F33A2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347845AbiDEJ2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244958AbiDEIwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3951C114;
        Tue,  5 Apr 2022 01:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0094D60FFC;
        Tue,  5 Apr 2022 08:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D665AC385A0;
        Tue,  5 Apr 2022 08:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148471;
        bh=g/yUqTevTV8GciHyd7YeKtTHAieQUSEzbtaW7BPaBVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2zJ+2BviXbIYu/ULEe2uZs6gcbirQdV/lMvdMmDV+Z54AmsarlspHMTMVn2B6vqI
         RLGTy0t3R++t+3S0t8wVq5LpDD37dYzO2BjepxCyA5JDjBRF45Uep87oJcib+xhsGf
         X/V+K2yH+uzH1nqjxE5p9e9p6a/kajl5xVTXGCpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Angelo Dureghello <angelo@sysam.it>,
        Greg Ungerer <gerg@kernel.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, uclinux-dev@uclinux.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0367/1017] m68k: coldfire/device.c: only build for MCF_EDMA when h/w macros are defined
Date:   Tue,  5 Apr 2022 09:21:20 +0200
Message-Id: <20220405070405.179166748@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit e6e1e7b19fa132d23d09c465942aab4c110d3da9 ]

When CONFIG_MCF_EDMA is set (due to COMPILE_TEST, not due to
CONFIG_M5441x), coldfire/device.c has compile errors due to
missing MCFEDMA_* symbols. In the .config file that was provided,
CONFIG_M5206=y, not CONFIG_M5441x, so <asm/m5441xsim.h> is not
included in coldfire/device.c.

Only build the MCF_EDMA code in coldfire/device.c if the MCFEDMA_*
hardware macros are defined.

Fixes these build errors:

../arch/m68k/coldfire/device.c:512:35: error: 'MCFEDMA_BASE' undeclared here (not in a function); did you mean 'MCFDMA_BASE1'?
  512 |                 .start          = MCFEDMA_BASE,
../arch/m68k/coldfire/device.c:513:50: error: 'MCFEDMA_SIZE' undeclared here (not in a function)
  513 |                 .end            = MCFEDMA_BASE + MCFEDMA_SIZE - 1,
../arch/m68k/coldfire/device.c:517:35: error: 'MCFEDMA_IRQ_INTR0' undeclared here (not in a function)
  517 |                 .start          = MCFEDMA_IRQ_INTR0,
../arch/m68k/coldfire/device.c:523:35: error: 'MCFEDMA_IRQ_INTR16' undeclared here (not in a function)
  523 |                 .start          = MCFEDMA_IRQ_INTR16,
../arch/m68k/coldfire/device.c:529:35: error: 'MCFEDMA_IRQ_INTR56' undeclared here (not in a function)
  529 |                 .start          = MCFEDMA_IRQ_INTR56,
../arch/m68k/coldfire/device.c:535:35: error: 'MCFEDMA_IRQ_ERR' undeclared here (not in a function)
  535 |                 .start          = MCFEDMA_IRQ_ERR,

Fixes: d7e9d01ac292 ("m68k: add ColdFire mcf5441x eDMA platform support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: lore.kernel.org/r/202203030252.P752DK46-lkp@intel.com
Cc: Angelo Dureghello <angelo@sysam.it>
Cc: Greg Ungerer <gerg@kernel.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Cc: uclinux-dev@uclinux.org
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/coldfire/device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
index 0386252e9d04..4218750414bb 100644
--- a/arch/m68k/coldfire/device.c
+++ b/arch/m68k/coldfire/device.c
@@ -480,7 +480,7 @@ static struct platform_device mcf_i2c5 = {
 #endif /* MCFI2C_BASE5 */
 #endif /* IS_ENABLED(CONFIG_I2C_IMX) */
 
-#if IS_ENABLED(CONFIG_MCF_EDMA)
+#ifdef MCFEDMA_BASE
 
 static const struct dma_slave_map mcf_edma_map[] = {
 	{ "dreq0", "rx-tx", MCF_EDMA_FILTER_PARAM(0) },
@@ -552,7 +552,7 @@ static struct platform_device mcf_edma = {
 		.platform_data = &mcf_edma_data,
 	}
 };
-#endif /* IS_ENABLED(CONFIG_MCF_EDMA) */
+#endif /* MCFEDMA_BASE */
 
 #ifdef MCFSDHC_BASE
 static struct mcf_esdhc_platform_data mcf_esdhc_data = {
@@ -651,7 +651,7 @@ static struct platform_device *mcf_devices[] __initdata = {
 	&mcf_i2c5,
 #endif
 #endif
-#if IS_ENABLED(CONFIG_MCF_EDMA)
+#ifdef MCFEDMA_BASE
 	&mcf_edma,
 #endif
 #ifdef MCFSDHC_BASE
-- 
2.34.1



