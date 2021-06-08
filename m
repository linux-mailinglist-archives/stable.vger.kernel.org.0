Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449893A0233
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbhFHTBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236659AbhFHS6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:58:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D7776162C;
        Tue,  8 Jun 2021 18:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177788;
        bh=nZrT3fieOAgx0W68wom3CT2u2lo1QSQHplfGTL3oKaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GN8GNGe0cgg3VqLpBGN/DjOe5c1DwXl2CtxSnzvCav/4LWwqjlqta+61SZBrSw+uy
         no3kD0f3OApJhdHnzMC+/E9XkkD67NumxTvMypF5KdGUoedQzNYX+QomLCQs+YOiXn
         X3/TlW6pFFTHrrzNwpuX+WooM+ciEd1RRLkaFntI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.10 100/137] ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334 switch
Date:   Tue,  8 Jun 2021 20:27:20 +0200
Message-Id: <20210608175945.770367479@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
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


