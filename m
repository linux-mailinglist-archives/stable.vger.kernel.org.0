Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3714658BF10
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbiHHBfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241987AbiHHBee (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:34:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F117CDF27;
        Sun,  7 Aug 2022 18:33:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2167BB80E09;
        Mon,  8 Aug 2022 01:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFF6C433C1;
        Mon,  8 Aug 2022 01:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922377;
        bh=ZlAR3l31X+YY8TuJwDiWqWrQ90lnCzpLo89Bcdp9OV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeukyYLQDYmTkzg9nWmkSxemMuDPp+M7n/+6d/753ClrXIOL46M6CAmJgQ9FiMon7
         uA1K+caprAws3pFH3H7P+0TxHnUDpbot4bBA91VjzsSDpG42STJ9XBKp+BVX0MbYM9
         XaV5didTC030FPxIcZWrXENBKdLq3YqbmtjjvtN5eTpbdQklvfWSmdVlJBM/2NTdeR
         oCsbahXsLHnI2eGlVlWoJiVh1p9hCeeTUfotmrpuuL2VUvS4+frFqiw56LVBOyzYxI
         dvEZPM8tz+a7KZC+IpK+5K9TxFqIHV6AaTIxmgmGt190blQM8Z2mUFNBet9VW+AC/x
         NnbYTpY3sHH7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 33/58] arm64: dts: qcom: timer should use only 32-bit size
Date:   Sun,  7 Aug 2022 21:30:51 -0400
Message-Id: <20220808013118.313965-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 458ebdbb8e5d596a462d8125cec74142ff5dfa97 ]

There's no reason the timer needs > 32-bits of address or size.
Since we using 32-bit size, we need to define ranges properly.

Fixes warnings as:
```
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: timer@17c90000: #size-cells:0:0: 1 was expected
        From schema: Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
```

Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220626105800.35586-1-david@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sc7180.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sc7280.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sdm845.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sm6350.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sm8150.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sm8250.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sm8350.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sm8450.dtsi  | 22 +++++++++++-----------
 9 files changed, 99 insertions(+), 99 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index c89499e366d3..748575ed1490 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -525,9 +525,9 @@ timer {
 		};
 
 		timer@b120000 {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x10000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0x0 0x0b120000 0x0 0x1000>;
 
@@ -535,49 +535,49 @@ frame@b120000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b121000 0x0 0x1000>,
-				      <0x0 0x0b122000 0x0 0x1000>;
+				reg = <0x0b121000 0x1000>,
+				      <0x0b122000 0x1000>;
 			};
 
 			frame@b123000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0xb123000 0x0 0x1000>;
