Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BDE65D7F4
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239874AbjADQJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239876AbjADQJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:09:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CECC3E0F0
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:08:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1239AB8172B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF05C433EF;
        Wed,  4 Jan 2023 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848530;
        bh=8jEAnOgj6WAwSacmCzKr6pansgO9Hlao88Dh9B6VRlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QE5SnRvWsRuu+malqrTNH8F7QB9c/qB/VEkL/78t5byQFCqfYPhqDQ56Pjhz98PxB
         lhByh5TDw0vGCB4bL29EOmc9j8GomGSb1tY+2bBws3JEB4a2M0f3OrmQhW8colXik+
         GYcr3C7K7tqfavOL7n/pwDMC7erxjaPD50QPr2PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Brian Masney <bmasney@redhat.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 015/207] arm64: dts: qcom: sc8280xp: fix UFS reference clocks
Date:   Wed,  4 Jan 2023 17:04:33 +0100
Message-Id: <20230104160512.395726833@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit f446022b932aff1d6a308ca5d537ec2b512debdc upstream.

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
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221104092045.17410-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -861,7 +861,7 @@
 				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
 				 <&gcc GCC_UFS_PHY_AHB_CLK>,
 				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
@@ -892,7 +892,7 @@
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_CARD_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
 			resets = <&ufs_mem_hc 0>;
@@ -930,7 +930,7 @@
 				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,
 				 <&gcc GCC_UFS_CARD_AHB_CLK>,
 				 <&gcc GCC_UFS_CARD_UNIPRO_CORE_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_TX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_CARD_RX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_CARD_RX_SYMBOL_1_CLK>;
@@ -961,7 +961,7 @@
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_1_CARD_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_PHY_AUX_CLK>;
 
 			resets = <&ufs_card_hc 0>;


