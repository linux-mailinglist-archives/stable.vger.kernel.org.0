Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F9E4F3493
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbiDEIkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiDEIZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:25:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E586013D0C;
        Tue,  5 Apr 2022 01:20:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97FF6B81B92;
        Tue,  5 Apr 2022 08:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EF0C385A0;
        Tue,  5 Apr 2022 08:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146836;
        bh=M5KJInYrlR+ql5Za/wReHZJT/XsYWuv2wTimrFGtLqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rr2nbaT6aAQ8htwnFEO7Xf64YdqYain35nqeR/ibClEwuhXnW2dUPJQY340gtry12
         6TTJUhbClsY/7Aj8BDEmvctSsVMz54laFrOPD5MIgFf6kde5MXmq1QJeEg/ZX2ckPk
         9fbI7wQHTSU1yKgupMS6eCYPFJa4EbyAUb20HQag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        LogicalErzor <logicalerzor@gmail.com>
Subject: [PATCH 5.17 0906/1126] ARM: dts: qcom: fix gic_irq_domain_translate warnings for msm8960
Date:   Tue,  5 Apr 2022 09:27:33 +0200
Message-Id: <20220405070434.121147589@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 6f7e221e7a5cfc3299616543fce42b36e631497b ]

IRQ types blindly copied from very similar APQ8064.

Fixes warnings as:
WARNING: CPU: 0 PID: 1 at drivers/irqchip/irq-gic.c:1080 gic_irq_domain_translate+0x118/0x120
...

Tested-by: LogicalErzor <logicalerzor@gmail.com> # boot-tested on Samsung S3
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220108174229.60384-1-david@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8960.dtsi | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8960.dtsi b/arch/arm/boot/dts/qcom-msm8960.dtsi
index 2a0ec97a264f..a0f9ab7f08f3 100644
--- a/arch/arm/boot/dts/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8960.dtsi
@@ -146,7 +146,9 @@
 			reg		= <0x108000 0x1000>;
 			qcom,ipc	= <&l2cc 0x8 2>;
 
-			interrupts	= <0 19 0>, <0 21 0>, <0 22 0>;
+			interrupts	= <GIC_SPI 19 IRQ_TYPE_EDGE_RISING>,
+					  <GIC_SPI 21 IRQ_TYPE_EDGE_RISING>,
+					  <GIC_SPI 22 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names	= "ack", "err", "wakeup";
 
 			regulators {
@@ -192,7 +194,7 @@
 				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 				reg = <0x16440000 0x1000>,
 				      <0x16400000 0x1000>;
-				interrupts = <0 154 0x0>;
+				interrupts = <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GSBI5_UART_CLK>, <&gcc GSBI5_H_CLK>;
 				clock-names = "core", "iface";
 				status = "disabled";
@@ -318,7 +320,7 @@
 				#address-cells = <1>;
 				#size-cells = <0>;
 				reg = <0x16080000 0x1000>;
-				interrupts = <0 147 0>;
+				interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
 				spi-max-frequency = <24000000>;
 				cs-gpios = <&msmgpio 8 0>;
 
-- 
2.34.1



