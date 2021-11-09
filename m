Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CAF44B746
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343925AbhKIWdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344814AbhKIWat (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C22C361A84;
        Tue,  9 Nov 2021 22:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496457;
        bh=s42mWIpAsOZrqBiWAEm25NkcCa/cXzGgUEKUh0F8EgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4dh0FHYTbMlhkJd63vDdRPy91FU7JKXz0+PaPrfZhgAp84p2x4VYfkJ3mxVTVndE
         dCvYorZLcOETm4MuoJxnQzGaMoww/02YchPEDmkSEJCuLUfB/3lJESWKGmCTytSndm
         qa71s0dbTO+XInKDb2Jq4QaJjAaeqSGF6TGi9NfBLLjHGt8K4/UJ0RcafgBXBgrTiO
         DC3CCxdWWtp3Vzo5aGL897QQZPqjFGTkycM/zpFNR2a6dx7/BHjKN1a43F6WvU52iG
         VfhtNEY3FeBliZriXipqREaOjW7gjyBEIFgCGDaCKoCgr7uP+bH30HOpCqDa1O6qbd
         6l3BgWakpW1Jg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        boris.brezillon@free-electrons.com, mturquette@baylibre.com,
        sboyd@codeaurora.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 72/75] clk: at91: sama7g5: remove prescaler part of master clock
Date:   Tue,  9 Nov 2021 17:19:02 -0500
Message-Id: <20211109221905.1234094-72-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit facb87ad75603813bc3b1314f5a87377f020fcb8 ]

On SAMA7G5 the prescaler part of master clock has been implemented as a
changeable one. Everytime the prescaler is changed the PMC_SR.MCKRDY bit
must be polled. Value 1 for PMC_SR.MCKRDY means the prescaler update is
done. Driver polls for this bit until it becomes 1. On SAMA7G5 it has
been discovered that in some conditions the PMC_SR.MCKRDY is not rising
but the rate it provides it's stable. The workaround is to add a timeout
when polling for PMC_SR.MCKRDY. At the moment, for SAMA7G5, the prescaler
will be removed from Linux clock tree as all the frequencies for CPU could
be obtained from PLL and also there will be less overhead when changing
frequency via DVFS.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20211011112719.3951784-14-claudiu.beznea@microchip.com
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sama7g5.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/clk/at91/sama7g5.c b/drivers/clk/at91/sama7g5.c
index 9e1ec48c44747..9c05ecb760b79 100644
--- a/drivers/clk/at91/sama7g5.c
+++ b/drivers/clk/at91/sama7g5.c
@@ -982,16 +982,7 @@ static void __init sama7g5_pmc_setup(struct device_node *np)
 	}
 
 	parent_names[0] = "cpupll_divpmcck";
-	hw = at91_clk_register_master_pres(regmap, "cpuck", 1, parent_names,
-					   &mck0_layout, &mck0_characteristics,
-					   &pmc_mck0_lock,
-					   CLK_SET_RATE_PARENT, 0);
-	if (IS_ERR(hw))
-		goto err_free;
-
-	sama7g5_pmc->chws[PMC_CPU] = hw;
-
-	hw = at91_clk_register_master_div(regmap, "mck0", "cpuck",
+	hw = at91_clk_register_master_div(regmap, "mck0", "cpupll_divpmcck",
 					  &mck0_layout, &mck0_characteristics,
 					  &pmc_mck0_lock, 0);
 	if (IS_ERR(hw))
-- 
2.33.0

