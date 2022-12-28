Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00FC657816
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiL1OsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiL1Orh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0180C12081
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:46:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 22284CE1356
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13421C433D2;
        Wed, 28 Dec 2022 14:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238808;
        bh=Fonu3mN+E70+ToDQpqtqrZVZDZeht0gTr23iUmuveQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fF1WpvLt9wyYowrKCdo89rmpu7mhBlXqNxlr43/oUGkzrY5+8XOgtC5WJcRun6JyH
         V23TY/jsi/gOwktA9fX+AK4HLduzl0qmM+BAfYhMTsQeext1ON0X7rAxg5M8wzZZl6
         qeXIV6WsyNw/fYl+z2tjbygmdT7n5mSQJoeEGbNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yassine Oudjana <y.oudjana@protonmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/731] arm64: dts: qcom: msm8996: Add MSM8996 Pro support
Date:   Wed, 28 Dec 2022 15:31:52 +0100
Message-Id: <20221228144256.693364791@linuxfoundation.org>
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

From: Yassine Oudjana <y.oudjana@protonmail.com>

[ Upstream commit 8898c9748a872866f8c2973e719b26bf7c6ab64e ]

Qualcomm MSM8996 Pro is a variant of MSM8996 with higher frequencies
supported both on CPU and GPU. There are other minor hardware
differencies in the CPU and GPU regulators and bus fabrics.

However this results in significant differences between 8996 and 8996
Pro CPU OPP tables. Judging from msm-3.18 there are only few common
frequencies supported by both msm8996 and msm8996pro. Rather than
hacking the tables for msm8996, split msm8996pro support into a separate
file. Later this would allow having additional customizations for the
CBF, CPR, retulators, etc.

[DB: dropped all non-CPU-OPP changes]

