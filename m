Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF722649FC2
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiLLNOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiLLNOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:14:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD032DA
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:14:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FCFEB80D36
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F88FC433D2;
        Mon, 12 Dec 2022 13:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850858;
        bh=VtH8VJ61uSnvgAe5z1cros6jyaW4NSe3Lgq/hHLQtBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PaALQ677iAK31gacN55eOywLjAt6dQG6JMURFVVSmI91ljKc0vrfCUNQn5RIC23Z+
         ckwYUhWf/FVfMG0ga5ILNnLcmt2HHQSBLhjis3G/qOqAwQCvr0s84T3W79LCPrTsg/
         wQe4qt+IBkNiKS1sRn9AnTg0W9VHjmWk98c3B0Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 046/106] Revert "ARM: dts: imx7: Fix NAND controller size-cells"
Date:   Mon, 12 Dec 2022 14:09:49 +0100
Message-Id: <20221212130926.866020798@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit ef19964da8a668c683f1d38274f6fb756e047945 upstream.

This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.

It introduced a boot regression on colibri-imx7, and potentially any
other i.MX7 boards with MTD partition list generated into the fdt by
U-Boot.

While the commit we are reverting here is not obviously wrong, it fixes
only a dt binding checker warning that is non-functional, while it
introduces a boot regression and there is no obvious fix ready.

Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com/
Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx7s.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1221,10 +1221,10 @@
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


