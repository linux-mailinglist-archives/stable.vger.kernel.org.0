Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52C041DE38
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 17:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347527AbhI3P6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 11:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347501AbhI3P6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 11:58:52 -0400
Received: from mail.fris.de (mail.fris.de [IPv6:2a01:4f8:c2c:390b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEB3C06176F;
        Thu, 30 Sep 2021 08:57:10 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B61A4BFBD8;
        Thu, 30 Sep 2021 17:57:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1633017428; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=fq/4Ecd3SDWhNxyRFfxC6ViwOFH6rIsVd8/4VWDJEbo=;
        b=qeTkR3/Fi2HJPraZCMZszO8aIsq9+39huk7ZEHY5y7erfgAwbgCRTtayxhxPAGbE2ELM+s
        Yyf3gOeVAk2kOyoKrkCTAEsPx4wYZ6J2KgeNTXe2GfqzbNc2rUi7c5YrCt/5Cx7rtUeGTJ
        OimZI5hw90qsw/drCyEV/NGVuWMIIXDa4fivt68fzs/9OU94FC82mE1/0AQEcXLbb9X0iM
        RJ8EFBw8H/qU+gt35m3wgT+DfveXK2oWYf9Wj3HJYvkzd7S9GdX/yBwqOCBZiBITsKS38J
        8oVap9CG7cvqRF0M7UmJqbnQee2Po6D1gbwXgbItLPwA7C31QjOex52PD3UStA==
From:   Frieder Schrempf <frieder@fris.de>
To:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: [PATCH 5/8] arm64: dts: imx8mm-kontron: Fix CAN SPI clock frequency
Date:   Thu, 30 Sep 2021 17:56:28 +0200
Message-Id: <20210930155633.2745201-6-frieder@fris.de>
In-Reply-To: <20210930155633.2745201-1-frieder@fris.de>
References: <20210930155633.2745201-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

The MCP2515 can be used with an SPI clock of up to 10 MHz. Set the
limit accordingly to prevent any performance issues caused by the
really low clock speed of 100 kHz.

Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
index f2c8ccefd1bf..dbf11e03ecce 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -98,7 +98,7 @@ can0: can@0 {
 		clocks = <&osc_can>;
 		interrupt-parent = <&gpio4>;
 		interrupts = <28 IRQ_TYPE_EDGE_FALLING>;
-		spi-max-frequency = <100000>;
+		spi-max-frequency = <10000000>;
 		vdd-supply = <&reg_vdd_3v3>;
 		xceiver-supply = <&reg_vdd_5v>;
 	};
-- 
2.33.0

