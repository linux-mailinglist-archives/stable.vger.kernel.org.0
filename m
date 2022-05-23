Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076D753171D
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241386AbiEWRdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241253AbiEWR0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC7F6D3AE;
        Mon, 23 May 2022 10:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E0E43CE1705;
        Mon, 23 May 2022 17:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8427C34119;
        Mon, 23 May 2022 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326384;
        bh=kePXsJT2lZ2fQxyGP+ajHTM8R08PGr6ZcmBpYcLI058=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqIfwy89fjPJhvrHcRX5t/zdz+mPFgwsNH4D7Hx4ftMQ1C4q6/pgQRB9cG/3UIlMz
         GX0+sYEgV3ajKrutMUyfp88BekATSQc7UNoGU6G8+r1DzmFBe3kGG1xR9uCr1KdH81
         rY9/RrkeXR2tgyPcvOM9GjKp+tzVm6WTV6YZ7+6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/132] ARM: dts: aspeed: Add ADC for AST2600 and enable for Rainier and Everest
Date:   Mon, 23 May 2022 19:04:34 +0200
Message-Id: <20220523165834.029161364@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit eaad40466bd715c4b342ac9f7c889f5281714feb ]

Add the ADC nodes to the AST2600 devicetree. Enable ADC1 for Rainier and
Everest systems and add an iio-hwmon node for the 7th channel to report
the battery voltage.

Tested on Rainier:
~# cat /sys/class/hwmon/hwmon11/in1_input
1347

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20210916210045.31769-1-eajames@linux.ibm.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts | 15 +++++++++++++++
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts | 15 +++++++++++++++
 arch/arm/boot/dts/aspeed-g6.dtsi             | 20 ++++++++++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
index 2efd70666738..af7ea7cab8cf 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
@@ -231,6 +231,21 @@ led-pcieslot-power {
 			gpios = <&gpio0 ASPEED_GPIO(P, 4) GPIO_ACTIVE_LOW>;
 		};
 	};
+
+	iio-hwmon {
+		compatible = "iio-hwmon";
+		io-channels = <&adc1 7>;
+	};
+};
+
+&adc1 {
+	status = "okay";
+	aspeed,int-vref-microvolt = <2500000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_adc8_default &pinctrl_adc9_default
+				 &pinctrl_adc10_default &pinctrl_adc11_default
+				 &pinctrl_adc12_default &pinctrl_adc13_default
+				 &pinctrl_adc14_default &pinctrl_adc15_default>;
 };
 
 &gpio0 {
diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
index 6419c9762c0b..6c9f34396a3a 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
@@ -246,6 +246,21 @@ fan5-presence {
 			linux,code = <11>;
 		};
 	};
+
+	iio-hwmon {
+		compatible = "iio-hwmon";
+		io-channels = <&adc1 7>;
+	};
+};
+
+&adc1 {
+	status = "okay";
+	aspeed,int-vref-microvolt = <2500000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_adc8_default &pinctrl_adc9_default
+		&pinctrl_adc10_default &pinctrl_adc11_default
+		&pinctrl_adc12_default &pinctrl_adc13_default
+		&pinctrl_adc14_default &pinctrl_adc15_default>;
 };
 
 &ehci1 {
diff --git a/arch/arm/boot/dts/aspeed-g6.dtsi b/arch/arm/boot/dts/aspeed-g6.dtsi
index 1b47be1704f8..ee171b3364fa 100644
--- a/arch/arm/boot/dts/aspeed-g6.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6.dtsi
@@ -364,6 +364,26 @@ xdma: xdma@1e6e7000 {
 				status = "disabled";
 			};
 
+			adc0: adc@1e6e9000 {
+				compatible = "aspeed,ast2600-adc0";
+				reg = <0x1e6e9000 0x100>;
+				clocks = <&syscon ASPEED_CLK_APB2>;
+				resets = <&syscon ASPEED_RESET_ADC>;
+				interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
+				#io-channel-cells = <1>;
+				status = "disabled";
+			};
+
+			adc1: adc@1e6e9100 {
+				compatible = "aspeed,ast2600-adc1";
+				reg = <0x1e6e9100 0x100>;
+				clocks = <&syscon ASPEED_CLK_APB2>;
+				resets = <&syscon ASPEED_RESET_ADC>;
+				interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
+				#io-channel-cells = <1>;
+				status = "disabled";
+			};
+
 			gpio0: gpio@1e780000 {
 				#gpio-cells = <2>;
 				gpio-controller;
-- 
2.35.1



