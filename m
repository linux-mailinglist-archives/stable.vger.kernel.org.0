Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC2E20F060
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 10:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbgF3IUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 04:20:20 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:52538 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728079AbgF3IUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 04:20:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1593505219; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=c70MMxXQxL9Q0nDICJFkGeCgnQoGRAhYSDB6a9QVanY=; b=UeEp+5tkO9aJViNi4zZ8wF32GBbEeYS0GSrZhb6rH7W19MJSwzjioFsSL0wse4NrosuS2l3B
 5CpxjNmrXLeDO4wbyXqf768RHB/5Coh10n3xd3HPtZabaFD08UClQLgypLH7KMCOaFtC5JNh
 d/ZDadQ4Y5+2YcEFqxYqUaQpdNk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n11.prod.us-east-1.postgun.com with SMTP id
 5efaf5b186de6ccd44d461b6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 30 Jun 2020 08:20:01
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B3007C433A1; Tue, 30 Jun 2020 08:20:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from blr-ubuntu-253.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sibis)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 97CBBC433C6;
        Tue, 30 Jun 2020 08:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 97CBBC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=sibis@codeaurora.org
From:   Sibi Sankar <sibis@codeaurora.org>
To:     bjorn.andersson@linaro.org
Cc:     agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, will@kernel.org,
        saiprakash.ranjan@codeaurora.org, robh+dt@kernel.org,
        evgreen@chromium.org, dianders@chromium.org, mka@chromium.org,
        devicetree@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH] arm64: dts: qcom: sc7180: Drop the unused non-MSA SID
Date:   Tue, 30 Jun 2020 13:49:38 +0530
Message-Id: <20200630081938.8131-1-sibis@codeaurora.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Having a non-MSA (Modem Self-Authentication) SID bypassed breaks modem
sandboxing i.e if a transaction were to originate from it, the hardware
memory protections units (XPUs) would fail to flag them (any transaction
originating from modem are historically termed as an MSA transaction).
Drop the unused non-MSA modem SID on SC7180 SoCs and cheza so that SMMU
continues to block them.

Fixes: bec71ba243e95 ("arm64: dts: qcom: sc7180: Update Q6V5 MSS node")
Fixes: 68aee4af5f620 ("arm64: dts: qcom: sdm845-cheza: Add iommus property")
Cc: stable@vger.kernel.org
Reported-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
---
 arch/arm64/boot/dts/qcom/sc7180-idp.dts    | 2 +-
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-idp.dts b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
index 39dbfc89689e8..141de49a1b7d6 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-idp.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
@@ -312,7 +312,7 @@ &qupv3_id_1 {
 &remoteproc_mpss {
 	status = "okay";
 	compatible = "qcom,sc7180-mss-pil";
-	iommus = <&apps_smmu 0x460 0x1>, <&apps_smmu 0x444 0x3>;
+	iommus = <&apps_smmu 0x461 0x0>, <&apps_smmu 0x444 0x3>;
 	memory-region = <&mba_mem &mpss_mem>;
 };
 
diff --git a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
index 70466cc4b4055..64fc1bfd66fad 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
@@ -634,7 +634,7 @@ &mdss_mdp {
 };
 
 &mss_pil {
-	iommus = <&apps_smmu 0x780 0x1>,
+	iommus = <&apps_smmu 0x781 0x0>,
 		 <&apps_smmu 0x724 0x3>;
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

