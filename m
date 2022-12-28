Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5EB65799D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbiL1PDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiL1PC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A812512D2A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:02:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7DB66153C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7846C433D2;
        Wed, 28 Dec 2022 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239775;
        bh=Hoa7/5auRty9GH+3CoCIj2AkJ2hYuMCvUkoIBQbYcRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNG8l7lDP+Q5YCJXKEh7gj2yhKnBfR2sIVTNrkSDnns/jiJDPNRIaHLP5ffhVtUi2
         QhJWumF1tH852kHpj8n/KvddX4VoLWz8PrNJkoJQ+REViW07+/epFHr82u1SGyfRsi
         e81pWo9Kz2XIU+qnFIRtCZx7U+yRqvPsdnz2HTuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0077/1073] ARM: dts: armada-38x: Fix compatible string for gpios
Date:   Wed, 28 Dec 2022 15:27:45 +0100
Message-Id: <20221228144330.163854383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit c4de4667f15d04ef5920bacf41e514ec7d1ef03d ]

Armada 38x supports per CPU interrupts for gpios, like Armada XP. Pre-XP
variants like Armada 370 do not support per CPU interrupts for gpios.

So change compatible string for Armada 38x from "marvell,armada-370-gpio"
which indicates pre-XP variant to "marvell,armadaxp-gpio" which indicates
XP variant or new.

Driver gpio-mvebu.c which handles both pre-XP and XP variants already
provides support for per CPU interrupts on XP and newer variants.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 7cb2acb3fbae ("ARM: dts: mvebu: Add PWM properties for armada-38x")
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-38x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/armada-38x.dtsi b/arch/arm/boot/dts/armada-38x.dtsi
index df3c8d1d8f64..9343de6947b3 100644
--- a/arch/arm/boot/dts/armada-38x.dtsi
+++ b/arch/arm/boot/dts/armada-38x.dtsi
@@ -292,7 +292,7 @@ sata3_pins: sata-pins-3 {
 			};
 
 			gpio0: gpio@18100 {
-				compatible = "marvell,armada-370-gpio",
+				compatible = "marvell,armadaxp-gpio",
 					     "marvell,orion-gpio";
 				reg = <0x18100 0x40>, <0x181c0 0x08>;
 				reg-names = "gpio", "pwm";
@@ -310,7 +310,7 @@ gpio0: gpio@18100 {
 			};
 
 			gpio1: gpio@18140 {
-				compatible = "marvell,armada-370-gpio",
+				compatible = "marvell,armadaxp-gpio",
 					     "marvell,orion-gpio";
 				reg = <0x18140 0x40>, <0x181c8 0x08>;
 				reg-names = "gpio", "pwm";
-- 
2.35.1



