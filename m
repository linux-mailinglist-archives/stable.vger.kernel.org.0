Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953F915C81D
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgBMQUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:20:11 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:55868 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727675AbgBMQUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 11:20:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1581610805; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g/SD8x/sT6sRYFTDMcohhadfbdGohJWYMNwnI87CBaA=;
        b=FEVZc9jp99cvjMkDmWCd6R69TaBlRm5xzSiXDMEkp1TXh5G2jVFNy8oIN5up2Aoa6fJfXb
        QrKuk638Vs/l0bJy9ljUKOiLLmurymKxwgL/9HHZd3Cd4BrQlPREluKmkZ9fHO6y+7eYoC
        loWqVBCUNjD1lx9xIyz+A+rKILgkzJI=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc:     od@zcrc.me, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] clk: ingenic/TCU: Fix round_rate returning error
Date:   Thu, 13 Feb 2020 13:19:52 -0300
Message-Id: <20200213161952.37460-2-paul@crapouillou.net>
In-Reply-To: <20200213161952.37460-1-paul@crapouillou.net>
References: <20200213161952.37460-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When requesting a rate superior to the parent's rate, it would return
-EINVAL instead of simply returning the parent's rate like it should.

Fixes: 4f89e4b8f121 ("clk: ingenic: Add driver for the TCU clocks")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---

Notes:
    v2: New patch

 drivers/clk/ingenic/tcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/ingenic/tcu.c b/drivers/clk/ingenic/tcu.c
index ad7daa494fd4..cd537c3db782 100644
--- a/drivers/clk/ingenic/tcu.c
+++ b/drivers/clk/ingenic/tcu.c
@@ -189,7 +189,7 @@ static long ingenic_tcu_round_rate(struct clk_hw *hw, unsigned long req_rate,
 	u8 prescale;
 
 	if (req_rate > rate)
-		return -EINVAL;
+		return rate;
 
 	prescale = ingenic_tcu_get_prescale(rate, req_rate);
 
-- 
2.25.0

