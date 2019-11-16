Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B263BFF2CD
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfKPQV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:21:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728738AbfKPPnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:31 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E157320815;
        Sat, 16 Nov 2019 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919011;
        bh=v07zbc7vShP28g0iL9bjsCC4WxDrC1Mp4bhpHU4L4qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEK037BfSHhBFty++qGjzYyEQu/KxU+dCxUTFzIYt712bIc5dfalT6V9NYgThTMP0
         dV/sfWPggheOVOCP4EQ++7Zq4tOT0hZ6Qba6WGY2rM0scwqFoxA4wLVF0sJkMok/Ge
         IrfsKevIYM8keufkBpo+6o0wJbfM6ys7oAJC5xjU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keiji Hayashibara <hayashibara.keiji@socionext.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 115/237] spi: uniphier: fix incorrect property items
Date:   Sat, 16 Nov 2019 10:39:10 -0500
Message-Id: <20191116154113.7417-115-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keiji Hayashibara <hayashibara.keiji@socionext.com>

[ Upstream commit 3511ba7d4ca6f39e2d060bb94e42a41ad1fee7bf ]

This commit fixes incorrect property because it was different
from the actual.
The parameters of '#address-cells' and '#size-cells' were removed,
and 'interrupts', 'pinctrl-names' and 'pinctrl-0' were added.

Fixes: 4dcd5c2781f3 ("spi: add DT bindings for UniPhier SPI controller")
Signed-off-by: Keiji Hayashibara <hayashibara.keiji@socionext.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/spi/spi-uniphier.txt       | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-uniphier.txt b/Documentation/devicetree/bindings/spi/spi-uniphier.txt
index 504a4ecfc7b16..b04e66a52de5d 100644
--- a/Documentation/devicetree/bindings/spi/spi-uniphier.txt
+++ b/Documentation/devicetree/bindings/spi/spi-uniphier.txt
@@ -5,18 +5,20 @@ UniPhier SoCs have SCSSI which supports SPI single channel.
 Required properties:
  - compatible: should be "socionext,uniphier-scssi"
  - reg: address and length of the spi master registers
- - #address-cells: must be <1>, see spi-bus.txt
- - #size-cells: must be <0>, see spi-bus.txt
- - clocks: A phandle to the clock for the device.
- - resets: A phandle to the reset control for the device.
+ - interrupts: a single interrupt specifier
+ - pinctrl-names: should be "default"
+ - pinctrl-0: pin control state for the default mode
+ - clocks: a phandle to the clock for the device
+ - resets: a phandle to the reset control for the device
 
 Example:
 
 spi0: spi@54006000 {
 	compatible = "socionext,uniphier-scssi";
 	reg = <0x54006000 0x100>;
-	#address-cells = <1>;
-	#size-cells = <0>;
+	interrupts = <0 39 4>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_spi0>;
 	clocks = <&peri_clk 11>;
 	resets = <&peri_rst 11>;
 };
-- 
2.20.1

