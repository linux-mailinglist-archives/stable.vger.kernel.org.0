Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49321498BA1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345267AbiAXTPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238400AbiAXTM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:12:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663A5C0604D4;
        Mon, 24 Jan 2022 11:04:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 070A060FED;
        Mon, 24 Jan 2022 19:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38F5C340E5;
        Mon, 24 Jan 2022 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051041;
        bh=Mm29p/MNKCC/N2fGHWjrloJ+iJd7CPkhYTkIPF/7R3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMl2QlauKj7R8TuC+SL2NCD0s0+UxkFynMdnhlhSki+o9qHtCEKleTX+Si8kFATF6
         Lb7EQ+LTuje7HfK/M8Lrg1KK07I2Wao8S3Ew7Smj6fBEaB1Fx92J6IyxboD3myYl4Q
         OmYCPGfMmmo8qkGpkNfgymsUfCELCcRwnyux/tSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Michael Stapelberg <michael@stapelberg.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 034/186] clk: bcm-2835: Pick the closest clock rate
Date:   Mon, 24 Jan 2022 19:41:49 +0100
Message-Id: <20220124183938.221804577@linuxfoundation.org>
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
index 98295b9703178..d6cd1cc3f8e4d 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -1233,7 +1233,7 @@ static int bcm2835_clock_determine_rate(struct clk_hw *hw,
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



