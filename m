Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44981BA5EE
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390156AbfIVSqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390149AbfIVSqn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:46:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEFA1214AF;
        Sun, 22 Sep 2019 18:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178002;
        bh=laBXdjhEBj/+X/JVTuEkEsHnRzQeu89qrZqIqosxvkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0cjrGVl0lewtS1m9wU/GdJHd0XJoWK56G1vpc80YJzufgkGjN3JFjQnOBM7l/p2jW
         a5u/zQa1A6/JnD+r7cu7WhE5jTT/eneGJToYABRJk2H15y02YRHzQaLDYPvF791a0L
         /keOVVhk3Wnn6WyARXPjujcuR8Zsf9ceM+fcV3SI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 091/203] arm64: dts: qcom: qcs404-evb: Mark WCSS clocks protected
Date:   Sun, 22 Sep 2019 14:41:57 -0400
Message-Id: <20190922184350.30563-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 54d895bea43c94f31304d59f82d755b7f4b59e7c ]

'7d0c76bdf227 ("clk: qcom: Add WCSS gcc clock control for QCS404")'
introduces two new clocks to gcc. These are not used before
clk_disable_unused() and as such the clock framework tries to disable
them.

But on the EVB these registers are only accessible through TrustZone, so
these clocks must be marked as "protected" to prevent the clock code
from touching them.

Numerical values are used as the constants are not yet available in a
common tree.

Reviewed-by: Niklas Cassel <niklas.cassel@linaro.org>
Reported-by: Mark Brown <broonie@kernel.org>
Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
index 11c0a7137823d..db6df76e97a1a 100644
--- a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
@@ -61,7 +61,9 @@
 	protected-clocks = <GCC_BIMC_CDSP_CLK>,
 			   <GCC_CDSP_CFG_AHB_CLK>,
 			   <GCC_CDSP_BIMC_CLK_SRC>,
-			   <GCC_CDSP_TBU_CLK>;
+			   <GCC_CDSP_TBU_CLK>,
+			   <141>, /* GCC_WCSS_Q6_AHB_CLK */
+			   <142>; /* GCC_WCSS_Q6_AXIM_CLK */
 };
 
 &pms405_spmi_regulators {
-- 
2.20.1

