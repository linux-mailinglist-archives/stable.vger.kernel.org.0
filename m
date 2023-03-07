Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A306AEDC0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjCGSHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjCGSG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:06:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19802BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:59:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E960061526
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF441C433EF;
        Tue,  7 Mar 2023 17:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211987;
        bh=lpPLMsNe2of69YzSM1u2+smejLT4v3EKRNQCr3rQgiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWQG+teEu0bNjmJcoVf9Q9NfZFqcBTVcunHIayRfE+7/SknjfKLUNDzLdT2/5Didf
         hJK1qjk/J7WTuvGlzghGo/EKHg5623OdKZJ9az0Ox58QA+PBRVxTB+F0HKSWHUVRbw
         L/rjluc95CYByZt4xe4qr6qi5dXFprPt9wVS6Ijs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/885] arm64: dts: qcom: ipq8074: fix Gen3 PCIe QMP PHY
Date:   Tue,  7 Mar 2023 17:49:34 +0100
Message-Id: <20230307170003.408795760@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 7ba33591b45f9d547a317e42f1c2acd19c925eb6 ]

IPQ8074 comes in 2 silicon versions:
* v1 with 2x Gen2 PCIe ports and QMP PHY-s
* v2 with 1x Gen3 and 1x Gen2 PCIe ports and QMP PHY-s

v2 is the final and production version that is actually supported by the
kernel, however it looks like PCIe related nodes were added for the v1 SoC.

Now that we have Gen3 QMP PHY support, we can start fixing the PCIe support
by fixing the Gen3 QMP PHY node first.

Change the compatible to the Gen3 QMP PHY, correct the register space start
and size, add the missing misc PCS register space.

Fixes: 33057e1672fe ("ARM: dts: ipq8074: Add pcie nodes")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230113164449.906002-2-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 09ba99fc90ac4..2a3123827285e 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -197,9 +197,9 @@ qusb_phy_0: phy@79000 {
 			status = "disabled";
 		};
 
-		pcie_qmp0: phy@86000 {
-			compatible = "qcom,ipq8074-qmp-pcie-phy";
-			reg = <0x00086000 0x1c4>;
+		pcie_qmp0: phy@84000 {
+			compatible = "qcom,ipq8074-qmp-gen3-pcie-phy";
+			reg = <0x00084000 0x1bc>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
@@ -213,10 +213,11 @@ pcie_qmp0: phy@86000 {
 				      "common";
 			status = "disabled";
 
-			pcie_phy0: phy@86200 {
-				reg = <0x86200 0x16c>,
-				      <0x86400 0x200>,
-				      <0x86800 0x4f4>;
+			pcie_phy0: phy@84200 {
+				reg = <0x84200 0x16c>,
+				      <0x84400 0x200>,
+				      <0x84800 0x1f0>,
+				      <0x84c00 0xf4>;
 				#phy-cells = <0>;
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_PCIE0_PIPE_CLK>;
-- 
2.39.2



