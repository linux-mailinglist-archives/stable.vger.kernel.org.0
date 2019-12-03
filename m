Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05EEA111C96
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbfLCWpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:45:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbfLCWpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F25E92080F;
        Tue,  3 Dec 2019 22:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413138;
        bh=8s/D6N+MLCFZDqBWjmbNVUY9RQVu/I3sSk1MbvKERwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=See+KfZ48Y5xt+G0Xogc6imvKVM0+s82b77lWBuI7zb0lyoQdjW8ZrNvKmKfdb1rw
         afoiMbRBj/+oFNTY9nNJCmlQ8CzcCB2I9AY9XFC0ebaWDUSBJdx9f/OgTrsK1K1Sxg
         pd2VWknT5dsg0J4XIvkNh6tklwckKRogAKZEzqUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/321] clk: sunxi: Fix operator precedence in sunxi_divs_clk_setup
Date:   Tue,  3 Dec 2019 23:31:20 +0100
Message-Id: <20191203223427.862800725@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit afdc74ed2d57e86c10b1d6831339770a802bab9a ]

r375326 in Clang exposes an issue with operator precedence in
sunxi_div_clk_setup:

drivers/clk/sunxi/clk-sunxi.c:1083:30: warning: operator '?:' has lower
precedence than '|'; '|' will be evaluated first
[-Wbitwise-conditional-parentheses]
                                                 data->div[i].critical ?
                                                 ~~~~~~~~~~~~~~~~~~~~~ ^
drivers/clk/sunxi/clk-sunxi.c:1083:30: note: place parentheses around
the '|' expression to silence this warning
                                                 data->div[i].critical ?
                                                                       ^
                                                                      )
drivers/clk/sunxi/clk-sunxi.c:1083:30: note: place parentheses around
the '?:' expression to evaluate it first
                                                 data->div[i].critical ?
                                                                       ^
                                                 (
1 warning generated.

It appears that the intention was for ?: to be evaluated first so that
CLK_IS_CRITICAL could be added to clkflags if the critical boolean was
set; right now, | is being evaluated first. Add parentheses around the
?: block to have it be evaluated first.

Fixes: 9919d44ff297 ("clk: sunxi: Use CLK_IS_CRITICAL flag for critical clks")
Link: https://github.com/ClangBuiltLinux/linux/issues/745
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi/clk-sunxi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 012714d94b429..004b411b640b3 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -1086,8 +1086,8 @@ static struct clk ** __init sunxi_divs_clk_setup(struct device_node *node,
 						 rate_hw, rate_ops,
 						 gate_hw, &clk_gate_ops,
 						 clkflags |
-						 data->div[i].critical ?
-							CLK_IS_CRITICAL : 0);
+						 (data->div[i].critical ?
+							CLK_IS_CRITICAL : 0));
 
 		WARN_ON(IS_ERR(clk_data->clks[i]));
 	}
-- 
2.20.1



