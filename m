Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B806A2C9B77
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389317AbgLAJIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389310AbgLAJIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC4F820656;
        Tue,  1 Dec 2020 09:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813710;
        bh=eolXpumk6hF1HxX7zjKHOr305ikx7LoLNhCdBIZxuGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6cPk+lqpMtwLWxlsKQuN+hdJPicmLQ9D/THvrZyZ5kZHOWwZvFpTPDiUeaRD8Ijz
         IAS+Wx7UaEC8bkkjGRjbxVEJLFRl09g+hQN3UmI+gfXS5VMfzoxIUtd4f/x09GIKR4
         TQz2UrL1amUnZBPoQm30lFG2zjfhHpVN9ZuuxakY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JC Kuo <jckuo@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.9 032/152] arm64: tegra: Fix USB_VBUS_EN0 regulator on Jetson TX1
Date:   Tue,  1 Dec 2020 09:52:27 +0100
Message-Id: <20201201084716.117533922@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JC Kuo <jckuo@nvidia.com>

commit f24a2acc15bcc7bbd295f9759efc873b88fbe429 upstream.

USB host mode is broken on the OTG port of Jetson TX1 platform because
the USB_VBUS_EN0 regulator (regulator@11) is being overwritten by the
vdd-cam-1v2 regulator. This commit rearranges USB_VBUS_EN0 to be
regulator@14.

Fixes: 257c8047be44 ("arm64: tegra: jetson-tx1: Add camera supplies")
Cc: stable@vger.kernel.org
Signed-off-by: JC Kuo <jckuo@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1663,16 +1663,6 @@
 		vin-supply = <&vdd_5v0_sys>;
 	};
 
-	vdd_usb_vbus_otg: regulator@11 {
-		compatible = "regulator-fixed";
-		regulator-name = "USB_VBUS_EN0";
-		regulator-min-microvolt = <5000000>;
-		regulator-max-microvolt = <5000000>;
-		gpio = <&gpio TEGRA_GPIO(CC, 4) GPIO_ACTIVE_HIGH>;
-		enable-active-high;
-		vin-supply = <&vdd_5v0_sys>;
-	};
-
 	vdd_hdmi: regulator@10 {
 		compatible = "regulator-fixed";
 		regulator-name = "VDD_HDMI_5V0";
@@ -1712,4 +1702,14 @@
 		enable-active-high;
 		vin-supply = <&vdd_3v3_sys>;
 	};
+
+	vdd_usb_vbus_otg: regulator@14 {
+		compatible = "regulator-fixed";
+		regulator-name = "USB_VBUS_EN0";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gpio TEGRA_GPIO(CC, 4) GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+		vin-supply = <&vdd_5v0_sys>;
+	};
 };


