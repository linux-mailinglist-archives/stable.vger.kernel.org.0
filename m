Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E5E593E50
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244050AbiHOUkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiHOUiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:38:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364DFADCD2;
        Mon, 15 Aug 2022 12:07:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82940B8107A;
        Mon, 15 Aug 2022 19:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC54BC433C1;
        Mon, 15 Aug 2022 19:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590424;
        bh=UZHIizdr5sPbVxj0LzXonL82Cx1mUWDggRzlm6WmWnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6eKU8KKluitpny5kHUmavvvWOFIYhS0agsXC9uUUni41BRg/f4KIGLfYDSUkLVA5
         cURRMqrKboNLvB+8eEAwrXMI0P7Dqq55Wu1t8HUQmwFkeGORRQ+jeydhVHMSKU2ZaB
         FnzES02kwLk1RGzwesFoWEOroOKsCBebaR3I2T1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0255/1095] arm64: dts: qcom: sm6125: Move sdc2 pinctrl from seine-pdx201 to sm6125
Date:   Mon, 15 Aug 2022 19:54:14 +0200
Message-Id: <20220815180440.305485923@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 6990640a93ba4e76dd62ca3ea1082a7354db09d7 ]

Both the sdc2-on and sdc2-off pinctrl nodes are used by the
sdhci@4784000 node in sm6125.dtsi.  Surprisingly sdc2-off is defined in
sm6125, yet its sdc2-on counterpart is only defined in board-specific DT
for the Sony Seine PDX201 board/device resulting in an "undefined label
&sdc2_state_on" error if sm6125.dtsi were included elsewhere.
This sm6125 base dtsi should not rely on externally defined labels; the
properties referencing it should then also be written externally.
Since the sdc2-on pin configuration is board-independent just like
sdc2-off, move it from seine-pdx201.dts into sm6125.dtsi.

The SDCard-detect pin (gpio98) is however board-specific, and remains as
an overwrite in seine-pdx201.dts for both the on and off state.

As a drive-by cleanup, reorder bias- and drive-strength properties.

Fixes: cff4bbaf2a2d ("arm64: dts: qcom: Add support for SM6125")
Fixes: 82e1783890b7 ("arm64: dts: qcom: sm6125: Add support for Sony Xperia 10II")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220508100336.127176-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/sm6125-sony-xperia-seine-pdx201.dts  | 34 +++++--------------
 arch/arm64/boot/dts/qcom/sm6125.dtsi          | 24 +++++++++++--
 2 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts b/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
index 871ccbba445b..4916e6c8b625 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
@@ -91,8 +91,16 @@ &hsusb_phy1 {
 &sdc2_state_off {
 	sd-cd {
 		pins = "gpio98";
+		drive-strength = <2>;
 		bias-disable;
+	};
+};
+
+&sdc2_state_on {
+	sd-cd {
+		pins = "gpio98";
 		drive-strength = <2>;
+		bias-pull-up;
 	};
 };
 
@@ -102,32 +110,6 @@ &sdhc_1 {
 
 &tlmm {
 	gpio-reserved-ranges = <22 2>, <28 6>;
-
-	sdc2_state_on: sdc2-on {
-		clk {
-			pins = "sdc2_clk";
-			bias-disable;
-			drive-strength = <16>;
-		};
-
-		cmd {
-			pins = "sdc2_cmd";
-			bias-pull-up;
-			drive-strength = <10>;
-		};
-
-		data {
-			pins = "sdc2_data";
-			bias-pull-up;
-			drive-strength = <10>;
-		};
-
-		sd-cd {
-			pins = "gpio98";
-			bias-pull-up;
-			drive-strength = <2>;
-		};
-	};
 };
 
 &usb3 {
diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index e81b2a7794fb..3fadf5196c4d 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -389,20 +389,40 @@ tlmm: pinctrl@500000 {
 			sdc2_state_off: sdc2-off {
 				clk {
 					pins = "sdc2_clk";
-					bias-disable;
 					drive-strength = <2>;
+					bias-disable;
 				};
 
 				cmd {
 					pins = "sdc2_cmd";
+					drive-strength = <2>;
 					bias-pull-up;
+				};
+
+				data {
+					pins = "sdc2_data";
 					drive-strength = <2>;
+					bias-pull-up;
+				};
+			};
+
+			sdc2_state_on: sdc2-on {
+				clk {
+					pins = "sdc2_clk";
+					drive-strength = <16>;
+					bias-disable;
+				};
+
+				cmd {
+					pins = "sdc2_cmd";
+					drive-strength = <10>;
+					bias-pull-up;
 				};
 
 				data {
 					pins = "sdc2_data";
+					drive-strength = <10>;
 					bias-pull-up;
-					drive-strength = <2>;
 				};
 			};
 		};
-- 
2.35.1



