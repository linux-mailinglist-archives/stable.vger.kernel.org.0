Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9858F56FBFA
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiGKJhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiGKJhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:37:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501E24D4CD;
        Mon, 11 Jul 2022 02:19:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 986BC6129D;
        Mon, 11 Jul 2022 09:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E76C34115;
        Mon, 11 Jul 2022 09:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531153;
        bh=Lx4hc0nUrNwQiiQOUQxsaBTqW6L6HwC4km2Y1mY4GHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNZd+WfIGP0VtfiHLQ0TtMIJKm5phVZPxyHWiNTWGjhCTyxuGHQ6gTE+VuKF9YvdE
         PSQyqjUGk36NGxr3mv1yd42Ah02bMwURBbCft4LvWFZYtQXiiI7CZOMo4zSyMBLkqV
         /aJujp1IOTH2xca2V5b0J9TezwAXd/LdZpko0Czw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 080/112] ARM: dts: stm32: add missing usbh clock and fix clk order on stm32mp15
Date:   Mon, 11 Jul 2022 11:07:20 +0200
Message-Id: <20220711090551.842963197@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit 1d0c1aadf1fd9f3de95d1532b3651e8634546e71 ]

The USBH composed of EHCI and OHCI controllers needs the PHY clock to be
initialized first, before enabling (gating) them. The reverse is also
required when going to suspend.
So, add USBPHY clock as 1st entry in both controllers, so the USBPHY PLL
gets enabled 1st upon controller init. Upon suspend/resume, this also makes
the clock to be disabled/re-enabled in the correct order.
This fixes some IRQ storm conditions seen when going to low-power, due to
PHY PLL being disabled before all clocks are cleanly gated.

Fixes: 949a0c0dec85 ("ARM: dts: stm32: add USB Host (USBH) support to stm32mp157c")
Fixes: db7be2cb87ae ("ARM: dts: stm32: use usbphyc ck_usbo_48m as USBH OHCI clock on stm32mp151")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp151.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp151.dtsi b/arch/arm/boot/dts/stm32mp151.dtsi
index f9aa9af31efd..9c2bbf115f4c 100644
--- a/arch/arm/boot/dts/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/stm32mp151.dtsi
@@ -1474,7 +1474,7 @@
 		usbh_ohci: usb@5800c000 {
 			compatible = "generic-ohci";
 			reg = <0x5800c000 0x1000>;
-			clocks = <&rcc USBH>, <&usbphyc>;
+			clocks = <&usbphyc>, <&rcc USBH>;
 			resets = <&rcc USBH_R>;
 			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
@@ -1483,7 +1483,7 @@
 		usbh_ehci: usb@5800d000 {
 			compatible = "generic-ehci";
 			reg = <0x5800d000 0x1000>;
-			clocks = <&rcc USBH>;
+			clocks = <&usbphyc>, <&rcc USBH>;
 			resets = <&rcc USBH_R>;
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
 			companion = <&usbh_ohci>;
-- 
2.35.1



