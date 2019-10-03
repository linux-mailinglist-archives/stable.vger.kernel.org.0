Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A968CA66B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392721AbfJCQnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392151AbfJCQnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:43:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BEC92070B;
        Thu,  3 Oct 2019 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121019;
        bh=laBXdjhEBj/+X/JVTuEkEsHnRzQeu89qrZqIqosxvkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StMOLy3XeTNfDattvj9vO7G6iX2S+8GXSbSQD5SS5IK98DmD0S9/5eesLSX4U/mcP
         smHpZwC195gY2Z1GS7l0tf58lKAHKyWsUxR0wUWSrV/luYHQDGV1lUREUvlnzZdMO2
         30FoH2Zl2fIk0uzshgtI0lw4aeXzz5fdCPKbEdwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 124/344] arm64: dts: qcom: qcs404-evb: Mark WCSS clocks protected
Date:   Thu,  3 Oct 2019 17:51:29 +0200
Message-Id: <20191003154552.443445773@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



