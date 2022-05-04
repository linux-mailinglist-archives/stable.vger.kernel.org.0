Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C336F51A7D6
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355051AbiEDRGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356210AbiEDRE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B81506CD;
        Wed,  4 May 2022 09:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2676B827A1;
        Wed,  4 May 2022 16:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6947CC385A5;
        Wed,  4 May 2022 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683236;
        bh=991+XoknVdpicnxuOhW4qb+TFA1w0TvmUm6GIvqmLoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwguSTht72eKQznb4D8QN/MsqcUc8SQmpd0alWxQbar6bMURRz7FOsgFkCqLnOKtD
         2GNqcHSraBBzR3rB+HoYu8g+REFZVwURVuHDo67S98qGF+/eckEQDlZNn2V8TSPY+w
         VNne7SYMzGteZRIm029mNvdPUWy3VRv7EsNeXYns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Max Krummenacher <max.krummenacher@toradex.com>,
        Denys Drozdov <denys.drozdov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/177] ARM: dts: imx6ull-colibri: fix vqmmc regulator
Date:   Wed,  4 May 2022 18:44:42 +0200
Message-Id: <20220504153101.063746673@linuxfoundation.org>
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

From: Max Krummenacher <max.krummenacher@toradex.com>

[ Upstream commit 45974e4276a8d6653394f66666fc57d8ffa6de9a ]

The correct spelling for the property is gpios. Otherwise, the regulator
will neither reserve nor control any GPIOs. Thus, any SD/MMC card which
can use UHS-I modes will fail.

Fixes: c2e4987e0e02 ("ARM: dts: imx6ull: add Toradex Colibri iMX6ULL support")
Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Denys Drozdov <denys.drozdov@toradex.com>
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ull-colibri.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ull-colibri.dtsi b/arch/arm/boot/dts/imx6ull-colibri.dtsi
index 0cdbf7b6e728..b6fc879e9dbe 100644
--- a/arch/arm/boot/dts/imx6ull-colibri.dtsi
+++ b/arch/arm/boot/dts/imx6ull-colibri.dtsi
@@ -37,7 +37,7 @@ reg_module_3v3_avdd: regulator-module-3v3-avdd {
 
 	reg_sd1_vmmc: regulator-sd1-vmmc {
 		compatible = "regulator-gpio";
-		gpio = <&gpio5 9 GPIO_ACTIVE_HIGH>;
+		gpios = <&gpio5 9 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_snvs_reg_sd>;
 		regulator-always-on;
-- 
2.35.1



