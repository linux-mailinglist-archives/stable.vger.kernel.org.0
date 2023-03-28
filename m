Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417586CC3C5
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbjC1O5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbjC1O5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:57:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD03EE061
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7669AB81D75
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7B2C433EF;
        Tue, 28 Mar 2023 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015437;
        bh=6PzF22KeicrrdyoEVT6KdM0Qb4ODHtE99hoY+gMW4OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPieMxNbZI54mZwk2+VCBaUO2UOj4ncGS0PgMcTyTcjj0MKvxk1w/3eF+/ikidwyC
         SfsF7sBtiyCl6TEQ6p8N2Qf0C/Rmx/TWqFq9TxTIfROzM+dP39FP/VQEKoTYAJB8/D
         rfDoea2oGNObMMSUwvDE+lVTbu3jb+pj0IYLJvP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Halaney <ahalaney@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/224] arm64: dts: imx8dxl-evk: Fix eqos phy reset gpio
Date:   Tue, 28 Mar 2023 16:40:14 +0200
Message-Id: <20230328142618.025827374@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit feafeb53140af3cde3fba46b292b15b3a0c0635c ]

The deprecated property is named snps,reset-gpio, but this devicetree
used snps,reset-gpios instead which results in the reset not being used
and the following make dtbs_check error:

    ./arch/arm64/boot/dts/freescale/imx8dxl-evk.dtb: ethernet@5b050000: 'snps,reset-gpio' is a dependency of 'snps,reset-delays-us'
        From schema: ./Documentation/devicetree/bindings/net/snps,dwmac.yaml

Use the preferred method of defining the reset gpio in the phy node
itself. Note that this drops the 10 us pre-delay, but prior this wasn't
used at all and a pre-delay doesn't make much sense in this context so
it should be fine.

Fixes: 8dd495d12374 ("arm64: dts: freescale: add support for i.MX8DXL EVK board")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
index 96f5947ed5f41..3af4c76369741 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -99,8 +99,6 @@ &eqos {
 	phy-handle = <&ethphy0>;
 	nvmem-cells = <&fec_mac1>;
 	nvmem-cell-names = "mac-address";
-	snps,reset-gpios = <&pca6416_1 2 GPIO_ACTIVE_LOW>;
-	snps,reset-delays-us = <10 20 200000>;
 	status = "okay";
 
 	mdio {
@@ -114,6 +112,9 @@ ethphy0: ethernet-phy@0 {
 			eee-broken-1000t;
 			qca,disable-smarteee;
 			qca,disable-hibernation-mode;
+			reset-gpios = <&pca6416_1 2 GPIO_ACTIVE_LOW>;
+			reset-assert-us = <20>;
+			reset-deassert-us = <200000>;
 			vddio-supply = <&vddio0>;
 
 			vddio0: vddio-regulator {
-- 
2.39.2



