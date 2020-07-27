Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CAE22F04C
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbgG0OXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732070AbgG0OXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6FD12075A;
        Mon, 27 Jul 2020 14:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859803;
        bh=lPIAlXZ+TuTrN574WW+Cre/QNN//vIBP8RLlfz5OV8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TY1/rCtEq2k/6gc7XA9g0wxN4cITixU/4a2+T5fVc/6+oi3Vobq5VY5aQ6gKd/vEG
         gRyZBlpeZvk3ncvP4WfYSFOPY2d7hWbsX1NSxR7x/a1iSRvBXEPErH/8ZcJWziqW6x
         CWQ1HmT78n23ejDA7xqF4KA6XSlwwy85xMOgKjSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tony Lindgren <tony@atomide.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 111/179] ARM: dts: n900: remove mmc1 card detect gpio
Date:   Mon, 27 Jul 2020 16:04:46 +0200
Message-Id: <20200727134938.061895643@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -105,6 +105,14 @@
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
@@ -819,10 +827,6 @@
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



