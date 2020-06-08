Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D381F2BCD
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgFHXRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730463AbgFHXRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6BA52083E;
        Mon,  8 Jun 2020 23:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658250;
        bh=APpvt+MMCcQxISVhtvO7q0OKCxYEbo4iENP+Gh1BHl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJNkZ+DBux7MEnukq6mZ0wfXkqX0J7Y5ZOw0sYxwzHUVeayW6zU3J3LcLDGTX4xIM
         z3y5iGHNnlKDHvvtamwtUtsnm6UHEcCzC9qcj+GwHlSgdenETydVP29z261SDDg8WD
         hg5kvqe/nr+l2CvoKDS12zmbAT3XO6/fwcDyW7i0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, maemo-leste@lists.dyne.org,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 260/606] ARM: dts: omap4-droid4: Fix occasional lost wakeirq for uart1
Date:   Mon,  8 Jun 2020 19:06:25 -0400
Message-Id: <20200608231211.3363633-260-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 738b150ecefbffb6e55cfa8a3b66a844f777d8fb ]

Looks like using the UART CTS pin does not always trigger for a wake-up
when the SoC is idle.

This is probably because the modem first uses gpio_149 to signal the SoC
that data will be sent, and the CTS will only get used later when the
data transfer is starting.

Let's fix the issue by configuring the gpio_149 pad as the wakeirq for
UART. We have gpio_149 managed by the USB PHY for powering up the right
USB mode, and after that, the gpio gets recycled as the modem wake-up
pin. If needeed, the USB PHY can also later on be configured to use
gpio_149 pad as the wakeirq as a shared irq.

Let's also configure the missing properties for uart-has-rtscts and
current-speed for the modem port while at it. We already configure the
hardware flow control pins with uart1_pins pinctrl setting.

Cc: maemo-leste@lists.dyne.org
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/motorola-mapphone-common.dtsi | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/motorola-mapphone-common.dtsi b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
index 01ea9a1e2c86..06fbffa81636 100644
--- a/arch/arm/boot/dts/motorola-mapphone-common.dtsi
+++ b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
@@ -723,14 +723,18 @@ &timer9 {
 };
 
 /*
- * As uart1 is wired to mdm6600 with rts and cts, we can use the cts pin for
- * uart1 wakeirq.
+ * The uart1 port is wired to mdm6600 with rts and cts. The modem uses gpio_149
+ * for wake-up events for both the USB PHY and the UART. We can use gpio_149
+ * pad as the shared wakeirq for the UART rather than the RX or CTS pad as we
+ * have gpio_149 trigger before the UART transfer starts.
  */
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart1_pins>;
 	interrupts-extended = <&wakeupgen GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH
-			       &omap4_pmx_core 0xfc>;
+			       &omap4_pmx_core 0x110>;
+	uart-has-rtscts;
+	current-speed = <115200>;
 };
 
 &uart3 {
-- 
2.25.1

