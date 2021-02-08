Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D77E313C70
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhBHSGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235191AbhBHSCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:02:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85B7864D92;
        Mon,  8 Feb 2021 17:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807142;
        bh=l/mRLh6nguuYRxV20ToE7e2U3A0nwpk5ETan8VcVz9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehUUkbsGDf2jX4SBbRZV5jxfK5Cjv41PEoz7KapGeIxhWhMzIV9AozeG09ZNRdsnt
         /voD1GjJ/Wri6VE4m22JPYKeWnxJM1KIsjpMG4mQzStVZJvccHqLu2X+uXxczeN/PU
         scCXw4d3hzNB7CwTN/PlhRVjjmddNGpK0Qx/PFUoPj5jQ/OVorDVd495C/cjyaliW6
         F2OQE9LuYNE73uzI6J1EXb5/oWAuLf8nSVebe7wyxjKqRSnpBPxHxtWL1f5Gms1GT5
         K03e1/ft8HH/yQmbVjDHwqy0GrWNP5g4GoFLUTnQBwXq64Q8a6M7gHHTKB0FkORcLi
         utTdY9eqk+axQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/19] arm64: dts: qcom: sdm845: Reserve LPASS clocks in gcc
Date:   Mon,  8 Feb 2021 12:58:41 -0500
Message-Id: <20210208175858.2092008-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175858.2092008-1-sashal@kernel.org>
References: <20210208175858.2092008-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 93f2a11580a9732c1d90f9e01a7e9facc825658f ]

The GCC_LPASS_Q6_AXI_CLK and GCC_LPASS_SWAY_CLK clocks may not be
touched on a typical UEFI based SDM845 device, but when the kernel is
built with CONFIG_SDM_LPASSCC_845 this happens, unless they are marked
as protected-clocks in the DT.

This was done for the MTP and the Pocophone, but not for DB845c and the
Lenovo Yoga C630 - causing these to fail to boot if the LPASS clock
controller is enabled (which it typically isn't).

Tested-by: Vinod Koul <vkoul@kernel.org> #on db845c
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20201222001103.3112306-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts           | 4 +++-
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 751651a6cd819..bf4fde88011c8 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -337,7 +337,9 @@ &cdsp_pas {
 &gcc {
 	protected-clocks = <GCC_QSPI_CORE_CLK>,
 			   <GCC_QSPI_CORE_CLK_SRC>,
-			   <GCC_QSPI_CNOC_PERIPH_AHB_CLK>;
+			   <GCC_QSPI_CNOC_PERIPH_AHB_CLK>,
+			   <GCC_LPASS_Q6_AXI_CLK>,
+			   <GCC_LPASS_SWAY_CLK>;
 };
 
 &pm8998_gpio {
diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index f539b3655f6b9..ccecc8ea0f96d 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -232,7 +232,9 @@ &apps_smmu {
 &gcc {
 	protected-clocks = <GCC_QSPI_CORE_CLK>,
 			   <GCC_QSPI_CORE_CLK_SRC>,
-			   <GCC_QSPI_CNOC_PERIPH_AHB_CLK>;
+			   <GCC_QSPI_CNOC_PERIPH_AHB_CLK>,
+			   <GCC_LPASS_Q6_AXI_CLK>,
+			   <GCC_LPASS_SWAY_CLK>;
 };
 
 &i2c1 {
-- 
2.27.0

