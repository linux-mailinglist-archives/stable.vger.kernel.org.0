Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69A36AF318
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbjCGTAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjCGS74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:59:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200D3AF769
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:46:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BBECB817AE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68219C433D2;
        Tue,  7 Mar 2023 18:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214802;
        bh=VqdY6qdwi0/wxoBc3it83JrUloxRgSaPxVN6tAk98Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyV4wTsHltK0ZreHot4lUquEyg0sCDQv+pmpitT/eJdcBDBR1Ywjjma6gtjXjBZpL
         8dITN256/fO3jlpcX6M0zVeDYKhFrBcQxb4dxD6SdA+tiP0Q3y8RC3H/yXcc7bI0XR
         y3mFKE0MpmH17e1nazr/HHlhs8Vj2psK61fJpwrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/567] arm64: dts: qcom: ipq8074: fix PCIe PHY serdes size
Date:   Tue,  7 Mar 2023 17:55:59 +0100
Message-Id: <20230307165906.921440165@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index ae32e2380dd5a..a7ce999182e9e 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -176,7 +176,7 @@ qusb_phy_0: phy@79000 {
 
 		pcie_qmp0: phy@86000 {
 			compatible = "qcom,ipq8074-qmp-pcie-phy";
-			reg = <0x00086000 0x1000>;
+			reg = <0x00086000 0x1c4>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
@@ -204,7 +204,7 @@ pcie_phy0: phy@86200 {
 
 		pcie_qmp1: phy@8e000 {
 			compatible = "qcom,ipq8074-qmp-pcie-phy";
-			reg = <0x0008e000 0x1000>;
+			reg = <0x0008e000 0x1c4>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
-- 
2.39.2



