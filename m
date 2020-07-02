Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31782118C0
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgGBB0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729133AbgGBB0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:26:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E3F320899;
        Thu,  2 Jul 2020 01:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653178;
        bh=7unQuD6RQF9evWNzPIBBNm4pqs2Zj8iAyTBFtKok13Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMZXpvCI3c2PeSERQiIM1IinkpuoWQWaQF8dALoINsLkpvoK9VGmFv1rFtGOcGee7
         djAMkQy9zcDSVR81ccY0FUjZWEeFL0dgrWBuoC6w96V0jsAx+MQyWSzq4oCnfi7o6l
         h/pMtsBUCh2soORxPJ2z/ZlHtFF1GXLui2DaW/TM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, maemo-leste@lists.dyne.org,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/27] ARM: dts: omap4-droid4: Fix spi configuration and increase rate
Date:   Wed,  1 Jul 2020 21:25:50 -0400
Message-Id: <20200702012615.2701532-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012615.2701532-1-sashal@kernel.org>
References: <20200702012615.2701532-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 0df12a01f4857495816b05f048c4c31439446e35 ]

We can currently sometimes get "RXS timed out" errors and "EOT timed out"
errors with spi transfers.

These errors can be made easy to reproduce by reading the cpcap iio
values in a loop while keeping the CPUs busy by also reading /dev/urandom.

The "RXS timed out" errors we can fix by adding spi-cpol and spi-cpha
in addition to the spi-cs-high property we already have.

The "EOT timed out" errors we can fix by increasing the spi clock rate
to 9.6 MHz. Looks similar MC13783 PMIC says it works at spi clock rates
up to 20 MHz, so let's assume we can pick any rate up to 20 MHz also
for cpcap.

Cc: maemo-leste@lists.dyne.org
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi b/arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi
index f57acf8f66b95..75de8134b1d1f 100644
--- a/arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi
+++ b/arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi
@@ -16,8 +16,10 @@ cpcap: pmic@0 {
 		#interrupt-cells = <2>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		spi-max-frequency = <3000000>;
+		spi-max-frequency = <9600000>;
 		spi-cs-high;
+		spi-cpol;
+		spi-cpha;
 
 		cpcap_adc: adc {
 			compatible = "motorola,mapphone-cpcap-adc";
-- 
2.25.1

