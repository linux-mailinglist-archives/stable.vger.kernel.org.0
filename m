Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47FB55D4CD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238986AbiF0LyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238818AbiF0Lwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EA0BC02;
        Mon, 27 Jun 2022 04:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5256F612AE;
        Mon, 27 Jun 2022 11:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CF4C3411D;
        Mon, 27 Jun 2022 11:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330349;
        bh=k6NbGGPYbqPNqNNE4tM28F9irAdaA/11Pf9wsO43kKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWL+gX63VjuiOd/5Cx3TGzeBMDplIlomA87T3si9xW1ofMOkBV/umfcck2lJZKvEl
         y2FjIIRQV0Ur4wI/ooHxZQe9XxuMfV4UYCP9yuO4Z2wX195EOjVLzggsCwrOj3fyie
         NB4LgB1+fr7g42r/c38pWwUqE5MdCOT+zermKWwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Virag <virag.david003@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.18 167/181] arm64: dts: exynos: Correct UART clocks on Exynos7885
Date:   Mon, 27 Jun 2022 13:22:20 +0200
Message-Id: <20220627111949.528911342@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Virag <virag.david003@gmail.com>

commit f84d83d8165570380f55f4ce578bfb131a9266c5 upstream.

The clocks in the serial UART nodes were swapped by mistake on
Exynos7885. This only worked correctly because of a mistake in the clock
driver which has been fixed. With the fixed clock driver in place, the
baudrate of the UARTs get miscalculated. Fix this by correcting the
clocks in the dtsi.

Fixes: 06874015327b ("arm64: dts: exynos: Add initial device tree support for Exynos7885 SoC")
Signed-off-by: David Virag <virag.david003@gmail.com>
Link: https://lore.kernel.org/r/20220526055840.45209-3-virag.david003@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/exynos/exynos7885.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7885.dtsi b/arch/arm64/boot/dts/exynos/exynos7885.dtsi
index 3170661f5b67..9c233c56558c 100644
--- a/arch/arm64/boot/dts/exynos/exynos7885.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7885.dtsi
@@ -280,8 +280,8 @@ serial_0: serial@13800000 {
 			interrupts = <GIC_SPI 246 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart0_bus>;
-			clocks = <&cmu_peri CLK_GOUT_UART0_EXT_UCLK>,
-				 <&cmu_peri CLK_GOUT_UART0_PCLK>;
+			clocks = <&cmu_peri CLK_GOUT_UART0_PCLK>,
+				 <&cmu_peri CLK_GOUT_UART0_EXT_UCLK>;
 			clock-names = "uart", "clk_uart_baud0";
 			samsung,uart-fifosize = <64>;
 			status = "disabled";
@@ -293,8 +293,8 @@ serial_1: serial@13810000 {
 			interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart1_bus>;
-			clocks = <&cmu_peri CLK_GOUT_UART1_EXT_UCLK>,
-				 <&cmu_peri CLK_GOUT_UART1_PCLK>;
+			clocks = <&cmu_peri CLK_GOUT_UART1_PCLK>,
+				 <&cmu_peri CLK_GOUT_UART1_EXT_UCLK>;
 			clock-names = "uart", "clk_uart_baud0";
 			samsung,uart-fifosize = <256>;
 			status = "disabled";
@@ -306,8 +306,8 @@ serial_2: serial@13820000 {
 			interrupts = <GIC_SPI 279 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart2_bus>;
-			clocks = <&cmu_peri CLK_GOUT_UART2_EXT_UCLK>,
-				 <&cmu_peri CLK_GOUT_UART2_PCLK>;
+			clocks = <&cmu_peri CLK_GOUT_UART2_PCLK>,
+				 <&cmu_peri CLK_GOUT_UART2_EXT_UCLK>;
 			clock-names = "uart", "clk_uart_baud0";
 			samsung,uart-fifosize = <256>;
 			status = "disabled";
-- 
2.36.1



