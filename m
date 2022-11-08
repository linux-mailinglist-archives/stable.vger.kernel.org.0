Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD51A62156C
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbiKHOMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiKHOLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:11:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD41C8A38
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 631536157D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0EEC433D6;
        Tue,  8 Nov 2022 14:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916683;
        bh=WxB95QSIM8FmC+vUW0/oF29LHCyD/Xez/FxhMC66PaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8zzSWwomdk3VhtB45hTHxc//9K7A+hplZl+owgrY43CXCcs4hcejO2/otvrDP4X/
         sQOJZb3yWthvVYrp7c6LqwyUvSn+xgKUAnbEfQUtYM+knVASXa2ng9LnksTI7PWxnM
         PqbM/HzH0Ko+rcVMHkay3KLzrAUz5n9NLuRyobOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Jun <jun.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 101/197] arm64: dts: imx8mn: Correct the usb power domain
Date:   Tue,  8 Nov 2022 14:38:59 +0100
Message-Id: <20221108133359.461371096@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Li Jun <jun.li@nxp.com>

[ Upstream commit ee895139a761bdb7869f9f5b9ccc19a064d0d740 ]

pgc_otg1 is actual the power domain of usb PHY, usb controller
is in hsio power domain, and pgc_otg1 is required to be powered
up to detect usb remote wakeup, so move the pgc_otg1 power domain
to the usb phy node.

Fixes: ea2b5af58ab2 ("arm64: dts: imx8mn: put USB controller into power-domains")
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index 950f432627fe..ad0b99adf691 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -1075,7 +1075,7 @@ usbotg1: usb@32e40000 {
 				assigned-clock-parents = <&clk IMX8MN_SYS_PLL2_500M>;
 				phys = <&usbphynop1>;
 				fsl,usbmisc = <&usbmisc1 0>;
-				power-domains = <&pgc_otg1>;
+				power-domains = <&pgc_hsiomix>;
 				status = "disabled";
 			};
 
@@ -1174,5 +1174,6 @@ usbphynop1: usbphynop1 {
 		assigned-clocks = <&clk IMX8MN_CLK_USB_PHY_REF>;
 		assigned-clock-parents = <&clk IMX8MN_SYS_PLL1_100M>;
 		clock-names = "main_clk";
+		power-domains = <&pgc_otg1>;
 	};
 };
-- 
2.35.1



