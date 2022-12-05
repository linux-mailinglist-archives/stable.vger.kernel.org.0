Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0033B643237
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbiLETZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiLETZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:25:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8197727FCD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:20:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31538B80EFD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8227BC433D6;
        Mon,  5 Dec 2022 19:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268037;
        bh=KX13tLEhoTROJ3VvFrKR4hH96s7o7aBWs7Ww5QE7dao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmHGRskKQBPZRb38n6D0S+4i0KDGOKsVM0LVSJYKwO8u+LKmUmyVpLryN89rQNbhY
         8WVNd0k0Gvm/hMIZ5oQAU5O49XHlI4IawyjVv+dbcK/XLmFViL/Vs5uDJbnM0L09OV
         vDrheng53llSUlTIwMU6WK9ymKk++7xhWgP8x9gI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 4.19 035/105] arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency
Date:   Mon,  5 Dec 2022 20:09:07 +0100
Message-Id: <20221205190804.327832365@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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

From: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>

commit 91e8b74fe6381e083f8aa55217bb0562785ab398 upstream.

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
Link: https://lore.kernel.org/r/20221019-upstream-puma-sd-40mhz-v1-0-754a76421518@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
@@ -203,7 +203,7 @@
 	cap-sd-highspeed;
 	cd-gpios = <&gpio0 RK_PA7 GPIO_ACTIVE_LOW>;
 	disable-wp;
-	max-frequency = <150000000>;
+	max-frequency = <40000000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc_clk &sdmmc_cmd &sdmmc_cd &sdmmc_bus4>;
 	vmmc-supply = <&vcc3v3_baseboard>;


