Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C32329B9A7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802686AbgJ0Pux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901456AbgJ0PqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAE8A21D42;
        Tue, 27 Oct 2020 15:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813579;
        bh=z4xFy9j49OUnmiY3/lx8+n22eqHBVvFwSdZmhixlAEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=off6lGJxpD9AzhJgbwBsTYX3qh4CKJrLA+5VYP6TD8+8j2UdKvMd/JQBxQ0UxzeHK
         yMF5F1f1D9nnMADt3uwpT/3Qyhi5INrYiK18+TPN+vsPnyGo4ln0J18zBP6SRGUPqR
         MucU8qyBEuIgiCZ5vyd6qSAxB1bjEE3+LAFZwgZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 599/757] arm64: dts: qcom: sm8250: Rename UART2 node to UART12
Date:   Tue, 27 Oct 2020 14:54:09 +0100
Message-Id: <20201027135518.641655267@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit bb1dfb4da1d031380cd631dd0d6884d4e79a8d51 ]

The UART12 node has been mistakenly mentioned as UART2. Let's fix that
for both SM8250 SoC and MTP board and also add pinctrl definition for
it.

Fixes: 60378f1a171e ("arm64: dts: qcom: sm8250: Add sm8250 dts file")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20200904063637.28632-3-manivannan.sadhasivam@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts |  4 ++--
 arch/arm64/boot/dts/qcom/sm8250.dtsi    | 11 ++++++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
index 6894f8490dae7..6e2f7ae1d6211 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
@@ -17,7 +17,7 @@ / {
 	compatible = "qcom,sm8250-mtp";
 
 	aliases {
-		serial0 = &uart2;
+		serial0 = &uart12;
 	};
 
 	chosen {
@@ -371,7 +371,7 @@ &tlmm {
 	gpio-reserved-ranges = <28 4>, <40 4>;
 };
 
-&uart2 {
+&uart12 {
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 377172e8967b7..e7d139e1a6cec 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -935,11 +935,13 @@ spi12: spi@a90000 {
 				status = "disabled";
 			};
 
-			uart2: serial@a90000 {
+			uart12: serial@a90000 {
 				compatible = "qcom,geni-debug-uart";
 				reg = <0x0 0x00a90000 0x0 0x4000>;
 				clock-names = "se";
 				clocks = <&gcc GCC_QUPV3_WRAP1_S4_CLK>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&qup_uart12_default>;
 				interrupts = <GIC_SPI 357 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
@@ -1880,6 +1882,13 @@ config {
 					bias-disable;
 				};
 			};
+
+			qup_uart12_default: qup-uart12-default {
+				mux {
+					pins = "gpio34", "gpio35";
+					function = "qup12";
+				};
+			};
 		};
 
 		adsp: remoteproc@17300000 {
-- 
2.25.1



