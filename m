Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3BC4052FA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354598AbhIIMtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355151AbhIIMlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:41:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6048261C16;
        Thu,  9 Sep 2021 11:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188520;
        bh=OSdMAULjlmnN/jT+nXnh2Xtyn15yJLPU363d9rLYq7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pH99Q505CIej6YdF0vnfmNO0DaLiwQC9MU3pCuBNBKSzoo1SeEvvcUiGgbw4rvleA
         DYwhHaw+4K63CFxcgosicbvN/6YT8bofrNAU1UnaX5wdv144JYtnwoKqTWXfj/cueF
         Jf5q1RYOMymYl/fgdZOryib5qIp5WHMB3xoEC1qGF05fyC8PvrWr2ERsaYHJdr/6Qp
         YEEwHhsBVvbQYE/aLnEk6YICI7v8C+V47oicefokEeh9EG1fuf65hSJi+17FyWSExL
         p38cQ0MfgfUiKMWjG4rzYs3TwayxznK6YzZErt+2VwWE0edI6+2+7++Wgr56RAzcQN
         +yBZOvUm6HeTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Heidelberg <david@ixit.cz>,
        Brian Masney <masneyb@onstation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 010/109] ARM: dts: qcom: apq8064: correct clock names
Date:   Thu,  9 Sep 2021 07:53:27 -0400
Message-Id: <20210909115507.147917-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 0dc6c59892ead17a9febd11202c9f6794aac1895 ]

Since new code doesn't take old clk names in account, it does fixes
error:

msm_dsi 4700000.mdss_dsi: dev_pm_opp_set_clkname: Couldn't find clock: -2

and following kernel oops introduced by
b0530eb1191 ("drm/msm/dpu: Use OPP API to set clk/perf state").

Also removes warning about deprecated clock names.

Tested against linux-5.10.y LTS on Nexus 7 2013.

Reviewed-by: Brian Masney <masneyb@onstation.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20210707131453.24041-1-david@ixit.cz
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 8b79b4112ee1..2b075e287610 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1261,9 +1261,9 @@ dsi0: mdss_dsi@4700000 {
 				<&mmcc DSI1_BYTE_CLK>,
 				<&mmcc DSI_PIXEL_CLK>,
 				<&mmcc DSI1_ESC_CLK>;
-			clock-names = "iface_clk", "bus_clk", "core_mmss_clk",
-					"src_clk", "byte_clk", "pixel_clk",
-					"core_clk";
+			clock-names = "iface", "bus", "core_mmss",
+					"src", "byte", "pixel",
+					"core";
 
 			assigned-clocks = <&mmcc DSI1_BYTE_SRC>,
 					<&mmcc DSI1_ESC_SRC>,
-- 
2.30.2

