Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F141940608D
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhIJARv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229938AbhIJARa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D145F611AD;
        Fri, 10 Sep 2021 00:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232980;
        bh=9B0qvwXOkMfmmzRZ/C3JHuzLjLIcXh41PevnronS+fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRHVOTYnH4qUlrA4SCZ/3WKnVnjCJpLQvONa02OjYbeArTUhPjKJtk4AdJdinzebz
         JR5D+J9FVSG6nhmPAbrxx+PU3qEXJdf5LckJLyQdkWWYJ2mRqRmD7QVYsDECHVqlsY
         BM3XXDShigD+RwgbdvMbYU2cPSWKWgm+v01t2NZcpZGxjsjUNiOwwBVwlBuVV0aFNz
         Iz5qua9q1G9flxa3UGtTiXUNh7u06h3MvPkQnzSgW7TQAfYVaQL8708Lujx3n1rZsI
         UJqiZa1Z6Oru+1S0WCTnzio5vf5uQg9awvR5IEonfpnnyhAVCsWCksHQ0mp5hfG0Ko
         wGDrsHrtTwAvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 16/99] clk: renesas: rzg2l: Fix return value and unused assignment
Date:   Thu,  9 Sep 2021 20:14:35 -0400
Message-Id: <20210910001558.173296-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 97c29755598f98c6c91f68f12bdd3f517e457890 ]

Currently the function returns NULL on error, so exact error code is
lost.  This patch changes return convention of the function to use
ERR_PTR() on error instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Link: https://lore.kernel.org/r/1623896524-102058-1-git-send-email-yang.lee@linux.alibaba.com
[geert: Drop curly braces]
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-rzg2l-cpg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/renesas/renesas-rzg2l-cpg.c b/drivers/clk/renesas/renesas-rzg2l-cpg.c
index e7c59af2a1d8..5fe73225ece2 100644
--- a/drivers/clk/renesas/renesas-rzg2l-cpg.c
+++ b/drivers/clk/renesas/renesas-rzg2l-cpg.c
@@ -182,10 +182,8 @@ rzg2l_cpg_pll_clk_register(const struct cpg_core_clk *core,
 		return ERR_CAST(parent);
 
 	pll_clk = devm_kzalloc(dev, sizeof(*pll_clk), GFP_KERNEL);
-	if (!pll_clk) {
-		clk = ERR_PTR(-ENOMEM);
-		return NULL;
-	}
+	if (!pll_clk)
+		return ERR_PTR(-ENOMEM);
 
 	parent_name = __clk_get_name(parent);
 	init.name = core->name;
-- 
2.30.2

