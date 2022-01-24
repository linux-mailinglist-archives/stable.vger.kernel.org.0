Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E5C498BDC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347655AbiAXTRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348178AbiAXTO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:14:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9953C0612F9;
        Mon, 24 Jan 2022 11:06:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E7A6B8122C;
        Mon, 24 Jan 2022 19:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E0BC340E5;
        Mon, 24 Jan 2022 19:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051172;
        bh=B7mjUnZq8ZfyVsarG1B9zQS0XV+aXbFi/U1xJGdxK64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Svz7jkVxxJcDukhQGB5M0fZCNdEDnL3cbhkv+D4WrRPll872hGDL4oSTGOjAsT5d5
         UJixNK8oqjYSlMfBMIWcrx6nVJUOHCRn/3N/fhP894YjuRVnMyacB+C16UBOOXjI9Y
         glQXSc9hd+WbxG/qU+F++M2Z7DiB6k9qHn+6KmEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Michael Stapelberg <michael@stapelberg.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 035/186] clk: bcm-2835: Remove rounding up the dividers
Date:   Mon, 24 Jan 2022 19:41:50 +0100
Message-Id: <20220124183938.253195344@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 8ca011ef4af48a7af7b15afd8a4a44039dd04cea ]

The driver, once it found a divider, tries to round it up by increasing
the least significant bit of the fractional part by one when the
round_up argument is set and there's a remainder.

However, since it increases the divider it will actually reduce the
clock rate below what we were asking for, leading to issues with
clk_set_min_rate() that will complain that our rounded clock rate is
below the minimum of the rate.

Since the dividers are fairly precise already, let's remove that part so
that we can have clk_set_min_rate() working.

This is effectively a revert of 9c95b32ca093 ("clk: bcm2835: add a round
up ability to the clock divisor").

Fixes: 9c95b32ca093 ("clk: bcm2835: add a round up ability to the clock divisor")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Tested-by: Nicolas Saenz Julienne <nsaenz@kernel.org> # boot and basic functionality
Tested-by: Michael Stapelberg <michael@stapelberg.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210922125419.4125779-3-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm2835.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index d6cd1cc3f8e4d..8ccd72cc66bab 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -949,8 +949,7 @@ static int bcm2835_clock_is_on(struct clk_hw *hw)
 
 static u32 bcm2835_clock_choose_div(struct clk_hw *hw,
 				    unsigned long rate,
-				    unsigned long parent_rate,
-				    bool round_up)
+				    unsigned long parent_rate)
 {
 	struct bcm2835_clock *clock = bcm2835_clock_from_hw(hw);
 	const struct bcm2835_clock_data *data = clock->data;
@@ -962,10 +961,6 @@ static u32 bcm2835_clock_choose_div(struct clk_hw *hw,
 
 	rem = do_div(temp, rate);
 	div = temp;
-
-	/* Round up and mask off the unused bits */
-	if (round_up && ((div & unused_frac_mask) != 0 || rem != 0))
-		div += unused_frac_mask + 1;
 	div &= ~unused_frac_mask;
 
 	/* different clamping limits apply for a mash clock */
@@ -1096,7 +1091,7 @@ static int bcm2835_clock_set_rate(struct clk_hw *hw,
 	struct bcm2835_clock *clock = bcm2835_clock_from_hw(hw);
 	struct bcm2835_cprman *cprman = clock->cprman;
 	const struct bcm2835_clock_data *data = clock->data;
-	u32 div = bcm2835_clock_choose_div(hw, rate, parent_rate, false);
+	u32 div = bcm2835_clock_choose_div(hw, rate, parent_rate);
 	u32 ctl;
 
 	spin_lock(&cprman->regs_lock);
@@ -1147,7 +1142,7 @@ static unsigned long bcm2835_clock_choose_div_and_prate(struct clk_hw *hw,
 
 	if (!(BIT(parent_idx) & data->set_rate_parent)) {
 		*prate = clk_hw_get_rate(parent);
-		*div = bcm2835_clock_choose_div(hw, rate, *prate, true);
+		*div = bcm2835_clock_choose_div(hw, rate, *prate);
 
 		*avgrate = bcm2835_clock_rate_from_divisor(clock, *prate, *div);
 
-- 
2.34.1



