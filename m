Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6402271C0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgGTVhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgGTVhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:37:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 384D422BEF;
        Mon, 20 Jul 2020 21:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281051;
        bh=ngBgYryhRrbUSwezXCMKxVoZ+YtUstZLZkhj22QczNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0UjyQUPINUK+aTDE3YDe/9ALKCXvL7mp1Ld2eOthebLPphlCSaQUg0ocT188wh7Rn
         1VXSKSog/8i6zjizbfx13q0XJJpEyxDswPIlX4POd7uQntOK1+73b2HYAcoHCLA2CR
         WEDPycUNW52HuCFBtidAV2BKJjk+U8Ue+T4LqUG4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Merlijn Wajer <merlijn@wizzup.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 12/40] ARM: dts: n900: remove mmc1 card detect gpio
Date:   Mon, 20 Jul 2020 17:36:47 -0400
Message-Id: <20200720213715.406997-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213715.406997-1-sashal@kernel.org>
References: <20200720213715.406997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Merlijn Wajer <merlijn@wizzup.org>

[ Upstream commit ed3e98e919aaaa47e9d9f8a40c3f6f4a22577842 ]

Instead, expose the key via the input framework, as SW_MACHINE_COVER

The chip-detect GPIO is actually detecting if the cover is closed.
Technically it's possible to use the SD card with open cover. The
only downside is risk of battery falling out and user being able
to physically remove the card.

The behaviour of SD card not being available when the device is
open is unexpected and creates more problems than it solves. There
is a high chance, that more people accidentally break their rootfs
by opening the case without physically removing the card.

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>
Link: https://lore.kernel.org/r/20200612125402.18393-3-merlijn@wizzup.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 4089d97405c95..3dbcae3d60d28 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -105,6 +105,14 @@ proximity_sensor {
 			linux,code = <SW_FRONT_PROXIMITY>;
 			linux,can-disable;
 		};
+
+		machine_cover {
+			label = "Machine Cover";
+			gpios = <&gpio6 0 GPIO_ACTIVE_LOW>; /* 160 */
+			linux,input-type = <EV_SW>;
+			linux,code = <SW_MACHINE_COVER>;
+			linux,can-disable;
+		};
 	};
 
 	isp1707: isp1707 {
@@ -819,10 +827,6 @@ &mmc1 {
 	pinctrl-0 = <&mmc1_pins>;
 	vmmc-supply = <&vmmc1>;
 	bus-width = <4>;
-	/* For debugging, it is often good idea to remove this GPIO.
-	   It means you can remove back cover (to reboot by removing
-	   battery) and still use the MMC card. */
-	cd-gpios = <&gpio6 0 GPIO_ACTIVE_LOW>; /* 160 */
 };
 
 /* most boards use vaux3, only some old versions use vmmc2 instead */
-- 
2.25.1

