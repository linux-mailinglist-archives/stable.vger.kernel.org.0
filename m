Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB66B2C0693
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbgKWMcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731090AbgKWMca (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB42A20728;
        Mon, 23 Nov 2020 12:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134750;
        bh=fEF9kRPPCardacE5L9TP+K37eC3+sGoXEkoj/lRVbTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jo/JkEVQrbFQZKHtv2XeAYdvvZ+45SSFmHsUL6QRDPTX8V3ijbe5aDrUCWnyx2yPw
         ncUmYk6VGN+btkPKIHxyHf/693KuXJ7elifr7FwIQYcDxGtC1F9MFD3bUF8otY8dao
         KQKu1pbXF/BGvC0FONy8qe14moLbhLcnp0xIV+VA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/91] ARM: dts: sun8i: a83t: Enable both RGMII RX/TX delay on Ethernet PHY
Date:   Mon, 23 Nov 2020 13:21:58 +0100
Message-Id: <20201123121811.163725411@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 57dbe558457bf4042169bc1f334e3b53a8480a1c ]

The Ethernet PHY on the Bananapi M3 and Cubietruck Plus have the RX
and TX delays enabled on the PHY, using pull-ups on the RXDLY and
TXDLY pins.

Fix the phy-mode description to correct reflect this so that the
implementation doesn't reconfigure the delays incorrectly. This
happened with commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e
rx/tx delay config").

Fixes: 039359948a4b ("ARM: dts: sun8i: a83t: Enable Ethernet on two boards")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20201024162515.30032-6-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts     | 2 +-
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
index f250b20af4937..9be1c4a3d95fb 100644
--- a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
@@ -131,7 +131,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_sw>;
 	phy-handle = <&rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	allwinner,rx-delay-ps = <700>;
 	allwinner,tx-delay-ps = <700>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts b/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
index 7e74ba83f8095..75396993195d1 100644
--- a/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
@@ -168,7 +168,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_dldo4>;
 	phy-handle = <&rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 
-- 
2.27.0



