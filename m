Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D30024BB8E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgHTMbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbgHTJu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:50:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5515A2075E;
        Thu, 20 Aug 2020 09:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917055;
        bh=eevjQnw9rouQmoVAWrlOyJAU3VncyMN6KmHNuM6x0uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTqsm2WI0GFRPtp767DZsslZb6sFURuadpFo48QVHKC8qk5DRIZCoZubTs9ORLJMP
         axvv4WAU4FWkDmoaGHzZRvQ1QYTYEHR1hdWkr5Z33E/skDzhYtpHku80bOzm93ll2h
         mWeQGA+JbCQGB5nj+YhWJ4carRrn36ED2rmc2aLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>,
        Barry Song <baohua@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/152] clk: clk-atlas6: fix return value check in atlas6_clk_init()
Date:   Thu, 20 Aug 2020 11:21:18 +0200
Message-Id: <20200820091559.456000231@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
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



