Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA6C64266A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 11:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiLEKKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 05:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiLEKKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 05:10:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E60183B4;
        Mon,  5 Dec 2022 02:10:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A900B80E5E;
        Mon,  5 Dec 2022 10:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F25AC433D6;
        Mon,  5 Dec 2022 10:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670235029;
        bh=IEH5+SklrZeRvcXZ7x5oYjnP26+lXJJ2RNphQwvxjSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=it3VXqPNUYO6b3CpFHhBT/sPrSRTn45NGpy3vOHKBgv70rhrrMK10Yb/M6oPvTUsV
         xIZTgKbm4BoDhrygucNiU+qxsJzo34op+S9z0SHdqA15Zy4JQx0zJrK37jcjOWwVbl
         i2R4p8MtGE7lQD2lQAPsAdx8j1Nc55kfSSzQ3hztdmwfMH+o/hvdh9bM51mwudHxi/
         F8XqCAFNW+rJd4Yivw2TPNZbY60iEIg/ZRDbM+QutZcFhczQrn7OSIBroVEfE9kkF3
         uO5T6rAzwrY1R6Ysp3uWGPpUUYGuyLgeBsQ32eW5xnlQEhrmxYNOwUK/PV9wSqdCTj
         eruE5i/wBahBw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1p28Qk-0007cA-DB; Mon, 05 Dec 2022 11:10:34 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] arm64: dts: qcom: sc8280xp: fix UFS DMA coherency
Date:   Mon,  5 Dec 2022 11:08:37 +0100
Message-Id: <20221205100837.29212-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221205100837.29212-1-johan+linaro@kernel.org>
References: <20221205100837.29212-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The SC8280XP UFS controllers are cache coherent and must be marked as
such in the devicetree to avoid potential data corruption.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Cc: stable@vger.kernel.org      # 6.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index c4947c563099..23d1f51527aa 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1430,6 +1430,7 @@ ufs_mem_hc: ufs@1d84000 {
 			required-opps = <&rpmhpd_opp_nom>;
 
 			iommus = <&apps_smmu 0xe0 0x0>;
+			dma-coherent;
 
 			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
 				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
@@ -1491,6 +1492,7 @@ ufs_card_hc: ufs@1da4000 {
 			power-domains = <&gcc UFS_CARD_GDSC>;
 
 			iommus = <&apps_smmu 0x4a0 0x0>;
+			dma-coherent;
 
 			clocks = <&gcc GCC_UFS_CARD_AXI_CLK>,
 				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,
-- 
2.37.4

