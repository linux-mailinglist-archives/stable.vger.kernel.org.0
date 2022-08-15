Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF32F593DBA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243750AbiHOUUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241563AbiHOUSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:18:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDD845059;
        Mon, 15 Aug 2022 12:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5574C611D6;
        Mon, 15 Aug 2022 19:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF24C433C1;
        Mon, 15 Aug 2022 19:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590028;
        bh=rkWXU3TEa6CIXUl/UnvFRmLkzh9CC0lIVI2ALWVyQsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDrLiUkk0C38Exnzao9fL/LpbGKbnlv9dLlzIQpZPGECtxxeNjtY6roRKwYyuNaYt
         h0DhNLLtGoINc/o1GsesXzktjH9skLEn8awXzsBrjruCkon737iy9LXcLzrgGZhSm5
         +j6Xo9k00DV3Ji13jZcge+hNByerAQ34ozbO6OsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryuta NAKANISHI <nakanishi.ryuta@socionext.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.18 0126/1095] arm64: dts: uniphier: Fix USB interrupts for PXs3 SoC
Date:   Mon, 15 Aug 2022 19:52:05 +0200
Message-Id: <20220815180434.796543185@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

commit fe17b91a7777df140d0f1433991da67ba658796c upstream.

An interrupt for USB device are shared with USB host. Set interrupt-names
property to common "dwc_usb3" instead of "host" and "peripheral".

Cc: stable@vger.kernel.org
Fixes: d7b9beb830d7 ("arm64: dts: uniphier: Add USB3 controller nodes")
Reported-by: Ryuta NAKANISHI <nakanishi.ryuta@socionext.com>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi
@@ -599,8 +599,8 @@
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
@@ -701,8 +701,8 @@
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


