Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28A2328F08
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbhCATmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:42:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242085AbhCATfI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:35:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AAD061481;
        Mon,  1 Mar 2021 17:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618320;
        bh=I2rU249vd8pGI/UieVT64Y3DM2S6fBrCgGzl3YSgijs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjAXGga4m9+dEROqr1uOhU1XGOvXaFYnAOckMA1WZEKbINVaO1M0f5QCXtMYCcScT
         eIl7dgVPtKiY9flzNXLrijdnk4Zfux12ASeT2lN1hhamx1avlwQ35CbrBWuY4/go8t
         vOhAhJN2gxRXE1OBI5vNLTTUa7Rrlmcnm3vqfKqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/663] arm64: dts: allwinner: H6: properly connect USB PHY to port 0
Date:   Mon,  1 Mar 2021 17:04:53 +0100
Message-Id: <20210301161144.008494626@linuxfoundation.org>
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

[ Upstream commit da2fb8457f71138d455cba82edec0d34f858e506 ]

In recent Allwinner SoCs the first USB host controller (HCI0) shares
the first PHY with the MUSB controller. Probably to make this sharing
work, we were avoiding to declare this in the DT. This has two
shortcomings:
- U-Boot (which uses the same .dts) cannot use this port in host mode
  without a PHY linked, so we were loosing one USB port there.
- It requires the MUSB driver to be enabled and loaded, although we
  don't actually use it.

To avoid those issues, let's add this PHY link to the H6 .dtsi file.
After all PHY port 0 *is* connected to HCI0, so we should describe
it as this.

This makes it work in U-Boot, also improves compatiblity when no MUSB
driver is loaded (for instance in distribution installers).

Fixes: eabb3d424b6d ("arm64: dts: allwinner: h6: add USB2-related device nodes")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210113152630.28810-3-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 28c77d6872f64..0361f5f467093 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -667,6 +667,8 @@
 				 <&ccu CLK_USB_OHCI0>;
 			resets = <&ccu RST_BUS_OHCI0>,
 				 <&ccu RST_BUS_EHCI0>;
+			phys = <&usb2phy 0>;
+			phy-names = "usb";
 			status = "disabled";
 		};
 
@@ -677,6 +679,8 @@
 			clocks = <&ccu CLK_BUS_OHCI0>,
 				 <&ccu CLK_USB_OHCI0>;
 			resets = <&ccu RST_BUS_OHCI0>;
+			phys = <&usb2phy 0>;
+			phy-names = "usb";
 			status = "disabled";
 		};
 
-- 
2.27.0



