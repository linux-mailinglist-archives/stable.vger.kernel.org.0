Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B35564A12D
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiLLNgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiLLNft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:35:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD73513F30
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:35:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89049B8068B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F017C433D2;
        Mon, 12 Dec 2022 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852146;
        bh=6Q/ceYq2bcnZr3s3d6tLNoBiaxGV2h9u/VNlpMX+ekw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCDPkKUZbefkAf1rYSsthGayUr+EN/QqRuGRRVSLfsojJjDZANGldk6PiJHONNNH3
         QavYOi70atjYUFDH2Y0hUgPVYOYuMTKiQvqWK/2M+O1Q0IOLxP20oqnBsTlVTV9T7z
         dS1nYuVJc91JBfguS67Lk93MoYUpLuyTkHtVoJ5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 020/157] ARM: dts: rockchip: disable arm_global_timer on rk3066 and rk3188
Date:   Mon, 12 Dec 2022 14:16:08 +0100
Message-Id: <20221212130935.296560236@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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
index b8f34bef0efa..44b54af0bbf9 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -607,7 +607,6 @@
 
 &global_timer {
 	interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
-	status = "disabled";
 };
 
 &local_timer {
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index 616a828e0c6e..17e89d30de78 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -76,6 +76,13 @@
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