Fixes: 90173a954a22 ("arm64: dts: qcom: msm8996: Add CPU opps")
Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
[DB: Realigned supported-hw to keep compat with current cpufreq driver]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220724140421.1933004-3-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi    |  82 +++----
 arch/arm64/boot/dts/qcom/msm8996pro.dtsi | 266 +++++++++++++++++++++++
 2 files changed, 307 insertions(+), 41 deletions(-)
 create mode 100644 arch/arm64/boot/dts/qcom/msm8996pro.dtsi

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 6077c3601951..4f472306f10f 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -142,82 +142,82 @@ cluster0_opp: opp_table0 {
 		/* Nominal fmax for now */
 		opp-307200000 {
 			opp-hz = /bits/ 64 <307200000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-422400000 {
 			opp-hz = /bits/ 64 <422400000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-480000000 {
 			opp-hz = /bits/ 64 <480000000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-556800000 {
 			opp-hz = /bits/ 64 <556800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-652800000 {
 			opp-hz = /bits/ 64 <652800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-729600000 {
 			opp-hz = /bits/ 64 <729600000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-844800000 {
 			opp-hz = /bits/ 64 <844800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-960000000 {
 			opp-hz = /bits/ 64 <960000000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1036800000 {
 			opp-hz = /bits/ 64 <1036800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1113600000 {
 			opp-hz = /bits/ 64 <1113600000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1190400000 {
 			opp-hz = /bits/ 64 <1190400000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1228800000 {
 			opp-hz = /bits/ 64 <1228800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1324800000 {
 			opp-hz = /bits/ 64 <1324800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1401600000 {
 			opp-hz = /bits/ 64 <1401600000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1478400000 {
 			opp-hz = /bits/ 64 <1478400000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1593600000 {
 			opp-hz = /bits/ 64 <1593600000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 	};
@@ -230,127 +230,127 @@ cluster1_opp: opp_table1 {
 		/* Nominal fmax for now */
 		opp-307200000 {
 			opp-hz = /bits/ 64 <307200000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-403200000 {
 			opp-hz = /bits/ 64 <403200000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-480000000 {
 			opp-hz = /bits/ 64 <480000000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-556800000 {
 			opp-hz = /bits/ 64 <556800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-652800000 {
 			opp-hz = /bits/ 64 <652800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-729600000 {
 			opp-hz = /bits/ 64 <729600000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-806400000 {
 			opp-hz = /bits/ 64 <806400000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-883200000 {
 			opp-hz = /bits/ 64 <883200000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-940800000 {
 			opp-hz = /bits/ 64 <940800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1036800000 {
 			opp-hz = /bits/ 64 <1036800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1113600000 {
 			opp-hz = /bits/ 64 <1113600000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1190400000 {
 			opp-hz = /bits/ 64 <1190400000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1248000000 {
 			opp-hz = /bits/ 64 <1248000000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1324800000 {
 			opp-hz = /bits/ 64 <1324800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1401600000 {
 			opp-hz = /bits/ 64 <1401600000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1478400000 {
 			opp-hz = /bits/ 64 <1478400000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1555200000 {
 			opp-hz = /bits/ 64 <1555200000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1632000000 {
 			opp-hz = /bits/ 64 <1632000000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1708800000 {
 			opp-hz = /bits/ 64 <1708800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1785600000 {
 			opp-hz = /bits/ 64 <1785600000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1824000000 {
 			opp-hz = /bits/ 64 <1824000000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1920000000 {
 			opp-hz = /bits/ 64 <1920000000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-1996800000 {
 			opp-hz = /bits/ 64 <1996800000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-2073600000 {
 			opp-hz = /bits/ 64 <2073600000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 		opp-2150400000 {
 			opp-hz = /bits/ 64 <2150400000>;
-			opp-supported-hw = <0x77>;
+			opp-supported-hw = <0x7>;
 			clock-latency-ns = <200000>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/qcom/msm8996pro.dtsi b/arch/arm64/boot/dts/qcom/msm8996pro.dtsi
new file mode 100644
index 000000000000..63e1b4ec7a36
--- /dev/null
+++ b/arch/arm64/boot/dts/qcom/msm8996pro.dtsi
@@ -0,0 +1,266 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/*
+ * Copyright (c) 2022, Linaro Limited
+ */
+
+#include "msm8996.dtsi"
+
+/ {
+	/delete-node/ opp-table-cluster0;
+	/delete-node/ opp-table-cluster1;
+
+	/*
+	 * On MSM8996 Pro the cpufreq driver shifts speed bins into the high
+	 * nibble of supported hw, so speed bin 0 becomes 0x10, speed bin 1
+	 * becomes 0x20, speed 2 becomes 0x40.
+	 */
+
+	cluster0_opp: opp-table-cluster0 {
+		compatible = "operating-points-v2-kryo-cpu";
+		nvmem-cells = <&speedbin_efuse>;
+		opp-shared;
+
+		opp-307200000 {
+			opp-hz = /bits/ 64 <307200000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-384000000 {
+			opp-hz = /bits/ 64 <384000000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-460800000 {
+			opp-hz = /bits/ 64 <460800000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-537600000 {
+			opp-hz = /bits/ 64 <537600000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-614400000 {
+			opp-hz = /bits/ 64 <614400000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-691200000 {
+			opp-hz = /bits/ 64 <691200000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-768000000 {
+			opp-hz = /bits/ 64 <768000000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-844800000 {
+			opp-hz = /bits/ 64 <844800000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-902400000 {
+			opp-hz = /bits/ 64 <902400000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-979200000 {
+			opp-hz = /bits/ 64 <979200000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1056000000 {
+			opp-hz = /bits/ 64 <1056000000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1132800000 {
+			opp-hz = /bits/ 64 <1132800000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1209600000 {
+			opp-hz = /bits/ 64 <1209600000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1286400000 {
+			opp-hz = /bits/ 64 <1286400000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1363200000 {
+			opp-hz = /bits/ 64 <1363200000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1440000000 {
+			opp-hz = /bits/ 64 <1440000000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1516800000 {
+			opp-hz = /bits/ 64 <1516800000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1593600000 {
+			opp-hz = /bits/ 64 <1593600000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1996800000 {
+			opp-hz = /bits/ 64 <1996800000>;
+			opp-supported-hw = <0x20>;
+			clock-latency-ns = <200000>;
+		};
+		opp-2188800000 {
+			opp-hz = /bits/ 64 <2188800000>;
+			opp-supported-hw = <0x10>;
+			clock-latency-ns = <200000>;
+		};
+	};
+
+	cluster1_opp: opp-table-cluster1 {
+		compatible = "operating-points-v2-kryo-cpu";
+		nvmem-cells = <&speedbin_efuse>;
+		opp-shared;
+
+		opp-307200000 {
+			opp-hz = /bits/ 64 <307200000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-384000000 {
+			opp-hz = /bits/ 64 <384000000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-460800000 {
+			opp-hz = /bits/ 64 <460800000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-537600000 {
+			opp-hz = /bits/ 64 <537600000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-614400000 {
+			opp-hz = /bits/ 64 <614400000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-691200000 {
+			opp-hz = /bits/ 64 <691200000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-748800000 {
+			opp-hz = /bits/ 64 <748800000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-825600000 {
+			opp-hz = /bits/ 64 <825600000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-902400000 {
+			opp-hz = /bits/ 64 <902400000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-979200000 {
+			opp-hz = /bits/ 64 <979200000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1056000000 {
+			opp-hz = /bits/ 64 <1056000000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1132800000 {
+			opp-hz = /bits/ 64 <1132800000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1209600000 {
+			opp-hz = /bits/ 64 <1209600000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1286400000 {
+			opp-hz = /bits/ 64 <1286400000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1363200000 {
+			opp-hz = /bits/ 64 <1363200000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1440000000 {
+			opp-hz = /bits/ 64 <1440000000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1516800000 {
+			opp-hz = /bits/ 64 <1516800000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1593600000 {
+			opp-hz = /bits/ 64 <1593600000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1670400000 {
+			opp-hz = /bits/ 64 <1670400000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1747200000 {
+			opp-hz = /bits/ 64 <1747200000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1824000000 {
+			opp-hz = /bits/ 64 <1824000000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1900800000 {
+			opp-hz = /bits/ 64 <1900800000>;
+			opp-supported-hw = <0x70>;
+			clock-latency-ns = <200000>;
+		};
+		opp-1977600000 {
+			opp-hz = /bits/ 64 <1977600000>;
+			opp-supported-hw = <0x30>;
+			clock-latency-ns = <200000>;
+		};
+		opp-2054400000 {
+			opp-hz = /bits/ 64 <2054400000>;
+			opp-supported-hw = <0x30>;
+			clock-latency-ns = <200000>;
+		};
+		opp-2150400000 {
+			opp-hz = /bits/ 64 <2150400000>;
+			opp-supported-hw = <0x30>;
+			clock-latency-ns = <200000>;
+		};
+		opp-2246400000 {
+			opp-hz = /bits/ 64 <2246400000>;
+			opp-supported-hw = <0x10>;
+			clock-latency-ns = <200000>;
+		};
+		opp-2342400000 {
+			opp-hz = /bits/ 64 <2342400000>;
+			opp-supported-hw = <0x10>;
+			clock-latency-ns = <200000>;
+		};
+	};
+};
-- 
2.35.1



