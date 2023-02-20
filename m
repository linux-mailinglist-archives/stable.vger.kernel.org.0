Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D4669CD38
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjBTNrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbjBTNrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:47:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421F11CF72
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:47:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 668E9CE0FD1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8991FC433D2;
        Mon, 20 Feb 2023 13:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900837;
        bh=4ctmASc/+2JR47zSznn55yZeUKXCAMfa3I++ikvF9Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSLTmdI/GolXyCFPZqlI60yoRvBhrqo/lW5sazmKUM+CCTiznB+M9CxV8zOuJ58J6
         Voi75MqQJJtyp3N0AqYlru4wxZbLD2xEctBOzkNQKLn8WNEEbXySmjrCu8Ruh3QkeX
         s9EduSnyOlN/rha3kMMXxRHsmYFp4BTB/0RkPGDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Peter Suti <peter.suti@streamunlimited.com>,
        Vyacheslav Bocharov <adeep@lexina.in>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.4 087/156] arm64: dts: meson-axg: Make mmc host controller interrupts level-sensitive
Date:   Mon, 20 Feb 2023 14:35:31 +0100
Message-Id: <20230220133606.051153000@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

commit d182bcf300772d8b2e5f43e47fa0ebda2b767cc4 upstream.

The usage of edge-triggered interrupts lead to lost interrupts under load,
see [0]. This was confirmed to be fixed by using level-triggered
interrupts.
The report was about SDIO. However, as the host controller is the same
for SD and MMC, apply the change to all mmc controller instances.

[0] https://www.spinics.net/lists/linux-mmc/msg73991.html

Fixes: 221cf34bac54 ("ARM64: dts: meson-axg: enable the eMMC controller")
Reported-by: Peter Suti <peter.suti@streamunlimited.com>
Tested-by: Vyacheslav Bocharov <adeep@lexina.in>
Tested-by: Peter Suti <peter.suti@streamunlimited.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/c00655d3-02f8-6f5f-4239-ca2412420cad@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -1705,7 +1705,7 @@
 			sd_emmc_b: sd@5000 {
 				compatible = "amlogic,meson-axg-mmc";
 				reg = <0x0 0x5000 0x0 0x800>;
-				interrupts = <GIC_SPI 217 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 217 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 				clocks = <&clkc CLKID_SD_EMMC_B>,
 					<&clkc CLKID_SD_EMMC_B_CLK0>,
@@ -1717,7 +1717,7 @@
 			sd_emmc_c: mmc@7000 {
 				compatible = "amlogic,meson-axg-mmc";
 				reg = <0x0 0x7000 0x0 0x800>;
-				interrupts = <GIC_SPI 218 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 218 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 				clocks = <&clkc CLKID_SD_EMMC_C>,
 					<&clkc CLKID_SD_EMMC_C_CLK0>,


