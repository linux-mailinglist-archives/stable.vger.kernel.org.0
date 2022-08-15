Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C7C594033
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345194AbiHOUrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346769AbiHOUqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:46:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517CEB7296;
        Mon, 15 Aug 2022 12:08:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45ABD6077B;
        Mon, 15 Aug 2022 19:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC1AC433D6;
        Mon, 15 Aug 2022 19:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590519;
        bh=mq+CtN7rPgtSlZEf05FUxvje3ElW+F118U2FUc+iF8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofZqYMqaKvOAAiWLrYfS2nvQmEfXrUpqID0yzvVpTHzlNKxTacEh8K3LuTkHRRkyO
         DijhdwVh2JFf46wncWsribDppE+NbqmTqqZm9xoSh6XSuyzZ6R2lWCWZJ5v0b6kVHn
         TJJEFdlSiti56Y0BS0nkzb6U9TUiQ/THxjpS8ESo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca@z3ntu.xyz>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0285/1095] ARM: dts: qcom: msm8974: Disable remoteprocs by default
Date:   Mon, 15 Aug 2022 19:54:44 +0200
Message-Id: <20220815180441.583050835@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
 arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts | 2 ++
 arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts  | 2 ++
 arch/arm/boot/dts/qcom-msm8974.dtsi              | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
index 32975f56f896..085591183592 100644
--- a/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-fairphone-fp2.dts
@@ -132,10 +132,12 @@ wcnss {
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
diff --git a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
index 3b1ea8c24f57..9ef5a68747f1 100644
--- a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
@@ -467,10 +467,12 @@ fuelgauge_pin: fuelgauge-int-pin {
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
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 7a25d313e4fb..05a36566bd52 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -1150,6 +1150,8 @@ remoteproc_mss: remoteproc@fc880000 {
 			qcom,smem-states = <&modem_smp2p_out 0>;
 			qcom,smem-state-names = "stop";
 
+			status = "disabled";
+
 			mba {
 				memory-region = <&mba_region>;
 			};
@@ -1401,6 +1403,8 @@ remoteproc_adsp: remoteproc@fe200000 {
 			qcom,smem-states = <&adsp_smp2p_out 0>;
 			qcom,smem-state-names = "stop";
 
+			status = "disabled";
+
 			smd-edge {
 				interrupts = <GIC_SPI 156 IRQ_TYPE_EDGE_RISING>;
 
-- 
2.35.1



