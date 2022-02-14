Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4B34B4BCF
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbiBNK16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiBNK1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:27:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE6195A0E;
        Mon, 14 Feb 2022 01:58:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3572F60921;
        Mon, 14 Feb 2022 09:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1745EC340E9;
        Mon, 14 Feb 2022 09:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832691;
        bh=cDrmzps+EwVMIVwa4E3JRtZVdxrZkoacSvcnAIzOuQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZirjobC00MKz59tBbmcee+q0T/qoHZRj5xLsOGppIeTm5GAR0GImyLl9vLBFxIJD
         U1NXly1UB9yAx4ZUYJM4i1XxL682A130cRMfvmT95bWubjRi0Zn7CeRCkRmPtiREWN
         Isif5Idd3TLQMliGcODJE5NtyItgZJCo9iU+ZTBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 094/203] ARM: dts: meson: Fix the UART compatible strings
Date:   Mon, 14 Feb 2022 10:25:38 +0100
Message-Id: <20220214092513.460176580@linuxfoundation.org>
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

[ Upstream commit 5225e1b87432dcf0d0fc3440824b91d04c1d6cc1 ]

The dt-bindings for the UART controller only allow the following values
for Meson6 SoCs:
- "amlogic,meson6-uart", "amlogic,meson-ao-uart"
- "amlogic,meson6-uart"

Use the correct fallback compatible string "amlogic,meson-ao-uart" for
AO UART. Drop the "amlogic,meson-uart" compatible string from the EE
domain UART controllers.

Fixes: ec9b59162fd831 ("ARM: dts: meson6: use stable UART bindings")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20211227180026.4068352-2-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/meson.dtsi b/arch/arm/boot/dts/meson.dtsi
index 3be7cba603d5a..26eaba3fa96f3 100644
--- a/arch/arm/boot/dts/meson.dtsi
+++ b/arch/arm/boot/dts/meson.dtsi
@@ -59,7 +59,7 @@ hwrng: rng@8100 {
 			};
 
 			uart_A: serial@84c0 {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart";
 				reg = <0x84c0 0x18>;
 				interrupts = <GIC_SPI 26 IRQ_TYPE_EDGE_RISING>;
 				fifo-size = <128>;
@@ -67,7 +67,7 @@ uart_A: serial@84c0 {
 			};
 
 			uart_B: serial@84dc {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart";
 				reg = <0x84dc 0x18>;
 				interrupts = <GIC_SPI 75 IRQ_TYPE_EDGE_RISING>;
 				status = "disabled";
@@ -105,7 +105,7 @@ saradc: adc@8680 {
 			};
 
 			uart_C: serial@8700 {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart";
 				reg = <0x8700 0x18>;
 				interrupts = <GIC_SPI 93 IRQ_TYPE_EDGE_RISING>;
 				status = "disabled";
@@ -228,7 +228,7 @@ ir_receiver: ir-receiver@480 {
 			};
 
 			uart_AO: serial@4c0 {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-ao-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart", "amlogic,meson-ao-uart";
 				reg = <0x4c0 0x18>;
 				interrupts = <GIC_SPI 90 IRQ_TYPE_EDGE_RISING>;
 				status = "disabled";
-- 
2.34.1



