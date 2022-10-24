Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A775E60B390
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 19:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiJXRKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 13:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiJXRKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 13:10:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A038294139;
        Mon, 24 Oct 2022 08:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA40C61335;
        Mon, 24 Oct 2022 12:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06243C433C1;
        Mon, 24 Oct 2022 12:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616175;
        bh=VOZfQD/70v7dIut2wKyWJCvorf5i4revhmo2B5p6WqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KXjcf04gcY5ULsDl0l1Bq6dnEuEKkMET0hUlGIFumIo1xzKhBnrKW/Gn7iN3uWKy
         GfVQwz9XWQ8mG7o/o9a6puKVje37yOfxu4bFhWr2il0QbXuhkxf6ESHSOKP2uLZ5mi
         Aw83NoRnk6eYS6P7lO/59h0oqxQIk7GqwSJRa2OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 498/530] arm64: dts: imx8mp: Add snps,gfladj-refclk-lpm-sel quirk to USB nodes
Date:   Mon, 24 Oct 2022 13:34:02 +0200
Message-Id: <20221024113107.588116897@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 5c3d5ecf48ab06c709c012bf1e8f0c91e1fcd7ad ]

With this set the SOF/ITP counter is based on ref_clk when 2.0 ports are
suspended.
snps,dis-u2-freeclk-exists-quirk can be removed as
snps,gfladj-refclk-lpm-sel also clears the free running clock configuration
bit.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20220915062855.751881-4-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 9b07b26230a1..664177ed38d3 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -912,7 +912,7 @@
 				interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&usb3_phy0>, <&usb3_phy0>;
 				phy-names = "usb2-phy", "usb3-phy";
-				snps,dis-u2-freeclk-exists-quirk;
+				snps,gfladj-refclk-lpm-sel-quirk;
 			};
 
 		};
@@ -953,7 +953,7 @@
 				interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&usb3_phy1>, <&usb3_phy1>;
 				phy-names = "usb2-phy", "usb3-phy";
-				snps,dis-u2-freeclk-exists-quirk;
+				snps,gfladj-refclk-lpm-sel-quirk;
 			};
 		};
 
-- 
2.35.1



