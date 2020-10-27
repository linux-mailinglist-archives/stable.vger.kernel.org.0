Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CE529BD73
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810994AbgJ0Qgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801878AbgJ0Po6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB6024171;
        Tue, 27 Oct 2020 15:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813461;
        bh=8nIsznwbJXEp2nf4FzRAold2wYLO+eucYv5yyKMhKlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSDoP0o+iynYDwggQrr2wcnRPHhVzwH5wkAe+i7Vw/CC0xI/cjjZWVDKaWmWb8U1I
         80vMMUluHDU8uRqopE262UohKb6EsshLjfxJ+THrrZR1AUFu2c7ZOWt4Lh1JSsx1P0
         LwuVerwJ8PrONJ8Dd7MJBKK86zd6DwxPqWN2RRyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 542/757] clk: at91: clk-main: update key before writing AT91_CKGR_MOR
Date:   Tue, 27 Oct 2020 14:53:12 +0100
Message-Id: <20201027135515.917562784@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 85d071e7f19a6a9abf30476b90b3819642568756 ]

SAMA5D2 datasheet specifies on chapter 33.22.8 (PMC Clock Generator
Main Oscillator Register) that writing any value other than
0x37 on KEY field aborts the write operation. Use the key when
selecting main clock parent.

Fixes: 27cb1c2083373 ("clk: at91: rework main clk implementation")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/1598338751-20607-3-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
index 5c83e899084ff..cfae2f59df665 100644
--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -437,12 +437,17 @@ static int clk_sam9x5_main_set_parent(struct clk_hw *hw, u8 index)
 		return -EINVAL;
 
 	regmap_read(regmap, AT91_CKGR_MOR, &tmp);
-	tmp &= ~MOR_KEY_MASK;
 
 	if (index && !(tmp & AT91_PMC_MOSCSEL))
-		regmap_write(regmap, AT91_CKGR_MOR, tmp | AT91_PMC_MOSCSEL);
+		tmp = AT91_PMC_MOSCSEL;
 	else if (!index && (tmp & AT91_PMC_MOSCSEL))
-		regmap_write(regmap, AT91_CKGR_MOR, tmp & ~AT91_PMC_MOSCSEL);
+		tmp = 0;
+	else
+		return 0;
+
+	regmap_update_bits(regmap, AT91_CKGR_MOR,
+			   AT91_PMC_MOSCSEL | MOR_KEY_MASK,
+			   tmp | AT91_PMC_KEY);
 
 	while (!clk_sam9x5_main_ready(regmap))
 		cpu_relax();
-- 
2.25.1



