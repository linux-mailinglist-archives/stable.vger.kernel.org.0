Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB68412197
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358454AbhITSGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357564AbhITSE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29096613C8;
        Mon, 20 Sep 2021 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158232;
        bh=153GbFQv+1XpPTX46Dm/XvVwqoIpE+VaTFAgiRIMeCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcfhdMMRMDASii+NfA7jUO/BV8PbNzY4IE4pMMyNLvtkJJV4ukH/IJPEJ9TcyVGjJ
         iA5DeBAW56Wtvcl08szjBbZQjpvof+Abi4Hm8fzUz0XC1wr1QXynk9xleu8/xZZfmq
         VfNegpXHoqahhRCk9URLnLvkmB0+oEPlxuEK2AqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/260] clk: at91: sam9x60: Dont use audio PLL
Date:   Mon, 20 Sep 2021 18:41:20 +0200
Message-Id: <20210920163933.236813392@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit 5bf7f4a249387a6062b9a14c8a77e7ba2fd6a53b ]

On sam9x60, there is not audio PLL and so I2S and classD have to use one
of the best matching parents for their generated clock.

Fixes: 01e2113de9a5 ("clk: at91: add sam9x60 pmc driver")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lkml.kernel.org/r/20200131115816.12483-1-codrin.ciubotariu@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sam9x60.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/at91/sam9x60.c b/drivers/clk/at91/sam9x60.c
index e3f4c8f20223..bee1120e7041 100644
--- a/drivers/clk/at91/sam9x60.c
+++ b/drivers/clk/at91/sam9x60.c
@@ -124,7 +124,6 @@ static const struct {
 	char *n;
 	u8 id;
 	struct clk_range r;
-	bool pll;
 } sam9x60_gck[] = {
 	{ .n = "flex0_gclk",  .id = 5, },
 	{ .n = "flex1_gclk",  .id = 6, },
@@ -144,11 +143,9 @@ static const struct {
 	{ .n = "sdmmc1_gclk", .id = 26, .r = { .min = 0, .max = 105000000 }, },
 	{ .n = "flex11_gclk", .id = 32, },
 	{ .n = "flex12_gclk", .id = 33, },
-	{ .n = "i2s_gclk",    .id = 34, .r = { .min = 0, .max = 105000000 },
-		.pll = true, },
+	{ .n = "i2s_gclk",    .id = 34, .r = { .min = 0, .max = 105000000 }, },
 	{ .n = "pit64b_gclk", .id = 37, },
-	{ .n = "classd_gclk", .id = 42, .r = { .min = 0, .max = 100000000 },
-		.pll = true, },
+	{ .n = "classd_gclk", .id = 42, .r = { .min = 0, .max = 100000000 }, },
 	{ .n = "tcb1_gclk",   .id = 45, },
 	{ .n = "dbgu_gclk",   .id = 47, },
 };
@@ -285,7 +282,7 @@ static void __init sam9x60_pmc_setup(struct device_node *np)
 						 sam9x60_gck[i].n,
 						 parent_names, 6,
 						 sam9x60_gck[i].id,
-						 sam9x60_gck[i].pll,
+						 false,
 						 &sam9x60_gck[i].r);
 		if (IS_ERR(hw))
 			goto err_free;
-- 
2.30.2



