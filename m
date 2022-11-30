Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E29063DF36
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiK3So7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiK3Soj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE699894E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:44:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D403161D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DACC433C1;
        Wed, 30 Nov 2022 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833873;
        bh=P7VgSkt0gS/878XSTQbXe5Dhvu2xlRta4sHCH7zol6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeuin1DpfXato5N4hVrWXtkKDdOqFtYqlA8yUPW+UGJmWiYjZtLY8HvLxYwCpmR4N
         lwyi5esM3F1le1ztggHoGhiX3Ufpclv7jjv/Z8tChiBBFrqUqTmF2WwLYPSKUXjgDv
         SS/izBU4FJpcge/+pE/qgPMBsckxddF4DwLWJ/0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lev Popov <leo@nabam.net>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 045/289] arm64: dts: rockchip: fix quartz64-a bluetooth configuration
Date:   Wed, 30 Nov 2022 19:20:30 +0100
Message-Id: <20221130180545.151953986@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Lev Popov <leo@nabam.net>

[ Upstream commit 2dcd7e0c821fe9b663f7d3382b6d2faa8edf2129 ]

For "Quartz64 Model A" add missing RTS line to the UART interface used by
bluetooth and swap bluetooth host-wakeup and device-wakeup gpio pins to
match the boards physical layout. This changes are necessary to make
bluetooth provided by the wireless module work.

Also set max-speed on the bluetooth device as it's not automatically
detected.

Fixes: b33a22a1e7c4 ("arm64: dts: rockchip: add basic dts for Pine64 Quartz64-A")
Signed-off-by: Lev Popov <leo@nabam.net>
Link: https://lore.kernel.org/r/20220926125350.64783-1-leo@nabam.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts b/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts
index a05460b92415..25a8c781f4e7 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts
@@ -740,7 +740,7 @@ &uart0 {
 
 &uart1 {
 	pinctrl-names = "default";
-	pinctrl-0 = <&uart1m0_xfer &uart1m0_ctsn>;
+	pinctrl-0 = <&uart1m0_xfer &uart1m0_ctsn &uart1m0_rtsn>;
 	status = "okay";
 	uart-has-rtscts;
 
@@ -748,13 +748,14 @@ bluetooth {
 		compatible = "brcm,bcm43438-bt";
 		clocks = <&rk817 1>;
 		clock-names = "lpo";
-		device-wakeup-gpios = <&gpio2 RK_PC1 GPIO_ACTIVE_HIGH>;
-		host-wakeup-gpios = <&gpio2 RK_PC0 GPIO_ACTIVE_HIGH>;
+		host-wakeup-gpios = <&gpio2 RK_PC1 GPIO_ACTIVE_HIGH>;
+		device-wakeup-gpios = <&gpio2 RK_PC0 GPIO_ACTIVE_HIGH>;
 		shutdown-gpios = <&gpio2 RK_PB7 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&bt_host_wake_l &bt_wake_l &bt_enable_h>;
 		vbat-supply = <&vcc_sys>;
 		vddio-supply = <&vcca1v8_pmu>;
+		max-speed = <3000000>;
 	};
 };
 
-- 
2.35.1



