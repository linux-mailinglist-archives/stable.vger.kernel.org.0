Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AF563555F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbiKWJRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiKWJQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:16:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEC310B41F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:16:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C3DC61B14
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F037C43470;
        Wed, 23 Nov 2022 09:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194975;
        bh=7SgnVAVl2NJcLcP/1kGBVDJFHN2HuOo9+hoJ77kW3xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRobX9ITPfhMSDAW61FME0/cZmg6FvYlZhuvCsT+mQQA1ZSKVxVvkPqdb+zT2450O
         JR7E39EDIh3E7n9ixD58gQkCU2Gfewhdrv9wbDplJPEtcQ8fw6U6YxZXU2WxZLCq2O
         QlbICSkR2S4RhRuGPPK4i3/0J9DvhEiEKLfqPlEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/156] arm64: dts: imx8mn: Fix NAND controller size-cells
Date:   Wed, 23 Nov 2022 09:50:52 +0100
Message-Id: <20221123084601.419449836@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

[ Upstream commit 5468e93b5b1083eaa729f98e59da18c85d9c4126 ]

The NAND controller size-cells should be 0 per DT bindings.
Fix the following warning produces by DT bindings check:
"
nand-controller@33002000: #size-cells:0:0: 0 was expected
nand-controller@33002000: Unevaluated properties are not allowed ('#address-cells', '#size-cells' were unexpected)
"

Fixes: 6c3debcbae47a ("arm64: dts: freescale: Add i.MX8MN dtsi support")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index 546511b373d4..31c017736a05 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -695,7 +695,7 @@ dma_apbh: dma-controller@33000000 {
 		gpmi: nand-controller@33002000 {
 			compatible = "fsl,imx8mn-gpmi-nand", "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.35.1



