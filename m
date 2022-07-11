Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502FB56FAB4
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbiGKJVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiGKJUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:20:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA0254CBC;
        Mon, 11 Jul 2022 02:12:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5F8BB80956;
        Mon, 11 Jul 2022 09:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A32C34115;
        Mon, 11 Jul 2022 09:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530759;
        bh=+L9JjLDxzqw+0yrDi4hRO6YshXQDQqOAc1leq9TyQg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4WykBUGDfTfNFOroZIM42AEi6Ocw3eimi4a9gMessokUDoJGkOc6rut/2uI2xNO3
         8XYO1BamcQiv1JmkBsFYeMQsYLgl3eUiDGDGZXLL8/u771NcjAOmWpaZX2FttqHZra
         SvBcF8jA6Kd+El6BsFi15bf7k1LLfwuIr5wCixXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/55] arm64: dts: imx8mp-evk: correct gpio-led pad settings
Date:   Mon, 11 Jul 2022 11:07:18 +0200
Message-Id: <20220711090542.651570932@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit b838582ab8d5fb11b2c0275056a9f34e1d94fece ]

0x19 is not a valid setting. According to RM bit layout,
BIT3 and BIT0 are reserved.
  8  7   6   5   4   3  2 1  0
 PE HYS PUE ODE FSEL X  DSE  X

Correct setting with PE PUE set, DSE set to 0.

Fixes: 50d336b12f34 ("arm64: dts: imx8mp-evk: Add GPIO LED support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index 5011adb5ff1f..c0663a6c8376 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -148,7 +148,7 @@
 
 	pinctrl_gpio_led: gpioledgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_NAND_READY_B__GPIO3_IO16	0x19
+			MX8MP_IOMUXC_NAND_READY_B__GPIO3_IO16	0x140
 		>;
 	};
 
-- 
2.35.1



