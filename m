Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4678404F0A
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344726AbhIIMQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344940AbhIIMNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:13:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3862C61A0A;
        Thu,  9 Sep 2021 11:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188134;
        bh=JSuMEoCZLHXcZw9K4iVZHo9WxIsZ7wd55+BApHU8Nvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzKed2tK6VbRZEwJmfzKy70kGvTnBjgG5d1QLSglCWvLTjnKo9ZnSz03LFGrr8HFc
         iJz6EJiCucMINgG2jRFUssNSm/qxXpEz0G8tSWxmKWxl8gT6YlUPDcLjIDzZ8BtUcG
         I3p5EktEgLh58/xAwANIS+l+o1YENxfR0ZkxxTlt2bpCqjVVKIVcERLnTU9MICN14o
         12sYP8gvjZISMCL7F4EM9wu9hR1kEIiE+8LSs3xi3BrGsjXpqSZ+fGqM5S44C6ZIBi
         WG8GG/iprvxJZyYKG52IbK+5/pWGqXedGGYarnaD6ykMTxeQz1vNq2kLAkkZl+moFU
         ZbhNMp6yrjQ5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 107/219] arm64: dts: qcom: msm8994: don't use underscore in node name
Date:   Thu,  9 Sep 2021 07:44:43 -0400
Message-Id: <20210909114635.143983-107-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index f9f0b5aa6a26..87a3217e88ef 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -15,16 +15,18 @@ / {
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

