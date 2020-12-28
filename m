Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7462E3E01
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502668AbgL1OWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502696AbgL1OWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D35CC2245C;
        Mon, 28 Dec 2020 14:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165341;
        bh=hPjhXAoIm/w9iNN0/IKZTd6AgKR4XWkQMRic0MeKI+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1MlboQgl3fTrl6Gb7x2Ity6rx/Il5lY/hfJDG6ijtzZRk3/6B3NawaQyxHuXMY0W
         VM/6acbkrHXfsbyAJ2cziwt9+31w/5LNV1ndZ2aPShj3WPf4S/I+ZczOBmBAAhvIfD
         tmwfh2MYCKg778LsTjT4iBgyQLH1r890OuMTLoAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 496/717] clk: at91: sam9x60: remove atmel,osc-bypass support
Date:   Mon, 28 Dec 2020 13:48:14 +0100
Message-Id: <20201228125044.728604509@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 01324f9e88b5cfc1f4c26eef66bdcb52596c9af8 ]

The sam9x60 doesn't have the MOSCXTBY bit to enable the crystal oscillator
bypass.

Fixes: 01e2113de9a5 ("clk: at91: add sam9x60 pmc driver")
Reported-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201202125816.168618-1-alexandre.belloni@bootlin.com
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sam9x60.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/clk/at91/sam9x60.c b/drivers/clk/at91/sam9x60.c
index 3c4c956035954..c8cbec5308f02 100644
--- a/drivers/clk/at91/sam9x60.c
+++ b/drivers/clk/at91/sam9x60.c
@@ -174,7 +174,6 @@ static void __init sam9x60_pmc_setup(struct device_node *np)
 	struct regmap *regmap;
 	struct clk_hw *hw;
 	int i;
-	bool bypass;
 
 	i = of_property_match_string(np, "clock-names", "td_slck");
 	if (i < 0)
@@ -209,10 +208,7 @@ static void __init sam9x60_pmc_setup(struct device_node *np)
 	if (IS_ERR(hw))
 		goto err_free;
 
-	bypass = of_property_read_bool(np, "atmel,osc-bypass");
-
-	hw = at91_clk_register_main_osc(regmap, "main_osc", mainxtal_name,
-					bypass);
+	hw = at91_clk_register_main_osc(regmap, "main_osc", mainxtal_name, 0);
 	if (IS_ERR(hw))
 		goto err_free;
 	main_osc_hw = hw;
-- 
2.27.0



