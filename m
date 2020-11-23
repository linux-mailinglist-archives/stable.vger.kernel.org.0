Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243F92C0694
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgKWMce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:32:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731086AbgKWMcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 510382076E;
        Mon, 23 Nov 2020 12:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134752;
        bh=i0JLtIsLsB60KnJBANGpwL95XLftI2liUKtcr7CUQEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LILBMYfIZ8mejlgND2bKcQDEi0ZsZp4NhVLdUev/wpRYDZN0+T8u+RhCogfrEKddR
         8/DIkcTo0epq9bPOZtNKTJYz0em/f67XknzStPMW889QV8g9BPrI6fBgsfGzlHgSj5
         FtyoFl8KiBrzpWEHLfAPB2RVw8mo9C8VcJp2AOto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/91] arm64: dts: allwinner: a64: bananapi-m64: Enable RGMII RX/TX delay on PHY
Date:   Mon, 23 Nov 2020 13:21:59 +0100
Message-Id: <20201123121811.212732948@linuxfoundation.org>
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
index 094cfed13df97..13ce24e922eea 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-bananapi-m64.dts
@@ -97,7 +97,7 @@
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



