Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FA363B047
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiK1Rt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiK1Rrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:47:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CEF1A223;
        Mon, 28 Nov 2022 09:42:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9333CB80E96;
        Mon, 28 Nov 2022 17:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5956DC433B5;
        Mon, 28 Nov 2022 17:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657368;
        bh=eVRo4bHlsQx6r8wW61Kgeyqm8gZl5vPhd/u+YKEWw0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWnM9YQiF6Ya6rIFymFsQwEGkHHQKv0vpwXzw2hIGrsguLW6TvMOanlSTuRz9H1Ud
         yfLb80NmjzEJIbx9GKtjy0/8lZ8UsHXkMl1Q1IevvvoBJv34K3YyXJa6T1oNtxl4UL
         erCd3czY8sLe5C1c/ABD0bVFm9hi+BrU6aMPGqSOsZ1VE/MMe0tsOtHs5TsFLyvEyr
         ICTZBHbsC6Oay46ceoZkNOBOzeLbFuYzEmducdpXKZCGk6bvktP83Ip1UKl1hQSIbL
         xZScQ7zf7KkJSzT9YFgl6YIGG9OmIzJE3L+O3PNCx6XRH4aqR4rrznQFREQXQNX6mx
         jhir2Iref6MBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/12] ARM: dts: rockchip: disable arm_global_timer on rk3066 and rk3188
Date:   Mon, 28 Nov 2022 12:42:28 -0500
Message-Id: <20221128174235.1442841-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174235.1442841-1-sashal@kernel.org>
References: <20221128174235.1442841-1-sashal@kernel.org>
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
index 3b7cae6f4127..24efc9b31d89 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -509,7 +509,6 @@ &emac {
 
 &global_timer {
 	interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
-	status = "disabled";
 };
 
 &local_timer {
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index 86a0d98d28ff..1b6429843bd4 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -108,6 +108,13 @@ global_timer: global-timer@1013c200 {
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

