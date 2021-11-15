Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F4A451E08
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349814AbhKPAew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344475AbhKOTYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D47D633DA;
        Mon, 15 Nov 2021 18:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002712;
        bh=yIzlTmEWChwZQlGr+UE5tzq2u0HIYJzQuxIIgotRxm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKEDo7NqYGYOUuhSeJfPL6gp3lDY9yiHH6/y/EmDF80wCz7S3rYgnvM+72CVqkr7F
         3/zD1RARvMmYik7ON3Tp57a07sa7zgwIdS3q6nF7RT3M+h/Y7O8QR7BqlN7FfI7wbY
         H6Qhlg93TaEls61ECf1SSLNX2ge7m6XCPHI9qi7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 636/917] ARM: dts: stm32: Reduce DHCOR SPI NOR frequency to 50 MHz
Date:   Mon, 15 Nov 2021 18:02:11 +0100
Message-Id: <20211115165450.381284021@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 2b0ac605549d7..44ecc47085871 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
@@ -202,7 +202,7 @@
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



