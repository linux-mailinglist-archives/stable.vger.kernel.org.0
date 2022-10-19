Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA0C604987
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 16:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJSOml convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 19 Oct 2022 10:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiJSOmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 10:42:21 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510C0192D87;
        Wed, 19 Oct 2022 07:27:54 -0700 (PDT)
Received: (Authenticated sender: foss@0leil.net)
        by mail.gandi.net (Postfix) with ESMTPSA id 6AECBFF805;
        Wed, 19 Oct 2022 14:27:50 +0000 (UTC)
From:   Quentin Schulz <foss+kernel@0leil.net>
To:     foss+kernel@0leil.net,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency
Date:   Wed, 19 Oct 2022 16:27:27 +0200
Message-Id: <20221019-upstream-puma-sd-40mhz-v1-0-754a76421518@theobroma-systems.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.10.1
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

From: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>

CRC errors (code -84 EILSEQ) have been observed for some SanDisk
Ultra A1 cards when running at 50MHz.

Waveform analysis suggest that the level shifters that are used on the
RK3399-Q7 module for voltage translation between 3.0 and 3.3V don't
handle clock rates at or above 48MHz properly. Back off to 40MHz for
some safety margin.

Cc: stable@vger.kernel.org
Fixes: 60fd9f72ce8a ("arm64: dts: rockchip: add Haikou baseboard with RK3399-Q7 SoM")
Signed-off-by: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
---
We've been carrying this patch downstream for years and completely forgot to
upstream it. This is now done.

To: Rob Herring <robh+dt@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
index 04c752f49be9..115c14c0a3c6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
@@ -207,7 +207,7 @@ &sdmmc {
 	cap-sd-highspeed;
 	cd-gpios = <&gpio0 RK_PA7 GPIO_ACTIVE_LOW>;
 	disable-wp;
-	max-frequency = <150000000>;
+	max-frequency = <40000000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc_clk &sdmmc_cmd &sdmmc_cd &sdmmc_bus4>;
 	vmmc-supply = <&vcc3v3_baseboard>;

---
base-commit: aae703b02f92bde9264366c545e87cec451de471
change-id: 20221019-upstream-puma-sd-40mhz-b5aef1c351e6

Best regards,
-- 
Quentin Schulz <quentin.schulz@theobroma-systems.com>
