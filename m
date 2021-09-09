Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A064054D2
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353586AbhIINDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357132AbhIIM7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4407063272;
        Thu,  9 Sep 2021 11:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188747;
        bh=vB0KYNHGxCN1lO8Jxd+fn371xRiVqBtRljeuyckGFEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LD+sF0p03wiohqTE/OnjqV4gbKrAVHRDCzA803WnoCF/AQw2OabnHN9kac/wX8XZX
         hqUSHQaydxI8eir/LE1FroZkudC9vD3GQtRUdZqYMVECI0kYPcgRFM6fF1Sq4BOR/M
         T+g2ck8j4y1BvkUEPBeOcffd+49isSTag4V+53DSg5n4z2KVoGlvl2iDiiUbf7sfR7
         tyjEp1Cs898pLENy3zOuFHZ72w0H4/F2rb93Aj4u1qzZPjMwBo0e2dugcZr5ROvjHp
         l28ypD03QFwG/eTv52su7JJTw7MB7gyHJeyy1GF2nCSROun5HVvl4HDPRNTV8zN9oV
         b0RHIUvPce9Ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Heidelberg <david@ixit.cz>,
        Brian Masney <masneyb@onstation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/59] ARM: dts: qcom: apq8064: correct clock names
Date:   Thu,  9 Sep 2021 07:58:06 -0400
Message-Id: <20210909115900.149795-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
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
index 6089c8d56cd5..eef243998392 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1228,9 +1228,9 @@ dsi0: mdss_dsi@4700000 {
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

