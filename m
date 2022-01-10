Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FBD48920A
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbiAJHhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241510AbiAJHfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:35:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19356C028BF4;
        Sun,  9 Jan 2022 23:31:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF6E1B81205;
        Mon, 10 Jan 2022 07:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C78C36AED;
        Mon, 10 Jan 2022 07:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799867;
        bh=nbDOWtRTOobu4zr4WWANoM0fHIMn9fEz4m8CnbDXrd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bm3z1sMCYEyK1dg3ebfn2KbvWlEx2611EseJW+eyg627WF8m/rvZT/BxkN2VWFBnj
         BX2/j7eJ08FZw8PAfXXgePnf25rHhxdukBw5hR0tjC1t5XB+mVOUn8j/ADuZ0Fnpjb
         YMU9S0UHHSHVhTIULW9hO5hqRGJzhsvG4GgH1P8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Phil Elwell <phil@raspberrypi.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/43] ARM: dts: gpio-ranges property is now required
Date:   Mon, 10 Jan 2022 08:23:39 +0100
Message-Id: <20220110071818.764625175@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit c8013355ead68dce152cf426686f8a5f80d88b40 ]

Since [1], added in 5.7, the absence of a gpio-ranges property has
prevented GPIOs from being restored to inputs when released.
Add those properties for BCM283x and BCM2711 devices.

[1] commit 2ab73c6d8323 ("gpio: Support GPIO controllers without
    pin-ranges")

Link: https://lore.kernel.org/r/20220104170247.956760-1-linus.walleij@linaro.org
Fixes: 2ab73c6d8323 ("gpio: Support GPIO controllers without pin-ranges")
Fixes: 266423e60ea1 ("pinctrl: bcm2835: Change init order for gpio hogs")
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Reported-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20211206092237.4105895-3-phil@raspberrypi.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2711.dtsi | 2 ++
 arch/arm/boot/dts/bcm283x.dtsi | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dtsi
index 4ade854bdcdaf..55ec83bde5a61 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -555,6 +555,8 @@
 		     <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>,
 		     <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
 
+	gpio-ranges = <&gpio 0 0 58>;
+
 	gpclk0_gpio49: gpclk0_gpio49 {
 		pin-gpclk {
 			pins = "gpio49";
diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dtsi
index 0f3be55201a5b..ffdf7c4fba465 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -126,6 +126,8 @@
 			interrupt-controller;
 			#interrupt-cells = <2>;
 
+			gpio-ranges = <&gpio 0 0 54>;
+
 			/* Defines common pin muxing groups
 			 *
 			 * While each pin can have its mux selected
-- 
2.34.1



