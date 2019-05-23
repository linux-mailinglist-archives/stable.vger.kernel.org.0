Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE03628A40
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388176AbfEWTL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388163AbfEWTL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:11:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EAE72133D;
        Thu, 23 May 2019 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638686;
        bh=/qPQOaavt0NlqN/oIrdA0kL6wmDyBzKkrP+wc4M5NWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqPsVhwfDUf+OTAqbZyPxF3W5oDgqoqiJMk8HGWP2OAiul62hqLnFpPHkmKDyOUj0
         HSYiy0qiIOQYMryHm1uH8H1sXao0EBwV5e811uvfY5JXwFDjm+U91zhEyBR3KwXRP4
         Nb13l+Prf2TXpoKurpmgTwlPpsyHlpN8Ey2qi8Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Karlman <jonas@kwiboo.se>,
        Peter Geis <pgwipeout@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 4.14 27/77] clk: rockchip: fix wrong clock definitions for rk3328
Date:   Thu, 23 May 2019 21:05:45 +0200
Message-Id: <20190523181724.028009472@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Karlman <jonas@kwiboo.se>

commit fb903392131a324a243c7731389277db1cd9f8df upstream.

This patch fixes definition of several clock gate and select register
that is wrong for rk3328 referring to the TRM and vendor kernel.
Also use correct number of softrst registers.

Fix clock definition for:
- clk_crypto
- aclk_h265
- pclk_h265
- aclk_h264
- hclk_h264
- aclk_axisram
- aclk_gmac
- aclk_usb3otg

Fixes: fe3511ad8a1c ("clk: rockchip: add clock controller for rk3328")
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Tested-by: Peter Geis <pgwipeout@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/rockchip/clk-rk3328.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/clk/rockchip/clk-rk3328.c
+++ b/drivers/clk/rockchip/clk-rk3328.c
@@ -458,7 +458,7 @@ static struct rockchip_clk_branch rk3328
 			RK3328_CLKSEL_CON(35), 15, 1, MFLAGS, 8, 7, DFLAGS,
 			RK3328_CLKGATE_CON(2), 12, GFLAGS),
 	COMPOSITE(SCLK_CRYPTO, "clk_crypto", mux_2plls_p, 0,
-			RK3328_CLKSEL_CON(20), 7, 1, MFLAGS, 0, 7, DFLAGS,
+			RK3328_CLKSEL_CON(20), 7, 1, MFLAGS, 0, 5, DFLAGS,
 			RK3328_CLKGATE_CON(2), 4, GFLAGS),
 	COMPOSITE_NOMUX(SCLK_TSADC, "clk_tsadc", "clk_24m", 0,
 			RK3328_CLKSEL_CON(22), 0, 10, DFLAGS,
@@ -550,15 +550,15 @@ static struct rockchip_clk_branch rk3328
 	GATE(0, "hclk_rkvenc_niu", "hclk_rkvenc", CLK_IGNORE_UNUSED,
 			RK3328_CLKGATE_CON(25), 1, GFLAGS),
 	GATE(ACLK_H265, "aclk_h265", "aclk_rkvenc", 0,
-			RK3328_CLKGATE_CON(25), 0, GFLAGS),
+			RK3328_CLKGATE_CON(25), 2, GFLAGS),
 	GATE(PCLK_H265, "pclk_h265", "hclk_rkvenc", 0,
-			RK3328_CLKGATE_CON(25), 1, GFLAGS),
+			RK3328_CLKGATE_CON(25), 3, GFLAGS),
 	GATE(ACLK_H264, "aclk_h264", "aclk_rkvenc", 0,
-			RK3328_CLKGATE_CON(25), 0, GFLAGS),
+			RK3328_CLKGATE_CON(25), 4, GFLAGS),
 	GATE(HCLK_H264, "hclk_h264", "hclk_rkvenc", 0,
-			RK3328_CLKGATE_CON(25), 1, GFLAGS),
+			RK3328_CLKGATE_CON(25), 5, GFLAGS),
 	GATE(ACLK_AXISRAM, "aclk_axisram", "aclk_rkvenc", CLK_IGNORE_UNUSED,
-			RK3328_CLKGATE_CON(25), 0, GFLAGS),
+			RK3328_CLKGATE_CON(25), 6, GFLAGS),
 
 	COMPOSITE(SCLK_VENC_CORE, "sclk_venc_core", mux_4plls_p, 0,
 			RK3328_CLKSEL_CON(51), 14, 2, MFLAGS, 8, 5, DFLAGS,
@@ -663,7 +663,7 @@ static struct rockchip_clk_branch rk3328
 
 	/* PD_GMAC */
 	COMPOSITE(ACLK_GMAC, "aclk_gmac", mux_2plls_hdmiphy_p, 0,
-			RK3328_CLKSEL_CON(35), 6, 2, MFLAGS, 0, 5, DFLAGS,
+			RK3328_CLKSEL_CON(25), 6, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3328_CLKGATE_CON(3), 2, GFLAGS),
 	COMPOSITE_NOMUX(PCLK_GMAC, "pclk_gmac", "aclk_gmac", 0,
 			RK3328_CLKSEL_CON(25), 8, 3, DFLAGS,
@@ -733,7 +733,7 @@ static struct rockchip_clk_branch rk3328
 
 	/* PD_PERI */
 	GATE(0, "aclk_peri_noc", "aclk_peri", CLK_IGNORE_UNUSED, RK3328_CLKGATE_CON(19), 11, GFLAGS),
-	GATE(ACLK_USB3OTG, "aclk_usb3otg", "aclk_peri", 0, RK3328_CLKGATE_CON(19), 4, GFLAGS),
+	GATE(ACLK_USB3OTG, "aclk_usb3otg", "aclk_peri", 0, RK3328_CLKGATE_CON(19), 14, GFLAGS),
 
 	GATE(HCLK_SDMMC, "hclk_sdmmc", "hclk_peri", 0, RK3328_CLKGATE_CON(19), 0, GFLAGS),
 	GATE(HCLK_SDIO, "hclk_sdio", "hclk_peri", 0, RK3328_CLKGATE_CON(19), 1, GFLAGS),
@@ -894,7 +894,7 @@ static void __init rk3328_clk_init(struc
 				     &rk3328_cpuclk_data, rk3328_cpuclk_rates,
 				     ARRAY_SIZE(rk3328_cpuclk_rates));
 
-	rockchip_register_softrst(np, 11, reg_base + RK3328_SOFTRST_CON(0),
+	rockchip_register_softrst(np, 12, reg_base + RK3328_SOFTRST_CON(0),
 				  ROCKCHIP_SOFTRST_HIWORD_MASK);
 
 	rockchip_register_restart_notifier(ctx, RK3328_GLB_SRST_FST, NULL);


