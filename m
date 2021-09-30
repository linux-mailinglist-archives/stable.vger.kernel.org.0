Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FC441DE3C
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 17:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347514AbhI3P7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 11:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347542AbhI3P65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 11:58:57 -0400
Received: from mail.fris.de (mail.fris.de [IPv6:2a01:4f8:c2c:390b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2D5C06176A;
        Thu, 30 Sep 2021 08:57:14 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6590EBFBF7;
        Thu, 30 Sep 2021 17:57:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1633017432; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=U2BMALAc9YdZifU3ydM+t12Cr15TJPxPAwAYvhTKJRM=;
        b=wodVgWg82W0RW2jGBSZy3Ack4sv2Cq72G5mIVrY5AQJ35k/3T9npty8ZyzVC/8ZPqxFSvv
        snakMqLHd/3rCQizJL96/JJmYNhG5DFx/gPFfMPe6iDRJwD1Vz9qVAJMAcpHHSU+Sy0OqE
        7iA7/J3PUmldAmuRckRDzwJmKk2QWv0ngAZdmLhBXg+DBVBbwbJ25D30TigE2QBn6op6ib
        dNlZi1JYGMrm74YN99PkwU9wC7yUW/n4POp5na8jIT7euFvrxtlzBCfmnNxDyph8hvyfGy
        Z1YBruEXRQGjZKzqx/rViC+P6n7/nB1uFZZ6FAK/9fPuKCJ/Dl8liqi786saOg==
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
Subject: [PATCH 6/8] arm64: dts: imx8mm-kontron: Fix connection type for VSC8531 RGMII PHY
Date:   Thu, 30 Sep 2021 17:56:29 +0200
Message-Id: <20210930155633.2745201-7-frieder@fris.de>
In-Reply-To: <20210930155633.2745201-1-frieder@fris.de>
References: <20210930155633.2745201-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

Previously we falsely relied on the PHY driver to unconditionally
enable the internal RX delay. Since the following fix for the PHY
driver this is not the case anymore:

commit 7b005a1742be ("net: phy: mscc: configure both RX and TX internal
delays for RGMII")

In order to enable the delay we need to set the connection type to
"rgmii-rxid".

Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
index dbf11e03ecce..0e4509287a92 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -114,7 +114,7 @@ &ecspi3 {
 &fec1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-connection-type = "rgmii";
+	phy-connection-type = "rgmii-rxid";
 	phy-handle = <&ethphy>;
 	status = "okay";
 
-- 
2.33.0

