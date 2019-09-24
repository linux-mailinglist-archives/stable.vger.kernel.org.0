Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD26BBCFB3
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409924AbfIXQoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409919AbfIXQoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD971217D9;
        Tue, 24 Sep 2019 16:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343493;
        bh=ufQvx7ZNex7e9L1n3iz0qxl2DPV4jX3rgvJ6+P7qKWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAjV6HN8gdrTNe2vPwKlBWRH1xihV1OeYA2OQJOqadFPzEX7hNMomuvxrO5CDMjbu
         N2uv+4IW6IDclb3toYX4gkwkh7sKjNMh1qCCPtPHcwdGB0i4ERE3kf1te2ziPseBQA
         7vWafXFJBaM4XweQwZtWn09LDkg3DBX1Udyvsmpw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Taniya Das <tdas@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 70/87] clk: qcom: gcc-sdm845: Use floor ops for sdcc clks
Date:   Tue, 24 Sep 2019 12:41:26 -0400
Message-Id: <20190924164144.25591-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 5e4b7e82d497580bc430576c4c9bce157dd72512 ]

Some MMC cards fail to enumerate properly when inserted into an MMC slot
on sdm845 devices. This is because the clk ops for qcom clks round the
frequency up to the nearest rate instead of down to the nearest rate.
For example, the MMC driver requests a frequency of 52MHz from
clk_set_rate() but the qcom implementation for these clks rounds 52MHz
up to the next supported frequency of 100MHz. The MMC driver could be
modified to request clk rate ranges but for now we can fix this in the
clk driver by changing the rounding policy for this clk to be round down
instead of round up.

Fixes: 06391eddb60a ("clk: qcom: Add Global Clock controller (GCC) driver for SDM845")
Reported-by: Douglas Anderson <dianders@chromium.org>
Cc: Taniya Das <tdas@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lkml.kernel.org/r/20190830195142.103564-1-swboyd@chromium.org
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sdm845.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sdm845.c b/drivers/clk/qcom/gcc-sdm845.c
index 7131dcf9b0603..95be125c3bddf 100644
--- a/drivers/clk/qcom/gcc-sdm845.c
+++ b/drivers/clk/qcom/gcc-sdm845.c
@@ -685,7 +685,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_names = gcc_parent_names_10,
 		.num_parents = 5,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
@@ -709,7 +709,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.name = "gcc_sdcc4_apps_clk_src",
 		.parent_names = gcc_parent_names_0,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
-- 
2.20.1

