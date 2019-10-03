Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7160ECA4E1
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389865AbfJCQ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391568AbfJCQ3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:29:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E89621783;
        Thu,  3 Oct 2019 16:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120138;
        bh=Obtjp4ZwBmT/y2TVxxCzMnVGIK54jgwwUKhCZT0umyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlTq8/8Tkb4uXMQMqs0LuhZc/GbaBcY64rA+8U7p+hotMlDBfEG0SCfDgDZVJIQt4
         8+hYYy8MhVCVp806bqRzzOLnpZ0kR+d+j7MfxnUeZelZVa3UYM2lm4UCgAPwXoPxGr
         a3j3wF88smBNfu3Ozi7H4giIPr3XP9IkYzWkA7ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9=20Draszik?= <git@andred.net>,
        Ilya Ledvich <ilya@compulab.co.il>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 110/313] ARM: dts: imx7d: cl-som-imx7: make ethernet work again
Date:   Thu,  3 Oct 2019 17:51:28 +0200
Message-Id: <20191003154543.679087746@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: André Draszik <git@andred.net>

[ Upstream commit 9846a4524ac90b63496580b7ad50674b40d92a8f ]

Recent changes to the atheros at803x driver caused
ethernet to stop working on this board.
In particular commit 6d4cd041f0af
("net: phy: at803x: disable delay only for RGMII mode")
and commit cd28d1d6e52e
("net: phy: at803x: Disable phy delay for RGMII mode")
fix the AR8031 driver to configure the phy's (RX/TX)
delays as per the 'phy-mode' in the device tree.

This now prevents ethernet from working on this board.

It used to work before those commits, because the
AR8031 comes out of reset with RX delay enabled, and
the at803x driver didn't touch the delay configuration
at all when "rgmii" mode was selected, and because
arch/arm/mach-imx/mach-imx7d.c:ar8031_phy_fixup()
unconditionally enables TX delay.

Since above commits ar8031_phy_fixup() also has no
effect anymore, and the end-result is that all delays
are disabled in the phy, no ethernet.

Update the device tree to restore functionality.

Signed-off-by: André Draszik <git@andred.net>
CC: Ilya Ledvich <ilya@compulab.co.il>
CC: Igor Grinberg <grinberg@compulab.co.il>
CC: Rob Herring <robh+dt@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Shawn Guo <shawnguo@kernel.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>
CC: Pengutronix Kernel Team <kernel@pengutronix.de>
CC: Fabio Estevam <festevam@gmail.com>
CC: NXP Linux Team <linux-imx@nxp.com>
CC: devicetree@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d-cl-som-imx7.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx7d-cl-som-imx7.dts b/arch/arm/boot/dts/imx7d-cl-som-imx7.dts
index e61567437d73c..62d5e9a4a7818 100644
--- a/arch/arm/boot/dts/imx7d-cl-som-imx7.dts
+++ b/arch/arm/boot/dts/imx7d-cl-som-imx7.dts
@@ -44,7 +44,7 @@
 			  <&clks IMX7D_ENET1_TIME_ROOT_CLK>;
 	assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_100M_CLK>;
 	assigned-clock-rates = <0>, <100000000>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ethphy0>;
 	fsl,magic-packet;
 	status = "okay";
@@ -70,7 +70,7 @@
 			  <&clks IMX7D_ENET2_TIME_ROOT_CLK>;
 	assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_100M_CLK>;
 	assigned-clock-rates = <0>, <100000000>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ethphy1>;
 	fsl,magic-packet;
 	status = "okay";
-- 
2.20.1



