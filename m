Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116CB19AFF8
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387526AbgDAQWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387527AbgDAQWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:22:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F4952137B;
        Wed,  1 Apr 2020 16:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758164;
        bh=mPMg+GIZNgjPNi6MOWo6soVJy6BjBjhd20BrzjGqz2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKJ0qQ1lb5JXgoRmvkfrwJl2xBQbElKnCUQuD/mNmw3tKOFYFkQp7Jg8UqSB9Eyab
         ydybLfZacxrlu/7ZafjEogWbGX5odBskzX8VYDSyTrSzeecq1Xyf7U9j/7a/mZikMX
         QIYq85NjFwv5/VsAWSvVWeL6Bm2ONws+SZmnKdHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 5.4 25/27] ARM: dts: sun8i: r40: Move AHCI device node based on address order
Date:   Wed,  1 Apr 2020 18:17:53 +0200
Message-Id: <20200401161434.337279705@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
References: <20200401161414.352722470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

commit fe3a04824f75786e39ed74e82fb6cb2534c95fe4 upstream.

When the AHCI device node was added, it was added in the wrong location
in the device tree file. The device nodes should be sorted by register
address.

Move the device node to before EHCI1, where it belongs.

Fixes: 41c64d3318aa ("ARM: dts: sun8i: r40: add sata node")
Acked-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sun8i-r40.dtsi |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/arch/arm/boot/dts/sun8i-r40.dtsi
+++ b/arch/arm/boot/dts/sun8i-r40.dtsi
@@ -266,6 +266,16 @@
 			#phy-cells = <1>;
 		};
 
+		ahci: sata@1c18000 {
+			compatible = "allwinner,sun8i-r40-ahci";
+			reg = <0x01c18000 0x1000>;
+			interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_SATA>, <&ccu CLK_SATA>;
+			resets = <&ccu RST_BUS_SATA>;
+			reset-names = "ahci";
+			status = "disabled";
+		};
+
 		ehci1: usb@1c19000 {
 			compatible = "allwinner,sun8i-r40-ehci", "generic-ehci";
 			reg = <0x01c19000 0x100>;
@@ -557,17 +567,6 @@
 			#size-cells = <0>;
 		};
 
-		ahci: sata@1c18000 {
-			compatible = "allwinner,sun8i-r40-ahci";
-			reg = <0x01c18000 0x1000>;
-			interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&ccu CLK_BUS_SATA>, <&ccu CLK_SATA>;
-			resets = <&ccu RST_BUS_SATA>;
-			reset-names = "ahci";
-			status = "disabled";
-
-		};
-
 		gmac: ethernet@1c50000 {
 			compatible = "allwinner,sun8i-r40-gmac";
 			syscon = <&ccu>;


