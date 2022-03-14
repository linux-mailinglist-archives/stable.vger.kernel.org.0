Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7374D83CC
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238961AbiCNMVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241813AbiCNMSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CFF264D;
        Mon, 14 Mar 2022 05:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3256F6139D;
        Mon, 14 Mar 2022 12:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41515C340ED;
        Mon, 14 Mar 2022 12:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259984;
        bh=x8ZDC68Cp5usz1aT+VE2TNb5XMwJpsLwMUxX0tjgTFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjrT8N7SqCWf/cFCIQzloXGbB4Sely2ZWWF2fuxsLe3XvALJtx+OQ+vuL629SH71H
         nwx5jqti+curogXwprtzgCWhINC59m0mtuXncPRQyUKx8tYbGpuWODnDyrRyhKMXAp
         oMwzXuez8hbthfssfx1GMuap4JObzWGgjZtQ/VSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 007/121] clk: qcom: dispcc: Update the transition delay for MDSS GDSC
Date:   Mon, 14 Mar 2022 12:53:10 +0100
Message-Id: <20220314112744.330030133@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taniya Das <tdas@codeaurora.org>

[ Upstream commit 6e6fec3f961c00ca34ffb4bf2ad9febb4b499f8d ]

On SC7180 we observe black screens because the gdsc is being
enabled/disabled very rapidly and the GDSC FSM state does not work as
expected. This is due to the fact that the GDSC reset value is being
updated from SW.

The recommended transition delay for mdss core gdsc updated for
SC7180/SC7280/SM8250.

Fixes: dd3d06622138 ("clk: qcom: Add display clock controller driver for SC7180")
Fixes: 1a00c962f9cd ("clk: qcom: Add display clock controller driver for SC7280")
Fixes: 80a18f4a8567 ("clk: qcom: Add display clock controller driver for SM8150 and SM8250")
Signed-off-by: Taniya Das <tdas@codeaurora.org>
Link: https://lore.kernel.org/r/20220223185606.3941-2-tdas@codeaurora.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
[sboyd@kernel.org: lowercase hex]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sc7180.c | 5 ++++-
 drivers/clk/qcom/dispcc-sc7280.c | 5 ++++-
 drivers/clk/qcom/dispcc-sm8250.c | 5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sc7180.c b/drivers/clk/qcom/dispcc-sc7180.c
index 538e4963c915..5d2ae297e741 100644
--- a/drivers/clk/qcom/dispcc-sc7180.c
+++ b/drivers/clk/qcom/dispcc-sc7180.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2019, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2019, 2022, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/clk-provider.h>
@@ -625,6 +625,9 @@ static struct clk_branch disp_cc_mdss_vsync_clk = {
 
 static struct gdsc mdss_gdsc = {
 	.gdscr = 0x3000,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "mdss_gdsc",
 	},
diff --git a/drivers/clk/qcom/dispcc-sc7280.c b/drivers/clk/qcom/dispcc-sc7280.c
index 4ef4ae231794..ad596d567f6a 100644
--- a/drivers/clk/qcom/dispcc-sc7280.c
+++ b/drivers/clk/qcom/dispcc-sc7280.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2021-2022, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/clk-provider.h>
@@ -787,6 +787,9 @@ static struct clk_branch disp_cc_sleep_clk = {
 
 static struct gdsc disp_cc_mdss_core_gdsc = {
 	.gdscr = 0x1004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "disp_cc_mdss_core_gdsc",
 	},
diff --git a/drivers/clk/qcom/dispcc-sm8250.c b/drivers/clk/qcom/dispcc-sm8250.c
index 566fdfa0a15b..db9379634fb2 100644
--- a/drivers/clk/qcom/dispcc-sm8250.c
+++ b/drivers/clk/qcom/dispcc-sm8250.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2020, 2022, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/clk-provider.h>
@@ -1126,6 +1126,9 @@ static struct clk_branch disp_cc_mdss_vsync_clk = {
 
 static struct gdsc mdss_gdsc = {
 	.gdscr = 0x3000,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "mdss_gdsc",
 	},
-- 
2.34.1



