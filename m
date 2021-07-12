Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B701A3C46BE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhGLG2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235003AbhGLG12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:27:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BE3761106;
        Mon, 12 Jul 2021 06:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071041;
        bh=rHUErpW9oaBHn/FInFnjGX1rWLjFOXtKGhV/jROd038=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K361YQra7Z/A5lOp1cDXDi6UsVLIIKhXFO7iNL24FeT06uAcE6TfdhWWx89Pf4050
         VdrwYhTYSenhNGnSd3GeD8mnw+4uiEHcua+2QUXbcIzpPbwW5QgtKTMaJQlRzTfek6
         UJwloMtZnRKyHzuf9LGwMC9ZB+Z3t9qWkDdNdKHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 247/348] clk: si5341: Avoid divide errors due to bogus register contents
Date:   Mon, 12 Jul 2021 08:10:31 +0200
Message-Id: <20210712060735.438557013@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 78f6f406026d688868223d5dbeb197a4f7e9a9fd ]

If the Si5341 is being initially programmed and has no stored NVM
configuration, some of the register contents may contain unexpected
values, such as zeros, which could cause divide by zero errors during
driver initialization. Trap errors caused by zero registers or zero clock
rates which could result in divide errors later in the code.

Fixes: 3044a860fd ("clk: Add Si5341/Si5340 driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20210325192643.2190069-4-robert.hancock@calian.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5341.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index 6e780c2a9e6b..ae8960188826 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -482,6 +482,9 @@ static unsigned long si5341_synth_clk_recalc_rate(struct clk_hw *hw,
 			SI5341_SYNTH_N_NUM(synth->index), &n_num, &n_den);
 	if (err < 0)
 		return err;
+	/* Check for bogus/uninitialized settings */
+	if (!n_num || !n_den)
+		return 0;
 
 	/*
 	 * n_num and n_den are shifted left as much as possible, so to prevent
@@ -665,6 +668,9 @@ static long si5341_output_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 {
 	unsigned long r;
 
+	if (!rate)
+		return 0;
+
 	r = *parent_rate >> 1;
 
 	/* If rate is an even divisor, no changes to parent required */
@@ -693,11 +699,16 @@ static int si5341_output_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 		unsigned long parent_rate)
 {
 	struct clk_si5341_output *output = to_clk_si5341_output(hw);
-	/* Frequency divider is (r_div + 1) * 2 */
-	u32 r_div = (parent_rate / rate) >> 1;
+	u32 r_div;
 	int err;
 	u8 r[3];
 
+	if (!rate)
+		return -EINVAL;
+
+	/* Frequency divider is (r_div + 1) * 2 */
+	r_div = (parent_rate / rate) >> 1;
+
 	if (r_div <= 1)
 		r_div = 0;
 	else if (r_div >= BIT(24))
-- 
2.30.2



