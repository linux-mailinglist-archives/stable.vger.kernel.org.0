Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6844531606
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241603AbiEWRdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242317AbiEWRcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D5272E05;
        Mon, 23 May 2022 10:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1005B608C0;
        Mon, 23 May 2022 17:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBFAC385AA;
        Mon, 23 May 2022 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326828;
        bh=5bH7H4zGMBgeHEFbaAZv0/6QAQAaX1t2ZSNtFSywXWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0SSeH+ferziS38n6Uk7cU2wyWyXxnmwoes33aNAVHLEFFBBC4OEdmk24OLC9SRl5s
         xdiLSJTFuStXtHpZ3i4i/aI3iVIhq8Vk6wwaiJbeem3oHVHx4MsP1C/ppHmR2bxLEu
         nSia9HtOJKxg2WINtpHY/zJvKwqG/QQfEC4oderQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Howard Chiu <howard_chiu@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 072/158] ARM: dts: aspeed: Add video engine to g6
Date:   Mon, 23 May 2022 19:03:49 +0200
Message-Id: <20220523165842.883024624@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Howard Chiu <howard_chiu@aspeedtech.com>

[ Upstream commit 32e62d1beab70d485980013312e747a25c4e13f7 ]

This node was accidentally removed by commit 645afe73f951 ("ARM: dts:
aspeed: ast2600: Update XDMA engine node").

Fixes: 645afe73f951 ("ARM: dts: aspeed: ast2600: Update XDMA engine node")
Signed-off-by: Howard Chiu <howard_chiu@aspeedtech.com>
Link: https://lore.kernel.org/r/SG2PR06MB2315C57600A0132FEF40F21EE61E9@SG2PR06MB2315.apcprd06.prod.outlook.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-g6.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/aspeed-g6.dtsi b/arch/arm/boot/dts/aspeed-g6.dtsi
index c32e87fad4dc..aac55b3aeded 100644
--- a/arch/arm/boot/dts/aspeed-g6.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6.dtsi
@@ -389,6 +389,16 @@ sbc: secure-boot-controller@1e6f2000 {
 				reg = <0x1e6f2000 0x1000>;
 			};
 
+			video: video@1e700000 {
+				compatible = "aspeed,ast2600-video-engine";
+				reg = <0x1e700000 0x1000>;
+				clocks = <&syscon ASPEED_CLK_GATE_VCLK>,
+					 <&syscon ASPEED_CLK_GATE_ECLK>;
+				clock-names = "vclk", "eclk";
+				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+				status = "disabled";
+			};
+
 			gpio0: gpio@1e780000 {
 				#gpio-cells = <2>;
 				gpio-controller;
-- 
2.35.1



