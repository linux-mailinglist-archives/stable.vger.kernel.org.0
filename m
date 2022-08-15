Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAC859452C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244584AbiHOWV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347549AbiHOWUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:20:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60646B153;
        Mon, 15 Aug 2022 12:43:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05ADBB81141;
        Mon, 15 Aug 2022 19:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F94C433C1;
        Mon, 15 Aug 2022 19:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592598;
        bh=/nlk2RNgiWALLZkduIiOCkuWAgi6PpoVPN4WKKCrp3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8y5s+Xm5vsnoQ4y2S0CAUNGuT0XokdQDE1H5YvH7ceCAJlP1NXdSkg5LZ5YB//3p
         E/CrCGVQmB+/fIg/oytkdMrPwHCA8cwlLfy72LNmbQ6RCVZ1AuOTrh0aZvSizozdNy
         dz4sKFMdoTnAev7r7+Qb8aC9bI/dGzWZS/LZBGa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryuta NAKANISHI <nakanishi.ryuta@socionext.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.19 0135/1157] ARM: dts: uniphier: Fix USB interrupts for PXs2 SoC
Date:   Mon, 15 Aug 2022 19:51:31 +0200
Message-Id: <20220815180445.031158433@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

commit 9b0dc7abb5cc43a2dbf90690c3c6011dcadc574d upstream.

An interrupt for USB device are shared with USB host. Set interrupt-names
property to common "dwc_usb3" instead of "host" and "peripheral".

Cc: stable@vger.kernel.org
Fixes: 45be1573ad19 ("ARM: dts: uniphier: Add USB3 controller nodes")
Reported-by: Ryuta NAKANISHI <nakanishi.ryuta@socionext.com>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/uniphier-pxs2.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/boot/dts/uniphier-pxs2.dtsi
+++ b/arch/arm/boot/dts/uniphier-pxs2.dtsi
@@ -597,8 +597,8 @@
 			compatible = "socionext,uniphier-dwc3", "snps,dwc3";
 			status = "disabled";
 			reg = <0x65a00000 0xcd00>;
-			interrupt-names = "host", "peripheral";
-			interrupts = <0 134 4>, <0 135 4>;
+			interrupt-names = "dwc_usb3";
+			interrupts = <0 134 4>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_usb0>, <&pinctrl_usb2>;
 			clock-names = "ref", "bus_early", "suspend";
@@ -693,8 +693,8 @@
 			compatible = "socionext,uniphier-dwc3", "snps,dwc3";
 			status = "disabled";
 			reg = <0x65c00000 0xcd00>;
-			interrupt-names = "host", "peripheral";
-			interrupts = <0 137 4>, <0 138 4>;
+			interrupt-names = "dwc_usb3";
+			interrupts = <0 137 4>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_usb1>, <&pinctrl_usb3>;
 			clock-names = "ref", "bus_early", "suspend";


