Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B20A2265DF
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbgGTP6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731991AbgGTP6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:58:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EE9A206E9;
        Mon, 20 Jul 2020 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260686;
        bh=7mPeL6q5fqzI+QggGUNvC3bQjLzT8Ro3i8ISN2AzR1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5KXijEqwTiLI06rRJYuu+1Rhmd7AWjpu6bOTWCKrVTu5IJIYPO4hgqQnkZCOfMzK
         66adA54VyAtCVwlDR/OgrX6++msgbDdadEsTNQYAwBAMU+DSc2gaw6PYZysanMeDVa
         8tH8gEBKOg62kl2OdC5kohZ8XBuDwRVUpeTTEG+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/215] net: macb: call pm_runtime_put_sync on failure path
Date:   Mon, 20 Jul 2020 17:35:40 +0200
Message-Id: <20200720152822.973921309@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0eaf228d574bd82a9aed73e3953bfb81721f4227 ]

Call pm_runtime_put_sync() on failure path of at91ether_open.

Fixes: e6a41c23df0d ("net: macb: ensure interface is not suspended on at91rm9200")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 01ed4d4296db2..a5c4d4d66df35 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3708,7 +3708,7 @@ static int at91ether_open(struct net_device *dev)
 
 	ret = at91ether_start(dev);
 	if (ret)
-		return ret;
+		goto pm_exit;
 
 	/* Enable MAC interrupts */
 	macb_writel(lp, IER, MACB_BIT(RCOMP)	|
@@ -3725,6 +3725,10 @@ static int at91ether_open(struct net_device *dev)
 	netif_start_queue(dev);
 
 	return 0;
+
+pm_exit:
+	pm_runtime_put_sync(&lp->pdev->dev);
+	return ret;
 }
 
 /* Close the interface */
-- 
2.25.1



