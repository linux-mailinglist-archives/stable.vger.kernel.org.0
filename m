Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142445947CD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343781AbiHOXIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352815AbiHOXGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:06:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D871415CE;
        Mon, 15 Aug 2022 12:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B37FB80EB1;
        Mon, 15 Aug 2022 19:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83C1C433D6;
        Mon, 15 Aug 2022 19:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593532;
        bh=IrnIOX7I/KNoLv78351gqETiUbl/nD5t/8ewY3lYHk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/x+rVDO+fZc3fQsOIQzoE/BwhqIRnGY0O9Uop0bP9/RHmobne0qJ3xJaekk59zRn
         q29J3+7Uknu1Orwtsl9sdiLiOybSdiYCExc1CToAGHiEnGaVFyuDhOxHpUztdjXwSa
         D8SoujoMWyqChx9DeVG7epdd0q/OLRsE8PVAjIPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0284/1157] arm64: dts: qcom: qcs404: Fix incorrect USB2 PHYs assignment
Date:   Mon, 15 Aug 2022 19:54:00 +0200
Message-Id: <20220815180450.969622989@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Sumit Garg <sumit.garg@linaro.org>

[ Upstream commit 58577966a42fc0b660b5e2c7c9e5a2241363ea83 ]

Currently the DT for QCS404 SoC has setup for 2 USB2 PHYs with one each
assigned to USB3 controller and USB2 controller. This assignment is
incorrect which only works by luck: as when each USB HCI comes up it
configures the *other* controllers PHY which is enough to make them
happy. If, for any reason, we were to disable one of the controllers then
both would stop working.

This was a difficult inconsistency to be caught which was found while
trying to enable USB support in u-boot. So with all the required drivers
ported to u-boot, I couldn't get the same USB storage device enumerated
in u-boot which was being enumerated fine by the kernel.

The root cause of the problem came out to be that I wasn't enabling USB2
PHY: "usb2_phy_prim" in u-boot. Then I realised that via simply disabling
the same USB2 PHY currently assigned to USB2 host controller in the
kernel disabled enumeration for USB3 host controller as well.

So fix this inconsistency by correctly assigning USB2 PHYs.

Fixes: 9375e7d719b3 ("arm64: dts: qcom: qcs404: Add USB devices and PHYs")
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220711083038.1518529-1-sumit.garg@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs404.dtsi b/arch/arm64/boot/dts/qcom/qcs404.dtsi
index d912166b7552..c8b7d8eb5996 100644
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -548,7 +548,7 @@ usb3_dwc3: usb@7580000 {
 				compatible = "snps,dwc3";
 				reg = <0x07580000 0xcd00>;
 				interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
-				phys = <&usb2_phy_sec>, <&usb3_phy>;
+				phys = <&usb2_phy_prim>, <&usb3_phy>;
 				phy-names = "usb2-phy", "usb3-phy";
 				snps,has-lpm-erratum;
 				snps,hird-threshold = /bits/ 8 <0x10>;
@@ -577,7 +577,7 @@ usb@78c0000 {
 				compatible = "snps,dwc3";
 				reg = <0x078c0000 0xcc00>;
 				interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
-				phys = <&usb2_phy_prim>;
+				phys = <&usb2_phy_sec>;
 				phy-names = "usb2-phy";
 				snps,has-lpm-erratum;
 				snps,hird-threshold = /bits/ 8 <0x10>;
-- 
2.35.1



