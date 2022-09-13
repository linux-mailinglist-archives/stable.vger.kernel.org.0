Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7955B6FE9
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiIMOUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiIMOSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:18:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0834F59262;
        Tue, 13 Sep 2022 07:13:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF56E614B5;
        Tue, 13 Sep 2022 14:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EDCC433B5;
        Tue, 13 Sep 2022 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078289;
        bh=MJsQ0W3J9r8wWRvEcJeGoG8xf58axo3OCDJZ0ZGSDR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OyNMKOY8vd72z+u+Vps88c4fHrwfQzZ5zorYJOlvhzgwno1i/wbcWz/MQoMhlGXXc
         Cr+z3o4HDaEw8RUI3776CfRaItMgasLbHLX5B0NHR0Uq/uatUxl6OGTeSBwQCQL/lY
         dxOSR32e4C6cJkUFYEKuHWLynExEyDuPe1byKxO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 083/192] arm64: dts: freescale: verdin-imx8mp: fix atmel_mxt_ts reset polarity
Date:   Tue, 13 Sep 2022 16:03:09 +0200
Message-Id: <20220913140414.096787980@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 8f143b9f3849828870bb2a7f28288095ad9a329d ]

Fix reset GPIO polarity in-line with the following commit feedaacdadfc
("Input: atmel_mxt_ts - fix up inverted RESET handler").

Fixes: a39ed23bdf6e ("arm64: dts: freescale: add initial support for verdin imx8m plus")
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
index fb17e329cd370..f5323291a9b24 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
@@ -620,7 +620,7 @@
 		interrupts = <5 IRQ_TYPE_EDGE_FALLING>;
 		reg = <0x4a>;
 		/* Verdin GPIO_2 (SODIMM 208) */
-		reset-gpios = <&gpio1 1 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 1 GPIO_ACTIVE_LOW>;
 		status = "disabled";
 	};
 };
@@ -697,7 +697,7 @@
 		pinctrl-0 = <&pinctrl_gpio_9_dsi>, <&pinctrl_i2s_2_bclk_touch_reset>;
 		reg = <0x4a>;
 		/* Verdin I2S_2_BCLK (TOUCH_RESET#, SODIMM 42) */
-		reset-gpios = <&gpio5 0 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
 		status = "disabled";
 	};
 
-- 
2.35.1



