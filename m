Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493893137A5
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhBHP2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233883AbhBHPX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9443964F12;
        Mon,  8 Feb 2021 15:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797264;
        bh=knllIAyGDKAAm8UOv+igvPm3nf81/hPKr0A59HVe6Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfOHCqtZ+4cjjWxvND8aQmzIZI97amrlVWCIu2jNvBiElTYN+GXkGXXeIOtsK+mZf
         /pt0kdlA76TUfiRzGN5Os80+k16YB0ZHYCyKpvmSGz6CxtEC+0FXzKbXOnI4X9A32+
         UhNdCqoA/59lXyJmMy/mc82imKLqwmNlWtvG1dOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hermann Lauer <Hermann.Lauer@uni-heidelberg.de>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/120] ARM: dts: sun7i: a20: bananapro: Fix ethernet phy-mode
Date:   Mon,  8 Feb 2021 16:00:35 +0100
Message-Id: <20210208145820.341315443@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hermann Lauer <Hermann.Lauer@uni-heidelberg.de>

[ Upstream commit a900cac3750b9f0b8f5ed0503d9c6359532f644d ]

BPi Pro needs TX and RX delay for Gbit to work reliable and avoid high
packet loss rates. The realtek phy driver overrides the settings of the
pull ups for the delays, so fix this for BananaPro.

Fix the phy-mode description to correctly reflect this so that the
implementation doesn't reconfigure the delays incorrectly. This
happened with commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e
rx/tx delay config").

Fixes: 10662a33dcd9 ("ARM: dts: sun7i: Add dts file for Bananapro board")
Signed-off-by: Hermann Lauer <Hermann.Lauer@uni-heidelberg.de>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210128111842.GA11919@lemon.iwr.uni-heidelberg.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun7i-a20-bananapro.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun7i-a20-bananapro.dts b/arch/arm/boot/dts/sun7i-a20-bananapro.dts
index 01ccff756996d..5740f9442705c 100644
--- a/arch/arm/boot/dts/sun7i-a20-bananapro.dts
+++ b/arch/arm/boot/dts/sun7i-a20-bananapro.dts
@@ -110,7 +110,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-supply = <&reg_gmac_3v3>;
 	status = "okay";
 };
-- 
2.27.0



