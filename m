Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C10A541BD1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350223AbiFGVyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383030AbiFGVwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0F92408CE;
        Tue,  7 Jun 2022 12:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59FFDB82182;
        Tue,  7 Jun 2022 19:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10C3C385A2;
        Tue,  7 Jun 2022 19:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629017;
        bh=liNhd+rQWFOn1syJrUOicb3uykE30jaLc4TMIIZdHug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yWIenax208psdePA8y4S4y0s6gH0Hc3vXYyVIU9ZtVknpruqnnUQZHtmWoZ3DspaI
         rX5Hyzn9MA3fJEhKt6ZpM9nSEcUYv60Nc0l7407rse7yuSVZhPjjUpK67YnK/tiCXj
         ptMI0akawWTvSzTp01ro30LFIHPKaJqdkMNjqKHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 538/879] ARM: dts: suniv: F1C100: fix watchdog compatible
Date:   Tue,  7 Jun 2022 19:00:56 +0200
Message-Id: <20220607165018.487992000@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 01a850ee61cbf0ab77dcbf26bb133fec2dd640d6 ]

The F1C100 series of SoCs actually have their watchdog IP being
compatible with the newer Allwinner generation, not the older one.

The currently described sun4i-a10-wdt actually does not work, neither
the watchdog functionality (just never fires), nor the reset part
(reboot hangs).

Replace the compatible string with the one used by the newer generation.
Verified to work with both the watchdog and reboot functionality on a
LicheePi Nano.

Also add the missing interrupt line and clock source, to make it binding
compliant.

Fixes: 4ba16d17efdd ("ARM: dts: suniv: add initial DTSI file for F1C100s")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20220317162349.739636-4-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/suniv-f1c100s.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/suniv-f1c100s.dtsi b/arch/arm/boot/dts/suniv-f1c100s.dtsi
index 6100d3b75f61..def830101448 100644
--- a/arch/arm/boot/dts/suniv-f1c100s.dtsi
+++ b/arch/arm/boot/dts/suniv-f1c100s.dtsi
@@ -104,8 +104,10 @@
 
 		wdt: watchdog@1c20ca0 {
 			compatible = "allwinner,suniv-f1c100s-wdt",
-				     "allwinner,sun4i-a10-wdt";
+				     "allwinner,sun6i-a31-wdt";
 			reg = <0x01c20ca0 0x20>;
+			interrupts = <16>;
+			clocks = <&osc32k>;
 		};
 
 		uart0: serial@1c25000 {
-- 
2.35.1



