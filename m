Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F502C0A01
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733097AbgKWMoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730899AbgKWMow (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 808CA20888;
        Mon, 23 Nov 2020 12:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135491;
        bh=/rai50xeOA7HLIO6nuXCOz9GFE7NmCzYduUg7qqQIEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cy6s4St70S3IU5uNC8yKBp4Pi8tcTpmWx9iMWERh/Xlg+LCTmkYblVorgaCPnIFNj
         a14HzfrHhlTvrZ3heBMwff+DcjVszg8m/weeSfgR0xL5D8h1ojsjW0kHOxGME39E7P
         hU6+raAylG24NK/5JV4mFcq1WGfhyOoSXs+SvKn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 088/252] ARM: dts: sunxi: bananapi-m2-plus: Enable RGMII RX/TX delay on Ethernet PHY
Date:   Mon, 23 Nov 2020 13:20:38 +0100
Message-Id: <20201123121839.838342059@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 3914160ffc0bf762d6d605d4b27036b7b89367ea ]

The Ethernet PHY on the Bananapi M2+ has the RX and TX delays
enabled on the PHY, using pull-ups on the RXDLY and TXDLY pins.

Fix the phy-mode description to correct reflect this so that the
implementation doesn't reconfigure the delays incorrectly. This
happened with commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e
rx/tx delay config").

Fixes: 8c7ba536e709 ("ARM: sun8i: bananapi-m2-plus: Enable dwmac-sun8i")
Fixes: 4904337fe34f ("ARM: dts: sunxi: Restore EMAC changes (boards)")
Fixes: aa8fee415f46 ("ARM: dts: sun8i: h3: Split out non-SoC-specific parts of Bananapi M2 Plus")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Tested-by: Jernej Skrabec <jernej.skrabec@siol.net>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20201024162515.30032-8-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi b/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
index 39263e74fbb53..8e5cb3b3fd686 100644
--- a/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
+++ b/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
@@ -126,7 +126,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 
 	status = "okay";
 };
-- 
2.27.0



