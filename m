Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814B540E2B7
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbhIPQlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244351AbhIPQiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:38:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CBE5619F6;
        Thu, 16 Sep 2021 16:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809366;
        bh=oWRUCAFDJYgHIjgHuS3unULmVDpG7sU3d4EIncw7RW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GavS5cPbWDN/A7PI0eRR6TYM7ehfcYito2CtxPERv8KAbJinDJhJwDxlVSCZYNfH0
         T5OHi3J7tzUEKGMZ1QiXb7YWD77hjIZcWq0s4w10Yd9bb6ME1WAGmm3j7isW5FMoCd
         +uShgh1Hbh2Fz/rvbK3I3WZWpgZj8vcM8jBINszg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 128/380] clk: at91: clk-generated: Limit the requested rate to our range
Date:   Thu, 16 Sep 2021 17:58:05 +0200
Message-Id: <20210916155808.389495052@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit af7651e67b9d5f7e63ea23b118e3672ac662244a ]

On clk_generated_determine_rate(), the requested rate could be outside
of clk's range. Limit the rate to the clock's range to not return an
error.

Fixes: df70aeef6083 ("clk: at91: add generated clock driver")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20210707131213.3283509-1-codrin.ciubotariu@microchip.com
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-generated.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/at91/clk-generated.c b/drivers/clk/at91/clk-generated.c
index b4fc8d71daf2..b656d25a9767 100644
--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -128,6 +128,12 @@ static int clk_generated_determine_rate(struct clk_hw *hw,
 	int i;
 	u32 div;
 
+	/* do not look for a rate that is outside of our range */
+	if (gck->range.max && req->rate > gck->range.max)
+		req->rate = gck->range.max;
+	if (gck->range.min && req->rate < gck->range.min)
+		req->rate = gck->range.min;
+
 	for (i = 0; i < clk_hw_get_num_parents(hw); i++) {
 		if (gck->chg_pid == i)
 			continue;
-- 
2.30.2



