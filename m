Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0166593E79
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbiHOUnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345194AbiHOUjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:39:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B5DAE222;
        Mon, 15 Aug 2022 12:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0F0861019;
        Mon, 15 Aug 2022 19:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5CDC433C1;
        Mon, 15 Aug 2022 19:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590431;
        bh=xHJUJwpKHAC+e9emaowpBnNgdWEKlSRsQ5QR4/3UQYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xs3cywuGt1aejfJwuCicexj68rU1/iSW+NaNGO7m7luLvQkIfbsMHtbtpD2RfBNdK
         X7z529m7tTJtmkGJUHYY1vTkoJ3ldJ0FODMHI4Hn4Ayx3quUzMQ8KpsiigcnfMqx/D
         nPNeVS2OLxVXrYKrpGJ268zCuDOBzzlr4LgSI3Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0257/1095] arm64: dts: qcom: msm8996: correct #clock-cells for QMP PHY nodes
Date:   Mon, 15 Aug 2022 19:54:16 +0200
Message-Id: <20220815180440.377834433@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b874fff9a7683df30e5aff16d5a85b1f8a43aa5d ]

The commit 82d61e19fccb ("arm64: dts: qcom: msm8996: Move '#clock-cells'
to QMP PHY child node") moved the '#clock-cells' properties to the child
nodes. However it missed the fact that the property must have been set
to <0> (as all pipe clocks use of_clk_hw_simple_get as the xlate
function. Also the mentioned commit didn't add '#clock-cells' properties
to second and third PCIe PHY nodes. Correct both these mistakes:

- Set '#clock-cells' to <0>,
- Add the property to pciephy_1 and pciephy_2 nodes.

Fixes: 82d61e19fccb ("arm64: dts: qcom: msm8996: Move '#clock-cells' to QMP PHY child node")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220620071936.1558906-3-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index b9a48cfd760f..078edf46de2b 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -603,7 +603,7 @@ pciephy_0: phy@35000 {
 				      <0x00035400 0x1dc>;
 				#phy-cells = <0>;
 
-				#clock-cells = <1>;
+				#clock-cells = <0>;
 				clock-output-names = "pcie_0_pipe_clk_src";
 				clocks = <&gcc GCC_PCIE_0_PIPE_CLK>;
 				clock-names = "pipe0";
@@ -617,6 +617,7 @@ pciephy_1: phy@36000 {
 				      <0x00036400 0x1dc>;
 				#phy-cells = <0>;
 
+				#clock-cells = <0>;
 				clock-output-names = "pcie_1_pipe_clk_src";
 				clocks = <&gcc GCC_PCIE_1_PIPE_CLK>;
 				clock-names = "pipe1";
@@ -630,6 +631,7 @@ pciephy_2: phy@37000 {
 				      <0x00037400 0x1dc>;
 				#phy-cells = <0>;
 
+				#clock-cells = <0>;
 				clock-output-names = "pcie_2_pipe_clk_src";
 				clocks = <&gcc GCC_PCIE_2_PIPE_CLK>;
 				clock-names = "pipe2";
@@ -2659,7 +2661,7 @@ ssusb_phy_0: phy@7410200 {
 				      <0x07410600 0x1a8>;
 				#phy-cells = <0>;
 
-				#clock-cells = <1>;
+				#clock-cells = <0>;
 				clock-output-names = "usb3_phy_pipe_clk_src";
 				clocks = <&gcc GCC_USB3_PHY_PIPE_CLK>;
 				clock-names = "pipe0";
-- 
2.35.1



