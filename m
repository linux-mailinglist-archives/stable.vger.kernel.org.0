Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90853C8F5B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhGNTw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239275AbhGNTtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33219613D0;
        Wed, 14 Jul 2021 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291852;
        bh=Yrve12/jdwlvsNq68YzbRvKgyuj0pinj6xtK69FCuWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USfuYsM6m6YRjXpdQb2PeBjgkbWQYB0U0TK8wcgsIq2oZ3B71JfwcfJxb2rUyVzFW
         rzCAvKedSZEVSg/5GTP62GZ0kUe+uaPQJ7iz8LTxSLkgXIdxHl3zp3jp2Hu8CuTOdH
         695qhOsE6xA13Zf9hDzwnVyPRX6VJ3oThhVwIcEumPvPYCJn690Em1N2C7876721/S
         Jj4El6HfHVX4OOGpKIjX58t7FqrpfsqXV9jq1VRSqdeFhrUj45HPvm9Ew3RoYkd1MS
         aYOieAIVvCnCHeBB38GVgVx90nZlpgaAwEx4o6HzNGPG2N+c95NGXtb2rjv+hyCUaG
         3YspVfse2AhDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 45/88] arm64: dts: qcom: msm8996: Make CPUCC actually probe (and work)
Date:   Wed, 14 Jul 2021 15:42:20 -0400
Message-Id: <20210714194303.54028-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index fd6ae5464dea..b774d5457328 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -1741,9 +1741,14 @@ apss_merge_funnel_out: endpoint {
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

