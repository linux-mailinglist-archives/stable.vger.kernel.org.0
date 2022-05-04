Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C4A51A7C7
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355199AbiEDRGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355782AbiEDREm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EBC4990C;
        Wed,  4 May 2022 09:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEACCB827AC;
        Wed,  4 May 2022 16:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766EFC385A5;
        Wed,  4 May 2022 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683201;
        bh=kPLz94WvLTpi4nn5bI9RZUlYwgXMZk6o7VGKl86N18I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lE7Og0WfdLYCti3fBza8jqt5dmhRvPuG1sq8j0qKEQGFlCMj65UmGMJq8u6Lpsh2r
         CH/mOmZ3FKz3PRCy2lGv0I2+1vWLHGOYBpix8rBpvlnnDvFNJ6kNvLr78SV9KkFeTj
         B1X9Nvlu6uuUozSUnMSb2RbDcY7+wrC82oeqJTQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajay Kathat <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/177] ARM: dts: at91: fix pinctrl phandles
Date:   Wed,  4 May 2022 18:44:19 +0200
Message-Id: <20220504153058.970518474@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 0c640d9544d0109da3889d71ae77301e556db977 ]

Commit bf781869e5cf ("ARM: dts: at91: add pinctrl-{names, 0} for all
gpios") introduces pinctrl phandles for pins used by individual
controllers to avoid failures due to commit 2ab73c6d8323 ("gpio:
Support GPIO controllers without pin-ranges"). For SPI controllers
available on SAMA5D4 and SAMA5D3 some of the pins are defined in
SoC specific dtsi on behalf of pinctrl-0. Adding extra pinctrl phandles
on board specific dts also on behalf of pinctrl-0 overwrite the pinctrl-0
phandle specified in SoC specific dtsi. Thus add the board specific
pinctrl to pinctrl-1.

Fixes: bf781869e5cf ("ARM: dts: at91: add pinctrl-{names, 0} for all gpios")
Depends-on: 5c8b49852910 ("ARM: dts: at91: sama5d4_xplained: fix pinctrl phandle name")
Reported-by: Ajay Kathat <ajay.kathat@microchip.com>
Co-developed-by: Ajay Kathat <ajay.kathat@microchip.com>
Signed-off-by: Ajay Kathat <ajay.kathat@microchip.com>
Tested-by: Ajay Kathat <ajay.kathat@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20220331141323.194355-2-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 8 ++++----
 arch/arm/boot/dts/at91-sama5d4_xplained.dts | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index d72c042f2850..a49c2966b41e 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -57,8 +57,8 @@ slot@0 {
 			};
 
 			spi0: spi@f0004000 {
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_spi0_cs>;
+				pinctrl-names = "default", "cs";
+				pinctrl-1 = <&pinctrl_spi0_cs>;
 				cs-gpios = <&pioD 13 0>, <0>, <0>, <&pioD 16 0>;
 				status = "okay";
 			};
@@ -171,8 +171,8 @@ slot@0 {
 			};
 
 			spi1: spi@f8008000 {
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_spi1_cs>;
+				pinctrl-names = "default", "cs";
+				pinctrl-1 = <&pinctrl_spi1_cs>;
 				cs-gpios = <&pioC 25 0>;
 				status = "okay";
 			};
diff --git a/arch/arm/boot/dts/at91-sama5d4_xplained.dts b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
index accb92cfac44..e519d2747936 100644
--- a/arch/arm/boot/dts/at91-sama5d4_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d4_xplained.dts
@@ -81,8 +81,8 @@ usart4: serial@fc010000 {
 			};
 
 			spi1: spi@fc018000 {
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_spi1_cs>;
+				pinctrl-names = "default", "cs";
+				pinctrl-1 = <&pinctrl_spi1_cs>;
 				cs-gpios = <&pioB 21 0>;
 				status = "okay";
 			};
-- 
2.35.1



