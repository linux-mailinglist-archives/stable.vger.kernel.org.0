Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1013A00D0
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbhFHSrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235986AbhFHSpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:45:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27A84613C0;
        Tue,  8 Jun 2021 18:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177429;
        bh=rn0ZDWajCLVB6mjeat+w3nNIyKcpESD7f63+rbmiRJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLQ7ggk5Z5sSQJYROg1aalAnP1gQ7KQg+UAqOVckoW/U64dpYO19UWC8XnZCRrZ18
         8y15nRGofdwp6RFR9lUWUfm8J1dkpM+WyEyD+Q51nZGi6DoT6iadcl8g+g/C5VLgRC
         jyAh4x+a+ykbT/JSuPCRd3vNkOV78Q1nfEAIuQ18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 49/78] ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334 switch
Date:   Tue,  8 Jun 2021 20:27:18 +0200
Message-Id: <20210608175936.936933510@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
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
@@ -99,9 +99,13 @@
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


