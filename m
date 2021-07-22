Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D138C3D29AE
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhGVQF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233975AbhGVQD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A52A561C8C;
        Thu, 22 Jul 2021 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972257;
        bh=cKbrKWrpak8L0uBM/FvyHSAiZzF4hb5RFwSKwT9B0Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Io6VqEvgcQZ88AT0/Np6ENBES3TQAOP4rFVZ4ftti5guoGP6J3FkIqa6jlb6bjY0
         eoGepDfN+F839ufSzRe5vsurFGhN41fzlYOSNKJB3NFD7RPmC9K7nZp20+/cbTeyvg
         T6wl+IRadA1nT+xJh+sU+78GQed92kmMo9BJrK2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Foss <robert.foss@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 046/156] arm64: dts: qcom: sm8350: fix the node unit addresses
Date:   Thu, 22 Jul 2021 18:30:21 +0200
Message-Id: <20210722155629.897199540@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 1dee9e3b0997fef7170f7ea2d8eab47d0cd334d8 ]

Some node unit addresses were put wrongly in the dts, resulting in
below warning when run with W=1

arch/arm64/boot/dts/qcom/sm8350.dtsi:693.34-702.5: Warning (simple_bus_reg): /soc@0/thermal-sensor@c222000: simple-bus unit address format error, expected "c263000"
arch/arm64/boot/dts/qcom/sm8350.dtsi:704.34-713.5: Warning (simple_bus_reg): /soc@0/thermal-sensor@c223000: simple-bus unit address format error, expected "c265000"
arch/arm64/boot/dts/qcom/sm8350.dtsi:1180.32-1185.5: Warning (simple_bus_reg): /soc@0/interconnect@90e0000: simple-bus unit address format error, expected "90c0000"

Fix by correcting to the correct address as given in reg node

Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210513060733.382420-1-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index ed0b51bc03ea..a2382eb8619b 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -689,7 +689,7 @@
 			interrupt-controller;
 		};
 
-		tsens0: thermal-sensor@c222000 {
+		tsens0: thermal-sensor@c263000 {
 			compatible = "qcom,sm8350-tsens", "qcom,tsens-v2";
 			reg = <0 0x0c263000 0 0x1ff>, /* TM */
 			      <0 0x0c222000 0 0x8>; /* SROT */
@@ -700,7 +700,7 @@
 			#thermal-sensor-cells = <1>;
 		};
 
-		tsens1: thermal-sensor@c223000 {
+		tsens1: thermal-sensor@c265000 {
 			compatible = "qcom,sm8350-tsens", "qcom,tsens-v2";
 			reg = <0 0x0c265000 0 0x1ff>, /* TM */
 			      <0 0x0c223000 0 0x8>; /* SROT */
@@ -1176,7 +1176,7 @@
 			};
 		};
 
-		dc_noc: interconnect@90e0000 {
+		dc_noc: interconnect@90c0000 {
 			compatible = "qcom,sm8350-dc-noc";
 			reg = <0 0x090c0000 0 0x4200>;
 			#interconnect-cells = <1>;
-- 
2.30.2



