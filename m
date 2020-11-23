Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EA22C07DE
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbgKWMoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730904AbgKWMoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FA2620857;
        Mon, 23 Nov 2020 12:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135493;
        bh=Pld0y+BpjrJ3AOaf36DmjLFIQv6GGI7xcnt001j928o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=meDIsjw91+VekyqkWRSlSS8ZDVwoto4hM6nvLte6u4JDlih8gcig38A9KvSZcVRei
         IbzkNK0Cgs6mVB1fI0q8tcexywzCBtju22iCr7Y/jEyzL8GXWchSMYmENPKgH8hllk
         ssF6iYy+/DM8xs9VU6be6pmq3N3tsBxyDd5u8wN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 089/252] arm64: dts: allwinner: h5: libretech-all-h5-cc: Enable RGMII RX/TX delay on PHY
Date:   Mon, 23 Nov 2020 13:20:39 +0100
Message-Id: <20201123121839.886769195@linuxfoundation.org>
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

[ Upstream commit 2bd8570d20c88909b8be3251727a26476b02652c ]

The Ethernet PHY on the Libre Computer ALL-H5-CC has the RX and TX
delays enabled on the PHY, using pull-ups on the RXDLY and TXDLY pins.

Fix the phy-mode description to correct reflect this so that the
implementation doesn't reconfigure the delays incorrectly. This
happened with commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e
rx/tx delay config").

Fixes: 60d0426d7603 ("arm64: dts: allwinner: h5: Add Libre Computer ALL-H5-CC H5 board")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20201024162515.30032-9-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts
index df1b9263ad0e2..6e30a564c87f6 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-libretech-all-h5-cc.dts
@@ -36,7 +36,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	/delete-property/ allwinner,leds-active-low;
 	status = "okay";
 };
-- 
2.27.0



