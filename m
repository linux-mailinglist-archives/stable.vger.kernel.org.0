Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5A338F06B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbhEXQDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235520AbhEXQCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:02:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5E59619A9;
        Mon, 24 May 2021 15:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871235;
        bh=faehA8I3uMVllVZfmpnz2a0NHiuIJTyRyUPwSUh/uDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHU5pGfoPZjcNpdjFmujnsTvGklZw7Gm9GIiKH8nXtLTXo+IE9bfEM5UzogaMc/PS
         WAk1CwYNzIQFKmLN1kztULLz4ve07jlHWr23NAlxp4d5JmBCJ/LEp5DephjoDRefjJ
         F8SyHi2ZoeJYixiKHQV8AZcPf7Wuhzyk4OAWndhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 097/127] Revert "net: stmicro: fix a missing check of clk_prepare"
Date:   Mon, 24 May 2021 17:26:54 +0200
Message-Id: <20210524152338.132312340@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit bee1b0511844c8c79fccf1f2b13472393b6b91f7 upstream.

This reverts commit f86a3b83833e7cfe558ca4d70b64ebc48903efec.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit causes a memory leak when it is trying to claim it
is properly handling errors.  Revert this change and fix it up properly
in a follow-on commit.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Fixes: f86a3b83833e ("net: stmicro: fix a missing check of clk_prepare")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-21-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
index 527077c98ebc..fc68e90acbea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
@@ -50,9 +50,7 @@ static int sun7i_gmac_init(struct platform_device *pdev, void *priv)
 		gmac->clk_enabled = 1;
 	} else {
 		clk_set_rate(gmac->tx_clk, SUN7I_GMAC_MII_RATE);
-		ret = clk_prepare(gmac->tx_clk);
-		if (ret)
-			return ret;
+		clk_prepare(gmac->tx_clk);
 	}
 
 	return 0;
-- 
2.31.1



