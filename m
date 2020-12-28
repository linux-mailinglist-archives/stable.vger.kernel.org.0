Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7A52E3B95
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407006AbgL1Nv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407001AbgL1Nvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:51:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8BC221D94;
        Mon, 28 Dec 2020 13:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163474;
        bh=hJPvZ98uWfYMgHk6MR39rxcwhu74WZNtnAqFZCpUbFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwxh97tXLZv4zvQGw5/lBS76Bz7v7MWpEPCmYs8g6f9FQG7uSMqric5KY067fqUjm
         unMzs/unhEgSgAfQCVKQ6F5R5DFpPwoOHCGhVnSLq81YfqGGRM16cIi5ZFAS5d6V62
         pTl8mWuYEs33wagDOm6zx7nzj/qGVgVeYGio2Qsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 298/453] clk: ti: Fix memleak in ti_fapll_synth_setup
Date:   Mon, 28 Dec 2020 13:48:54 +0100
Message-Id: <20201228124951.544748021@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 8c6239f6e95f583bb763d0228e02d4dd0fb3d492 ]

If clk_register fails, we should goto free branch
before function returns to prevent memleak.

Fixes: 163152cbbe321 ("clk: ti: Add support for FAPLL on dm816x")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201113131623.2098222-1-zhangqilong3@huawei.com
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/fapll.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ti/fapll.c b/drivers/clk/ti/fapll.c
index 95e36ba64accf..8024c6d2b9e95 100644
--- a/drivers/clk/ti/fapll.c
+++ b/drivers/clk/ti/fapll.c
@@ -498,6 +498,7 @@ static struct clk * __init ti_fapll_synth_setup(struct fapll_data *fd,
 {
 	struct clk_init_data *init;
 	struct fapll_synth *synth;
+	struct clk *clk = ERR_PTR(-ENOMEM);
 
 	init = kzalloc(sizeof(*init), GFP_KERNEL);
 	if (!init)
@@ -520,13 +521,19 @@ static struct clk * __init ti_fapll_synth_setup(struct fapll_data *fd,
 	synth->hw.init = init;
 	synth->clk_pll = pll_clk;
 
-	return clk_register(NULL, &synth->hw);
+	clk = clk_register(NULL, &synth->hw);
+	if (IS_ERR(clk)) {
+		pr_err("failed to register clock\n");
+		goto free;
+	}
+
+	return clk;
 
 free:
 	kfree(synth);
 	kfree(init);
 
-	return ERR_PTR(-ENOMEM);
+	return clk;
 }
 
 static void __init ti_fapll_setup(struct device_node *node)
-- 
2.27.0



