Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D890657817
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiL1OsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbiL1Orh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEA01208B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:46:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA6A0CE134B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA4FC433EF;
        Wed, 28 Dec 2022 14:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238811;
        bh=LPxoZ4k9G3fNILRX+bf+StZjyW63VVdFYpmM9jvrFIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8RZf1hqff3Ezn/zv02vKZwpkdS8omokSplEA5CaHnWeLyd6AyuiFb3qLLZ9dzXJK
         I3RrRbNeW+4yLfsu858F2SG0DFkCu1Mzv9H8bppDbpYgXAWHYVBnkTrfNOOow9Df2n
         xhknqtEtdM7uQyr76sQoteCIMIPTo4GhB7Wwm5B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/731] arm64: dts: qcom: msm8996: fix supported-hw in cpufreq OPP tables
Date:   Wed, 28 Dec 2022 15:31:53 +0100
Message-Id: <20221228144256.720678872@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 4f472306f10f..032c6cd635e2 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -202,22 +202,32 @@ opp-1228800000 {
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
@@ -328,29 +338,39 @@ opp-1785600000 {
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



