Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB9D29BE41
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794375AbgJ0PLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794370AbgJ0PLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:11:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF8A820657;
        Tue, 27 Oct 2020 15:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811490;
        bh=U38pIinAUzj6lUxBuxFi6yjG8fqQCzz+IqPvS2YnehE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yht9rk+/jJKKemFCdTgSDFHpFht1ZqPxjlRYwuq46rWaMAQwQI6BiLcdU0hhWwwcJ
         7QQL7WcdUBESq5s5KQhfPEnFKaBK5GcL4+pfu30boM01T8T67HYyGyA4xeS0Ga0tl4
         QrXUvq14Pg7U0+C8B5pnBKIveeeBpcUpE+MXeV0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 510/633] ARM: dts: stm32: Swap PHY reset GPIO and TSC2004 IRQ on DHCOM SOM
Date:   Tue, 27 Oct 2020 14:54:13 +0100
Message-Id: <20201027135546.663643908@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 9ad98319e95263469d8ca2cb543c37c5a2f40980 ]

On the production revision of the SoM, 587-200, the PHY reset GPIO and
touchscreen IRQs are swapped to prevent collision between EXTi IRQs,
reflect that in DT.

Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index d30a3c60da9b0..a87ebc4843963 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -117,7 +117,7 @@ &ethernet0 {
 	max-speed = <100>;
 	phy-handle = <&phy0>;
 	st,eth-ref-clk-sel;
-	phy-reset-gpios = <&gpioh 15 GPIO_ACTIVE_LOW>;
+	phy-reset-gpios = <&gpioh 3 GPIO_ACTIVE_LOW>;
 
 	mdio0 {
 		#address-cells = <1>;
@@ -285,7 +285,7 @@ touchscreen@49 {
 		compatible = "ti,tsc2004";
 		reg = <0x49>;
 		vio-supply = <&v3v3>;
-		interrupts-extended = <&gpioh 3 IRQ_TYPE_EDGE_FALLING>;
+		interrupts-extended = <&gpioh 15 IRQ_TYPE_EDGE_FALLING>;
 	};
 
 	eeprom@50 {
-- 
2.25.1



