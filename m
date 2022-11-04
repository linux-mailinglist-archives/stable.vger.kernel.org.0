Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D9A619359
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 10:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiKDJVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 05:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiKDJVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 05:21:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEB0248DB;
        Fri,  4 Nov 2022 02:21:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07D6D6202C;
        Fri,  4 Nov 2022 09:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D70DC433D7;
        Fri,  4 Nov 2022 09:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667553674;
        bh=JiGW3IovHz7nDy/fwgLDO/2d+ZpNIFbV/Xo9gEkjrPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfPn9BjAdbYNYQMQD54Z00EzH3XFq9a6iYx9SEbkRxNXL6zouY5Dc6kq3rtCVRX2+
         a5gAtPn0adnxG6DD7VXBrqY7TvoumMSV002oqka5m1cQ1lHy2BMscI8Q6FidArS6bU
         voArok4ngCRjAirPqGO8x5W+56xXm9beZVUxTb14/J3vA4OaV3N7PC9ZdLOuYcZjxo
         xD3ufEKRiklObg6j8x3MwvG10H2G3cB4efCfkW4Y3mJpUxFQjUzAYguTL5gTCKNoan
         vheehfXafk9g5eqktjU0Ptgu19LiB0bxvyG7YKZ1PF0CUBKGz339p9+tLTng4fIzXb
         pWeXV3ASlGLXQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1oqssi-0004XZ-Ii; Fri, 04 Nov 2022 10:20:56 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Bjorn Andersson <andersson@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Brian Masney <bmasney@redhat.com>,
        Shazad Hussain <quic_shazhuss@quicinc.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] arm64: dts: qcom: sc8280xp: fix UFS reference clocks
Date:   Fri,  4 Nov 2022 10:20:44 +0100
Message-Id: <20221104092045.17410-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221104092045.17410-1-johan+linaro@kernel.org>
References: <20221104092045.17410-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are three UFS reference clocks on SC8280XP which are used as
follows:

 - The GCC_UFS_REF_CLKREF_CLK clock is fed to any UFS device connected
   to either controller.

 - The GCC_UFS_1_CARD_CLKREF_CLK and GCC_UFS_CARD_CLKREF_CLK clocks
   provide reference clocks to the two PHYs.

Note that this depends on first updating the clock driver to reflect
that all three clocks are sourced from CXO. Specifically, the UFS
controller driver expects the device reference clock to have a valid
frequency:

	ufshcd-qcom 1d84000.ufs: invalid ref_clk setting = 0

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Fixes: 8d6b458ce6e9 ("arm64: dts: qcom: sc8280xp: fix ufs_card_phy ref clock")
Fixes: f3aa975e230e ("arm64: dts: qcom: sc8280xp: correct ref clock for ufs_mem_phy")
Link: https://lore.kernel.org/lkml/Y2OEjNAPXg5BfOxH@hovoldconsulting.com/
Cc: stable@vger.kernel.org	# 5.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 21ac119e0382..e0d0fb6994b5 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -912,7 +912,7 @@ ufs_mem_hc: ufs@1d84000 {
 				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
 				 <&gcc GCC_UFS_PHY_AHB_CLK>,
 				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
@@ -943,7 +943,7 @@ ufs_mem_phy: phy@1d87000 {
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_CARD_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
 			resets = <&ufs_mem_hc 0>;
@@ -980,7 +980,7 @@ ufs_card_hc: ufs@1da4000 {
 				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,
 				 <&gcc GCC_UFS_CARD_AHB_CLK>,
 				 <&gcc GCC_UFS_CARD_UNIPRO_CORE_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_TX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_CARD_RX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_CARD_RX_SYMBOL_1_CLK>;
@@ -1011,7 +1011,7 @@ ufs_card_phy: phy@1da7000 {
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_1_CARD_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_PHY_AUX_CLK>;
 
 			resets = <&ufs_card_hc 0>;
-- 
2.37.3

