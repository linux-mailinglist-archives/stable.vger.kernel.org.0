Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7EC6985E8
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjBOUqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjBOUqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:46:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9589C3C7B5;
        Wed, 15 Feb 2023 12:46:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35433B823B6;
        Wed, 15 Feb 2023 20:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A10C433EF;
        Wed, 15 Feb 2023 20:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493968;
        bh=pJ9qyWBsr9mPd+z6Cn2KF2wKt9ulc41prE/bP5SrksQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgMToS6ccMA0FE4E/0CP528cLPQqMVUj1pzo7lP1AXyHeSoD4CDgi7spKT1YbPMz7
         wmKRNivhUzgdbS1vmmfaGdqxrLR4sDfFJBovsCOlLhaA7oQ4lc+AI6osszqItOEg4F
         kk4ret2U2JyjNHo++x0OY96E/h42LbsA7A/QkyRmqAlCM67D/D445EVYPTwuAKWpqM
         Bh84+2MakV9SWs8/qc7HFd9RtkqQlhwtCnVyPSmHpxTQ2OCm2KIBg1Oa//d+zPMrrY
         dLXWXknkMAjnGPb+ccP0WjzZHTSupaGt8cGmWISkAxrHxqaFJcmv8lKgsSrNpNJWx/
         d/syj2kJBfQHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonas Karlman <jonas@kwiboo.se>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, amadeus@jmu.edu.cn,
        wiagn233@outlook.com, linux.amoon@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 06/24] arm64: dts: rockchip: fix probe of analog sound card on rock-3a
Date:   Wed, 15 Feb 2023 15:45:29 -0500
Message-Id: <20230215204547.2760761-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 1104693cdfcd337e73ab585a225f05445ff7a864 ]

The following was observed on my Radxa ROCK 3 Model A board:

  rockchip-pinctrl pinctrl: pin gpio1-9 already requested by vcc-cam-regulator; cannot claim for fe410000.i2s
  ...
  platform rk809-sound: deferred probe pending

Fix this by supplying a board specific pinctrl with the i2s1 pins used
by pmic codec according to the schematic [1].

[1] https://dl.radxa.com/rock3/docs/hw/3a/ROCK-3A-V1.3-SCH.pdf

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Acked-by: Michael Riesch <michael.riesch@wolfvision.net>
Link: https://lore.kernel.org/r/20230115211553.445007-1-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
index 44313a18e484e..bab46db2b18cd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
@@ -521,6 +521,8 @@ &i2s0_8ch {
 };
 
 &i2s1_8ch {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2s1m0_sclktx &i2s1m0_lrcktx &i2s1m0_sdi0 &i2s1m0_sdo0>;
 	rockchip,trcm-sync-tx-only;
 	status = "okay";
 };
-- 
2.39.0

