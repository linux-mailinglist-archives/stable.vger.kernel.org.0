Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B04E246AD4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387637AbgHQPnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbgHQPnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:43:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BF7122D74;
        Mon, 17 Aug 2020 15:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678989;
        bh=5FS1bRYbhh3iZG9BJtPW8I/Q7cLQiRbWaIwY811DndM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnGNccX344tbtl4VPDPRHnKE2H86xgP7M0kfsbnWnPEl0qCkJFTndxQADzyT1uwvV
         jAEsHInawi5Fk/qCLQgfmVa1tnwad0kLaitaRO69MyVIZCn15Zar+bXIHnTisylbiZ
         ZM12IwqFbkienaE88ih2GrkcKRQYDKg15q60NQgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        Dien Pham <dien.pham.ry@renesas.com>
Subject: [PATCH 5.7 028/393] clk: scmi: Fix min and max rate when registering clocks with discrete rates
Date:   Mon, 17 Aug 2020 17:11:18 +0200
Message-Id: <20200817143820.974286859@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit fcd2e0deae50bce48450f14c8fc5611b08d7438c ]

Currently we are not initializing the scmi clock with discrete rates
correctly. We fetch the min_rate and max_rate value only for clocks with
ranges and ignore the ones with discrete rates. This will lead to wrong
initialization of rate range when clock supports discrete rate.

Fix this by using the first and the last rate in the sorted list of the
discrete clock rates while registering the clock.

Link: https://lore.kernel.org/r/20200709081705.46084-2-sudeep.holla@arm.com
Fixes: 6d6a1d82eaef7 ("clk: add support for clocks provided by SCMI")
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Reported-and-tested-by: Dien Pham <dien.pham.ry@renesas.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scmi.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-scmi.c b/drivers/clk/clk-scmi.c
index c491f5de0f3f4..c754dfbb73fd4 100644
--- a/drivers/clk/clk-scmi.c
+++ b/drivers/clk/clk-scmi.c
@@ -103,6 +103,8 @@ static const struct clk_ops scmi_clk_ops = {
 static int scmi_clk_ops_init(struct device *dev, struct scmi_clk *sclk)
 {
 	int ret;
+	unsigned long min_rate, max_rate;
+
 	struct clk_init_data init = {
 		.flags = CLK_GET_RATE_NOCACHE,
 		.num_parents = 0,
@@ -112,9 +114,23 @@ static int scmi_clk_ops_init(struct device *dev, struct scmi_clk *sclk)
 
 	sclk->hw.init = &init;
 	ret = devm_clk_hw_register(dev, &sclk->hw);
-	if (!ret)
-		clk_hw_set_rate_range(&sclk->hw, sclk->info->range.min_rate,
-				      sclk->info->range.max_rate);
+	if (ret)
+		return ret;
+
+	if (sclk->info->rate_discrete) {
+		int num_rates = sclk->info->list.num_rates;
+
+		if (num_rates <= 0)
+			return -EINVAL;
+
+		min_rate = sclk->info->list.rates[0];
+		max_rate = sclk->info->list.rates[num_rates - 1];
+	} else {
+		min_rate = sclk->info->range.min_rate;
+		max_rate = sclk->info->range.max_rate;
+	}
+
+	clk_hw_set_rate_range(&sclk->hw, min_rate, max_rate);
 	return ret;
 }
 
-- 
2.25.1



