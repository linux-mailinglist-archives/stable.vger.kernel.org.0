Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABEA56FB8A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiGKJcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiGKJbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:31:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDF2747A7;
        Mon, 11 Jul 2022 02:17:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37BBE61227;
        Mon, 11 Jul 2022 09:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436AAC34115;
        Mon, 11 Jul 2022 09:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531027;
        bh=CvZxMF564fImUCGGwfXZ9rZR8Plvf1bwcZjjJWcrvAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slzW9vM2bvQhphegeZxFh/lOcAq6IuIB/8hYU0YGkvAOj5yF/DsbDXfPYpueEEM/O
         vjgvuO2LhN9lwQy8KxwaF+IqTTLNfq/dMheGp9d3B266zgf/dFqpTy7fX4huiapJ8E
         /mBvujLWK5fBUG9KPvTrrHSbgE6QK05mzjsvEL2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 069/112] arm64: dts: qcom: msm8992-*: Fix vdd_lvs1_2-supply typo
Date:   Mon, 11 Jul 2022 11:07:09 +0200
Message-Id: <20220711090551.532705662@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index 3b0cc85d6674..71e373b11de9 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -74,7 +74,7 @@
 		vdd_l17_29-supply = <&vph_pwr>;
 		vdd_l20_21-supply = <&vph_pwr>;
 		vdd_l25-supply = <&pm8994_s5>;
-		vdd_lvs1_2 = <&pm8994_s4>;
+		vdd_lvs1_2-supply = <&pm8994_s4>;
 
 		/* S1, S2, S6 and S12 are managed by RPMPD */
 
diff --git a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
index 84558ab5fe86..ae882bfbf48d 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
@@ -143,7 +143,7 @@
 		vdd_l17_29-supply = <&vph_pwr>;
 		vdd_l20_21-supply = <&vph_pwr>;
 		vdd_l25-supply = <&pm8994_s5>;
-		vdd_lvs1_2 = <&pm8994_s4>;
+		vdd_lvs1_2-supply = <&pm8994_s4>;
 
 		/* S1, S2, S6 and S12 are managed by RPMPD */
 
-- 
2.35.1



