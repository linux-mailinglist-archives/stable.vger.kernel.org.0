Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F45329B99F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802656AbgJ0Pun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801650AbgJ0PnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:43:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF14920657;
        Tue, 27 Oct 2020 15:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813384;
        bh=RkAb2M/QPYiOuEN/J8weC9N/KBTKrpBy8dh7V0N9d/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgldVScIvG7juLeQzMMWSTudVXIlE5GR3WtvjkAkstHwHs72m+A4618JLkUCs6cy7
         tBFoja5yByPkfzMGIsNZ5eChcF258zBAZ1Aq6vi6t6qEDhRMBCWnSRyV69sZHWvTa/
         iN2ifbDEribfzHnkf5rzacEFxIM1dUYc08cfj1b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 533/757] clk: keystone: sci-clk: fix parsing assigned-clock data during probe
Date:   Tue, 27 Oct 2020 14:53:03 +0100
Message-Id: <20201027135515.496107795@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit 2f05cced7307489faab873367fb20cd212e1d890 ]

The DT clock probe loop incorrectly terminates after processing "clocks"
only, fix this by re-starting the loop when all entries for current
DT property have been parsed.

Fixes: 8e48b33f9def ("clk: keystone: sci-clk: probe clocks from DT instead of firmware")
Reported-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Link: https://lore.kernel.org/r/20200907085740.1083-2-t-kristo@ti.com
Acked-by: Santosh Shilimkar <ssantosh@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/keystone/sci-clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/keystone/sci-clk.c b/drivers/clk/keystone/sci-clk.c
index 2ad26cb927fdb..f126b6045afa7 100644
--- a/drivers/clk/keystone/sci-clk.c
+++ b/drivers/clk/keystone/sci-clk.c
@@ -522,7 +522,7 @@ static int ti_sci_scan_clocks_from_dt(struct sci_clk_provider *provider)
 		np = of_find_node_with_property(np, *clk_name);
 		if (!np) {
 			clk_name++;
-			break;
+			continue;
 		}
 
 		if (!of_device_is_available(np))
-- 
2.25.1



