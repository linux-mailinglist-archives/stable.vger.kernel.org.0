Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE6451A7C9
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355134AbiEDRFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355257AbiEDREO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2414EA1A;
        Wed,  4 May 2022 09:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59396617C3;
        Wed,  4 May 2022 16:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DB3C385AA;
        Wed,  4 May 2022 16:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683172;
        bh=ErSJhNxNhAjFQyo0IYu55uUHakx8l73TBNY52bN65po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUuyE70H1KNkqRfNxtP7cIcdINKr0peVHWYmxYZHYwBkjG5T8Fi088NpnwFDZ3/6Q
         ca3rVHyB4Fxd69u4ZyIzGJe9o7ltZEtNZQwjJ6QMkzrytnjBiKgcWYJftODDp+H+r4
         cxM2hb2AFQE++tM784UPOOSwnQ93h875AzP92iYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Johan Hovold <johan@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.15 037/177] arm64: dts: imx8mm-venice: fix spi2 pin configuration
Date:   Wed,  4 May 2022 18:43:50 +0200
Message-Id: <20220504153056.262481379@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit dc900431337f5f861e3cc47ec5be5a69db40ee34 upstream.

Due to what looks like a copy-paste error, the ECSPI2_MISO pad is not
muxed for SPI mode and causes reads from a slave-device connected to the
SPI header to always return zero.

Configure the ECSPI2_MISO pad for SPI mode on the gw71xx, gw72xx and
gw73xx families of boards that got this wrong.

Fixes: 6f30b27c5ef5 ("arm64: dts: imx8mm: Add Gateworks i.MX 8M Mini Development Kits")
Cc: stable@vger.kernel.org      # 5.12
Cc: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi |    2 +-
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi |    2 +-
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
@@ -166,7 +166,7 @@
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI	0xd6
-			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
+			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO	0xd6
 			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13	0xd6
 		>;
 	};
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
@@ -231,7 +231,7 @@
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI	0xd6
-			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
+			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO	0xd6
 			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13	0xd6
 		>;
 	};
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
@@ -280,7 +280,7 @@
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI	0xd6
-			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK	0xd6
+			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO	0xd6
 			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13	0xd6
 		>;
 	};


