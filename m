Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FB5450E74
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240165AbhKOSPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:15:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237879AbhKOSHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74DF4633A5;
        Mon, 15 Nov 2021 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998323;
        bh=rLY4Mke7S36U1O4oppZxQHTcYaUOjDpT7lsAxWlWmoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7tNAxdIY4dfVm/M0BDiQu0AC0d4WoltfD5+Myi0imYB+kI2VOcGG0aqIu/iOR59J
         KsH3AdxKBem3S0JwKdYPlwzrunG7s4jxaoUiZhCRoFmkTkq+plpnxvAOSOxNiOWywL
         XVfnsjt7qbcv2zE5TVffaJZgNqu5Fl1Bg+nxtiGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 435/575] ARM: dts: stm32: Reduce DHCOR SPI NOR frequency to 50 MHz
Date:   Mon, 15 Nov 2021 18:02:40 +0100
Message-Id: <20211115165358.816966209@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 2012579b31293d0a8cf2024e9dab66810bf1a15e ]

The SPI NOR is a bit further away from the SoC on DHCOR than on DHCOM,
which causes additional signal delay. At 108 MHz, this delay triggers
a sporadic issue where the first bit of RX data is not received by the
QSPI controller.

There are two options of addressing this problem, either by using the
DLYB block to compensate the extra delay, or by reducing the QSPI bus
clock frequency. The former requires calibration and that is overly
complex, so opt for the second option.

Fixes: 76045bc457104 ("ARM: dts: stm32: Add QSPI NOR on AV96")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Patrick Delaunay <patrick.delaunay@foss.st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
index a9eb82b2f1704..5af32140e128b 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
@@ -198,7 +198,7 @@
 		compatible = "jedec,spi-nor";
 		reg = <0>;
 		spi-rx-bus-width = <4>;
-		spi-max-frequency = <108000000>;
+		spi-max-frequency = <50000000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
 	};
-- 
2.33.0



