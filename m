Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16195DD344
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391075AbfJRWQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387592AbfJRWIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38DF0222D1;
        Fri, 18 Oct 2019 22:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436494;
        bh=E1aoj9R79rabJbJBVwCZX4iH1w2YJ9tDbCCLe60+T58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozPna+JcsbwIzMvK7y74cXWwV5Qt+eIZaPIxCUhELsu1t1p0XB8qAY74TY59CI/0U
         mCdel5272G0mCNq+m6ZNonBkEgRPv0LLKuJUSJFwPuuBjsUOFUzVeEAJQ5tM4yKI2G
         P/Hs0gHWALAO51Cx4S74h6GTQgj0Q2XFNsTTjyUE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yi Wang <wang.yi59@zte.com.cn>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-mips@linux-mips.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/56] clk: boston: unregister clks on failure in clk_boston_setup()
Date:   Fri, 18 Oct 2019 18:07:05 -0400
Message-Id: <20191018220753.10002-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

