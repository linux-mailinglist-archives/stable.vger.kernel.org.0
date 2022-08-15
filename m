Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02B459479E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243089AbiHOXIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352994AbiHOXG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:06:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1552386704;
        Mon, 15 Aug 2022 12:59:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90BEFB80EB1;
        Mon, 15 Aug 2022 19:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6B8C433C1;
        Mon, 15 Aug 2022 19:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593541;
        bh=6+wA0NmZlSrQQuTg7iIoaIhed/v8R2Ua5FQQXmq+c7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHliD1EQunhhpL8XeRTGSI14rhCCvWnuyjcY885jIxbjauc+qBQP0xymPklG7anxu
         180ntmpYG+Qidjiuoeqr/rJz4wPTPLLLlKW7JeNqSuEDHMsshMrd55YyF84wW+RNp0
         BVWcXoas8B3I5SCLos4Ih89uB8UFxDCNQnGmGId0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca@z3ntu.xyz>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0285/1157] ARM: dts: qcom: msm8974: Disable remoteprocs by default
Date:   Mon, 15 Aug 2022 19:54:01 +0200
Message-Id: <20220815180451.017500034@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit 8d8be8dd7c1f5d50f84ecc7a6a41962da48c6164 ]

The remoteproc configuration in qcom-msm8974.dtsi is incomplete because
it lacks the regulator supplies that should be added in the board DT
files. Some of the msm8974 boards are currently missing the regulator
supplies and should have the remoteprocs disabled to avoid making use
of the incomplete configuration.

This also fixes dtbs_check warnings after moving "qcom,msm8974-mss-pil"
to DT schema, which rightfully complains that the -supply properties
are missing for some boards:

qcom-apq8074-dragonboard.dtb:
remoteproc@fc880000: 'pll-supply' is a required property
        From schema: remoteproc/qcom,msm8916-mss-pil.yaml
remoteproc@fc880000: 'mss-supply' is a required property
        From schema: remoteproc/qcom,msm8916-mss-pil.yaml
remoteproc@fc880000: 'oneOf' conditional failed, one must be fixed:
        'power-domains' is a required property
        'power-domain-names' is a required property, or
        'cx-supply' is a required property
        'mx-supply' is a required property

Cc: Luca Weiss <luca@z3ntu.xyz>
Cc: Konrad Dybcio <konrad.dybcio@somainline.org>
Fixes: f300826d27be ("ARM: dts: qcom-msm8974: Sort and clean up nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220712124421.3129206-4-stephan.gerhold@kernkonzept.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi                 | 4 ++++
 arch/arm/boot/dts/qcom-msm8974pro-fairphone-fp2.dts | 2 ++
 arch/arm/boot/dts/qcom-msm8974pro-samsung-klte.dts  | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 3c31c95aa6b9..2d9416d1a6c8 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -1182,6 +1182,8 @@ remoteproc_mss: remoteproc@fc880000 {
 			qcom,smem-states = <&modem_smp2p_out 0>;
 			qcom,smem-state-names = "stop";
 
+			status = "disabled";
+
 			mba {
 				memory-region = <&mba_region>;
 			};
@@ -1662,6 +1664,8 @@ remoteproc_adsp: remoteproc@fe200000 {
 			qcom,smem-states = <&adsp_smp2p_out 0>;
 			qcom,smem-state-names = "stop";
 
+			status = "disabled";
+
 			smd-edge {
 				interrupts = <GIC_SPI 156 IRQ_TYPE_EDGE_RISING>;
 
diff --git a/arch/arm/boot/dts/qcom-msm8974pro-fairphone-fp2.dts b/arch/arm/boot/dts/qcom-msm8974pro-fairphone-fp2.dts
index 58cb2ce1e4df..8a6b8e4de887 100644
--- a/arch/arm/boot/dts/qcom-msm8974pro-fairphone-fp2.dts
+++ b/arch/arm/boot/dts/qcom-msm8974pro-fairphone-fp2.dts
@@ -147,10 +147,12 @@ wcnss {
 };
 
 &remoteproc_adsp {
+	status = "okay";
 	cx-supply = <&pm8841_s2>;
 };
 
 &remoteproc_mss {
+	status = "okay";
 	cx-supply = <&pm8841_s2>;
 	mss-supply = <&pm8841_s3>;
 	mx-supply = <&pm8841_s1>;
diff --git a/arch/arm/boot/dts/qcom-msm8974pro-samsung-klte.dts b/arch/arm/boot/dts/qcom-msm8974pro-samsung-klte.dts
index d6b2300a8223..577cbffad010 100644
--- a/arch/arm/boot/dts/qcom-msm8974pro-samsung-klte.dts
+++ b/arch/arm/boot/dts/qcom-msm8974pro-samsung-klte.dts
@@ -457,10 +457,12 @@ fuelgauge_pin: fuelgauge-int-pin {
 };
 
 &remoteproc_adsp {
+	status = "okay";
 	cx-supply = <&pma8084_s2>;
 };
 
 &remoteproc_mss {
+	status = "okay";
 	cx-supply = <&pma8084_s2>;
 	mss-supply = <&pma8084_s6>;
 	mx-supply = <&pma8084_s1>;
-- 
2.35.1



