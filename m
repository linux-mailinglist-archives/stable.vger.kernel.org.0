Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695F563B051
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiK1Rtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiK1Rs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:48:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FEE2AE06;
        Mon, 28 Nov 2022 09:43:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8163612C4;
        Mon, 28 Nov 2022 17:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DC3C4347C;
        Mon, 28 Nov 2022 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657396;
        bh=/oGrLYV9w73kWoPiPHi9riy+YOU1tQ2Cb2dnNSH+7TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQ+NELxZ+1Ba3G6qOrkbDSPVAHUgAm3PMDtVsr4qwm+oNv+0eCU09EG0knWR04sT1
         S2idUZ1J0JcMUYSXiXyNk2tTcNjo/6lvbF+TW6F0ThrzGMSVHcRTLnaFA/ArIFKSdW
         xREaAFc1SOZN+51YWVKphAUAlwo798mcDrcZiW+20i9cnzdavFR9NCfba+KQhyps54
         qv4EQd2JnTzH1Q7qTpTWmX5J1AwqWmLMVZYhE7A3NwE42y75dU9RojxerkFuo58nRn
         zQ5kG/tAHpIyNhcsI9MPhdYvaHn13j0JltrbBb9EYGT2FOqdxEnolmOuuKeckk59rA
         Oc14N89KHtITg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/9] ARM: dts: rockchip: disable arm_global_timer on rk3066 and rk3188
Date:   Mon, 28 Nov 2022 12:42:58 -0500
Message-Id: <20221128174303.1443008-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174303.1443008-1-sashal@kernel.org>
References: <20221128174303.1443008-1-sashal@kernel.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit da74858a475782a3f16470907814c8cc5950ad68 ]

The clock source and the sched_clock provided by the arm_global_timer
on Rockchip rk3066a/rk3188 are quite unstable because their rates
depend on the CPU frequency.

Recent changes to the arm_global_timer driver makes it impossible to use.

On the other side, the arm_global_timer has a higher rating than the
ROCKCHIP_TIMER, it will be selected by default by the time framework
while we want to use the stable Rockchip clock source.

Keep the arm_global_timer disabled in order to have the
DW_APB_TIMER (rk3066a) or ROCKCHIP_TIMER (rk3188) selected by default.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/f275ca8d-fd0a-26e5-b978-b7f3df815e0a@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3188.dtsi | 1 -
 arch/arm/boot/dts/rk3xxx.dtsi | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index 74eb1dfa2f6c..3689a23a1bca 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -546,7 +546,6 @@ &emac {
 
 &global_timer {
 	interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
-	status = "disabled";
 };
 
 &local_timer {
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index 4aa6f60d6a22..5f9950704f13 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -134,6 +134,13 @@ global_timer: global-timer@1013c200 {
 		reg = <0x1013c200 0x20>;
 		interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_EDGE_RISING)>;
 		clocks = <&cru CORE_PERI>;
+		status = "disabled";
+		/* The clock source and the sched_clock provided by the arm_global_timer
+		 * on Rockchip rk3066a/rk3188 are quite unstable because their rates
+		 * depend on the CPU frequency.
+		 * Keep the arm_global_timer disabled in order to have the
+		 * DW_APB_TIMER (rk3066a) or ROCKCHIP_TIMER (rk3188) selected by default.
+		 */
 	};
 
 	local_timer: local-timer@1013c600 {
-- 
2.35.1

