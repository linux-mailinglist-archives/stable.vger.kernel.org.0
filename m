Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D556242F15D
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 14:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbhJOMvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 08:51:44 -0400
Received: from mail.fris.de ([116.203.77.234]:38838 "EHLO mail.fris.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239100AbhJOMvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 08:51:39 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 240C1BFB10;
        Fri, 15 Oct 2021 14:49:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1634302169; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=vtolzEmWYzx1NYsPin3VsKIQZeb2yk9gnCRf2QcYdHc=;
        b=dxCOAg6i7fFuDQ2K7rIcl6+RRwIPhGldD4ZkCjH8LvtGq3a0ycC3ZW8N9xu5hXMZukU41V
        cxvwLKJ11bEHPGT5/l2hw3cq/yJ+mSiO2iisFe+9O7UovYJg4xrVFTH035V4F0quEyviWv
        8VtD+4JtAKvRM0SyEvHWoBpS4nRMYNF5pger1ZAwMsSa7PbeU5Ck55DKxF4bI8MYNzS4pn
        cAaVIURO32+s4OfE3stm84Mo9tXosV9vhlgvb1w+uQ5Sq+cT1MxyU43yPimsofultE+1vs
        U8JIYvCjWkMW6KsTiQM9kFFEPgfXiaw6JHwzjTju93Q/SsCXO5Ow5jYkB4+t2Q==
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
Subject: [PATCH v2 5/6] arm64: dts: imx8mm-kontron: Fix CAN SPI clock frequency
Date:   Fri, 15 Oct 2021 14:48:39 +0200
Message-Id: <20211015124841.28226-6-frieder@fris.de>
In-Reply-To: <20211015124841.28226-1-frieder@fris.de>
References: <20211015124841.28226-1-frieder@fris.de>
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

This removes the arbitrarily low limit on the SPI frequency, that was
caused by a typo in the original dts.

Without this change, receiving CAN messages on the board beyond a
certain bitrate will cause overrun errors (see 'ip -det -stat link show
can0').

With this fix, receiving messages on the bus works without any overrun
errors for bitrates up to 1 MBit.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
Changes in v2:
  * Fix the commit ref in the Fixes tag
  * Improve commit message
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
index a192a047f264..14263cd40daf 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -97,7 +97,7 @@ can0: can@0 {
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

