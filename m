Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EB6869FB
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404087AbfHHTM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405023AbfHHTLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1974A21882;
        Thu,  8 Aug 2019 19:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291465;
        bh=BP/tS18VTE6N5HHmLwif1oOT9QhY3RzIxw3IeNrq2Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSipWUmv7v6CP88zMD05YornGzzGbBemXzparK2vWiTQh4qhCdXgz0Hb8qLEFCu0U
         IPoMpF3Df3t1sy3S0iCfDJS/5XIu5v1rfsabD6ymgdDuIV69Ehx8B6zw8vJngxKhXz
         J89K3wWZ5DymG+CM/cZ0ZcYFm6W37J3ORl+pRMSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/33] ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD torpedo
Date:   Thu,  8 Aug 2019 21:05:10 +0200
Message-Id: <20190808190453.732688214@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a135a392acbec7ecda782981788e8c03767a1571 ]

Since I2C1 and I2C4 have explicit pinmuxing set, let's be on the
safe side and set the pin muxing for I2C2 and I2C3.

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/logicpd-torpedo-som.dtsi b/arch/arm/boot/dts/logicpd-torpedo-som.dtsi
index cf22b35f0a289..fe4cbdc72359e 100644
--- a/arch/arm/boot/dts/logicpd-torpedo-som.dtsi
+++ b/arch/arm/boot/dts/logicpd-torpedo-som.dtsi
@@ -121,10 +121,14 @@
 };
 
 &i2c2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c2_pins>;
 	clock-frequency = <400000>;
 };
 
 &i2c3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c3_pins>;
 	clock-frequency = <400000>;
 	at24@50 {
 		compatible = "atmel,24c64";
@@ -219,6 +223,18 @@
 			OMAP3_CORE1_IOPAD(0x21bc, PIN_INPUT | MUX_MODE0)        /* i2c1_sda.i2c1_sda */
 		>;
 	};
+	i2c2_pins: pinmux_i2c2_pins {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x21be, PIN_INPUT | MUX_MODE0)	/* i2c2_scl */
+			OMAP3_CORE1_IOPAD(0x21c0, PIN_INPUT | MUX_MODE0)	/* i2c2_sda */
+		>;
+	};
+	i2c3_pins: pinmux_i2c3_pins {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x21c2, PIN_INPUT | MUX_MODE0)	/* i2c3_scl */
+			OMAP3_CORE1_IOPAD(0x21c4, PIN_INPUT | MUX_MODE0)	/* i2c3_sda */
+		>;
+	};
 };
 
 &uart2 {
-- 
2.20.1



