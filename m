Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4579956FDB3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiGKJ7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbiGKJ7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1035063911;
        Mon, 11 Jul 2022 02:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8F1761372;
        Mon, 11 Jul 2022 09:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6390C34115;
        Mon, 11 Jul 2022 09:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531662;
        bh=XUoSAv6TxAwN+8OKNJOnZbAN/7rSjDyG73oAYspuHQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jupjsNGqxTm2ziXn1JfImzpQkdvDVRlnaUDzrbJ9YyojDUSOjIr+9dX5jH+QYq0X
         W0BvLtzYO/2jC7RjP33x7i20VmI23LIX5ijUJW2eQzvv7cgCD1wdSTLWDIKd8iKlTr
         hUxIfuED/H2LgiZr1JNGTBeb/36LaCBAFzrZNpbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/230] arm64: dts: imx8mp-evk: correct gpio-led pad settings
Date:   Mon, 11 Jul 2022 11:07:23 +0200
Message-Id: <20220711090609.412872318@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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
index 3f424a8937f1..be3b01b5e159 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -351,7 +351,7 @@
 
 	pinctrl_gpio_led: gpioledgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_NAND_READY_B__GPIO3_IO16	0x19
+			MX8MP_IOMUXC_NAND_READY_B__GPIO3_IO16	0x140
 		>;
 	};
 
-- 
2.35.1



