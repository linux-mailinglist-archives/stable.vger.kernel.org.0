Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992D63A0358
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbhFHTQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237000AbhFHTOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:14:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C976195E;
        Tue,  8 Jun 2021 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178204;
        bh=nZrT3fieOAgx0W68wom3CT2u2lo1QSQHplfGTL3oKaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaEFsejSRrjbg9GQBB2zOQLS+kDRmnoJhiN6oqAYvDybOCwilTvkYJMpkQ2bZRyrh
         YsPepaJR4NAmZY+HSOcPAKW5hAAP58lDOxS8bk7uDTw/RIIJNXzJ7Xd8mmjGZiiHHX
         sU6T+P3ttvxMcup9QTjc+vjWycyi686n1M1+3ddY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.12 114/161] ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334 switch
Date:   Tue,  8 Jun 2021 20:27:24 +0200
Message-Id: <20210608175949.311455757@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Vokáč <michal.vokac@ysoft.com>

commit 0e4a4a08cd78efcaddbc2e4c5ed86b5a5cb8a15e upstream.

The FEC does not have a PHY so it should not have a phy-handle. It is
connected to the switch at RGMII level so we need a fixed-link sub-node
on both ends.

This was not a problem until the qca8k.c driver was converted to PHYLINK
by commit b3591c2a3661 ("net: dsa: qca8k: Switch to PHYLINK instead of
PHYLIB"). That commit revealed the FEC configuration was not correct.

Fixes: 87489ec3a77f ("ARM: dts: imx: Add Y Soft IOTA Draco, Hydra and Ursa boards")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6dl-yapp4-common.dtsi |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
+++ b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
@@ -105,9 +105,13 @@
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
 	phy-reset-duration = <20>;
 	phy-supply = <&sw2_reg>;
-	phy-handle = <&ethphy0>;
 	status = "okay";
 
+	fixed-link {
+		speed = <1000>;
+		full-duplex;
+	};
+
 	mdio {
 		#address-cells = <1>;
 		#size-cells = <0>;


