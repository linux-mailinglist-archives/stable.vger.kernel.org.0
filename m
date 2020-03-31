Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161D6199129
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbgCaJRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731905AbgCaJRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:17:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29BDA20772;
        Tue, 31 Mar 2020 09:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646264;
        bh=5w5sevNTNr86mBLCTM0fpE8hoT9scPHTJ9S4JvYEowQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtR1zbAg+DubYMeRZv6veO4I5IpoP45WHbAyoAfoIvSch3DC6w4fgw5mIKwvIktnU
         ke7MEdTqIOKgeg6/5eKnNXIxtkU6AAIhZsKDjcT+cUAhOj/CuMrkNHWTRoLdppDhVQ
         uxtXU5g5CDqP4t1MIEs596Xw2XcmpF42YCSBYdg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.4 132/155] ARM: dts: sun8i-a83t-tbs-a711: Fix USB OTG mode detection
Date:   Tue, 31 Mar 2020 10:59:32 +0200
Message-Id: <20200331085433.075509569@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

commit b642d4825441bf30c72b72deb739bd2d5f53af08 upstream.

USB-ID signal has a pullup on the schematic, but in reality it's not
pulled up, so add a GPIO pullup. And we also need a usb0_vbus_power-supply
for VBUS detection.

This fixes OTG mode detection and charging issues on TBS A711 tablet.
The issues came from ID pin reading 0, causing host mode to be enabled,
when it should not be, leading to DRVVBUS being enabled, which disabled
the charger.

Fixes: f2f221c7810b824e ("ARM: dts: sun8i: a711: Enable USB OTG")
Signed-off-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts
@@ -482,7 +482,8 @@
 };
 
 &usbphy {
-	usb0_id_det-gpios = <&pio 7 11 GPIO_ACTIVE_HIGH>; /* PH11 */
+	usb0_id_det-gpios = <&pio 7 11 (GPIO_ACTIVE_HIGH | GPIO_PULL_UP)>; /* PH11 */
+	usb0_vbus_power-supply = <&usb_power_supply>;
 	usb0_vbus-supply = <&reg_drivevbus>;
 	usb1_vbus-supply = <&reg_vmain>;
 	usb2_vbus-supply = <&reg_vmain>;


