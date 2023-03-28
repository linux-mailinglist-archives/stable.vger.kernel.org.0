Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8C66CC4A1
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbjC1PGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC1PGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:06:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B13EF92
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5967DB81D7D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D12C433D2;
        Tue, 28 Mar 2023 15:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015888;
        bh=QVjj/vfjbCAUi1PV50kQhPCpBKKxPA4fNWeXQXS1Q+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kX+eJo38onN6WD6fsSwwEI+9QeAL3YOA5WV+2CSthVO9+teYamrvd2bPHtJYjqV2U
         XEL71aqzWWt0OyrrxlzAeLJQxaxMoROnN2eSoeKardwyx/oTdOfjPwdSOCrtgEx19c
         +oR/7vEai4j4QJrhSDPuwRz/Rym3bVYzmWtemgFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 211/224] arm64: dts: qcom: sm8150: Fix the iommu mask used for PCIe controllers
Date:   Tue, 28 Mar 2023 16:43:27 +0200
Message-Id: <20230328142626.134630757@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 672a58fc7c477e59981653a11241566870fff852 upstream.

The iommu mask should be 0x3f as per Qualcomm internal documentation.
Without the correct mask, the PCIe transactions from the endpoint will
result in SMMU faults. Hence, fix it!

Cc: stable@vger.kernel.org # 5.19
Fixes: a1c86c680533 ("arm64: dts: qcom: sm8150: Add PCIe nodes")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230224080045.6577-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1810,7 +1810,7 @@
 				      "slave_q2a",
 				      "tbu";
 
-			iommus = <&apps_smmu 0x1d80 0x7f>;
+			iommus = <&apps_smmu 0x1d80 0x3f>;
 			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
 				    <0x100 &apps_smmu 0x1d81 0x1>;
 
@@ -1909,7 +1909,7 @@
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1e00 0x7f>;
+			iommus = <&apps_smmu 0x1e00 0x3f>;
 			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
 				    <0x100 &apps_smmu 0x1e01 0x1>;
 


