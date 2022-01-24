Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3058498BC8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242806AbiAXTQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:16:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39916 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346648AbiAXTOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:14:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99F53B81240;
        Mon, 24 Jan 2022 19:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98867C340E8;
        Mon, 24 Jan 2022 19:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051658;
        bh=eiiBgW+XxpwQNWaaPPOzfBVjpsZcwzuTbsm/oHVuOQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/2XDkSXtnIJQwYjowF/JImJ1UmvWCqDpyhUx+iO7MqKk7uF/uaKPp1tLfNa3CtFA
         uG7CMUl3KvURHO1wOEzBE4dUMWcoTf1p+36PMRwkaZ/NRgsfMOMzuYD8IbcHl/piGf
         Of9PEzYs0t7F1Pahxwo0vxunGXXWi0JAQjkm5Xek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Michael Stapelberg <michael@stapelberg.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/239] clk: bcm-2835: Pick the closest clock rate
Date:   Mon, 24 Jan 2022 19:41:24 +0100
Message-Id: <20220124183944.601337955@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 5517357a4733d7cf7c17fc79d0530cfa47add372 ]

The driver currently tries to pick the closest rate that is lower than
the rate being requested.

This causes an issue with clk_set_min_rate() since it actively checks
for the rounded rate to be above the minimum that was just set.

Let's change the logic a bit to pick the closest rate to the requested
rate, no matter if it's actually higher or lower.

Fixes: 6d18b8adbe67 ("clk: bcm2835: Support for clock parent selection")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Tested-by: Nicolas Saenz Julienne <nsaenz@kernel.org> # boot and basic functionality
Tested-by: Michael Stapelberg <michael@stapelberg.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210922125419.4125779-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm2835.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index e4fee233849d2..b14aa9ddd9456 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -1199,7 +1199,7 @@ static int bcm2835_clock_determine_rate(struct clk_hw *hw,
 		rate = bcm2835_clock_choose_div_and_prate(hw, i, req->rate,
 							  &div, &prate,
 							  &avgrate);
-		if (rate > best_rate && rate <= req->rate) {
+		if (abs(req->rate - rate) < abs(req->rate - best_rate)) {
 			best_parent = parent;
 			best_prate = prate;
 			best_rate = rate;
-- 
2.34.1



