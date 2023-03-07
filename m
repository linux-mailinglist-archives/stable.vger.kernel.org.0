Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB726AE881
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjCGRQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjCGRQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:16:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DDE9B2EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:11:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8780E61509
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB04C433EF;
        Tue,  7 Mar 2023 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209104;
        bh=QiaeUx89zd30XjWaXKf5M3A91APv59Z2kHCe/VgxFuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hdgcj2cxSyDHoW3Mb7RiPKTFWu4bWlsMA3nv0odw+IgbtVGpMveMf4K2VdaArCcti
         tTUieeBZSdn1hpETUX0rVETHXklg1lhLskMBZE2f2Y7IhAaT6wCtRH1Ti9v8BMfrER
         QJLgX5XRFPNRoSKrPJ85aRXtX34aeOiLzdbj0Zys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0111/1001] arm64: dts: qcom: msm8996: support using GPLL0 as kryocc input
Date:   Tue,  7 Mar 2023 17:48:03 +0100
Message-Id: <20230307170026.932329651@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit ac0d84d4556cecf81ba0b1631d25d9a395235a5c ]

In some cases the driver might need using GPLL0 to drive CPU clocks.
Bring it in through the sys_apcs_aux clock.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230113120544.59320-15-dmitry.baryshkov@linaro.org
Stable-dep-of: 8ae72166c2b7 ("arm64: dts: qcom: msm8996 switch from RPM_SMD_BB_CLK1 to RPM_SMD_XO_CLK_SRC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index d31464204f696..286f7b44057dd 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2940,8 +2940,8 @@ kryocc: clock-controller@6400000 {
 			compatible = "qcom,msm8996-apcc";
 			reg = <0x06400000 0x90000>;
 
-			clock-names = "xo";
-			clocks = <&rpmcc RPM_SMD_BB_CLK1>;
+			clock-names = "xo", "sys_apcs_aux";
+			clocks = <&rpmcc RPM_SMD_BB_CLK1>, <&apcs_glb>;
 
 			#clock-cells = <1>;
 		};
-- 
2.39.2



