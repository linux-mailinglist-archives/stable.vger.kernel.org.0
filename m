Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94505593E1C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245555AbiHOUg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345910AbiHOUeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:34:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BD82AE23;
        Mon, 15 Aug 2022 12:06:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45DBA61299;
        Mon, 15 Aug 2022 19:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A2BC433D6;
        Mon, 15 Aug 2022 19:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590366;
        bh=0b0R6RaL4DcQ7B6NQpB2BTI806Onu2sADIXafVLrug0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pffOw2tNFBoBeUHssfOJOc9JgDU14JeRB0y2tN+mf/QQb9o9VyAG0cvbw+rrl6LeC
         9qpvGNtxFNGff7H9LLvfmmEHw2AqKmiM8Yan9uHUk22/++nl7la86MSElTs6oDS1Zu
         6MpUyPgLJ9EU5SQRzzbVBYY0+M6r+ZlH0X3zLCpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0238/1095] ARM: dts: qcom-msm8974: Convert ADSP to a MMIO device
Date:   Mon, 15 Aug 2022 19:53:57 +0200
Message-Id: <20220815180439.629057638@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 2daa785817dd35172b856c30fc5148b2773b6891 ]

The cx-supply has been removed as it's supposed to be set on a
per-board basis.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-17-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 60 ++++++++++++++---------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index ea3491d47b9f..e6c9782e4670 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -341,36 +341,6 @@ timer {
 		clock-frequency = <19200000>;
 	};
 
-	remoteproc_adsp: adsp-pil {
-		compatible = "qcom,msm8974-adsp-pil";
-
-		interrupts-extended = <&intc GIC_SPI 162 IRQ_TYPE_EDGE_RISING>,
-				      <&adsp_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
-				      <&adsp_smp2p_in 1 IRQ_TYPE_EDGE_RISING>,
-				      <&adsp_smp2p_in 2 IRQ_TYPE_EDGE_RISING>,
-				      <&adsp_smp2p_in 3 IRQ_TYPE_EDGE_RISING>;
-		interrupt-names = "wdog", "fatal", "ready", "handover", "stop-ack";
-
-		cx-supply = <&pm8841_s2>;
-
-		clocks = <&xo_board>;
-		clock-names = "xo";
-
-		memory-region = <&adsp_region>;
-
-		qcom,smem-states = <&adsp_smp2p_out 0>;
-		qcom,smem-state-names = "stop";
-
-		smd-edge {
-			interrupts = <GIC_SPI 156 IRQ_TYPE_EDGE_RISING>;
-
-			qcom,ipc = <&apcs 8 8>;
-			qcom,smd-edge = <1>;
-
-			label = "lpass";
-		};
-	};
-
 	smem {
 		compatible = "qcom,smem";
 
@@ -1592,6 +1562,36 @@ dsi0_phy: dsi-phy@fd922a00 {
 			};
 		};
 
+		remoteproc_adsp: remoteproc@fe200000 {
+			compatible = "qcom,msm8974-adsp-pil";
+			reg = <0xfe200000 0x100>;
+
+			interrupts-extended = <&intc GIC_SPI 162 IRQ_TYPE_EDGE_RISING>,
+					       <&adsp_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
+					       <&adsp_smp2p_in 1 IRQ_TYPE_EDGE_RISING>,
+					       <&adsp_smp2p_in 2 IRQ_TYPE_EDGE_RISING>,
+					       <&adsp_smp2p_in 3 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "wdog", "fatal", "ready", "handover", "stop-ack";
+
+			clocks = <&xo_board>;
+			clock-names = "xo";
+
+			memory-region = <&adsp_region>;
+
+			qcom,smem-states = <&adsp_smp2p_out 0>;
+			qcom,smem-state-names = "stop";
+
+			smd-edge {
+				interrupts = <GIC_SPI 156 IRQ_TYPE_EDGE_RISING>;
+
+				qcom,ipc = <&apcs 8 8>;
+				qcom,smd-edge = <1>;
+				label = "lpass";
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+
 		imem: imem@fe805000 {
 			status = "disabled";
 			compatible = "syscon", "simple-mfd";
-- 
2.35.1



