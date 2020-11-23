Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB492C0B15
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbgKWMhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:37:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731929AbgKWMhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:37:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9851020857;
        Mon, 23 Nov 2020 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135058;
        bh=eGD28M00B+3pibXdKwX85S5eI1evxINnKsxwsrI0J4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YI13a2V2AJEscrAwR1wqThg1dbZQu5nkc6dLPrX8JAgsNPa+9Vb+rqRZF1/vj9jH
         g5dgpV5vvBGC5j2fN/nfmCKJmUqqLxdgSuNgcOCGhk7BpSI7PwNtq+8Fqt/golzvva
         unFhJ5wpGELBdZl/3eywl08AJ0aGWw7420wL/2Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/158] arm64: dts: allwinner: a64: bananapi-m64: Enable RGMII RX/TX delay on PHY
Date:   Mon, 23 Nov 2020 13:21:27 +0100
Message-Id: <20201123121822.787536568@linuxfoundation.org>
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

[ Upstream commit 1a9a8910b2153cd3c4f3f2f8defcb853ead3b1fd ]

The Ethernet PHY on the Bananapi M64 has the RX and TX delays
enabled on the PHY, using pull-ups on the RXDLY and TXDLY pins.

Fix the phy-mode description to correct reflect this so that the
implementation doesn't reconfigure the delays incorrectly. This
happened with commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e
rx/tx delay config").

Fixes: e7295499903d ("arm64: allwinner: bananapi-m64: Enable dwmac-sun8i")
Fixes: 94f442886711 ("arm64: dts: allwinner: A64: Restore EMAC changes")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20201024162515.30032-10-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
index 208373efee494..7d1e89e5b1ae4 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
@@ -127,7 +127,7 @@
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&rgmii_pins>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ext_rgmii_phy>;
 	phy-supply = <&reg_dc1sw>;
 	status = "okay";
-- 
2.27.0



