Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8D024BB14
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbgHTJyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730146AbgHTJyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:54:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21E482067C;
        Thu, 20 Aug 2020 09:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917278;
        bh=tSM3fUxeu8LXI30koBvOLHwugcmoLw+gNZiAMdNIypw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nS/hhV+IP2knEWWe8jZpTKfD9BXCcJzpUe5vNEaesWPWf8ODCNEqG5Cn00mtnZ9xq
         nKMP78Z7d2X2kvxbrBVD2VWPG/P4/acmR481fZWVcufC5rsxZQtWSH0DZ9y3k7xmGu
         L4rflSnkHkEPiLnewUhnDVyxkzvynPobPiK2SipI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>,
        Barry Song <baohua@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 66/92] clk: clk-atlas6: fix return value check in atlas6_clk_init()
Date:   Thu, 20 Aug 2020 11:21:51 +0200
Message-Id: <20200820091541.051178604@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>

[ Upstream commit 12b90b40854a8461a02ef19f6f4474cc88d64b66 ]

In case of error, the function clk_register() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20200713032143.21362-1-vulab@iscas.ac.cn
Acked-by: Barry Song <baohua@kernel.org>
Fixes: 7bf21bc81f28 ("clk: sirf: re-arch to make the codes support both prima2 and atlas6")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sirf/clk-atlas6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sirf/clk-atlas6.c b/drivers/clk/sirf/clk-atlas6.c
index 0cd11e6893afa..25ed60776560e 100644
--- a/drivers/clk/sirf/clk-atlas6.c
+++ b/drivers/clk/sirf/clk-atlas6.c
@@ -136,7 +136,7 @@ static void __init atlas6_clk_init(struct device_node *np)
 
 	for (i = pll1; i < maxclk; i++) {
 		atlas6_clks[i] = clk_register(NULL, atlas6_clk_hw_array[i]);
-		BUG_ON(!atlas6_clks[i]);
+		BUG_ON(IS_ERR(atlas6_clks[i]));
 	}
 	clk_register_clkdev(atlas6_clks[cpu], NULL, "cpu");
 	clk_register_clkdev(atlas6_clks[io],  NULL, "io");
-- 
2.25.1



