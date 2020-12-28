Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98052E66C4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbgL1QQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:16:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731578AbgL1NRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:17:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8E03206ED;
        Mon, 28 Dec 2020 13:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161414;
        bh=w1uyj+8QB9GT5kwpX/XN0NBBS6PW0xTqQK9FkK3cUos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCV+nwiZOMmJxkKKA6tBcx8t5rHiGrbwrgQkOYMzEIlK+Oim5Trzp/BKc2823Cng+
         wfqLeb6KNwi/4qP9/5uyZq4KNbt4rJkTjT2B3s6Ukz26/PETf+GM0xOnl6IASgDoMJ
         USV94qVxUd9vZkrkalnNe8c5qrQ6HSRR4xp/vHlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <mripard@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 176/242] clk: sunxi-ng: Make sure divider tables have sentinel
Date:   Mon, 28 Dec 2020 13:49:41 +0100
Message-Id: <20201228124913.363353964@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 48f68de00c1405351fa0e7bc44bca067c49cd0a3 ]

Two clock divider tables are missing sentinel at the end. Effect of that
is that clock framework reads past the last entry. Fix that with adding
sentinel at the end.

Issue was discovered with KASan.

Fixes: 0577e4853bfb ("clk: sunxi-ng: Add H3 clocks")
Fixes: c6a0637460c2 ("clk: sunxi-ng: Add A64 clocks")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20201202203817.438713-1-jernej.skrabec@siol.net
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c | 1 +
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-a64.c b/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
index 183985c8c9bab..7e3cd0bd597dc 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
@@ -381,6 +381,7 @@ static struct clk_div_table ths_div_table[] = {
 	{ .val = 1, .div = 2 },
 	{ .val = 2, .div = 4 },
 	{ .val = 3, .div = 6 },
+	{ /* Sentinel */ },
 };
 static const char * const ths_parents[] = { "osc24M" };
 static struct ccu_div ths_clk = {
diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-h3.c b/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
index b09acda71abe9..aa44602896fac 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
@@ -315,6 +315,7 @@ static struct clk_div_table ths_div_table[] = {
 	{ .val = 1, .div = 2 },
 	{ .val = 2, .div = 4 },
 	{ .val = 3, .div = 6 },
+	{ /* Sentinel */ },
 };
 static SUNXI_CCU_DIV_TABLE_WITH_GATE(ths_clk, "ths", "osc24M",
 				     0x074, 0, 2, ths_div_table, BIT(31), 0);
-- 
2.27.0



