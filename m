Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3244E6ECE32
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjDXNaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbjDXNaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:30:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F369D65B0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2A7C6231D
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67EEC433D2;
        Mon, 24 Apr 2023 13:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342985;
        bh=styUTBRCO5EqlR4CKl3Sp9KJBr5zwsqPCtYtWGezCMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Udn2Q02QcHew5kSV7F4Cd3WAuYx6ZzElYo+xwG0yW/nPBZKOg3bYptLEXG/ufm4Kz
         qTvm4FO+OMIERoxb3Xv4YK5KWqINUYmE4YN1d/xvWWfa2JaM6HPqAlnV0vpiC/pi1Y
         GYrkUFuZgoLX/8J6MePTHvq8xN2MbzWk/Sxlw2Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Gonzalez <mgonzalez@freebox.fr>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 006/110] arm64: dts: meson-g12-common: resolve conflict between canvas & pmu
Date:   Mon, 24 Apr 2023 15:16:28 +0200
Message-Id: <20230424131136.366660384@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Gonzalez <mgonzalez@freebox.fr>

[ Upstream commit 33acea2049b5058b93d1dabb536b494f543f02a2 ]

According to S905X2 Datasheet - Revision 07:

DMC_MON area spans 0xff638080-0xff6380c0
DDR_PLL area spans 0xff638c00-0xff638c34

Round DDR_PLL area size up to 0x40

Fixes: 90cf8e21016fa3 ("arm64: dts: meson: Add DDR PMU node")
Signed-off-by: Marc Gonzalez <mgonzalez@freebox.fr>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230327120932.2158389-3-mgonzalez@freebox.fr
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index ba36af9e20cf2..42027c78c8ded 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1579,6 +1579,12 @@
 					compatible = "amlogic,canvas";
 					reg = <0x0 0x48 0x0 0x14>;
 				};
+
+				pmu: pmu@80 {
+					reg = <0x0 0x80 0x0 0x40>,
+					      <0x0 0xc00 0x0 0x40>;
+					interrupts = <GIC_SPI 52 IRQ_TYPE_EDGE_RISING>;
+				};
 			};
 
 			usb2_phy1: phy@3a000 {
@@ -1704,12 +1710,6 @@
 			};
 		};
 
-		pmu: pmu@ff638000 {
-			reg = <0x0 0xff638000 0x0 0x100>,
-			      <0x0 0xff638c00 0x0 0x100>;
-			interrupts = <GIC_SPI 52 IRQ_TYPE_EDGE_RISING>;
-		};
-
 		aobus: bus@ff800000 {
 			compatible = "simple-bus";
 			reg = <0x0 0xff800000 0x0 0x100000>;
-- 
2.39.2



