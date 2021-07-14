Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5283C8CB2
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhGNTmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234692AbhGNTmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 088BF613D9;
        Wed, 14 Jul 2021 19:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291558;
        bh=U8Nkdo/ewlLhcS5FyiG8l9+XiwHGGNjkMo5Mcy+M6S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRPEhhwno1UKbT3A260Q0qEWCH5J/ILDsFh/oFueu9ioSbe+ElWRhVjRP3ncmSThS
         u+jBz2yQ9AFkIbPfRGmWvxCkEpZ7fRvjE/6sZW0tFWak7eo71GD2f4A3ubUZJZlGa5
         gnyxKueps6vdB6i8GAlYOxazx1At3K6X/xuQQArJ90Q1HBEEhyjID2fSMk24EAq0C8
         Rj7OPNDa0aG9HxV8kUsSnYqeaMmU7N3+B9QpVg0NuWRatz9+MD8hucdDT6B1yZ5kV4
         Vucbq0leP0o5yr60uC6s1EVurZ9L6oyl08RkFsK8m3IcOrg1QsTNssqTacpQqtOZF6
         mhVe1msW1keTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 054/108] arm64: dts: qcom: msm8996: Make CPUCC actually probe (and work)
Date:   Wed, 14 Jul 2021 15:37:06 -0400
Message-Id: <20210714193800.52097-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 0a275a35ceab07cb622ff212c54d6866e246ac53 ]

Fix the compatible to make the driver probe and tell the
driver where to look for the "xo" clock to make sure everything
works.

Then we get a happy (eh, happier) 8996:

somainline-sdcard:/home/konrad# cat /sys/kernel/debug/clk/pwrcl_pll/clk_rate
1152000000

Don't backport without "arm64: dts: qcom: msm8996: Add CPU opps", as
the system fails to boot without consumers for these clocks.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210527192958.775434-1-konrad.dybcio@somainline.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index ce430ba9c118..dd89d3cb772b 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -1745,9 +1745,14 @@ apss_merge_funnel_out: endpoint {
 				};
 			};
 		};
+
 		kryocc: clock-controller@6400000 {
-			compatible = "qcom,apcc-msm8996";
+			compatible = "qcom,msm8996-apcc";
 			reg = <0x06400000 0x90000>;
+
+			clock-names = "xo";
+			clocks = <&xo_board>;
+
 			#clock-cells = <1>;
 		};
 
-- 
2.30.2

