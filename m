Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB3B6047F9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiJSNrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233032AbiJSNqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:46:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF44113D7F;
        Wed, 19 Oct 2022 06:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE0E8B82432;
        Wed, 19 Oct 2022 08:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6508DC433D6;
        Wed, 19 Oct 2022 08:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169863;
        bh=3xApLsiBrtBLdrTTC/e7moWt4ozJ/XaI6HBikH3qPtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfazNRBnjV7mIAOs7QkD8sgANFpmJtDsQXB0utz/NdlKaw6B5qiqysaIWtPQD96yl
         bRwxHf51kLeFpUUl1yIaEbHrZfixi+fmXP7V/tvY9iNobB7XfFSOsraVlVpO7G8/bv
         PR9QYevtcFg7DYWM37bY/PGsdUCxdIJgJ2xnO2GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 437/862] arm64: dts: marvell: 98dx25xx: use correct property for i2c gpios
Date:   Wed, 19 Oct 2022 10:28:44 +0200
Message-Id: <20221019083309.295930262@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 2b14d382ec97ca5b420239ee6e16da390fab476c ]

Use the correct names for scl-gpios and sda-gpios so that the generic
i2c recovery code will find them. While we're here set the
GPIO_OPEN_DRAIN flag on the gpios.

Fixes: b795fadfc46b ("arm64: dts: marvell: Add Armada 98DX2530 SoC and RD-AC5X board")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi b/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi
index 80b44c7df56a..881bf948d1df 100644
--- a/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi
@@ -117,8 +117,8 @@
 				pinctrl-names = "default", "gpio";
 				pinctrl-0 = <&i2c0_pins>;
 				pinctrl-1 = <&i2c0_gpio>;
-				scl_gpio = <&gpio0 26 GPIO_ACTIVE_HIGH>;
-				sda_gpio = <&gpio0 27 GPIO_ACTIVE_HIGH>;
+				scl-gpios = <&gpio0 26 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+				sda-gpios = <&gpio0 27 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 				status = "disabled";
 			};
 
@@ -136,8 +136,8 @@
 				pinctrl-names = "default", "gpio";
 				pinctrl-0 = <&i2c1_pins>;
 				pinctrl-1 = <&i2c1_gpio>;
-				scl_gpio = <&gpio0 20 GPIO_ACTIVE_HIGH>;
-				sda_gpio = <&gpio0 21 GPIO_ACTIVE_HIGH>;
+				scl-gpios = <&gpio0 20 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+				sda-gpios = <&gpio0 21 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 				status = "disabled";
 			};
 
-- 
2.35.1



