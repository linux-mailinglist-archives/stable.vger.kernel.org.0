Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6F5505862
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244909AbiDROCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244903AbiDROBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:01:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246E92CE0B;
        Mon, 18 Apr 2022 06:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB303B80D9C;
        Mon, 18 Apr 2022 13:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37214C385A1;
        Mon, 18 Apr 2022 13:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287356;
        bh=dIgepHg2u5QCwwLh7ZLHSryTO5H5pf0+HHyZ6n09e5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAxOvLLsPCm/3vaMuUgVbWHk14Zb3LfbNOmIelGOHBiZyo6NPbCgC+WaXhH3TBmbv
         DlEE3qXaQaG8vjRbkUbaF3xnKbb8sN3pDsn6RjLCBpxUGvod6J8gugHmPDo9gnZzzp
         Pr+3vnDzmxe99M29h5MEjPrG0PVMZhjxf+y3Gb6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        LogicalErzor <logicalerzor@gmail.com>
Subject: [PATCH 4.9 137/218] ARM: dts: qcom: fix gic_irq_domain_translate warnings for msm8960
Date:   Mon, 18 Apr 2022 14:13:23 +0200
Message-Id: <20220418121203.508317845@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
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
index 288f56e0ccf5..819d0f085f8c 100644
--- a/arch/arm/boot/dts/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8960.dtsi
@@ -139,7 +139,9 @@
 			reg		= <0x108000 0x1000>;
 			qcom,ipc	= <&l2cc 0x8 2>;
 
-			interrupts	= <0 19 0>, <0 21 0>, <0 22 0>;
+			interrupts	= <GIC_SPI 19 IRQ_TYPE_EDGE_RISING>,
+					  <GIC_SPI 21 IRQ_TYPE_EDGE_RISING>,
+					  <GIC_SPI 22 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names	= "ack", "err", "wakeup";
 
 			regulators {
@@ -185,7 +187,7 @@
 				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 				reg = <0x16440000 0x1000>,
 				      <0x16400000 0x1000>;
-				interrupts = <0 154 0x0>;
+				interrupts = <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GSBI5_UART_CLK>, <&gcc GSBI5_H_CLK>;
 				clock-names = "core", "iface";
 				status = "disabled";
@@ -311,7 +313,7 @@
 				#address-cells = <1>;
 				#size-cells = <0>;
 				reg = <0x16080000 0x1000>;
-				interrupts = <0 147 0>;
+				interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
 				spi-max-frequency = <24000000>;
 				cs-gpios = <&msmgpio 8 0>;
 
-- 
2.34.1



