Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070632C06E4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731570AbgKWMfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731564AbgKWMfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:35:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 771C72065E;
        Mon, 23 Nov 2020 12:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134937;
        bh=T9PqBdyYdqYlCNxWCfEOekEaHTaHKDdc4s99GtrsAlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1K1Uhn9E5cDSwJvlELGTjVQVReJXcJbg3N0JMZ/NM69ceYyND0u0iAix+GHXs580
         yIV6chYZkShReB9xqZgB9dpKsGxIKcRnPR8fNRpc6BMMOD1gIMFL5IeUXPTMq80W4J
         oDjlscShE6QMp6T4UOvr1UykI1AS5AqpBSVl9V2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/158] arm64: dts: allwinner: beelink-gs1: Enable both RGMII RX/TX delay
Date:   Mon, 23 Nov 2020 13:21:13 +0100
Message-Id: <20201123121822.103712706@linuxfoundation.org>
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

From: Clément Péron <peron.clem@gmail.com>

[ Upstream commit 97a38c1c213b162aa577299de698f39c18ba696b ]

Before the commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx
delay config"), the software overwrite for RX/TX delays of the RTL8211e
were not working properly and the Beelink GS1 had both RX/TX delay of RGMII
interface set using pull-up on the TXDLY and RXDLY pins.

Now that these delays are working properly they overwrite the HW
config and set this to 'rgmii' meaning no delay on both RX/TX.
This makes the ethernet of this board not working anymore.

Set the phy-mode to 'rgmii-id' meaning RGMII with RX/TX delays
in the device-tree to keep the correct configuration.

Fixes: 089bee8dd119 ("arm64: dts: allwinner: h6: Introduce Beelink GS1 board")
Signed-off-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20201018172409.1754775-1-peron.clem@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
index 1d05d570142fa..0a04730960fcb 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
@@ -83,7 +83,7 @@
 &emac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&ext_rgmii_pins>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ext_rgmii_phy>;
 	phy-supply = <&reg_aldo2>;
 	status = "okay";
-- 
2.27.0



