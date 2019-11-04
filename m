Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677A5EEF6A
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387506AbfKDV6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388703AbfKDV6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:00 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE6E7214D9;
        Mon,  4 Nov 2019 21:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904679;
        bh=E1aoj9R79rabJbJBVwCZX4iH1w2YJ9tDbCCLe60+T58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZiWStwP88jLaDE5sbHQKP3Wd000Xn/N0/T6Hs8ZTgg5f6uBk2Co5BHU1AYQjE3Aa
         9FwO7J9vHgFDKfSeiip4NuphYM13TbI/dztG/mtiIThw23amu/u8Sn8vJxhyphQQeb
         pi0ktZVP+5P1yC5RhvkDwvptH27us45cEwF/FvfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Wang <wang.yi59@zte.com.cn>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/149] clk: boston: unregister clks on failure in clk_boston_setup()
Date:   Mon,  4 Nov 2019 22:43:43 +0100
Message-Id: <20191104212137.879569413@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Wang <wang.yi59@zte.com.cn>

[ Upstream commit 8b627f616ed63dcaf922369fc14a5daf8ad03038 ]

The registered clks should unregister when something wrong happens
before going out in function clk_boston_setup().

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imgtec/clk-boston.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/imgtec/clk-boston.c b/drivers/clk/imgtec/clk-boston.c
index f5d54a64d33c5..dddda45127a80 100644
--- a/drivers/clk/imgtec/clk-boston.c
+++ b/drivers/clk/imgtec/clk-boston.c
@@ -73,31 +73,39 @@ static void __init clk_boston_setup(struct device_node *np)
 	hw = clk_hw_register_fixed_rate(NULL, "input", NULL, 0, in_freq);
 	if (IS_ERR(hw)) {
 		pr_err("failed to register input clock: %ld\n", PTR_ERR(hw));
-		goto error;
+		goto fail_input;
 	}
 	onecell->hws[BOSTON_CLK_INPUT] = hw;
 
 	hw = clk_hw_register_fixed_rate(NULL, "sys", "input", 0, sys_freq);
 	if (IS_ERR(hw)) {
 		pr_err("failed to register sys clock: %ld\n", PTR_ERR(hw));
-		goto error;
+		goto fail_sys;
 	}
 	onecell->hws[BOSTON_CLK_SYS] = hw;
 
 	hw = clk_hw_register_fixed_rate(NULL, "cpu", "input", 0, cpu_freq);
 	if (IS_ERR(hw)) {
 		pr_err("failed to register cpu clock: %ld\n", PTR_ERR(hw));
-		goto error;
+		goto fail_cpu;
 	}
 	onecell->hws[BOSTON_CLK_CPU] = hw;
 
 	err = of_clk_add_hw_provider(np, of_clk_hw_onecell_get, onecell);
-	if (err)
+	if (err) {
 		pr_err("failed to add DT provider: %d\n", err);
+		goto fail_clk_add;
+	}
 
 	return;
 
-error:
+fail_clk_add:
+	clk_hw_unregister_fixed_rate(onecell->hws[BOSTON_CLK_CPU]);
+fail_cpu:
+	clk_hw_unregister_fixed_rate(onecell->hws[BOSTON_CLK_SYS]);
+fail_sys:
+	clk_hw_unregister_fixed_rate(onecell->hws[BOSTON_CLK_INPUT]);
+fail_input:
 	kfree(onecell);
 }
 
-- 
2.20.1



