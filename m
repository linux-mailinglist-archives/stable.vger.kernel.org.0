Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED9B87BBE
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407134AbfHINqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407126AbfHINqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1E75217F4;
        Fri,  9 Aug 2019 13:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358407;
        bh=ma+mZME1eL4s4q+6ed79DtazfhXJ2ZOqTRD0lvixRDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWq4Cp0rOJcCl2IpXZ8yo10DvhyzUXmEV+QzMr1s4XZK/Cdgo6ZeHCNITkewLU5Nv
         p1wWh5tkzUWq8owUhvLoW+lFph2C4eua2AGy+s3WfTKTMyuhSaCjstazvR3famSmYZ
         0t5f9AUUN86oYMDa0llTZUdgYC1XMsgrpGDlo+hY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 04/32] ARM: dts: logicpd-som-lv: Fix Audio Mute
Date:   Fri,  9 Aug 2019 15:45:07 +0200
Message-Id: <20190809133923.097185288@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 95e59fc3c3fa3187a07a75f40b21637deb4bd12d ]

The Audio has worked, but the mute pin has a weak pulldown which alows
some of the audio signal to pass very quietly.  This patch fixes
that so the mute pin is actively driven high for mute or low for normal
operation.

Fixes: ab8dd3aed011 ("ARM: DTS: Add minimal Support for Logic
PD DM3730 SOM-LV")

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/logicpd-som-lv.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/logicpd-som-lv.dtsi b/arch/arm/boot/dts/logicpd-som-lv.dtsi
index 43035cb71cbee..f82f193b88569 100644
--- a/arch/arm/boot/dts/logicpd-som-lv.dtsi
+++ b/arch/arm/boot/dts/logicpd-som-lv.dtsi
@@ -108,6 +108,7 @@
 		twl_audio: audio {
 			compatible = "ti,twl4030-audio";
 			codec {
+				ti,hs_extmute_gpio = <&gpio2 25 GPIO_ACTIVE_HIGH>;
 			};
 		};
 	};
@@ -225,6 +226,7 @@
 		pinctrl-single,pins = <
 			OMAP3_CORE1_IOPAD(0x21ba, PIN_INPUT | MUX_MODE0)        /* i2c1_scl.i2c1_scl */
 			OMAP3_CORE1_IOPAD(0x21bc, PIN_INPUT | MUX_MODE0)        /* i2c1_sda.i2c1_sda */
+			OMAP3_CORE1_IOPAD(0x20ba, PIN_OUTPUT | MUX_MODE4)        /* gpmc_ncs6.gpio_57 */
 		>;
 	};
 };
-- 
2.20.1



