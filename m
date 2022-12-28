Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7760865796F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiL1PBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiL1PAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:00:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CCB64D7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:00:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6154CB81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1CBC433EF;
        Wed, 28 Dec 2022 15:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239651;
        bh=zWGqAFrOQ3IA4mARuDue+Fdo6QtPIlFmigeR8E5lHtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqNKnv9g4DIkLTMqmBuubdIlqAxkmOqV3LPzXfc0TZNy7UfI5k9s8/QZK4SEZdSX9
         03HdUDKA9NKTySsATY105llRx0BGLG6xVY6ihZTIJP/kSNyiG5v5Mn4NVTBMXK7bT5
         o6Jbeo3+w7zN2V+kpWgvfLIpI6IoJWggrydwG+J8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0060/1073] arm64: dts: mediatek: mt8195: Fix CPUs capacity-dmips-mhz
Date:   Wed, 28 Dec 2022 15:27:28 +0100
Message-Id: <20221228144329.728876043@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 513c43328b189874fdfee3ae99cac81e5502e7f7 ]

The capacity-dmips-mhz parameter was miscalculated: this SoC runs
the first (Cortex-A55) cluster at a maximum of 2000MHz and the
second (Cortex-A78) cluster at a maximum of 3000MHz.

In order to calculate the right capacity-dmips-mhz, the following
test was performed:
1. CPUFREQ governor was set to 'performance' on both clusters
2. Ran dhrystone with 500000000 iterations for 10 times on each cluster
3. Calculate the mean result for each cluster
4. Calculate DMIPS/MHz: dmips_mhz = dmips_per_second / cpu_mhz
5. Scale results to 1024:
   result_c0 = (dmips_mhz_c0 - min_dmips_mhz(c0, c1)) /
               (max_dmips_mhz(c0, c1) - min_dmips_mhz(c0, c1)) * 1024

The mean results for this SoC are:
Cluster 0 (LITTLE): 11990400 Dhry/s
Cluster 1 (BIG): 59809036 Dhry/s

The calculated scaled results are:
Cluster 0: 307,934312801831 (rounded to 308)
Cluster 1: 1024

Fixes: 37f2582883be ("arm64: dts: Add mediatek SoC mt8195 and evaluation board")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221005093404.33102-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 066c14989708..e694ddb74f7d 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -27,7 +27,7 @@ cpu0: cpu@0 {
 			reg = <0x000>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			capacity-dmips-mhz = <578>;
+			capacity-dmips-mhz = <308>;
 			cpu-idle-states = <&cpu_off_l &cluster_off_l>;
 			next-level-cache = <&l2_0>;
 			#cooling-cells = <2>;
@@ -39,7 +39,7 @@ cpu1: cpu@100 {
 			reg = <0x100>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			capacity-dmips-mhz = <578>;
+			capacity-dmips-mhz = <308>;
 			cpu-idle-states = <&cpu_off_l &cluster_off_l>;
 			next-level-cache = <&l2_0>;
 			#cooling-cells = <2>;
@@ -51,7 +51,7 @@ cpu2: cpu@200 {
 			reg = <0x200>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			capacity-dmips-mhz = <578>;
+			capacity-dmips-mhz = <308>;
 			cpu-idle-states = <&cpu_off_l &cluster_off_l>;
 			next-level-cache = <&l2_0>;
 			#cooling-cells = <2>;
@@ -63,7 +63,7 @@ cpu3: cpu@300 {
 			reg = <0x300>;
 			enable-method = "psci";
 			clock-frequency = <1701000000>;
-			capacity-dmips-mhz = <578>;
+			capacity-dmips-mhz = <308>;
 			cpu-idle-states = <&cpu_off_l &cluster_off_l>;
 			next-level-cache = <&l2_0>;
 			#cooling-cells = <2>;
-- 
2.35.1



