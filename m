Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959A46AF320
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbjCGTAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbjCGTAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22D9B5B51
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:47:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CC7BB819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C280C433EF;
        Tue,  7 Mar 2023 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214806;
        bh=NbNEQjtG7NoY0Uc4i+KsWjJeYegPpHWlgnWbK8aDjEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OymAZqAUUo3Ep1A2/Zf/kwSTiwFgdzWKIkcvREsvNcVdS919sMGH6rwQJEWHzRuog
         pNpmwz9gjJ+BJEVbQHbmqXpfo3U98+89hkrv5ywW5pdA5MwSeI3oQsp1suZxQXAIlR
         Vzc7gWVrWuh15Hz+guM0Idr+Fjx4EkhR1c34Fbns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/567] arm64: dts: qcom: ipq8074: fix Gen3 PCIe QMP PHY
Date:   Tue,  7 Mar 2023 17:56:00 +0100
Message-Id: <20230307165906.964530741@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index a7ce999182e9e..6a095087bc64e 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -174,9 +174,9 @@ qusb_phy_0: phy@79000 {
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
@@ -190,10 +190,11 @@ pcie_qmp0: phy@86000 {
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



