Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E31A4D842B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241584AbiCNMXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241652AbiCNMSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE14421AC;
        Mon, 14 Mar 2022 05:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3980AB80DEB;
        Mon, 14 Mar 2022 12:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597A6C340E9;
        Mon, 14 Mar 2022 12:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259965;
        bh=FGlG9j/bb+DQZwt+VLKTEn12jff30HV9UqqLaRGCb9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlAw/BQB+UnNivGg3fIfLcAK0hBcC2nkwJ7M2VeTd5+o/sLifTLq83qES2WXmqYDb
         Aim6VtrDGx+aNukt97bW/7tLaKQLlPVJme3duGTYpHhS2CV/8WYG8DNLIbfWXDThav
         zUW7Z497ach4BMBau4Oca3wCX/fyHU7EEGr0MAZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 002/121] arm64: dts: qcom: sm8350: Correct UFS symbol clocks
Date:   Mon, 14 Mar 2022 12:53:05 +0100
Message-Id: <20220314112744.191997222@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 0fd4dcb607ce29110d6c0b481a98c4ff3d300551 ]

The introduction of '9a61f813fcc8 ("clk: qcom: regmap-mux: fix parent
clock lookup")' broke UFS support on SM8350.

The cause for this is that the symbol clocks have a specified rate in
the "freq-table-hz" table in the UFS node, which causes the UFS code to
request a rate change, for which the "bi_tcxo" happens to provide the
closest rate.  Prior to the change in regmap-mux it was determined
(incorrectly) that no change was needed and everything worked.

The rates of 75 and 300MHz matches the documentation for the symbol
clocks, but we don't represent the parent clocks today. So let's mimic
the configuration found in other platforms, by omitting the rate for the
symbol clocks as well to avoid the rate change.

While at it also fill in the dummy symbol clocks that was dropped from
the GCC driver as it was upstreamed.

Fixes: 59c7cf814783 ("arm64: dts: qcom: sm8350: Add UFS nodes")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20211222162058.3418902-1-bjorn.andersson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index db102b293154..1a70a70ed056 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -34,6 +34,24 @@ sleep_clk: sleep-clk {
 			clock-frequency = <32000>;
 			#clock-cells = <0>;
 		};
+
+		ufs_phy_rx_symbol_0_clk: ufs-phy-rx-symbol-0 {
+			compatible = "fixed-clock";
+			clock-frequency = <1000>;
+			#clock-cells = <0>;
+		};
+
+		ufs_phy_rx_symbol_1_clk: ufs-phy-rx-symbol-1 {
+			compatible = "fixed-clock";
+			clock-frequency = <1000>;
+			#clock-cells = <0>;
+		};
+
+		ufs_phy_tx_symbol_0_clk: ufs-phy-tx-symbol-0 {
+			compatible = "fixed-clock";
+			clock-frequency = <1000>;
+			#clock-cells = <0>;
+		};
 	};
 
 	cpus {
@@ -602,9 +620,9 @@ gcc: clock-controller@100000 {
 				 <0>,
 				 <0>,
 				 <0>,
-				 <0>,
-				 <0>,
-				 <0>,
+				 <&ufs_phy_rx_symbol_0_clk>,
+				 <&ufs_phy_rx_symbol_1_clk>,
+				 <&ufs_phy_tx_symbol_0_clk>,
 				 <0>,
 				 <0>;
 		};
@@ -1227,8 +1245,8 @@ ufs_mem_hc: ufshc@1d84000 {
 				<75000000 300000000>,
 				<0 0>,
 				<0 0>,
-				<75000000 300000000>,
-				<75000000 300000000>;
+				<0 0>,
+				<0 0>;
 			status = "disabled";
 		};
 
-- 
2.34.1



