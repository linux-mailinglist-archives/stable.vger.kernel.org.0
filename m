Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BC36578EE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiL1Ozs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiL1Ozq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:55:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46ECB07
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:55:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 722D361540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B18AC433D2;
        Wed, 28 Dec 2022 14:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239342;
        bh=AEb70Q1MeoX8gIrWrw8ekroLnKt8Vaic7XkzL2DG5/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIz455uy1eLlSiDm/hOVbU/AkE4MkPcXQoa0YnrDoX6tXNmnhwyf+hSV9RA2EH1gL
         Qj8ytKQOCHCojHPP7ipBMZ3WKeQ3XUOkJ3Vvdt39i/WikWyIjYwda4bu9mOVuckf5j
         0uC5osILbXXS/AcW0pUZjKVtRTlfO+HaqfCGN4n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0013/1073] arm64: dts: qcom: msm8996: fix supported-hw in cpufreq OPP tables
Date:   Wed, 28 Dec 2022 15:26:41 +0100
Message-Id: <20221228144328.524229362@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 0154caaa2b748e7414a4ec3c6ee60e8f483b2d4f ]

Adjust MSM8996 cpufreq tables according to tables in msm-3.18. Some of
the frequencies are not supported on speed bins other than 0. Also other
speed bins support intermediate topmost frequencies, not supported on
speed bin 0. Implement all these differencies.

Fixes: 90173a954a22 ("arm64: dts: qcom: msm8996: Add CPU opps")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220724140421.1933004-5-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 38 ++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 41c09895268e..24791ed436c5 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -203,22 +203,32 @@ opp-1228800000 {
 		};
 		opp-1324800000 {
 			opp-hz = /bits/ 64 <1324800000>;
-			opp-supported-hw = <0x7>;
+			opp-supported-hw = <0x5>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1363200000 {
+			opp-hz = /bits/ 64 <1363200000>;
+			opp-supported-hw = <0x2>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1401600000 {
 			opp-hz = /bits/ 64 <1401600000>;
-			opp-supported-hw = <0x7>;
+			opp-supported-hw = <0x5>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1478400000 {
 			opp-hz = /bits/ 64 <1478400000>;
-			opp-supported-hw = <0x7>;
+			opp-supported-hw = <0x1>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1497600000 {
+			opp-hz = /bits/ 64 <1497600000>;
+			opp-supported-hw = <0x04>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1593600000 {
 			opp-hz = /bits/ 64 <1593600000>;
-			opp-supported-hw = <0x7>;
+			opp-supported-hw = <0x1>;
 			clock-latency-ns = <200000>;
 		};
 	};
@@ -329,29 +339,39 @@ opp-1785600000 {
 			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
+		opp-1804800000 {
+			opp-hz = /bits/ 64 <1804800000>;
+			opp-supported-hw = <0x6>;
+			clock-latency-ns = <200000>;
+		};
 		opp-1824000000 {
 			opp-hz = /bits/ 64 <1824000000>;
-			opp-supported-hw = <0x7>;
+			opp-supported-hw = <0x1>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1900800000 {
+			opp-hz = /bits/ 64 <1900800000>;
+			opp-supported-hw = <0x4>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1920000000 {
 			opp-hz = /bits/ 64 <1920000000>;
-			opp-supported-hw = <0x7>;
+			opp-supported-hw = <0x1>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1996800000 {
 			opp-hz = /bits/ 64 <1996800000>;
-			opp-supported-hw = <0x7>;
+			opp-supported-hw = <0x1>;
 			clock-latency-ns = <200000>;
 		};
 		opp-2073600000 {
 			opp-hz = /bits/ 64 <2073600000>;
-			opp-supported-hw = <0x7>;
+			opp-supported-hw = <0x1>;
 			clock-latency-ns = <200000>;
 		};
 		opp-2150400000 {
 			opp-hz = /bits/ 64 <2150400000>;
-			opp-supported-hw = <0x7>;
+			opp-supported-hw = <0x1>;
 			clock-latency-ns = <200000>;
 		};
 	};
-- 
2.35.1



