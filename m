Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D5A13ECAB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405885AbgAPR55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:57:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393908AbgAPRnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:43:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 295D02472F;
        Thu, 16 Jan 2020 17:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196596;
        bh=4vp6+qYTLEpYWbaUySrr+/hC5VNQsimUjNPYH+qNsso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buFQ3PRz64/uD8wxK26rMNAUVicZm0aNDzK7tXrgJMaqA7yS7hKRuy/jyxy1PmwGj
         HgDMudpDoHNBC58gvE1xs/RN0pkjdKHNBzVAsKjqdbRbTiq1TstatlzsjCexJoAg4q
         HNNii6nGMXkvDIhEvbom8uXEFySqctkCOsVeuzmQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 019/174] clk: highbank: fix refcount leak in hb_clk_init()
Date:   Thu, 16 Jan 2020 12:40:16 -0500
Message-Id: <20200116174251.24326-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 5eb8ba90958de1285120dae5d3a5d2b1a360b3b4 ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: 26cae166cff9 ("ARM: highbank: remove custom .init_time hook")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-highbank.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index be3a21abb185..4105066b428c 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -294,6 +294,7 @@ static __init struct clk *hb_clk_init(struct device_node *node, const struct clk
 	/* Map system registers */
 	srnp = of_find_compatible_node(NULL, NULL, "calxeda,hb-sregs");
 	hb_clk->reg = of_iomap(srnp, 0);
+	of_node_put(srnp);
 	BUG_ON(!hb_clk->reg);
 	hb_clk->reg += reg;
 
-- 
2.20.1

