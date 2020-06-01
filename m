Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17CF1EA958
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgFASA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgFASAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:00:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F14F3206E2;
        Mon,  1 Jun 2020 18:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034454;
        bh=66iuDiF/gA+232VOa28AdKQaZlJM8eguxmtMywYIR5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Un63yAKmW6eM+RISCog3uANBrnvuh94E9qLxEcoKmsANrzwTZQgqSXqPSZT7Pp6e
         X2kf9gM6WBFJgUODsM7SZx0eu1xWbeiNXY0MibPn2yz6VoQMNDqEP9ta/ohT7M9abN
         pV9/fGfZw+UzVgNo2Iw62pCwFz7s5lAb9GXsaHQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 38/77] ARM: dts: imx6q-bx50v3: Add internal switch
Date:   Mon,  1 Jun 2020 19:53:43 +0200
Message-Id: <20200601174023.316856026@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

[ Upstream commit e26dead442689a861358f33126210b0f8de615a9 ]

B850v3, B650v3 and B450v3 all have a GPIO bit banged MDIO bus to
communicate with a Marvell switch. On all devices the switch is
connected to a PCI based network card, which needs to be referenced
by DT, so this also adds the common PCI root node.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-bx50v3.dtsi | 62 +++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-bx50v3.dtsi b/arch/arm/boot/dts/imx6q-bx50v3.dtsi
index 1015e55ca8f7..8420378d095d 100644
--- a/arch/arm/boot/dts/imx6q-bx50v3.dtsi
+++ b/arch/arm/boot/dts/imx6q-bx50v3.dtsi
@@ -92,6 +92,56 @@
 		mux-int-port = <1>;
 		mux-ext-port = <4>;
 	};
+
+	aliases {
+		mdio-gpio0 = &mdio0;
+	};
+
+	mdio0: mdio-gpio {
+		compatible = "virtual,mdio-gpio";
+		gpios = <&gpio2 5 GPIO_ACTIVE_HIGH>, /* mdc */
+			<&gpio2 7 GPIO_ACTIVE_HIGH>; /* mdio */
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		switch@0 {
+			compatible = "marvell,mv88e6085"; /* 88e6240*/
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+
+			switch_ports: ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			mdio {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				switchphy0: switchphy@0 {
+					reg = <0>;
+				};
+
+				switchphy1: switchphy@1 {
+					reg = <1>;
+				};
+
+				switchphy2: switchphy@2 {
+					reg = <2>;
+				};
+
+				switchphy3: switchphy@3 {
+					reg = <3>;
+				};
+
+				switchphy4: switchphy@4 {
+					reg = <4>;
+				};
+			};
+		};
+	};
 };
 
 &ecspi5 {
@@ -326,3 +376,15 @@
 		tcxo-clock-frequency = <26000000>;
 	};
 };
+
+&pcie {
+	/* Synopsys, Inc. Device */
+	pci_root: root@0,0 {
+		compatible = "pci16c3,abcd";
+		reg = <0x00000000 0 0 0 0>;
+
+		#address-cells = <3>;
+		#size-cells = <2>;
+		#interrupt-cells = <1>;
+	};
+};
-- 
2.25.1



