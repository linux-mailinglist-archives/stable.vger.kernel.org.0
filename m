Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB01759416A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345887AbiHOUrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346553AbiHOUqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:46:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80871B69D6;
        Mon, 15 Aug 2022 12:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C93FB81109;
        Mon, 15 Aug 2022 19:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BED6C433C1;
        Mon, 15 Aug 2022 19:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590513;
        bh=AqWw4NkX98xkqBjylREhBx6pgKkIJpx7teXTXimUm/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9xkU811CY2W6gqk3nGGRbOHXmzFBk7MMtbGbRAk25rdn1IXFzDWouQtC0dzkRdHz
         m7vAd4RbEBpNkKje44Ux3Q77Sq5D7bKuueM2xl36AGuoPqi14MW3mC/p3Mwu9YiqP6
         zxmGG6z09EWD6Ce6qCLtNHbwFkIdtPoiRzSwZ5g4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0283/1095] arm64: dts: qcom: qcs404: Fix incorrect USB2 PHYs assignment
Date:   Mon, 15 Aug 2022 19:54:42 +0200
Message-Id: <20220815180441.489375888@linuxfoundation.org>
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
index 3f06f7cd3cf2..65d71adee345 100644
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -548,7 +548,7 @@ dwc3@7580000 {
 				compatible = "snps,dwc3";
 				reg = <0x07580000 0xcd00>;
 				interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
-				phys = <&usb2_phy_sec>, <&usb3_phy>;
+				phys = <&usb2_phy_prim>, <&usb3_phy>;
 				phy-names = "usb2-phy", "usb3-phy";
 				snps,has-lpm-erratum;
 				snps,hird-threshold = /bits/ 8 <0x10>;
@@ -577,7 +577,7 @@ dwc3@78c0000 {
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



