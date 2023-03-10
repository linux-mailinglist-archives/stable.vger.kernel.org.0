Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C336B46D3
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbjCJOrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbjCJOrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:47:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426FF120E8C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:46:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B3CD61967
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A974C433A0;
        Fri, 10 Mar 2023 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459595;
        bh=t9xKa8yRF9mZCdG1YVeObQsiAXjFmzlf7LHF0c1vjeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNtgNerHMqlsueeChU03KsJXG2zfmcphMHaf8aCkoaI0AonUm0HogzWXWxsx/dR0u
         UcYY87N7MxZZnLI0wcZYXxRWNWcjE0sI2kfy0/xLTt6yvKtwsXCFlT6cbUgBehN4lR
         BkYtNsSWVdHV6iWTs/1bBZcLE4iQF/bo2LxL677M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/529] arm64: dts: qcom: ipq8074: fix PCIe PHY serdes size
Date:   Fri, 10 Mar 2023 14:32:39 +0100
Message-Id: <20230310133805.762043448@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit ed22cc93abae68f9d3fc4957c20a1d902cf28882 ]

The size of the PCIe PHY serdes register region is 0x1c4 and the
corresponding 'reg' property should specifically not include the
adjacent regions that are defined in the child node (e.g. tx and rx).

Fixes: 33057e1672fe ("ARM: dts: ipq8074: Add pcie nodes")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220915143431.19842-1-johan+linaro@kernel.org
Stable-dep-of: 7ba33591b45f ("arm64: dts: qcom: ipq8074: fix Gen3 PCIe QMP PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 5b17dbefe5cfd..555f633ef20e0 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -169,7 +169,7 @@ qusb_phy_0: phy@79000 {
 
 		pcie_qmp0: phy@86000 {
 			compatible = "qcom,ipq8074-qmp-pcie-phy";
-			reg = <0x00086000 0x1000>;
+			reg = <0x00086000 0x1c4>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
@@ -197,7 +197,7 @@ pcie_phy0: phy@86200 {
 
 		pcie_qmp1: phy@8e000 {
 			compatible = "qcom,ipq8074-qmp-pcie-phy";
-			reg = <0x0008e000 0x1000>;
+			reg = <0x0008e000 0x1c4>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
-- 
2.39.2



