Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC423D285E
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhGVP4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232663AbhGVP4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ADB660FDA;
        Thu, 22 Jul 2021 16:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971836;
        bh=nHVaMmFssVugTI/O0HVk9I2OZEDC1uJS2IkRqr+tM5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agpPfdZWVOpSEXTOeiYjSvvbFUUaumM6Qyd9q9X3Tdnp/z548gWC4p7x0EGoJeFid
         FXhbUKfGQDVEznn6FpYCebezE0o1qJRmzQ5M+HP4W1v1LeTUwQNW+Bv3ui9Hp3swDr
         jspSdg8eubNaoKrShzy+B/zkK6DuJB82Vi6bwKvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/125] arm64: dts: qcom: msm8996: Make CPUCC actually probe (and work)
Date:   Thu, 22 Jul 2021 18:30:29 +0200
Message-Id: <20210722155625.957020845@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -1741,9 +1741,14 @@
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



