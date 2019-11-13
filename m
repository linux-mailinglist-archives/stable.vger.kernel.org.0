Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1D0FA417
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbfKMCNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:13:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbfKMB5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25009222CF;
        Wed, 13 Nov 2019 01:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610254;
        bh=z6dOgVCl3TOZLyykDL4voQRGMy4T9KLqzH8tX70Qm04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBJmsMUzGRm/RXJ4V+pfFIe/osyhhrdkexunCzNcQw7bQEN9IprgQgs4dSGAOgNfj
         5jeEGtsfKZsPcLYsk1ZOVrR+yZPLWVofBd3enhQTia0/sANbg4XxTiP6Yhyc3QV3ot
         R0w1Yz9pdhh24/D1PhVwgtNaUj2hu4BaY7bNlCzw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Lechner <david@lechnology.com>, Sekhar Nori <nsekhar@ti.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 050/115] ARM: dts: da850-lego-ev3: slow down A/DC as much as possible
Date:   Tue, 12 Nov 2019 20:55:17 -0500
Message-Id: <20191113015622.11592-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Lechner <david@lechnology.com>

[ Upstream commit aea4762fb46e048c059ff49565ee33da07c8aeb3 ]

Due to the electrical design of the A/DC circuits on LEGO MINDSTORMS EV3,
if we are reading analog values as fast as possible (i.e. using DMA to
service the SPI) the A/DC chip will read incorrect values - as much as
0.1V off when the SPI is running at 10MHz. (This has to do with the
capacitor charge time when channels are muxed in the A/DC.)

This patch slows down the SPI as much as possible (if CPU is at 456MHz,
SPI runs at 1/2 of that, so 228MHz and has a max prescalar of 256, so
we could get ~891kHz, but we're just rounding it to 1MHz). We also use
the max allowable value for WDELAY to slow things down even more.

These changes reduce the error of the analog values to about 5mV, which
is tolerable.

Commits a3762b13a596 ("spi: spi-davinci: Add support for SPI_CS_WORD")
and e2540da86ef8 ("iio: adc: ti-ads7950: use SPI_CS_WORD to reduce
CPU usage") introduce changes that allow DMA transfers to be used, so
this slow down is needed now.

Signed-off-by: David Lechner <david@lechnology.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/da850-lego-ev3.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/da850-lego-ev3.dts b/arch/arm/boot/dts/da850-lego-ev3.dts
index 81942ae83e1f9..fbd6d16f39a55 100644
--- a/arch/arm/boot/dts/da850-lego-ev3.dts
+++ b/arch/arm/boot/dts/da850-lego-ev3.dts
@@ -361,7 +361,8 @@
 		compatible = "ti,ads7957";
 		reg = <3>;
 		#io-channel-cells = <1>;
-		spi-max-frequency = <10000000>;
+		spi-max-frequency = <1000000>;
+		ti,spi-wdelay = <63>;
 		vref-supply = <&adc_ref>;
 	};
 };
-- 
2.20.1

