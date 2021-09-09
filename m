Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2654051B7
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352239AbhIIMiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348767AbhIIMco (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 823E161B5F;
        Thu,  9 Sep 2021 11:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188390;
        bh=TYnTM6irSzRisHVyIZScuhsSNua4F2UTUECQVQIdccU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gujgNWkSNBy5CErc6CMM5Y+7byCV/kq5btvYsZ21q3S7Rg4BczCa51G5SwuHjQhJ4
         EICakI8+5VGslZk8FCV/Yc5fFd6VGcTsPkNB7+WKk/yRA3Ax2kLZmhEwoGNxY6Sfxj
         WLEGLnD6yqR4nHjbGvzK1xQw0AmQnjcnxTO/3WtIqlxUQT/LFdjeCFyep8mOBh9Ejk
         Sw0C/eTxHVDmi8LHc8XozQQwInJc+W2+AU7PatsSt8Y1+pUUkhc5ls7b6JA2RZi4tn
         7n/77lhwENqzjPC7gdMtrQiy8r825uWvd3x2p+QDvJlMRHiI5AYB50zgLRv6ej/Xuz
         ioeMOO4YrbGaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 087/176] arm64: dts: qcom: msm8994: don't use underscore in node name
Date:   Thu,  9 Sep 2021 07:49:49 -0400
Message-Id: <20210909115118.146181-87-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 8c678beca7ed3fa8a2c6d86f6603bc23400f9ad8 ]

We have underscore (_) in node name leading to warning:
arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon-cityman.dt.yaml: clocks: xo_board: {'type': 'object'} is not allowed for {'compatible': ['fixed-clock'], '#clock-cells': [[0]], 'clock-frequency': [[19200000]], 'phandle': [[26]]}
arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon-cityman.dt.yaml: clocks: sleep_clk: {'type': 'object'} is not allowed for {'compatible': ['fixed-clock'], '#clock-cells': [[0]], 'clock-frequency': [[32768]]}

Fix this by changing node name to use dash (-)

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-9-vkoul@kernel.org
[bjorn: Added clock-output-names to satisfy parent_names]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 6707f898607f..45f9a44326a6 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -14,16 +14,18 @@ / {
 	chosen { };
 
 	clocks {
-		xo_board: xo_board {
+		xo_board: xo-board {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <19200000>;
+			clock-output-names = "xo_board";
 		};
 
-		sleep_clk: sleep_clk {
+		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <32768>;
+			clock-output-names = "sleep_clk";
 		};
 	};
 
-- 
2.30.2

