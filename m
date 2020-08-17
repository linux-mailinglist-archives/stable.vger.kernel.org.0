Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414B7247764
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732740AbgHQTsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729255AbgHQPUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:20:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FFD520729;
        Mon, 17 Aug 2020 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677614;
        bh=iMAbjkb444Fs60V9JgSpamSFR5MPp1FyaSoD1MkeyFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYekgD1VULpLFMQhO//leWFdUhWBjvss9gwF+W4a88BY5TQlw5AS9hAeW8TIEAR+H
         C3hfl18OsK8e5GaWKQcS7zETe/qCbnzwoS4Dv5rqBl7cM1GBR6BIubb9jDCqiAvE98
         iYnY8/vnHN8G6zy7vX9x+KES6Az9/8hzR1hBKCQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Delaunay <patrick.delaunay@st.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 045/464] ARM: dts: stm32: Fix spi4 pins in stm32mp15-pinctrl
Date:   Mon, 17 Aug 2020 17:09:58 +0200
Message-Id: <20200817143835.916330472@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Delaunay <patrick.delaunay@st.com>

[ Upstream commit 4fe663890ac5b3b099f458b20cce13fe8efec12b ]

Move spi4_pins_a nodes from pinctrl_z to pinctrl as the associated pins
are not in BANK Z.

Fixes: 498a7014989d ("ARM: dts: stm32: Add missing pinctrl entries for STM32MP15")

Signed-off-by: Patrick Delaunay <patrick.delaunay@st.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi | 28 ++++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi b/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
index 49132921feeb9..cc505458da2fd 100644
--- a/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
@@ -1654,6 +1654,20 @@ pins2 {
 		};
 	};
 
+	spi4_pins_a: spi4-0 {
+		pins {
+			pinmux = <STM32_PINMUX('E', 12, AF5)>, /* SPI4_SCK */
+				 <STM32_PINMUX('E', 6, AF5)>;  /* SPI4_MOSI */
+			bias-disable;
+			drive-push-pull;
+			slew-rate = <1>;
+		};
+		pins2 {
+			pinmux = <STM32_PINMUX('E', 13, AF5)>; /* SPI4_MISO */
+			bias-disable;
+		};
+	};
+
 	usart2_pins_a: usart2-0 {
 		pins1 {
 			pinmux = <STM32_PINMUX('F', 5, AF7)>, /* USART2_TX */
@@ -1776,18 +1790,4 @@ pins2 {
 			bias-disable;
 		};
 	};
-
-	spi4_pins_a: spi4-0 {
-		pins {
-			pinmux = <STM32_PINMUX('E', 12, AF5)>, /* SPI4_SCK */
-				 <STM32_PINMUX('E', 6, AF5)>;  /* SPI4_MOSI */
-			bias-disable;
-			drive-push-pull;
-			slew-rate = <1>;
-		};
-		pins2 {
-			pinmux = <STM32_PINMUX('E', 13, AF5)>; /* SPI4_MISO */
-			bias-disable;
-		};
-	};
 };
-- 
2.25.1



