Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA985FB505
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJKOuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJKOuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:50:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7683B727;
        Tue, 11 Oct 2022 07:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2E84611B1;
        Tue, 11 Oct 2022 14:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E5EC433C1;
        Tue, 11 Oct 2022 14:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499830;
        bh=PK9pyYValBcm9OunKPNfoo7NdKhgn7VnsG70GI4Y2E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bnkc8fxThwMP8/Ax3LCjJ0ApKYNyNohHT8Ojw4hPtnLM3dsT6PWvbr7vFcy+uZQUy
         AkjPjpCXPnKxF+UK3G1etP9r1usF6GdR2Boowlv7JaVrxmkPP4GP5Yz8/mnPWLFgNz
         mqFi2yywt1xgeIqCntni9jTvNL/0O6SYUcXp4abHkRbjxetIVBF0T7CVnjFZI7Hi96
         tTjhwB569Ma19ndGA+nTiUETFc//BrB65Un973wsEoK0lSRwGXmgWgUynwxMZRabQq
         u9BFyDBXjaV/za3RrvEwAmfBNVz7F6oUfpVgeTtk0kLdNXjl7KjoStviO56dOMNN3P
         GzBgk0yrtiJjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 09/46] ARM: dts: imx6sl: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:49:37 -0400
Message-Id: <20221011145015.1622882-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 60c9213a1d9941a8b33db570796c3f9be8984974 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sl.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 06a515121dfc..cfd6b4972ae7 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -115,6 +115,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SL_CLK_OCRAM>;
 		};
 
-- 
2.35.1

