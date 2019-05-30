Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 247952F5B5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731525AbfE3Et0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbfE3DLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:12 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82923244B0;
        Thu, 30 May 2019 03:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185871;
        bh=9mXslimkPMmlanAaQNdynl1vDE9sPKhg5fOEZZEViIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0pvUJIJMjc0YojysSDN4R0tqFdfLPQtzVcgdC7+5WvQUp9c18YXNxTN8fJiwIVLy
         8hZkxzKCrzShUk+pV1D77nmnZ3htMWFsp8q8dBxClSiMlhUCrolA1NPJiS6WEUdRF+
         zFaJg07o6pVVY1bGy6GMjn5JlCIyT70FRdJQybDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Tretter <m.tretter@pengutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 214/405] clk: zynqmp: fix check for fractional clock
Date:   Wed, 29 May 2019 20:03:32 -0700
Message-Id: <20190530030551.919150670@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c06e64407e031e71c67f45f07981510ca4c880a1 ]

The firmware sets BIT(13) in clkflag to mark a divider as fractional
divider. The clock driver copies the clkflag straight to the flags of
the common clock framework. In the common clk framework flags, BIT(13)
is defined as CLK_DUTY_CYCLE_PARENT.

Add a new field to the zynqmp_clk_divider to specify if a divider is a
fractional devider. Set this field based on the clkflag when registering
a divider.

At the same time, unset BIT(13) from clkflag when copying the flags to
the common clk framework flags.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/divider.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/zynqmp/divider.c b/drivers/clk/zynqmp/divider.c
index a371c66e72ef6..bd9b5fbc443b3 100644
--- a/drivers/clk/zynqmp/divider.c
+++ b/drivers/clk/zynqmp/divider.c
@@ -31,12 +31,14 @@
  * struct zynqmp_clk_divider - adjustable divider clock
  * @hw:		handle between common and hardware-specific interfaces
  * @flags:	Hardware specific flags
+ * @is_frac:	The divider is a fractional divider
  * @clk_id:	Id of clock
  * @div_type:	divisor type (TYPE_DIV1 or TYPE_DIV2)
  */
 struct zynqmp_clk_divider {
 	struct clk_hw hw;
 	u8 flags;
+	bool is_frac;
 	u32 clk_id;
 	u32 div_type;
 };
@@ -116,8 +118,7 @@ static long zynqmp_clk_divider_round_rate(struct clk_hw *hw,
 
 	bestdiv = zynqmp_divider_get_val(*prate, rate);
 
-	if ((clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT) &&
-	    (divider->flags & CLK_FRAC))
+	if ((clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT) && divider->is_frac)
 		bestdiv = rate % *prate ? 1 : bestdiv;
 	*prate = rate * bestdiv;
 
@@ -195,11 +196,13 @@ struct clk_hw *zynqmp_clk_register_divider(const char *name,
 
 	init.name = name;
 	init.ops = &zynqmp_clk_divider_ops;
-	init.flags = nodes->flag;
+	/* CLK_FRAC is not defined in the common clk framework */
+	init.flags = nodes->flag & ~CLK_FRAC;
 	init.parent_names = parents;
 	init.num_parents = 1;
 
 	/* struct clk_divider assignments */
+	div->is_frac = !!(nodes->flag & CLK_FRAC);
 	div->flags = nodes->type_flag;
 	div->hw.init = &init;
 	div->clk_id = clk_id;
-- 
2.20.1



