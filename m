Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF94C328C94
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbhCASyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:54:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53755 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240629AbhCASsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:48:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECDBE64EEC;
        Mon,  1 Mar 2021 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619252;
        bh=kezp2w331YsW77p3RaREjUBoNjsHTktzMUK4qRAYL6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKpJpDyTFUPMZPilchtblPSQnsmu+izCIcJb1Fuhpj3CxWkyY+warxuW5uzK/GvE7
         o79YxUGKD1S2/vA9WzFV9UYESdSAsJjaI7f4Hv2TpyCdGpozgpq2O+RYM4/iUD5wLP
         Bhv8dDVAyVsniZYbBdgk0e011sd19492pG+qUvAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Tretter <m.tretter@pengutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/663] clk: divider: fix initialization with parent_hw
Date:   Mon,  1 Mar 2021 17:10:08 +0100
Message-Id: <20210301161159.662085310@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 8de12cb0c43d8..f32157cb40138 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -493,8 +493,13 @@ struct clk_hw *__clk_hw_register_divider(struct device *dev,
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



