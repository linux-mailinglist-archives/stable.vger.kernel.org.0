Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE8840E66C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343730AbhIPRVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350926AbhIPRSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:18:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BEBB61A0D;
        Thu, 16 Sep 2021 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810452;
        bh=oWRUCAFDJYgHIjgHuS3unULmVDpG7sU3d4EIncw7RW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaYX5uecjobndEvvlZpXVBJGqXd0BLTLuhSmYaNgSyoODT5p1WMqrXrFvaqOC5hYw
         s2Ax8p+/6OtE0DZRY6ebfmrTMh0tRjuSn5e/JFfVXVH02MnpzsGTuN6RmiordDG9XW
         XQaTKXKK+yAHwMJ/PRee0SpVwhpElodM4xgjV/yM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 146/432] clk: at91: clk-generated: Limit the requested rate to our range
Date:   Thu, 16 Sep 2021 17:58:15 +0200
Message-Id: <20210916155815.707843572@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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



