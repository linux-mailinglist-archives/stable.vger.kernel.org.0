Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FDF4B494B
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347303AbiBNKaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:30:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347527AbiBNK3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:29:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA2B98F62;
        Mon, 14 Feb 2022 01:58:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C02E360918;
        Mon, 14 Feb 2022 09:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F1EC340E9;
        Mon, 14 Feb 2022 09:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832698;
        bh=OGK0+msb1kIhUGC5n/iUnSiYpQt27a+vnzsr7j/gXos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V45YuwhS8KCcx7PoswUTVXWZqJ2/iLVOFnALn0Jbur51CQ/Ru60R/v6D+7oiYgVqF
         UBszRzPA1NwQFhtriGFSaXns5CoMLdlMpoU3x6CvVi52d875qAFA40cG2xo3AvsHxH
         VzhZ/KXUkPrz+Jv8JtexBalWwtahlTEhP1sFX0ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 096/203] ARM: dts: meson8b: Fix the UART device-tree schema validation
Date:   Mon, 14 Feb 2022 10:25:40 +0100
Message-Id: <20220214092513.523717618@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 3375aa77135f6aeb1107ed839a2050a4118444bc ]

The dt-bindings for the UART controller only allow the following values
for Meson8 SoCs:
- "amlogic,meson8b-uart", "amlogic,meson-ao-uart"
- "amlogic,meson8b-uart"

Use the correct fallback compatible string "amlogic,meson-ao-uart" for
AO UART. Drop the "amlogic,meson-uart" compatible string from the EE
domain UART controllers.

Also update the order of the clocks to match the order defined in the
yaml bindings.

Fixes: b02d6e73f5fc96 ("ARM: dts: meson8b: use stable UART bindings with correct gate clock")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20211227180026.4068352-4-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8b.dtsi | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/meson8b.dtsi b/arch/arm/boot/dts/meson8b.dtsi
index b49b7cbaed4ee..94f1c03deccef 100644
--- a/arch/arm/boot/dts/meson8b.dtsi
+++ b/arch/arm/boot/dts/meson8b.dtsi
@@ -724,27 +724,27 @@ &timer_abcde {
 };
 
 &uart_AO {
-	compatible = "amlogic,meson8b-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_CLK81>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8b-uart", "amlogic,meson-ao-uart";
+	clocks = <&xtal>, <&clkc CLKID_CLK81>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &uart_A {
-	compatible = "amlogic,meson8b-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_UART0>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8b-uart";
+	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &uart_B {
-	compatible = "amlogic,meson8b-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_UART1>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8b-uart";
+	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &uart_C {
-	compatible = "amlogic,meson8b-uart", "amlogic,meson-uart";
-	clocks = <&clkc CLKID_CLK81>, <&xtal>, <&clkc CLKID_UART2>;
-	clock-names = "baud", "xtal", "pclk";
+	compatible = "amlogic,meson8b-uart";
+	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clock-names = "xtal", "pclk", "baud";
 };
 
 &usb0 {
-- 
2.34.1



