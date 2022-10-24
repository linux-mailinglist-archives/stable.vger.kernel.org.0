Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBC360A5AC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiJXM2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiJXM1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:27:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16470237E2;
        Mon, 24 Oct 2022 05:01:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8415C612D2;
        Mon, 24 Oct 2022 12:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94550C433D6;
        Mon, 24 Oct 2022 12:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612877;
        bh=2JKLRDy2+cZZ2o+s2K3b+kNs0R+1VkWPx5B+2IXlEkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMTjAO+nKBxeUEfypVxXfBsY9FpipfFhHx+F/85afysRH9kmloGeywmvQEHWQOqKw
         PCW18vUUCwUDm31y27R4408DiSVCVRWJSzuLqKAGfRk6e5T9sb6bwoqh3lvvoElNny
         D5wxeeEe2dJZaMnst3Qmu5ty6YnDnTDdm2BsEyYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/229] clk: berlin: Add of_node_put() for of_get_parent()
Date:   Mon, 24 Oct 2022 13:30:41 +0200
Message-Id: <20221024113002.943563849@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 37c381b812dcbfde9c3f1f3d3e75fdfc1b40d5bc ]

In berlin2_clock_setup() and berlin2q_clock_setup(), we need to
call of_node_put() for the reference returned by of_get_parent()
which has increased the refcount. We should call *_put() in fail
path or when it is not used anymore.

Fixes: 26b3b6b959b2 ("clk: berlin: prepare simple-mfd conversion")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220708084900.311684-1-windhl@126.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/berlin/bg2.c  | 5 ++++-
 drivers/clk/berlin/bg2q.c | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/berlin/bg2.c b/drivers/clk/berlin/bg2.c
index 0b4b44a2579e..6efc3e02da47 100644
--- a/drivers/clk/berlin/bg2.c
+++ b/drivers/clk/berlin/bg2.c
@@ -499,12 +499,15 @@ static void __init berlin2_clock_setup(struct device_node *np)
 	int n, ret;
 
 	clk_data = kzalloc(struct_size(clk_data, hws, MAX_CLKS), GFP_KERNEL);
-	if (!clk_data)
+	if (!clk_data) {
+		of_node_put(parent_np);
 		return;
+	}
 	clk_data->num = MAX_CLKS;
 	hws = clk_data->hws;
 
 	gbase = of_iomap(parent_np, 0);
+	of_node_put(parent_np);
 	if (!gbase)
 		return;
 
diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
index 9b9db743df25..5bcd8406ac93 100644
--- a/drivers/clk/berlin/bg2q.c
+++ b/drivers/clk/berlin/bg2q.c
@@ -285,19 +285,23 @@ static void __init berlin2q_clock_setup(struct device_node *np)
 	int n, ret;
 
 	clk_data = kzalloc(struct_size(clk_data, hws, MAX_CLKS), GFP_KERNEL);
-	if (!clk_data)
+	if (!clk_data) {
+		of_node_put(parent_np);
 		return;
+	}
 	clk_data->num = MAX_CLKS;
 	hws = clk_data->hws;
 
 	gbase = of_iomap(parent_np, 0);
 	if (!gbase) {
+		of_node_put(parent_np);
 		pr_err("%pOF: Unable to map global base\n", np);
 		return;
 	}
 
 	/* BG2Q CPU PLL is not part of global registers */
 	cpupll_base = of_iomap(parent_np, 1);
+	of_node_put(parent_np);
 	if (!cpupll_base) {
 		pr_err("%pOF: Unable to map cpupll base\n", np);
 		iounmap(gbase);
-- 
2.35.1



