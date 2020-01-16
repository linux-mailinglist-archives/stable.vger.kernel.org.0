Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C998613E662
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390359AbgAPRUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390921AbgAPRSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:18:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865C82192A;
        Thu, 16 Jan 2020 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195091;
        bh=fiO/uMdzb33nTu5mjqEczI/VkXE1y0qKJ6+2eg/yFfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWiskkdKbmfgsr+eH3UGd7/5DRrEdUeAs8XbF5OO6jFjhmrxwwDaKDH1iKhNoDpB3
         JyNyc1HIAHUjs8HDwM+yURiJXJfiN//LvrygTch9khf0vAE66QqThHUIYlyNZYymZb
         JHeZvYSBHyn6IxxHyoMZec1FHR4DBs2f5aCeqnUw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 038/371] clk: socfpga: fix refcount leak
Date:   Thu, 16 Jan 2020 12:11:46 -0500
Message-Id: <20200116171719.16965-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 7f9705beeb3759e69165e7aff588f6488ff6c1ac ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: 5343325ff3dd ("clk: socfpga: add a clock driver for the Arria 10 platform")
Fixes: a30d27ed739b ("clk: socfpga: fix clock driver for 3.15")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-pll-a10.c | 1 +
 drivers/clk/socfpga/clk-pll.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/clk/socfpga/clk-pll-a10.c b/drivers/clk/socfpga/clk-pll-a10.c
index 35fabe1a32c3..269467e8e07e 100644
--- a/drivers/clk/socfpga/clk-pll-a10.c
+++ b/drivers/clk/socfpga/clk-pll-a10.c
@@ -95,6 +95,7 @@ static struct clk * __init __socfpga_pll_init(struct device_node *node,
 
 	clkmgr_np = of_find_compatible_node(NULL, NULL, "altr,clk-mgr");
 	clk_mgr_a10_base_addr = of_iomap(clkmgr_np, 0);
+	of_node_put(clkmgr_np);
 	BUG_ON(!clk_mgr_a10_base_addr);
 	pll_clk->hw.reg = clk_mgr_a10_base_addr + reg;
 
diff --git a/drivers/clk/socfpga/clk-pll.c b/drivers/clk/socfpga/clk-pll.c
index c7f463172e4b..b4b44e9b5901 100644
--- a/drivers/clk/socfpga/clk-pll.c
+++ b/drivers/clk/socfpga/clk-pll.c
@@ -100,6 +100,7 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 
 	clkmgr_np = of_find_compatible_node(NULL, NULL, "altr,clk-mgr");
 	clk_mgr_base_addr = of_iomap(clkmgr_np, 0);
+	of_node_put(clkmgr_np);
 	BUG_ON(!clk_mgr_base_addr);
 	pll_clk->hw.reg = clk_mgr_base_addr + reg;
 
-- 
2.20.1

