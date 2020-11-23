Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA57E2C0717
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731932AbgKWMh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:37:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731929AbgKWMh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:37:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 329DA2065E;
        Mon, 23 Nov 2020 12:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135044;
        bh=5ONfmuhu1eJSrJ5+DMlvqQn0ruu9+23QUEYy8h//tIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C007nIkNn6qPGPSJ5CuGHbQ/iqDYmvIdauEHzSN5M01hbJY4asGhq6aiclfATGYjR
         9TbMA0Mdt8wgjGoipsS2RCayaSmbb4TbzPcMmpjSAk2kCsfaBNW010xWKT8K8Qs5R0
         TJpD2jPUTG77IA9HdmG2Vy9IfBrPSOWj+rdk47h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/158] ARM: dts: sun9i: Enable both RGMII RX/TX delay on Ethernet PHY
Date:   Mon, 23 Nov 2020 13:21:25 +0100
Message-Id: <20201123121822.688835494@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit b1064037e8ecf09d587b7b4966eebe0c362908e5 ]

The Ethernet PHY on the Cubieboard 4 and A80 Optimus have the RX
and TX delays enabled on the PHY, using pull-ups on the RXDLY and
TXDLY pins.

Fix the phy-mode description to correct reflect this so that the
implementation doesn't reconfigure the delays incorrectly. This
happened with commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e
rx/tx delay config").

Fixes: 98048143b7f8 ("ARM: dts: sun9i: cubieboard4: Enable GMAC")
Fixes: bc9bd03a44f9 ("ARM: dts: sun9i: a80-optimus: Enable GMAC")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20201024162515.30032-7-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun9i-a80-cubieboard4.dts | 2 +-
 arch/arm/boot/dts/sun9i-a80-optimus.dts     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts b/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
index d3b337b043a15..484b93df20cb6 100644
--- a/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
+++ b/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
@@ -129,7 +129,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-supply = <&reg_cldo1>;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/sun9i-a80-optimus.dts b/arch/arm/boot/dts/sun9i-a80-optimus.dts
index bbc6335e56314..5c3580d712e40 100644
--- a/arch/arm/boot/dts/sun9i-a80-optimus.dts
+++ b/arch/arm/boot/dts/sun9i-a80-optimus.dts
@@ -124,7 +124,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-supply = <&reg_cldo1>;
 	status = "okay";
 };
-- 
2.27.0



