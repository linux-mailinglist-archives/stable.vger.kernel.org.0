Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6892E6903
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgL1M5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:57:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbgL1M5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:57:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A552B229C6;
        Mon, 28 Dec 2020 12:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160244;
        bh=qCPZnGg71nA+DH7EWZ4M3f0d3yuNrU/7XVXfB7ri/M0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0yDvi9b908dT0Njykr8PmSL2POmZHvk00kJ7yHqKLM4dDcK9VI7Xj5iPJOUiOlSw
         4hIyfT+Osgk/wUU/y42fhZmlmg+V8K+wuVi0FuoAhH3MyK77RAiA4xqMI0vLqJbnAI
         L8d1VViBljKkSJvNMMWCXsmy7XEHzrUae7MpNWF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 090/132] clk: ti: Fix memleak in ti_fapll_synth_setup
Date:   Mon, 28 Dec 2020 13:49:34 +0100
Message-Id: <20201228124850.777225725@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
index 66a0d0ed8b550..02ff499e36536 100644
--- a/drivers/clk/ti/fapll.c
+++ b/drivers/clk/ti/fapll.c
@@ -497,6 +497,7 @@ static struct clk * __init ti_fapll_synth_setup(struct fapll_data *fd,
 {
 	struct clk_init_data *init;
 	struct fapll_synth *synth;
+	struct clk *clk = ERR_PTR(-ENOMEM);
 
 	init = kzalloc(sizeof(*init), GFP_KERNEL);
 	if (!init)
@@ -519,13 +520,19 @@ static struct clk * __init ti_fapll_synth_setup(struct fapll_data *fd,
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



