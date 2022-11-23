Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071576355CF
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbiKWJX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237596AbiKWJXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:23:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D5010CEBE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:22:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6667B81EF6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D087BC433D7;
        Wed, 23 Nov 2022 09:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195339;
        bh=nvZTrhBnXULaYIkh0utOzkLR4LyToGCZxO6bBva3D04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hes1FV649gsBoVRMpN8/OnSAdZII3e58O+aBuIeboFC/51Oak0+4CjzOShlTyjQAm
         4z2WZo4n74vCS3q+i7p6VTVAp1hpeFymQAJPC/ClqNzU80kn+F6H55N6hEyBBOZ7ci
         liVAwbIOqEddANEG5TqVdClPQCIuCOhjAJAcEGTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/149] ARM: dts: imx7: Fix NAND controller size-cells
Date:   Wed, 23 Nov 2022 09:50:38 +0100
Message-Id: <20221123084559.902834055@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 753395ea1e45c724150070b5785900b6a44bd5fb ]

The NAND controller size-cells should be 0 per DT bindings.
Fix the following warning produces by DT bindings check:
"
nand-controller@33002000: #size-cells:0:0: 0 was expected
nand-controller@33002000: Unevaluated properties are not allowed ('#address-cells', '#size-cells' were unexpected)
"
Fix the missing space in node name too.

Fixes: e7495a45a76de ("ARM: dts: imx7: add GPMI NAND and APBH DMA")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 9e1b0af0aa43..e4ff47110a96 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1221,10 +1221,10 @@ dma_apbh: dma-apbh@33000000 {
 			clocks = <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
 		};
 
-		gpmi: nand-controller@33002000{
+		gpmi: nand-controller@33002000 {
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.35.1



