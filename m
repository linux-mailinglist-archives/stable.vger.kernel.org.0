Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8524BCFF6
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411065AbfIXRCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 13:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633015AbfIXQnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:43:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C08621928;
        Tue, 24 Sep 2019 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343412;
        bh=ghPfPE3Dv9KM5BihfJgp2aHVM6ja4supiXXbg586G2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fn9qKZVgVqQsHe8ut5F/IUcQl9ApKfoIUg7DWF7iqIbLlsfO4Q6GXY3SIQGwhQRUg
         j4fZIqOCOAGRtNE6rKtfaTcLSJrvTNtkVv3wqcjBp6TOxzsrVJlR4PdBxe5Tzvv0pz
         xMqq8YfkZoN7+vREIiiXJnnNsH+MUQ5fSZAlwlgE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <sboyd@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 41/87] clk: sunxi: Don't call clk_hw_get_name() on a hw that isn't registered
Date:   Tue, 24 Sep 2019 12:40:57 -0400
Message-Id: <20190924164144.25591-41-sashal@kernel.org>
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

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit a7b85ad25a97cf897b4819a121655c483d86156f ]

The implementation of clk_hw_get_name() relies on the clk_core
associated with the clk_hw pointer existing. If of_clk_hw_register()
fails, there isn't a clk_core created yet, so calling clk_hw_get_name()
here fails. Extract the name first so we can print it later.

Fixes: 1d80c14248d6 ("clk: sunxi-ng: Add common infrastructure")
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu_common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu_common.c b/drivers/clk/sunxi-ng/ccu_common.c
index 7fe3ac980e5f9..2e20e650b6c01 100644
--- a/drivers/clk/sunxi-ng/ccu_common.c
+++ b/drivers/clk/sunxi-ng/ccu_common.c
@@ -97,14 +97,15 @@ int sunxi_ccu_probe(struct device_node *node, void __iomem *reg,
 
 	for (i = 0; i < desc->hw_clks->num ; i++) {
 		struct clk_hw *hw = desc->hw_clks->hws[i];
+		const char *name;
 
 		if (!hw)
 			continue;
 
+		name = hw->init->name;
 		ret = of_clk_hw_register(node, hw);
 		if (ret) {
-			pr_err("Couldn't register clock %d - %s\n",
-			       i, clk_hw_get_name(hw));
+			pr_err("Couldn't register clock %d - %s\n", i, name);
 			goto err_clk_unreg;
 		}
 	}
-- 
2.20.1