+				reg = <0x0b123000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@b124000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b124000 0x0 0x1000>;
+				reg = <0x0b124000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@b125000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b125000 0x0 0x1000>;
+				reg = <0x0b125000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@b126000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b126000 0x0 0x1000>;
+				reg = <0x0b126000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@b127000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b127000 0x0 0x1000>;
+				reg = <0x0b127000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@b128000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b128000 0x0 0x1000>;
+				reg = <0x0b128000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 5dcaac23a138..2006f416e3e2 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3384,9 +3384,9 @@ watchdog@17c10000 {
 		};
 
 		timer@17c20000{
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0 0x17c20000 0 0x1000>;
 
@@ -3394,49 +3394,49 @@ frame@17c21000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c21000 0 0x1000>,
-				      <0 0x17c22000 0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c23000 0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c25000 0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c27000 0 0x1000>;
+				reg = <0x17c27000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c29000 0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c2b000 0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c2d000 0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index e66fc67de206..a7b128186b65 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -4771,9 +4771,9 @@ watchdog@17c10000 {
 		};
 
 		timer@17c20000 {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0 0x17c20000 0 0x1000>;
 
@@ -4781,49 +4781,49 @@ frame@17c21000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c21000 0 0x1000>,
-				      <0 0x17c22000 0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c23000 0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c25000 0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c27000 0 0x1000>;
+				reg = <0x17c27000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c29000 0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c2b000 0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c2d000 0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 038538c8c614..7783005c8028 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4948,9 +4948,9 @@ slimbam: dma-controller@17184000 {
 		};
 
 		timer@17c90000 {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0 0x17c90000 0 0x1000>;
 
@@ -4958,49 +4958,49 @@ frame@17ca0000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17ca0000 0 0x1000>,
-				      <0 0x17cb0000 0 0x1000>;
+				reg = <0x17ca0000 0x1000>,
+				      <0x17cb0000 0x1000>;
 			};
 
 			frame@17cc0000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17cc0000 0 0x1000>;
+				reg = <0x17cc0000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17cd0000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17cd0000 0 0x1000>;
+				reg = <0x17cd0000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17ce0000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17ce0000 0 0x1000>;
+				reg = <0x17ce0000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17cf0000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17cf0000 0 0x1000>;
+				reg = <0x17cf0000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17d00000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17d00000 0 0x1000>;
+				reg = <0x17d00000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17d10000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17d10000 0 0x1000>;
+				reg = <0x17d10000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index d4f8f33f3f0c..b44734cd8d6f 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1304,57 +1304,57 @@ timer@17c20000 {
 			compatible = "arm,armv7-timer-mem";
 			reg = <0x0 0x17c20000 0x0 0x1000>;
 			clock-frequency = <19200000>;
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 
 			frame@17c21000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c21000 0x0 0x1000>,
-				      <0x0 0x17c22000 0x0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c23000 0x0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c25000 0x0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c27000 0x0 0x1000>;
+				reg = <0x17c27000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c29000 0x0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2b000 0x0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2d000 0x0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 8ea44c4b56b4..592be9945cb8 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3944,9 +3944,9 @@ watchdog@17c10000 {
 		};
 
 		timer@17c20000 {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0x0 0x17c20000 0x0 0x1000>;
 			clock-frequency = <19200000>;
@@ -3955,49 +3955,49 @@ frame@17c21000{
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c21000 0x0 0x1000>,
-				      <0x0 0x17c22000 0x0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c23000 0x0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c25000 0x0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c26000 0x0 0x1000>;
+				reg = <0x17c26000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c29000 0x0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2b000 0x0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2d000 0x0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index cf0c97bd5ad3..5dae1b8469a2 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -4867,9 +4867,9 @@ watchdog@17c10000 {
 		};
 
 		timer@17c20000 {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0x0 0x17c20000 0x0 0x1000>;
 			clock-frequency = <19200000>;
@@ -4878,49 +4878,49 @@ frame@17c21000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c21000 0x0 0x1000>,
-				      <0x0 0x17c22000 0x0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c23000 0x0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c25000 0x0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c27000 0x0 0x1000>;
+				reg = <0x17c27000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c29000 0x0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2b000 0x0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2d000 0x0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 743cba9b683c..2b80d8f89d18 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1933,9 +1933,9 @@ intc: interrupt-controller@17a00000 {
 
 		timer@17c20000 {
 			compatible = "arm,armv7-timer-mem";
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			reg = <0x0 0x17c20000 0x0 0x1000>;
 			clock-frequency = <19200000>;
 
@@ -1943,49 +1943,49 @@ frame@17c21000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c21000 0x0 0x1000>,
-				      <0x0 0x17c22000 0x0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c23000 0x0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c25000 0x0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c27000 0x0 0x1000>;
+				reg = <0x17c27000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c29000 0x0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2b000 0x0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2d000 0x0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index b87756bf1ce4..c958f5d4adc2 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2867,9 +2867,9 @@ gic_its: msi-controller@17140000 {
 
 		timer@17420000 {
 			compatible = "arm,armv7-timer-mem";
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			reg = <0x0 0x17420000 0x0 0x1000>;
 			clock-frequency = <19200000>;
 
@@ -2877,49 +2877,49 @@ frame@17421000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17421000 0x0 0x1000>,
-				      <0x0 0x17422000 0x0 0x1000>;
+				reg = <0x17421000 0x1000>,
+				      <0x17422000 0x1000>;
 			};
 
 			frame@17423000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17423000 0x0 0x1000>;
+				reg = <0x17423000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17425000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17425000 0x0 0x1000>;
+				reg = <0x17425000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17427000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17427000 0x0 0x1000>;
+				reg = <0x17427000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17429000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17429000 0x0 0x1000>;
+				reg = <0x17429000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@1742b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x1742b000 0x0 0x1000>;
+				reg = <0x1742b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@1742d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x1742d000 0x0 0x1000>;
+				reg = <0x1742d000 0x1000>;
 				status = "disabled";
 			};
 		};
-- 
2.35.1

