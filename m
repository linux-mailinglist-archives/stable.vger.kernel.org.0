Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3962A404ECA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348771AbhIIMOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347868AbhIIMLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8310061A2A;
        Thu,  9 Sep 2021 11:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188122;
        bh=wlrHyYfPWKz23ai1ZnO5b4NKnVRwj7Rn0UBQRRpgyJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROIsoR1TaOrZujcCOggtoVtysV4KSjlPkuJRJ1+GbIut9SL8w+U+LygSkElxO2jXx
         3i+8LitLBgj3GPPFt4zwUd9+kKTDmBgIdut2V0V42AbDViTliy+zltF4/5Dy+thhLE
         IH4mLfqYPtzh710uI6cfoNivYCkpXfaiuFCpiELYfgCrdEVItv1Njw4D9gjF/7RpH9
         krjBd5f7JP+XijGXixZgl4hAJAQOhkAZkbmUm0SuF5dRqEnBM+vlTuMqNIipvQ2bNG
         3hfDkFruDEswptaVjO4yu1+w5HTU2nGsVtr8yv0piRKVmMVP6qMJ/XP8/Pf35mqbkl
         dR+i/LOLMYCRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 098/219] arm64: dts: qcom: sdm630: Rewrite memory map
Date:   Thu,  9 Sep 2021 07:44:34 -0400
Message-Id: <20210909114635.143983-98-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit 26e02c98a9ad63eb21b9be4ac92002f555130d3b ]

The memory map was wrong. Fix it.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210728222542.54269-2-konrad.dybcio@somainline.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 41 ++++++++++++----------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index f91a928466c3..5ea3884b3ccb 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -343,10 +343,19 @@ wlan_msa_mem: wlan-msa-mem@85700000 {
 		};
 
 		qhee_code: qhee-code@85800000 {
-			reg = <0x0 0x85800000 0x0 0x3700000>;
+			reg = <0x0 0x85800000 0x0 0x600000>;
 			no-map;
 		};
 
+		rmtfs_mem: memory@85e00000 {
+			compatible = "qcom,rmtfs-mem";
+			reg = <0x0 0x85e00000 0x0 0x200000>;
+			no-map;
+
+			qcom,client-id = <1>;
+			qcom,vmid = <15>;
+		};
+
 		smem_region: smem-mem@86000000 {
 			reg = <0 0x86000000 0 0x200000>;
 			no-map;
@@ -357,58 +366,44 @@ tz_mem: memory@86200000 {
 			no-map;
 		};
 
-		modem_fw_mem: modem-fw-region@8ac00000 {
+		mpss_region: mpss@8ac00000 {
 			reg = <0x0 0x8ac00000 0x0 0x7e00000>;
 			no-map;
 		};
 
-		adsp_fw_mem: adsp-fw-region@92a00000 {
+		adsp_region: adsp@92a00000 {
 			reg = <0x0 0x92a00000 0x0 0x1e00000>;
 			no-map;
 		};
 
-		pil_mba_mem: pil-mba-region@94800000 {
+		mba_region: mba@94800000 {
 			reg = <0x0 0x94800000 0x0 0x200000>;
 			no-map;
 		};
 
-		buffer_mem: buffer-region@94a00000 {
+		buffer_mem: tzbuffer@94a00000 {
 			reg = <0x0 0x94a00000 0x0 0x100000>;
 			no-map;
 		};
 
-		venus_fw_mem: venus-fw-region@9f800000 {
+		venus_region: venus@9f800000 {
 			reg = <0x0 0x9f800000 0x0 0x800000>;
 			no-map;
 		};
 
-		secure_region2: secure-region2@f7c00000 {
-			reg = <0x0 0xf7c00000 0x0 0x5c00000>;
-			no-map;
-		};
-
 		adsp_mem: adsp-region@f6000000 {
 			reg = <0x0 0xf6000000 0x0 0x800000>;
 			no-map;
 		};
 
-		qseecom_ta_mem: qseecom-ta-region@fec00000 {
-			reg = <0x0 0xfec00000 0x0 0x1000000>;
-			no-map;
-		};
-
 		qseecom_mem: qseecom-region@f6800000 {
 			reg = <0x0 0xf6800000 0x0 0x1400000>;
 			no-map;
 		};
 
-		secure_display_memory: secure-region@f5c00000 {
-			reg = <0x0 0xf5c00000 0x0 0x5c00000>;
-			no-map;
-		};
-
-		cont_splash_mem: cont-splash-region@9d400000 {
-			reg = <0x0 0x9d400000 0x0 0x23ff000>;
+		zap_shader_region: gpu@fed00000 {
+			compatible = "shared-dma-pool";
+			reg = <0x0 0xfed00000 0x0 0xa00000>;
 			no-map;
 		};
 	};
-- 
2.30.2

