Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D441489E3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403771AbgAXOSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:18:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391064AbgAXOSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A3E2077C;
        Fri, 24 Jan 2020 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875525;
        bh=5Shb8Tk5ld6AXNX7FO+L8lYGIpZSgw9dqSshcT78Bqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyP0/sKpInQVTLfRL3x7K9iC6m8Gy61lefl/yo1VEQgHIklNOhnz3OfcEvVzTTrzp
         l0JNL/CkIlkQ2+yl6OcjTDqd/7LBWvfN2jLUUveg7Xlb1GikDsz5QDp+dkPjqAKqUj
         +bVfws5GPoZESU/B2ngP8CcBv94llfiQPZjXsDbI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samuel Holland <samuel@sholland.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 024/107] clk: sunxi-ng: h6-r: Fix AR100/R_APB2 parent order
Date:   Fri, 24 Jan 2020 09:16:54 -0500
Message-Id: <20200124141817.28793-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 0c545240aebc2ccb8f661dc54283a14d64659804 ]

According to the BSP source code, both the AR100 and R_APB2 clocks have
PLL_PERIPH0 as mux index 3, not 2 as it was on previous chips. The pre-
divider used for PLL_PERIPH0 should be changed to index 3 to match.

This was verified by running a rough benchmark on the AR100 with various
clock settings:

        | mux | pre-divider | iterations/second | clock source |
        |=====|=============|===================|==============|
        |   0 |           0 |  19033   (stable) |       osc24M |
        |   2 |           5 |  11466 (unstable) |  iosc/osc16M |
        |   2 |          17 |  11422 (unstable) |  iosc/osc16M |
        |   3 |           5 |  85338   (stable) |  pll-periph0 |
        |   3 |          17 |  27167   (stable) |  pll-periph0 |

The relative performance numbers all match up (with pll-periph0 running
at its default 600MHz).

Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c b/drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c
index 45a1ed3fe6742..ab194143e06ce 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c
@@ -23,9 +23,9 @@
  */
 
 static const char * const ar100_r_apb2_parents[] = { "osc24M", "osc32k",
-					     "pll-periph0", "iosc" };
+						     "iosc", "pll-periph0" };
 static const struct ccu_mux_var_prediv ar100_r_apb2_predivs[] = {
-	{ .index = 2, .shift = 0, .width = 5 },
+	{ .index = 3, .shift = 0, .width = 5 },
 };
 
 static struct ccu_div ar100_clk = {
-- 
2.20.1

