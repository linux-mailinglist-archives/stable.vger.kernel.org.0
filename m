Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F75246A34
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgHQPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730294AbgHQPbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:31:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9359220786;
        Mon, 17 Aug 2020 15:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678310;
        bh=37V6/cHNfByxn1dowiPj7VwusDnRpgO6TdIfMvjVYJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4Ey9ulJNz/HtWs8iWZol+3LWuO5nUJjc2wj4d5V+c9/QZnESLQwQXAQCFTXehrUV
         uQvUWdD2hE/Z8CYqtsTNcxwReQwhxZP2ggroiID4NNUaojA7K3ei615j0QpioXS1RA
         2I31I7ooHKTAhW/2Qdauc/JNqewEk0yCsGMe5skc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Evan Green <evgreen@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 259/464] clk: qcom: gcc: Make disp gpll0 branch aon for sc7180/sdm845
Date:   Mon, 17 Aug 2020 17:13:32 +0200
Message-Id: <20200817143846.197184596@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taniya Das <tdas@codeaurora.org>

[ Upstream commit 9c3df2b1993da9ab1110702d7b2815d5cd8c02f3 ]

The display gpll0 branch clock inside GCC needs to always be enabled.
Otherwise the AHB clk (disp_cc_mdss_ahb_clk_src) for the display clk
controller (dispcc) will stop clocking while sourcing from gpll0 when
this branch inside GCC is turned off during unused clk disabling. We can
never turn this branch off because the AHB clk for the display subsystem
is needed to read/write any registers inside the display subsystem
including clk related ones. This makes this branch a really easy way to
turn off AHB access to the display subsystem and cause all sorts of
mayhem. Let's just make the clk ops keep the clk enabled forever and
ignore any attempts to disable this clk so that dispcc accesses keep
working.

Signed-off-by: Taniya Das <tdas@codeaurora.org>
Reported-by: Evan Green <evgreen@chromium.org>
Link: https://lore.kernel.org/r/1594796050-14511-1-git-send-email-tdas@codeaurora.org
Fixes: 17269568f726 ("clk: qcom: Add Global Clock controller (GCC) driver for SC7180")
Fixes: 06391eddb60a ("clk: qcom: Add Global Clock controller (GCC) driver for SDM845")
[sboyd@kernel.org: Fill out commit text more]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc7180.c | 2 +-
 drivers/clk/qcom/gcc-sdm845.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sc7180.c b/drivers/clk/qcom/gcc-sc7180.c
index ca4383e3a02a7..538677befb86f 100644
--- a/drivers/clk/qcom/gcc-sc7180.c
+++ b/drivers/clk/qcom/gcc-sc7180.c
@@ -1061,7 +1061,7 @@ static struct clk_branch gcc_disp_gpll0_clk_src = {
 				.hw = &gpll0.clkr.hw,
 			},
 			.num_parents = 1,
-			.ops = &clk_branch2_ops,
+			.ops = &clk_branch2_aon_ops,
 		},
 	},
 };
diff --git a/drivers/clk/qcom/gcc-sdm845.c b/drivers/clk/qcom/gcc-sdm845.c
index f6ce888098be9..90f7febaf5288 100644
--- a/drivers/clk/qcom/gcc-sdm845.c
+++ b/drivers/clk/qcom/gcc-sdm845.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018, 2020, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/kernel.h>
@@ -1344,7 +1344,7 @@ static struct clk_branch gcc_disp_gpll0_clk_src = {
 				"gpll0",
 			},
 			.num_parents = 1,
-			.ops = &clk_branch2_ops,
+			.ops = &clk_branch2_aon_ops,
 		},
 	},
 };
-- 
2.25.1



