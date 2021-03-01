Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E72D329038
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242754AbhCAUDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242502AbhCATxs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57F1F652F5;
        Mon,  1 Mar 2021 17:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621229;
        bh=0l32i3LfLbX2a/ZEUAGzt0HJxsUdgwIniReGIS6c5L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMVQvP804mm9fxZX7Th/3ApAqKRzl2XVlmi4ovGQckR9N8wIT3TrTfB037OVqqC43
         UfZc3OHp7s/7V0BNEr6ikObSOS6uiYMUzlaayZcIbDsNLH7Am2lYOOfzDp4ymVcuZR
         VTZ2zIDFhGoFAsKYO/kN6xOTr1jRyLMeLOF5/34s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Tretter <m.tretter@pengutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 441/775] clk: divider: fix initialization with parent_hw
Date:   Mon,  1 Mar 2021 17:10:09 +0100
Message-Id: <20210301161223.350132727@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit 0225daea08141b1dff681502d5af70b71e8b11ec ]

If a driver registers a divider clock with a parent_hw instead of the
parent_name, the parent_hw is ignored and the clock does not have a
parent.

Fix this by initializing the parents the same way they are initialized
for clock gates.

Fixes: ff258817137a ("clk: divider: Add support for specifying parents via DT/pointers")
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/20210121071659.1226489-3-m.tretter@pengutronix.de
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-divider.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index c499799693ccc..344997203f0e7 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -494,8 +494,13 @@ struct clk_hw *__clk_hw_register_divider(struct device *dev,
 	else
 		init.ops = &clk_divider_ops;
 	init.flags = flags;
-	init.parent_names = (parent_name ? &parent_name: NULL);
-	init.num_parents = (parent_name ? 1 : 0);
+	init.parent_names = parent_name ? &parent_name : NULL;
+	init.parent_hws = parent_hw ? &parent_hw : NULL;
+	init.parent_data = parent_data;
+	if (parent_name || parent_hw || parent_data)
+		init.num_parents = 1;
+	else
+		init.num_parents = 0;
 
 	/* struct clk_divider assignments */
 	div->reg = reg;
-- 
2.27.0



