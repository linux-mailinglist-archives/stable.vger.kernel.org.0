Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCF0499548
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392519AbiAXUvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390641AbiAXUp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C7EC0613BD;
        Mon, 24 Jan 2022 11:55:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C04EB80FA1;
        Mon, 24 Jan 2022 19:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11DFC340E5;
        Mon, 24 Jan 2022 19:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054149;
        bh=uDbfPJ73HUWqhPHuTRXhY7UbI0yEEfy4ihntlu9sniM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZv3l+6Q3hPPdY4o8Xr4Qt2aqiqio2hdWf/RhiYubfvr9J46JjG/asJEggVE1DfIi
         glBJ5lEeC6cleNGp8Bwp5Pz3IT6tLjstmr9Lr3kOuWslU/0wrJ/DAyx6oajaT0LJWx
         ze5zCeOrcDsZmspy3PP3PUgPZwGMPZZHZEea44VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/563] clk: bm1880: remove kfrees on static allocations
Date:   Mon, 24 Jan 2022 19:41:00 +0100
Message-Id: <20220124184034.638740619@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit c861c1be3897845313a0df47804b1db37c7052e1 ]

bm1880_clk_unregister_pll & bm1880_clk_unregister_div both try to
free statically allocated variables, so remove those kfrees.

For example, if we take L703 kfree(div_hw):
- div_hw is a bm1880_div_hw_clock pointer
- in bm1880_clk_register_plls this is pointed to an element of arg1:
  struct bm1880_div_hw_clock *clks
- in the probe, where bm1880_clk_register_plls is called arg1 is
  bm1880_div_clks, defined on L371:
  static struct bm1880_div_hw_clock bm1880_div_clks[]

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Fixes: 1ab4601da55b ("clk: Add common clock driver for BM1880 SoC")
Link: https://lore.kernel.org/r/20211223154244.1024062-1-conor.dooley@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-bm1880.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/clk/clk-bm1880.c b/drivers/clk/clk-bm1880.c
index e6d6599d310a1..fad78a22218e8 100644
--- a/drivers/clk/clk-bm1880.c
+++ b/drivers/clk/clk-bm1880.c
@@ -522,14 +522,6 @@ static struct clk_hw *bm1880_clk_register_pll(struct bm1880_pll_hw_clock *pll_cl
 	return hw;
 }
 
-static void bm1880_clk_unregister_pll(struct clk_hw *hw)
-{
-	struct bm1880_pll_hw_clock *pll_hw = to_bm1880_pll_clk(hw);
-
-	clk_hw_unregister(hw);
-	kfree(pll_hw);
-}
-
 static int bm1880_clk_register_plls(struct bm1880_pll_hw_clock *clks,
 				    int num_clks,
 				    struct bm1880_clock_data *data)
@@ -555,7 +547,7 @@ static int bm1880_clk_register_plls(struct bm1880_pll_hw_clock *clks,
 
 err_clk:
 	while (i--)
-		bm1880_clk_unregister_pll(data->hw_data.hws[clks[i].pll.id]);
+		clk_hw_unregister(data->hw_data.hws[clks[i].pll.id]);
 
 	return PTR_ERR(hw);
 }
@@ -695,14 +687,6 @@ static struct clk_hw *bm1880_clk_register_div(struct bm1880_div_hw_clock *div_cl
 	return hw;
 }
 
-static void bm1880_clk_unregister_div(struct clk_hw *hw)
-{
-	struct bm1880_div_hw_clock *div_hw = to_bm1880_div_clk(hw);
-
-	clk_hw_unregister(hw);
-	kfree(div_hw);
-}
-
 static int bm1880_clk_register_divs(struct bm1880_div_hw_clock *clks,
 				    int num_clks,
 				    struct bm1880_clock_data *data)
@@ -729,7 +713,7 @@ static int bm1880_clk_register_divs(struct bm1880_div_hw_clock *clks,
 
 err_clk:
 	while (i--)
-		bm1880_clk_unregister_div(data->hw_data.hws[clks[i].div.id]);
+		clk_hw_unregister(data->hw_data.hws[clks[i].div.id]);
 
 	return PTR_ERR(hw);
 }
-- 
2.34.1



