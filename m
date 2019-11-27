Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C2610BA30
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfK0VAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731589AbfK0VAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:00:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC66A21555;
        Wed, 27 Nov 2019 21:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888438;
        bh=v07zbc7vShP28g0iL9bjsCC4WxDrC1Mp4bhpHU4L4qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4XTPtnORpz2IE5GL9VsQwxlIQwea/ox6Lx1m+2g8zcr6B3wqBoGv6FLNj6tbW/Qn
         iJCaGed6Htw9rV6eQ2SWIMhxqN0OsYEZMBbO8d08K4V+sn5qKmVvSfWRrB6/3DI7Wa
         nMwXS9Yr5A8QyWwemSvxlDXv12GlCC5APJSd8Qsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Keiji Hayashibara <hayashibara.keiji@socionext.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/306] spi: uniphier: fix incorrect property items
Date:   Wed, 27 Nov 2019 21:29:43 +0100
Message-Id: <20191127203124.787458611@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



