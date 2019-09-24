Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D2BBCFE2
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632866AbfIXQnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632858AbfIXQnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:43:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8C22217F4;
        Tue, 24 Sep 2019 16:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343379;
        bh=UAfTYj9dSSWlNwqhJHR1m9xmDES6sax0XfOL7/szap8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rz8+Cy1l3KFTmxEVra0N74tNBOIF52eryfCGmlyuczNKcCrad866ILHWJJ3HR+8ca
         Rd5RJsm0ikNs2XLQmZzl7Lzn9cRXX7kmixtoErKDMYPLgcF/S/dutEOjGVgMyCb4oL
         4vCf9/x5BBB2U5enwugwrSAAx4upu9OtFRWVKVv8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 28/87] clk: ingenic/jz4740: Fix "pll half" divider not read/written properly
Date:   Tue, 24 Sep 2019 12:40:44 -0400
Message-Id: <20190924164144.25591-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 568b9de48d80bcf1a92e2c4fa67651abbb8ebfe2 ]

The code was setting the bit 21 of the CPCCR register to use a divider
of 2 for the "pll half" clock, and clearing the bit to use a divider
of 1.

This is the opposite of how this register field works: a cleared bit
means that the /2 divider is used, and a set bit means that the divider
is 1.

Restore the correct behaviour using the newly introduced .div_table
field.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lkml.kernel.org/r/20190701113606.4130-1-paul@crapouillou.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ingenic/jz4740-cgu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/ingenic/jz4740-cgu.c b/drivers/clk/ingenic/jz4740-cgu.c
index 4c0a20949c2c2..9b27d75d9485c 100644
--- a/drivers/clk/ingenic/jz4740-cgu.c
+++ b/drivers/clk/ingenic/jz4740-cgu.c
@@ -53,6 +53,10 @@ static const u8 jz4740_cgu_cpccr_div_table[] = {
 	1, 2, 3, 4, 6, 8, 12, 16, 24, 32,
 };
 
+static const u8 jz4740_cgu_pll_half_div_table[] = {
+	2, 1,
+};
+
 static const struct ingenic_cgu_clk_info jz4740_cgu_clocks[] = {
 
 	/* External clocks */
@@ -86,7 +90,10 @@ static const struct ingenic_cgu_clk_info jz4740_cgu_clocks[] = {
 	[JZ4740_CLK_PLL_HALF] = {
 		"pll half", CGU_CLK_DIV,
 		.parents = { JZ4740_CLK_PLL, -1, -1, -1 },
-		.div = { CGU_REG_CPCCR, 21, 1, 1, -1, -1, -1 },
+		.div = {
+			CGU_REG_CPCCR, 21, 1, 1, -1, -1, -1,
+			jz4740_cgu_pll_half_div_table,
+		},
 	},
 
 	[JZ4740_CLK_CCLK] = {
-- 
2.20.1

