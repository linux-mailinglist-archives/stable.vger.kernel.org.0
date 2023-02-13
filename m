Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5902694A52
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjBMPGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjBMPGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:06:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2E01CF5C
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:06:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D4396115B
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26F3C4339C;
        Mon, 13 Feb 2023 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300780;
        bh=UlUo/Ize98mqXVOg7Ga3AGnbbLgMb/sxT9gnvA7RWnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pdnx22kxmcjlwlHxFK9OV26mUfG7b+KIjUSpKkUSGcKqtJkn80npZR5P1CBdNR1zr
         aYpCdUqMN2JKA25PLcy1sIYjkwOJyLL3WPrQ0dyydBZJJd/G3m2n2n40+rAPngUnqW
         TjB0g3ZUJfmvbUt+ogbpHeGWajgFWVtjYKY9QItA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, FUKAUMI Naoki <naoki@radxa.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.10 136/139] arm64: dts: meson-g12-common: Make mmc host controller interrupts level-sensitive
Date:   Mon, 13 Feb 2023 15:51:21 +0100
Message-Id: <20230213144753.188568389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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

commit ac8db4cceed218cca21c84f9d75ce88182d8b04f upstream.

The usage of edge-triggered interrupts lead to lost interrupts under load,
see [0]. This was confirmed to be fixed by using level-triggered
interrupts.
The report was about SDIO. However, as the host controller is the same
for SD and MMC, apply the change to all mmc controller instances.

[0] https://www.spinics.net/lists/linux-mmc/msg73991.html

Fixes: 4759fd87b928 ("arm64: dts: meson: g12a: add mmc nodes")
Tested-by: FUKAUMI Naoki <naoki@radxa.com>
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Tested-by: Jerome Brunet <jbrunet@baylibre.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/27d89baa-b8fa-baca-541b-ef17a97cde3c@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2317,7 +2317,7 @@
 		sd_emmc_a: sd@ffe03000 {
 			compatible = "amlogic,meson-axg-mmc";
 			reg = <0x0 0xffe03000 0x0 0x800>;
-			interrupts = <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 189 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clocks = <&clkc CLKID_SD_EMMC_A>,
 				 <&clkc CLKID_SD_EMMC_A_CLK0>,
@@ -2329,7 +2329,7 @@
 		sd_emmc_b: sd@ffe05000 {
 			compatible = "amlogic,meson-axg-mmc";
 			reg = <0x0 0xffe05000 0x0 0x800>;
-			interrupts = <GIC_SPI 190 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clocks = <&clkc CLKID_SD_EMMC_B>,
 				 <&clkc CLKID_SD_EMMC_B_CLK0>,
@@ -2341,7 +2341,7 @@
 		sd_emmc_c: mmc@ffe07000 {
 			compatible = "amlogic,meson-axg-mmc";
 			reg = <0x0 0xffe07000 0x0 0x800>;
-			interrupts = <GIC_SPI 191 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 191 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clocks = <&clkc CLKID_SD_EMMC_C>,
 				 <&clkc CLKID_SD_EMMC_C_CLK0>,


