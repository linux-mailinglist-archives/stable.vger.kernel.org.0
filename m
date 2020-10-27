Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FC729BBEE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802676AbgJ0Puv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802252AbgJ0PqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBFCC22265;
        Tue, 27 Oct 2020 15:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813564;
        bh=2hK27uyi8KX0nlZwWnPThF77ntKgOGIt5gBXDfs2hZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHIYzilSV2w4TSUO2Uotomm1faOlNPtncsUM9enciW+CI2pjFEJjX4VmXlBhWcVsz
         Tf79g2wu9WCeqKJEXmCnieAuglDyFboUdfzdVxJtj9rTYm4SxGdxEHiQT6FLAoWBLQ
         ATxJL3sL0zutoiN9jVqZk7AIzbdpUAagJ8EnBdts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 594/757] arm64: dts: qcom: sm8150: fix up primary USB nodes
Date:   Tue, 27 Oct 2020 14:54:04 +0100
Message-Id: <20201027135518.398183118@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 79493db5bb573017767b4f48b0fc69bfd01b82d2 ]

The compatible for hsphy has out of place indentation, and the assigned
clock rate for GCC_USB30_PRIM_MASTER_CLK is incorrect, the clock doesn't
support a rate of 150000000. Use a rate of 200000000 to match downstream.

Fixes: b33d2868e8d3 ("arm64: dts: qcom: sm8150: Add USB and PHY device nodes")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Link: https://lore.kernel.org/r/20200818160445.14008-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index b86a7ead30067..ab8680c6672e4 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -767,7 +767,7 @@ glink-edge {
 
 		usb_1_hsphy: phy@88e2000 {
 			compatible = "qcom,sm8150-usb-hs-phy",
-							"qcom,usb-snps-hs-7nm-phy";
+				     "qcom,usb-snps-hs-7nm-phy";
 			reg = <0 0x088e2000 0 0x400>;
 			status = "disabled";
 			#phy-cells = <0>;
@@ -833,7 +833,7 @@ usb_1: usb@a6f8800 {
 
 			assigned-clocks = <&gcc GCC_USB30_PRIM_MOCK_UTMI_CLK>,
 					  <&gcc GCC_USB30_PRIM_MASTER_CLK>;
-			assigned-clock-rates = <19200000>, <150000000>;
+			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.25.1



