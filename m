Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676E3BCD6D
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410010AbfIXQpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410005AbfIXQpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:45:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 021D720872;
        Tue, 24 Sep 2019 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343537;
        bh=RWaQefVK8ASVG6pbqzbUIqMWiTGMpl6fvlxtzPjJeq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DAFcJ4Ueo4qqfiWr4z0gN5q40kSnzw4hJ/V+Kt0VJYGyYJI/YKeZjOjGxfACLwiS
         TIW31K2muFSEzl8QSXUn+RrdxsFFxU9yR7oSow/GTRREXfuLY+mWXJdBpWn+ksCFj6
         +wqwJwdtG7QWl9mRm6m5ZKISYz1sxitrWH+7Vf5Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 82/87] clk: sprd: add missing kfree
Date:   Tue, 24 Sep 2019 12:41:38 -0400
Message-Id: <20190924164144.25591-82-sashal@kernel.org>
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

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 5e75ea9c67433a065b0e8595ad3c91c7c0ca0d2d ]

The number of config registers for different pll clocks probably are not
same, so we have to use malloc, and should free the memory before return.

Fixes: 3e37b005580b ("clk: sprd: add adjustable pll support")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
Link: https://lkml.kernel.org/r/20190905103009.27166-1-zhang.lyra@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/pll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/sprd/pll.c b/drivers/clk/sprd/pll.c
index 36b4402bf09e3..640270f51aa56 100644
--- a/drivers/clk/sprd/pll.c
+++ b/drivers/clk/sprd/pll.c
@@ -136,6 +136,7 @@ static unsigned long _sprd_pll_recalc_rate(const struct sprd_pll *pll,
 					 k2 + refin * nint * CLK_PLL_1M;
 	}
 
+	kfree(cfg);
 	return rate;
 }
 
@@ -222,6 +223,7 @@ static int _sprd_pll_set_rate(const struct sprd_pll *pll,
 	if (!ret)
 		udelay(pll->udelay);
 
+	kfree(cfg);
 	return ret;
 }
 
-- 
2.20.1

