Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A9F2E6748
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbgL1QW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:22:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732213AbgL1NNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:13:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07E88207F7;
        Mon, 28 Dec 2020 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161157;
        bh=skuoOwSJpwvgK4geaYDxScnf+WXXOoNx3w+TgBODg2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNTlVAhHaWVBMT6sDsFbT1QzXfl4kY92a5SnmO39M7RUACnIzDc1jO6I5Veq6KOcr
         uPMMCudoOyIafw9VDoLvtsPLB5y3mmjCwaMrROQY3EGXhzCwuCEAB1R7rpnTczb42N
         iedqcj3j68LpK9xVI3KDfCq1GeUiuD61LGEWPyTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 121/242] ARM: dts: at91: at91sam9rl: fix ADC triggers
Date:   Mon, 28 Dec 2020 13:48:46 +0100
Message-Id: <20201228124910.653222850@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 851a95da583c26e2ddeb7281e9b61f0d76ea5aba ]

The triggers for the ADC were taken from at91sam9260 dtsi but are not
correct.

Fixes: a4c1d6c75822 ("ARM: at91/dt: sam9rl: add lcd, adc, usb gadget and pwm support")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201128222818.1910764-10-alexandre.belloni@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91sam9rl.dtsi | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 7768342a66385..64273f9439926 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -274,23 +274,26 @@
 				atmel,adc-use-res = "highres";
 
 				trigger0 {
-					trigger-name = "timer-counter-0";
+					trigger-name = "external-rising";
 					trigger-value = <0x1>;
+					trigger-external;
 				};
+
 				trigger1 {
-					trigger-name = "timer-counter-1";
-					trigger-value = <0x3>;
+					trigger-name = "external-falling";
+					trigger-value = <0x2>;
+					trigger-external;
 				};
 
 				trigger2 {
-					trigger-name = "timer-counter-2";
-					trigger-value = <0x5>;
+					trigger-name = "external-any";
+					trigger-value = <0x3>;
+					trigger-external;
 				};
 
 				trigger3 {
-					trigger-name = "external";
-					trigger-value = <0x13>;
-					trigger-external;
+					trigger-name = "continuous";
+					trigger-value = <0x6>;
 				};
 			};
 
-- 
2.27.0



