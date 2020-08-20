Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F38724B299
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgHTJd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbgHTJbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:31:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5DDD21775;
        Thu, 20 Aug 2020 09:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915876;
        bh=eevjQnw9rouQmoVAWrlOyJAU3VncyMN6KmHNuM6x0uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1k6/eG/g3LaOi6gF2rj9BHegFRSTz+8RIGDQtkabR84vt48NCjzcXYrZC/kPslAg0
         gkB0SkfNrrbKE2FM5z4buyphRXc12Sflcc8fmY0kOLgiJw1+NQradPXNkn44BbcCI1
         SMQxVYgqt/zreX/k7+viY7c4d47f0W+WDKem1iiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>,
        Barry Song <baohua@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 166/232] clk: clk-atlas6: fix return value check in atlas6_clk_init()
Date:   Thu, 20 Aug 2020 11:20:17 +0200
Message-Id: <20200820091620.854473044@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
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
index c84d5bab7ac28..b95483bb6a5ec 100644
--- a/drivers/clk/sirf/clk-atlas6.c
+++ b/drivers/clk/sirf/clk-atlas6.c
@@ -135,7 +135,7 @@ static void __init atlas6_clk_init(struct device_node *np)
 
 	for (i = pll1; i < maxclk; i++) {
 		atlas6_clks[i] = clk_register(NULL, atlas6_clk_hw_array[i]);
-		BUG_ON(!atlas6_clks[i]);
+		BUG_ON(IS_ERR(atlas6_clks[i]));
 	}
 	clk_register_clkdev(atlas6_clks[cpu], NULL, "cpu");
 	clk_register_clkdev(atlas6_clks[io],  NULL, "io");
-- 
2.25.1



