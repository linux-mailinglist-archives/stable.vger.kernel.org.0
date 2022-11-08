Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817EA62156B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbiKHOMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbiKHOLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:11:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D3EC8A20
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66875615B5
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A37CC433D6;
        Tue,  8 Nov 2022 14:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916677;
        bh=AtKkr/6iN2ssQ29OHf7ZNgz8aPA6+2aCQq584HXIcqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXzeV7Mv0mtdi1ndIeOvug+pIzMmqqGbWISyJ8TpYzQK3OUxa4XGT8xPh/Hxqrrl6
         1+Jbx6GbpXyFb7DbM/XfgNzYrj8JIdZfhczwBSFnekNC0/NDDEofbbsgW2F69pneVJ
         tEGMv+0Qbrm3a8VIrpBHoSxtehdcWsa+9w026uog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Jun <jun.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 099/197] arm64: dts: imx8mm: correct usb power domains
Date:   Tue,  8 Nov 2022 14:38:57 +0100
Message-Id: <20221108133359.367109438@linuxfoundation.org>
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

[ Upstream commit 4585c79ff477f9517b7f384a4fce351417e8fa36 ]

pgc_otg1/2 is actual the power domain of usb PHY, usb controller
is in hsio power domain, and pgc_otg1/2 is required to be powered
up to detect usb remote wakeup, so move the pgc_otg1/2 power domain
to the usb phy node.

Fixes: 01df28d80859 ("arm64: dts: imx8mm: put USB controllers into power-domains")
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 41204b871f4f..dabd94dc30c4 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -276,6 +276,7 @@ usbphynop1: usbphynop1 {
 		assigned-clocks = <&clk IMX8MM_CLK_USB_PHY_REF>;
 		assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_100M>;
 		clock-names = "main_clk";
+		power-domains = <&pgc_otg1>;
 	};
 
 	usbphynop2: usbphynop2 {
@@ -285,6 +286,7 @@ usbphynop2: usbphynop2 {
 		assigned-clocks = <&clk IMX8MM_CLK_USB_PHY_REF>;
 		assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_100M>;
 		clock-names = "main_clk";
+		power-domains = <&pgc_otg2>;
 	};
 
 	soc: soc@0 {
@@ -1184,7 +1186,7 @@ usbotg1: usb@32e40000 {
 				assigned-clock-parents = <&clk IMX8MM_SYS_PLL2_500M>;
 				phys = <&usbphynop1>;
 				fsl,usbmisc = <&usbmisc1 0>;
-				power-domains = <&pgc_otg1>;
+				power-domains = <&pgc_hsiomix>;
 				status = "disabled";
 			};
 
@@ -1204,7 +1206,7 @@ usbotg2: usb@32e50000 {
 				assigned-clock-parents = <&clk IMX8MM_SYS_PLL2_500M>;
 				phys = <&usbphynop2>;
 				fsl,usbmisc = <&usbmisc2 0>;
-				power-domains = <&pgc_otg2>;
+				power-domains = <&pgc_hsiomix>;
 				status = "disabled";
 			};
 
-- 
2.35.1



