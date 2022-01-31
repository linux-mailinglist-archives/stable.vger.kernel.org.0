Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F334A4C2C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 17:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380324AbiAaQc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 11:32:59 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:50565 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379566AbiAaQc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 11:32:58 -0500
Received: (Authenticated sender: foss@0leil.net)
        by mail.gandi.net (Postfix) with ESMTPSA id 160CC1C0009;
        Mon, 31 Jan 2022 16:32:52 +0000 (UTC)
From:   quentin.schulz@theobroma-systems.com
Cc:     mturquette@baylibre.com, sboyd@kernel.org, heiko@sntech.de,
        andriy.shevchenko@linux.intel.com, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        stable@vger.kernel.org, Quentin Schulz <foss+kernel@0leil.net>
Subject: [PATCH] clk: rockchip: re-add rational best approximation algorithm to the fractional divider
Date:   Mon, 31 Jan 2022 17:32:24 +0100
Message-Id: <20220131163224.708002-1-quentin.schulz@theobroma-systems.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

In commit 4e7cf74fa3b2 ("clk: fractional-divider: Export approximation
algorithm to the CCF users"), the code handling the rational best
approximation algorithm was replaced by a call to the core
clk_fractional_divider_general_approximation function which did the same
thing back then.

However, in commit 82f53f9ee577 ("clk: fractional-divider: Introduce
POWER_OF_TWO_PS flag"), this common code was made conditional on
CLK_FRAC_DIVIDER_POWER_OF_TWO_PS flag which was not added back to the
rockchip clock driver.

This broke the ltk050h3146w-a2 MIPI DSI display present on a PX30-based
downstream board.

Let's add the flag to the fractional divider flags so that the original
and intended behavior is brought back to the rockchip clock drivers.

Fixes: 82f53f9ee577 ("clk: fractional-divider: Introduce POWER_OF_TWO_PS flag")
Cc: stable@vger.kernel.org
Cc: Quentin Schulz <foss+kernel@0leil.net>
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
---
 drivers/clk/rockchip/clk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
index b7be7e11b0df..bb8a844309bf 100644
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -180,6 +180,7 @@ static void rockchip_fractional_approximation(struct clk_hw *hw,
 		unsigned long rate, unsigned long *parent_rate,
 		unsigned long *m, unsigned long *n)
 {
+	struct clk_fractional_divider *fd = to_clk_fd(hw);
 	unsigned long p_rate, p_parent_rate;
 	struct clk_hw *p_parent;
 
@@ -190,6 +191,8 @@ static void rockchip_fractional_approximation(struct clk_hw *hw,
 		*parent_rate = p_parent_rate;
 	}
 
+	fd->flags |= CLK_FRAC_DIVIDER_POWER_OF_TWO_PS;
+
 	clk_fractional_divider_general_approximation(hw, rate, parent_rate, m, n);
 }
 
-- 
2.34.1

