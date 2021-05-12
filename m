Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7984437C3E7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhELPXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233877AbhELPVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA83461480;
        Wed, 12 May 2021 15:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832129;
        bh=4v3rkBCuDsbbtwMcWdie9KBXrc2usgDI1sWuEScRJ1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8krDiAeh6h0rexzQ00X1njITG226nyls6DsAvg+jYG4hXIbN2AIAjYZO6va9/J9t
         MKhhvIeLilR1ol3EEM2FMQS4NTrLID549toQ2NFwode4dXs2SqjO3fUKkxo6huG0Se
         90BjkfhmsQ6tnUxEO8960oazDLXgYRCoFEADLUZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Caron <valentin.caron@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/530] ARM: dts: stm32: fix usart 2 & 3 pinconf to wake up with flow control
Date:   Wed, 12 May 2021 16:44:24 +0200
Message-Id: <20210512144824.904168833@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin CARON - foss <valentin.caron@foss.st.com>

[ Upstream commit a1429f3d3029b65cd4032f6218d5290911377ce4 ]

Modify usart 2 & 3 pins to allow wake up from low power mode while the
hardware flow control is activated. UART RTS pin need to stay configure
in idle mode to receive characters in order to wake up.

Fixes: 842ed898a757 ("ARM: dts: stm32: add usart2, usart3 and uart7 pins in stm32mp15-pinctrl")

Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi b/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
index d84686e00370..dee4d32ab32c 100644
--- a/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
@@ -1806,10 +1806,15 @@
 	usart2_idle_pins_c: usart2-idle-2 {
 		pins1 {
 			pinmux = <STM32_PINMUX('D', 5, ANALOG)>, /* USART2_TX */
-				 <STM32_PINMUX('D', 4, ANALOG)>, /* USART2_RTS */
 				 <STM32_PINMUX('D', 3, ANALOG)>; /* USART2_CTS_NSS */
 		};
 		pins2 {
+			pinmux = <STM32_PINMUX('D', 4, AF7)>; /* USART2_RTS */
+			bias-disable;
+			drive-push-pull;
+			slew-rate = <3>;
+		};
+		pins3 {
 			pinmux = <STM32_PINMUX('D', 6, AF7)>; /* USART2_RX */
 			bias-disable;
 		};
@@ -1855,10 +1860,15 @@
 	usart3_idle_pins_b: usart3-idle-1 {
 		pins1 {
 			pinmux = <STM32_PINMUX('B', 10, ANALOG)>, /* USART3_TX */
-				 <STM32_PINMUX('G', 8, ANALOG)>, /* USART3_RTS */
 				 <STM32_PINMUX('I', 10, ANALOG)>; /* USART3_CTS_NSS */
 		};
 		pins2 {
+			pinmux = <STM32_PINMUX('G', 8, AF8)>; /* USART3_RTS */
+			bias-disable;
+			drive-push-pull;
+			slew-rate = <0>;
+		};
+		pins3 {
 			pinmux = <STM32_PINMUX('B', 12, AF8)>; /* USART3_RX */
 			bias-disable;
 		};
@@ -1891,10 +1901,15 @@
 	usart3_idle_pins_c: usart3-idle-2 {
 		pins1 {
 			pinmux = <STM32_PINMUX('B', 10, ANALOG)>, /* USART3_TX */
-				 <STM32_PINMUX('G', 8, ANALOG)>, /* USART3_RTS */
 				 <STM32_PINMUX('B', 13, ANALOG)>; /* USART3_CTS_NSS */
 		};
 		pins2 {
+			pinmux = <STM32_PINMUX('G', 8, AF8)>; /* USART3_RTS */
+			bias-disable;
+			drive-push-pull;
+			slew-rate = <0>;
+		};
+		pins3 {
 			pinmux = <STM32_PINMUX('B', 12, AF8)>; /* USART3_RX */
 			bias-disable;
 		};
-- 
2.30.2



