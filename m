Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF43593574
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241496AbiHOSYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241500AbiHOSYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:24:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A7A2ED5E;
        Mon, 15 Aug 2022 11:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BF7860BEC;
        Mon, 15 Aug 2022 18:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA4DC433C1;
        Mon, 15 Aug 2022 18:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587488;
        bh=/nlk2RNgiWALLZkduIiOCkuWAgi6PpoVPN4WKKCrp3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQb1rObpwCdKlgQkw/GDQ2B2XhisIiad1oyMLyjscLsgkxb9Ok3taIBVs1OGXnnqG
         Ccoca+RRFxwInWeox4dZLRE0W8wtwqJNZ7SjtBvU5Rcs0ysuzXT4X/IDs0k7Ji3zE7
         BN0Mm3uA3OBGFkioGc/nwxHPh1bAvPheXNLEwV4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryuta NAKANISHI <nakanishi.ryuta@socionext.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 101/779] ARM: dts: uniphier: Fix USB interrupts for PXs2 SoC
Date:   Mon, 15 Aug 2022 19:55:45 +0200
Message-Id: <20220815180341.624480520@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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


