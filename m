Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D249B603EDE
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiJSJWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiJSJUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DC91C41E;
        Wed, 19 Oct 2022 02:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 563F96186E;
        Wed, 19 Oct 2022 08:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554EBC433D7;
        Wed, 19 Oct 2022 08:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169852;
        bh=ydGjh0C3/rjhYKtzdIX5zVrzBYzbNRasu01fnkBC9AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJLc9EuUoJjcGqY3dACCxIjOFhgxcPi5LpGXdhgNDc/HvRbFLpxSNv4gOyLbNgDuo
         LhLTS6m1tOMHXh2P7W/ajCLMKLoa3zNvVjBF6ksuwP4gk45mQEJ2XeOYxHcT+aQcmx
         BNBs3zpTetdXcNiFUf0LyPOigVnn9dv+ARwENWCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 433/862] arm64: dts: qcom: sc7180-trogdor: Keep pm6150_adc enabled for TZ
Date:   Wed, 19 Oct 2022 10:28:40 +0200
Message-Id: <20221019083309.103905831@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 144fbd028fdec2deeb3b99d5e60dbf3167950ebe ]

There's still a thermal zone using pm6150_adc in the pm6150.dtsi file,
pm6150_thermal. It's not super obvious because it indirectly uses the
adc through an iio channel in pm6150_temp. Let's keep this enabled on
lazor and coachz so that reading the temperature of the pm6150_thermal
zone continues to work. Otherwise we get -EINVAL when reading the zone,
and I suspect the PMIC temperature trip doesn't work properly so we
don't shutdown when the PMIC overheats.

Cc: Matthias Kaehlcke <mka@chromium.org>
Fixes: b8d1e3d33487 ("arm64: dts: qcom: sc7180-trogdor: Delete ADC config for unused thermistors")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220827004901.511543-1-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts | 2 --
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi    | 2 --
 2 files changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts
index 8290d036044a..edfcd47e1a00 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts
@@ -24,8 +24,6 @@
 };
 
 &pm6150_adc {
-	status = "disabled";
-
 	/delete-node/ skin-temp-thermistor@4e;
 	/delete-node/ charger-thermistor@4f;
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
index 2cf7d5212c61..002663d752da 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
@@ -55,8 +55,6 @@ ap_ts_pen_1v8: &i2c4 {
 };
 
 &pm6150_adc {
-	status = "disabled";
-
 	/delete-node/ charger-thermistor@4f;
 };
 
-- 
2.35.1



