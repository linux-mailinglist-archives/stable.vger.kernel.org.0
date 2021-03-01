Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89730328620
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbhCARE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236095AbhCAQ6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:58:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11B9464F69;
        Mon,  1 Mar 2021 16:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616614;
        bh=WWpvUeiJ4x0X/sK/Q7KMZF3lAGhB4Y0YBO+f7xeN85o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASvCsBeerSmHbYCkkFNxV8DbEBuaxKI4CIScds/kK3VKhpUkYcKHFXpLB1f3AX6PB
         Y1Yo6kR2AXK9jucaXO7087LicQrA41o2BqrWioga87+CIrZ33gC5hqoGDB63k81EUd
         W6IKh+OSERVGEF2JTKpF/5bOWHubMMHg8G+lCVsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/247] arm64: dts: allwinner: A64: properly connect USB PHY to port 0
Date:   Mon,  1 Mar 2021 17:10:56 +0100
Message-Id: <20210301161033.450994600@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit cc72570747e43335f4933a24dd74d5653639176a ]

In recent Allwinner SoCs the first USB host controller (HCI0) shares
the first PHY with the MUSB controller. Probably to make this sharing
work, we were avoiding to declare this in the DT. This has two
shortcomings:
- U-Boot (which uses the same .dts) cannot use this port in host mode
  without a PHY linked, so we were loosing one USB port there.
- It requires the MUSB driver to be enabled and loaded, although we
  don't actually use it.

To avoid those issues, let's add this PHY link to the A64 .dtsi file.
After all PHY port 0 *is* connected to HCI0, so we should describe
it as this. Remove the part from the Pinebook DTS which already had
this property.

This makes it work in U-Boot, also improves compatiblity when no MUSB
driver is loaded (for instance in distribution installers).

Fixes: dc03a047df1d ("arm64: allwinner: a64: add EHCI0/OHCI0 nodes to A64 DTSI")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210113152630.28810-2-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts | 4 ----
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi         | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
index 897e60cbe38d1..b2f0729d92d2c 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
@@ -67,8 +67,6 @@
 };
 
 &ehci0 {
-	phys = <&usbphy 0>;
-	phy-names = "usb";
 	status = "okay";
 };
 
@@ -115,8 +113,6 @@
 };
 
 &ohci0 {
-	phys = <&usbphy 0>;
-	phy-names = "usb";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 7abc4ea305410..47949f14c49f4 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -312,6 +312,8 @@
 				 <&ccu CLK_USB_OHCI0>;
 			resets = <&ccu RST_BUS_OHCI0>,
 				 <&ccu RST_BUS_EHCI0>;
+			phys = <&usbphy 0>;
+			phy-names = "usb";
 			status = "disabled";
 		};
 
@@ -322,6 +324,8 @@
 			clocks = <&ccu CLK_BUS_OHCI0>,
 				 <&ccu CLK_USB_OHCI0>;
 			resets = <&ccu RST_BUS_OHCI0>;
+			phys = <&usbphy 0>;
+			phy-names = "usb";
 			status = "disabled";
 		};
 
-- 
2.27.0



