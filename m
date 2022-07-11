Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F0F56FDDD
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbiGKKBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiGKKAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:00:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F22D77A53;
        Mon, 11 Jul 2022 02:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40FC0B80E87;
        Mon, 11 Jul 2022 09:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868A7C34115;
        Mon, 11 Jul 2022 09:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531689;
        bh=Hvax53qgUXZsqWatbkd00eJvztr3uDyt+Tr8Kc4Y1WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thFOMEOuQ/TJ8yXUr0jnn+wrg+aRKY96wHoDsM4RMf2T5T4splbu+KdJHe75Gd2pJ
         RpZzSP55hGbr9PH8CX8I5bKqXEHDWcvwrwGSeUgKnduQIV/Y7AJJ38Uv2mI1vxipwQ
         ONVWxvIXM+ixbbj5jSlQGT/kQoODtH3vjlveNX2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/230] arm64: dts: qcom: msm8992-*: Fix vdd_lvs1_2-supply typo
Date:   Mon, 11 Jul 2022 11:07:32 +0200
Message-Id: <20220711090609.667912132@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit 5fb779558f1c97e2bf2794cb59553e569c38e2f9 ]

"make dtbs_check" complains about the missing "-supply" suffix for
vdd_lvs1_2 which is clearly a typo, originally introduced in the
msm8994-smd-rpm.dtsi file and apparently later copied to
msm8992-xiaomi-libra.dts:

msm8992-lg-bullhead-rev-10/101.dtb: pm8994-regulators: 'vdd_lvs1_2'
does not match any of the regexes:
  '.*-supply$', '^((s|l|lvs|5vs)[0-9]*)|(boost-bypass)|(bob)$', 'pinctrl-[0-9]+'
>From schema: regulator/qcom,smd-rpm-regulator.yaml

msm8992-xiaomi-libra.dtb: pm8994-regulators: 'vdd_lvs1_2'
does not match any of the regexes:
  '.*-supply$', '^((s|l|lvs|5vs)[0-9]*)|(boost-bypass)|(bob)$', 'pinctrl-[0-9]+'
>From schema: regulator/qcom,smd-rpm-regulator.yaml

Reported-by: Rob Herring <robh@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@somainline.org>
Fixes: f3b2c99e73be ("arm64: dts: Enable onboard SDHCI on msm8992")
Fixes: 0f5cdb31e850 ("arm64: dts: qcom: Add Xiaomi Libra (Mi 4C) device tree")
Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220627135938.2901871-1-stephan.gerhold@kernkonzept.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts | 2 +-
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
index 1ccca83292ac..c7d191dc6d4b 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
@@ -74,7 +74,7 @@
 		vdd_l17_29-supply = <&vph_pwr>;
 		vdd_l20_21-supply = <&vph_pwr>;
 		vdd_l25-supply = <&pm8994_s5>;
-		vdd_lvs1_2 = <&pm8994_s4>;
+		vdd_lvs1_2-supply = <&pm8994_s4>;
 
 		/* S1, S2, S6 and S12 are managed by RPMPD */
 
diff --git a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
index 357d55496e75..a3d6340a0c55 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
@@ -142,7 +142,7 @@
 		vdd_l17_29-supply = <&vph_pwr>;
 		vdd_l20_21-supply = <&vph_pwr>;
 		vdd_l25-supply = <&pm8994_s5>;
-		vdd_lvs1_2 = <&pm8994_s4>;
+		vdd_lvs1_2-supply = <&pm8994_s4>;
 
 		/* S1, S2, S6 and S12 are managed by RPMPD */
 
-- 
2.35.1



