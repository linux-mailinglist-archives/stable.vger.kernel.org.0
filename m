Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9A4642BA6
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 16:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiLEP1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 10:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiLEP0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 10:26:09 -0500
Received: from smtp-out-05.comm2000.it (smtp-out-05.comm2000.it [212.97.32.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB0F1F9D7;
        Mon,  5 Dec 2022 07:23:41 -0800 (PST)
Received: from francesco-nb.toradex.int (31-10-206-125.static.upc.ch [31.10.206.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-05.comm2000.it (Postfix) with ESMTPSA id E8EAA8240D3;
        Mon,  5 Dec 2022 16:23:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1670253819;
        bh=kHr0aTjYplJsrICaBlaf8mmyRJ9l5EZ0Gq7KL8EAlqE=;
        h=From:To:Cc:Subject:Date;
        b=cBPD/nURivJ8O5RZoA8hzMlVtiZuEZgWhN4Wj8BDRChGtKFKVdWF4sane+Zcr1Jzs
         RqSIfZWiRpnxRFre97ab42h1KMU4/LbK6kceQMQegJsbIAHZ4PBTLBu2v4PrEP3581
         B7BuQMvFC2UoGobIRy8/W9DRCwxHFvHrYoiAcuWI53oNo6BnFsCazJHTDMw25hJOKB
         QP+AYYkOBeDyEe2vdN0q0lKTZb279ljQVlf62Nzm8amMGJRdym4Z/VrLWM4+QWxkR7
         kLcSYsi6QEMHUYTOAIP5vMZX9ICmGlOchHLaJHF5WLb4epdEzoB8EIxSJQBsz/69D1
         FO+fk/0FDzurg==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org
Subject: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller size-cells"
Date:   Mon,  5 Dec 2022 16:23:27 +0100
Message-Id: <20221205152327.26881-1-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Dolcini <francesco.dolcini@toradex.com>

This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.

It introduced a boot regression on colibri-imx7, and potentially any
other i.MX7 boards with MTD partition list generated into the fdt by
U-Boot.

While the commit we are reverting here is not obviously wrong, it fixes
only a dt binding checker warning that is non-functional, while it
introduces a boot regression and there is no obvious fix ready.

Cc: stable@vger.kernel.org
Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com/
Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
 arch/arm/boot/dts/imx7s.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 03d2e8544a4e..0fc9e6b8b05d 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1270,10 +1270,10 @@ dma_apbh: dma-apbh@33000000 {
 			clocks = <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
 		};
 
-		gpmi: nand-controller@33002000 {
+		gpmi: nand-controller@33002000{
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <0>;
+			#size-cells = <1>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.25.1

