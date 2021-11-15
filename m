Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA63A450E56
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239375AbhKOSOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238465AbhKOSHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3460B63313;
        Mon, 15 Nov 2021 17:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998294;
        bh=v/oeFtZlzZFVzk5N2nMBoHypZ7Txme4BAlmNd7i7Hn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgVQdKPN2IkQbANUIBaP8CGtsL4eA6BYvEyWzLD7d6J0XaeBq5hXNKKly347OS5Hf
         62SvV2HrAszE8UxSyvX4QGzvkja0GFuzJi21Rm5Kvbn43nBcBflnqzA9PezCWuygor
         fbLyAnEWryq4MJmtOoJ4nAQs678Js7SQ2IafNp30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 457/575] clk: at91: sam9x60-pll: use DIV_ROUND_CLOSEST_ULL
Date:   Mon, 15 Nov 2021 18:03:02 +0100
Message-Id: <20211115165359.548488388@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit f12d028b743bb6136da60b17228a1b6162886444 ]

Use DIV_ROUND_CLOSEST_ULL() to avoid any inconsistency b/w the rate
computed in sam9x60_frac_pll_recalc_rate() and the one computed in
sam9x60_frac_pll_compute_mul_frac().

Fixes: 43b1bb4a9b3e1 ("clk: at91: clk-sam9x60-pll: re-factor to support plls with multiple outputs")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20211011112719.3951784-8-claudiu.beznea@microchip.com
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-sam9x60-pll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/at91/clk-sam9x60-pll.c b/drivers/clk/at91/clk-sam9x60-pll.c
index 78f458a7b2ef4..5a9daa3643a72 100644
--- a/drivers/clk/at91/clk-sam9x60-pll.c
+++ b/drivers/clk/at91/clk-sam9x60-pll.c
@@ -71,8 +71,8 @@ static unsigned long sam9x60_frac_pll_recalc_rate(struct clk_hw *hw,
 	struct sam9x60_pll_core *core = to_sam9x60_pll_core(hw);
 	struct sam9x60_frac *frac = to_sam9x60_frac(core);
 
-	return (parent_rate * (frac->mul + 1) +
-		((u64)parent_rate * frac->frac >> 22));
+	return parent_rate * (frac->mul + 1) +
+		DIV_ROUND_CLOSEST_ULL((u64)parent_rate * frac->frac, (1 << 22));
 }
 
 static int sam9x60_frac_pll_prepare(struct clk_hw *hw)
-- 
2.33.0



