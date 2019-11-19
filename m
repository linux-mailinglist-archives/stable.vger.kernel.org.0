Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0F51015FF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731029AbfKSFtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:49:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731467AbfKSFtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:49:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D92B208C3;
        Tue, 19 Nov 2019 05:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142555;
        bh=ZeDtjHcS4F7h4sPEOoNT2gxFQHsLvg4xtMYXjgeG0y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9mduQ2AIwCjEa3Ri7A7LPmKrsoVgbRZk2wpkXCj4zHJGxoajBgVHaBz9FJZ2mrKQ
         zfjdShQKrUjNbg36yFD956QrvsrDg2oteYsg6TpNzX9PeDS9D5wabwQCGjFXupNzvc
         SRGGhR5BJlyowA/wHI5LQ9XIxnjatQhklvHvunjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        linux-amlogic@lists.infradead.org, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 120/239] arm64: dts: meson: Fix erroneous SPI bus warnings
Date:   Tue, 19 Nov 2019 06:18:40 +0100
Message-Id: <20191119051329.617803561@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 68ecb5c1920c5b98b1e717fd2349fba2ee5d4031 ]

dtc has new checks for SPI buses. The meson dts files have a node named
spi' which causes false positive warnings. As the node is a pinctrl child
node, change the node name to be 'spi-pins' to fix the warnings.

arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dtb: Warning (spi_bus_bridge): /soc/periphs@c8834000/pinctrl@4b0/spi: incorrect #address-cells for SPI bus

Cc: Carlo Caione <carlo@caione.org>
Cc: Kevin Hilman <khilman@baylibre.com>
Cc: linux-amlogic@lists.infradead.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index af834cdbba791..250b5c11c0e25 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -413,7 +413,7 @@
 			};
 		};
 
-		spi_pins: spi {
+		spi_pins: spi-pins {
 			mux {
 				groups = "spi_miso",
 					"spi_mosi",
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index fb8d76a17bc5d..3c30579449608 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -310,7 +310,7 @@
 			};
 		};
 
-		spi_pins: spi {
+		spi_pins: spi-pins {
 			mux {
 				groups = "spi_miso",
 					"spi_mosi",
-- 
2.20.1



