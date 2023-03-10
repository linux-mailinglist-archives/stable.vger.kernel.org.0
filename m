Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5226B46C7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbjCJOqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbjCJOqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:46:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40DA11E6C3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:46:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88EE0B822E3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6C8C4339B;
        Fri, 10 Mar 2023 14:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459567;
        bh=ZU+yxYviQ6eC4PX1A7391J8Sl2ynHYYIzS9B7ixUsCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOMCsOM4GinNpkhXfmqP6QKfswmVNfWGM6IF0pu58gX+d2SIwwQviEqQYCLXl32qG
         GmkR86EJtO/2dLUzGZg2j7RmVEpgRPrrMRfZkb13V1RS3S21lp71E3gIVaAG9Hwv8r
         Yf7R/mCfgHjLTAX9AYe7HwOKFgT0lrdY/ZEWKAAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/529] arm64: dts: qcom: ipq8074: fix Gen3 PCIe node
Date:   Fri, 10 Mar 2023 14:32:42 +0100
Message-Id: <20230310133805.882413692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

[ Upstream commit 3e83a9c41ab0244a45a4a2800b9adb8de0d15f82 ]

IPQ8074 comes in 2 silicon versions:
* v1 with 2x Gen2 PCIe ports and QMP PHY-s
* v2 with 1x Gen3 and 1x Gen2 PCIe ports and QMP PHY-s

v2 is the final and production version that is actually supported by the
kernel, however it looks like PCIe related nodes were added for the v1 SoC.

Finish the PCIe fixup by using the correct compatible, adding missing ATU
register space, declaring max-link-speed, use correct ranges, add missing
clocks and resets.

Fixes: 33057e1672fe ("ARM: dts: ipq8074: Add pcie nodes")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230113164449.906002-8-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 30 +++++++++++++++------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 1dbae9c73c590..4ef364c010125 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -655,16 +655,18 @@ IRQ_TYPE_LEVEL_HIGH>, /* int_c */
 		};
 
 		pcie0: pci@20000000 {
-			compatible = "qcom,pcie-ipq8074";
+			compatible = "qcom,pcie-ipq8074-gen3";
 			reg = <0x20000000 0xf1d>,
 			      <0x20000f20 0xa8>,
-			      <0x00080000 0x2000>,
+			      <0x20001000 0x1000>,
+			      <0x00080000 0x4000>,
 			      <0x20100000 0x1000>;
-			reg-names = "dbi", "elbi", "parf", "config";
+			reg-names = "dbi", "elbi", "atu", "parf", "config";
 			device_type = "pci";
 			linux,pci-domain = <0>;
 			bus-range = <0x00 0xff>;
 			num-lanes = <1>;
+			max-link-speed = <3>;
 			#address-cells = <3>;
 			#size-cells = <2>;
 
@@ -672,9 +674,9 @@ pcie0: pci@20000000 {
 			phy-names = "pciephy";
 
 			ranges = <0x81000000 0 0x20200000 0x20200000
-				  0 0x100000   /* downstream I/O */
-				  0x82000000 0 0x20300000 0x20300000
-				  0 0xd00000>; /* non-prefetchable memory */
+				  0 0x10000>, /* downstream I/O */
+				 <0x82000000 0 0x20220000 0x20220000
+				  0 0xfde0000>; /* non-prefetchable memory */
 
 			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
@@ -692,28 +694,30 @@ IRQ_TYPE_LEVEL_HIGH>, /* int_c */
 			clocks = <&gcc GCC_SYS_NOC_PCIE0_AXI_CLK>,
 				 <&gcc GCC_PCIE0_AXI_M_CLK>,
 				 <&gcc GCC_PCIE0_AXI_S_CLK>,
-				 <&gcc GCC_PCIE0_AHB_CLK>,
-				 <&gcc GCC_PCIE0_AUX_CLK>;
-
+				 <&gcc GCC_PCIE0_AXI_S_BRIDGE_CLK>,
+				 <&gcc GCC_PCIE0_RCHNG_CLK>;
 			clock-names = "iface",
 				      "axi_m",
 				      "axi_s",
-				      "ahb",
-				      "aux";
+				      "axi_bridge",
+				      "rchng";
+
 			resets = <&gcc GCC_PCIE0_PIPE_ARES>,
 				 <&gcc GCC_PCIE0_SLEEP_ARES>,
 				 <&gcc GCC_PCIE0_CORE_STICKY_ARES>,
 				 <&gcc GCC_PCIE0_AXI_MASTER_ARES>,
 				 <&gcc GCC_PCIE0_AXI_SLAVE_ARES>,
 				 <&gcc GCC_PCIE0_AHB_ARES>,
-				 <&gcc GCC_PCIE0_AXI_MASTER_STICKY_ARES>;
+				 <&gcc GCC_PCIE0_AXI_MASTER_STICKY_ARES>,
+				 <&gcc GCC_PCIE0_AXI_SLAVE_STICKY_ARES>;
 			reset-names = "pipe",
 				      "sleep",
 				      "sticky",
 				      "axi_m",
 				      "axi_s",
 				      "ahb",
-				      "axi_m_sticky";
+				      "axi_m_sticky",
+				      "axi_s_sticky";
 			status = "disabled";
 		};
 	};
-- 
2.39.2



