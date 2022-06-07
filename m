Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5B1541C28
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356322AbiFGV4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384148AbiFGVyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BCCBCEB0;
        Tue,  7 Jun 2022 12:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F17FAB823B3;
        Tue,  7 Jun 2022 19:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649AFC385A2;
        Tue,  7 Jun 2022 19:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629152;
        bh=3ln96m1f8OR5nh/j4MbOrTCjaT/9W5k0mT1TSWTYUks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1BMNRX90zxt4jHZk7xUu8RytK6Ub2r9rohnoi1PeTdLVX3WW0jtZqSoqiHrCCOKx
         ffMGgmqeFWntcJxV5X9eVADSqhmRqdmZw7fQ2Btk7JEwNg3WeLrSgysFBxLgtih241
         9s7uQ/1OswR7AQ+dnc/LFSRM/p4g5EP9pv0pbxR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Alexandru M Stan <amstan@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 548/879] arm64: dts: qcom: sc7280-herobrine: Drop outputs on fpmcu pins
Date:   Tue,  7 Jun 2022 19:01:06 +0200
Message-Id: <20220607165018.774208795@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit dbcbeed94f3b6f7f24349a7f335cc603a682e7a7 ]

Having these pins with outputs is good on a fresh boot because it puts
the boot and reset pins in a known "good" state. Unfortunately, that
conflicts with the fingerprint firmware flashing code. The firmware
flashing process binds and unbinds the cros-ec and spidev drivers and
that reapplies the pin output values after the flashing code has
overridden the gpio values. This causes a problem because we try to put
the device into bootloader mode, bind the spidev driver and that
inadvertently puts it right back into normal boot mode, breaking the
flashing process.

Fix this by removing the outputs. We'll introduce a binding for
fingerprint cros-ec specifically to set the gpios properly via gpio APIs
during cros-ec driver probe instead.

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Alexandru M Stan <amstan@chromium.org>
Fixes: 116f7cc43d28 ("arm64: dts: qcom: sc7280: Add herobrine-r1")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220317010640.2498502-2-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi b/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi
index 7b8fe20afcea..488caa48cba3 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi
@@ -677,7 +677,6 @@ ap_ec_spi: &spi10 {
 		function = "gpio";
 		bias-disable;
 		drive-strength = <2>;
-		output-high;
 	};
 
 	fp_to_ap_irq_l: fp-to-ap-irq-l {
@@ -691,7 +690,6 @@ ap_ec_spi: &spi10 {
 		pins = "gpio68";
 		function = "gpio";
 		bias-disable;
-		output-low;
 	};
 
 	gsc_ap_int_odl: gsc-ap-int-odl {
-- 
2.35.1



