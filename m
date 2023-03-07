Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DEF6AE803
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjCGRMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjCGRLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:11:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E859FBEA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:06:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50FE561506
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48667C433D2;
        Tue,  7 Mar 2023 17:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208791;
        bh=9Ez6C5fwIk5S21phgouzUkN8/sz3xki7uuVphuyingc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vw7vvWPyHIeyL2I74k1/JwrcwMHpADC77Rj999KoKMyI5X54w7UyzqXM+hZyr1LYP
         xDfHSHR4tSgOzigKhIC8zyNn+kn4cij3oOdfhxIyFyXRR67JUKfFYQxo1o0eGIJAfW
         wja/LQ/y7vXyqwQ9+l6qUNY62rM4vwIXrCMZAZ7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Iskren Chernev <me@iskren.info>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0012/1001] arm64: dts: qcom: sm6115: Fix UFS node
Date:   Tue,  7 Mar 2023 17:46:24 +0100
Message-Id: <20230307170022.672366381@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 01b6041454e8bc4f5feb76e6bcdc83a48cea21f2 ]

In its current form, UFS did not even probe successfully - it failed
when trying to set XO (ref_clk) to 300 MHz instead of doing so to
the ICE clk. Moreover, the missing reg-names prevented ICE from
working or being discovered at all. Fix both of these issues.

As a sidenote, the log reveals that this SoC uses UFS ICE v3.1.0.

Fixes: 97e563bf5ba1 ("arm64: dts: qcom: sm6115: Add basic soc dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Iskren Chernev <me@iskren.info>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221208201401.530555-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index 572bf04adf906..3f4017bc667d6 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -704,6 +704,7 @@ opp-202000000 {
 		ufs_mem_hc: ufs@4804000 {
 			compatible = "qcom,sm6115-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
 			reg = <0x04804000 0x3000>, <0x04810000 0x8000>;
+			reg-names = "std", "ice";
 			interrupts = <GIC_SPI 356 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&ufs_mem_phy_lanes>;
 			phy-names = "ufsphy";
@@ -736,10 +737,10 @@ ufs_mem_hc: ufs@4804000 {
 					<0 0>,
 					<0 0>,
 					<37500000 150000000>,
-					<75000000 300000000>,
 					<0 0>,
 					<0 0>,
-					<0 0>;
+					<0 0>,
+					<75000000 300000000>;
 
 			status = "disabled";
 		};
-- 
2.39.2



