Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C6D6AE85A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCGRPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjCGROz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179F192BEA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2A33B8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEF0C433EF;
        Tue,  7 Mar 2023 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209012;
        bh=tQ6Idm7z1CwL5iMmUpAUStbdZ7snpY7vAE2Gb/Hqoh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJECMRK+whxlyybaJSN9nuNvqzUq5X4150eENvtO8j+79R0+Aly1mdxr0BPqsmPjy
         HKqk1uyXQTZc3w/mCmNihyRATl+PkCnvawzB7w1VL851upxkI8PljEmlROZilzbdmW
         FnhT7W0b186QA3j9PZQEJoPUGlnJhln0nMJgUj8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0082/1001] arm64: dts: amlogic: meson-g12b-odroid-go-ultra: fix rk818 pmic properties
Date:   Tue,  7 Mar 2023 17:47:34 +0100
Message-Id: <20230307170025.659728092@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit ce9999722656f2433af9029571bc2b99448dda74 ]

Fixes:
pmic@1c: '#clock-cells' is a required property
pmic@1c: 'switch-supply' does not match any of the regexes: 'pinctrl-[0-9]+'

The switch supply is described by vcc9-supply per bindings documentation.

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-14-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-go-ultra.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-go-ultra.dts b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-go-ultra.dts
index 1e40709610c52..c8e5a0a42b898 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-go-ultra.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-go-ultra.dts
@@ -381,6 +381,7 @@ rk818: pmic@1c {
 		reg = <0x1c>;
 		interrupt-parent = <&gpio_intc>;
 		interrupts = <7 IRQ_TYPE_LEVEL_LOW>; /* GPIOAO_7 */
+		#clock-cells = <1>;
 
 		vcc1-supply = <&vdd_sys>;
 		vcc2-supply = <&vdd_sys>;
@@ -391,7 +392,6 @@ rk818: pmic@1c {
 		vcc8-supply = <&vcc_2v3>;
 		vcc9-supply = <&vddao_3v3>;
 		boost-supply = <&vdd_sys>;
-		switch-supply = <&vdd_sys>;
 
 		regulators {
 			vddcpu_a: DCDC_REG1 {
-- 
2.39.2



