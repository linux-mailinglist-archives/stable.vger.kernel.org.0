Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1ACC5317A6
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbiEWRXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242079AbiEWRWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:22:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3DC7CDFB;
        Mon, 23 May 2022 10:19:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED2A9B811FB;
        Mon, 23 May 2022 17:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B340C385A9;
        Mon, 23 May 2022 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326393;
        bh=5T70yuxBUh77ixBohRtBgJFO6qBe6dkIdLWu7q7eP0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1C9sC4iA/vIAFaOQYfGLCcPOaaPV5nkUCmYKRuXYYhYcFM3ugWmQoGWg9N0fpF6L
         vKrdmLbFlQmVnMbLH/pk+k6lxbS61RC+2lEX8hOXbpha9mrUgcVh43gpoUfQASjF0B
         eDQZXxsJk2mc0RII00ntB61W5xFSt4j50Nq5tOVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Howard Chiu <howard_chiu@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/132] ARM: dts: aspeed: Add video engine to g6
Date:   Mon, 23 May 2022 19:04:36 +0200
Message-Id: <20220523165834.327044759@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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
index 8f947ed47fc5..e5724b1a2e20 100644
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



