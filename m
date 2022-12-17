Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0D164F599
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 01:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiLQAKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 19:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiLQAKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 19:10:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F93973B29;
        Fri, 16 Dec 2022 16:10:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0D9B621A1;
        Sat, 17 Dec 2022 00:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DEDC433EF;
        Sat, 17 Dec 2022 00:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671235807;
        bh=F3IKvQb3dRbjUiVsFJJ7ZrKVxoZYc4KMN2m0fvwocZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qeW38RrqOM2KJ7vI8d/LKcjPErCe5R277VsXu3MD0bIgsDhoT/Ijcg135fh3e4Jol
         xbI0TEJpZE5FWHn4K4N13p7o1i/0p75/1XQZLTPvfFqvYogyhrhISYAng9a9XZtxWW
         Sy7Dey4xsfNFwYHowxTAu+pSh8+QpE1EjgCgs0A531FmzRtDZh0J6h4i/Y0LWG8K10
         Dxm+YK5pztR+rK8tWUsoZmRYLCGXxiVqDHEv5u9cCY1+Pyr7y0EKuTrpEi/CcJ2Su8
         Ai0lvZLIDZqx1zLfF25Lb2gsWKpKtp/TtFWNB7vCTD6MXZbQMHHW/vny4Wz+spzTCB
         9g+/tn+3BDUOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 7/9] arm64: dts: qcom: sm8450: disable SDHCI SDR104/SDR50 on all boards
Date:   Fri, 16 Dec 2022 19:09:34 -0500
Message-Id: <20221217000937.41115-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217000937.41115-1-sashal@kernel.org>
References: <20221217000937.41115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 9d561dc4e5cc31e757f91eb7bb709d2e2a8c9ce0 ]

SDHCI on SM8450 HDK also has problems with SDR104/SDR50:

  mmc0: card never left busy state
  mmc0: error -110 whilst initialising SD card

so I think it is safe to assume this issue affects all SM8450 boards.
Move the quirk disallowing these modes to the SoC DTSI, to spare people
working on other boards the misery of debugging this issue.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221026200357.391635-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts | 2 --
 arch/arm64/boot/dts/qcom/sm8450.dtsi                          | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts b/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts
index d68765eb6d4f..6351050bc87f 100644
--- a/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts
+++ b/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts
@@ -556,8 +556,6 @@ &sdhc_2 {
 	pinctrl-1 = <&sdc2_sleep_state &sdc2_card_det_n>;
 	vmmc-supply = <&pm8350c_l9>;
 	vqmmc-supply = <&pm8350c_l6>;
-	/* Forbid SDR104/SDR50 - broken hw! */
-	sdhci-caps-mask = <0x3 0x0>;
 	no-sdio;
 	no-mmc;
 	status = "okay";
diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index d32f08df743d..a91c40e4885f 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -3192,6 +3192,9 @@ sdhc_2: sdhci@8804000 {
 			bus-width = <4>;
 			dma-coherent;
 
+			/* Forbid SDR104/SDR50 - broken hw! */
+			sdhci-caps-mask = <0x3 0x0>;
+
 			status = "disabled";
 
 			sdhc2_opp_table: opp-table {
-- 
2.35.1

