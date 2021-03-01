Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48BD328B15
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239942AbhCAS2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:28:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239766AbhCASWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9385D65151;
        Mon,  1 Mar 2021 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618318;
        bh=54DIiQEKusXaJ/QZQfjpta6y6yypWQih5bmhYPZ3d2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FonYkfICMvs/pUaIuuiarOtKW5jtQnbuJE2CaQEOQuAPiQthfTySFwJLXtfgowKVx
         13BEuqGi5ZNPqt7dUF2RFBS5/g2QGo6NsuXgNNzMuz6Mgdv+l2wm9IcPCxOfbl2Tkt
         F42SOm4I4okbOtNB7HnIDdayS1OOj2kuDjW+vR74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/663] arm64: dts: allwinner: A64: properly connect USB PHY to port 0
Date:   Mon,  1 Mar 2021 17:04:52 +0100
Message-Id: <20210301161143.957126432@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 896f34fd9fc3a..d07cf05549c32 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
@@ -126,8 +126,6 @@
 };
 
 &ehci0 {
-	phys = <&usbphy 0>;
-	phy-names = "usb";
 	status = "okay";
 };
 
@@ -177,8 +175,6 @@
 };
 
 &ohci0 {
-	phys = <&usbphy 0>;
-	phy-names = "usb";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index dc238814013cb..15f6408e73a27 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -593,6 +593,8 @@
 				 <&ccu CLK_USB_OHCI0>;
 			resets = <&ccu RST_BUS_OHCI0>,
 				 <&ccu RST_BUS_EHCI0>;
+			phys = <&usbphy 0>;
+			phy-names = "usb";
 			status = "disabled";
 		};
 
@@ -603,6 +605,8 @@
 			clocks = <&ccu CLK_BUS_OHCI0>,
 				 <&ccu CLK_USB_OHCI0>;
 			resets = <&ccu RST_BUS_OHCI0>;
+			phys = <&usbphy 0>;
+			phy-names = "usb";
 			status = "disabled";
 		};
 
-- 
2.27.0



