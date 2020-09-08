Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DEA261CF8
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbgIHT26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730989AbgIHQAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:00:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2FB23F58;
        Tue,  8 Sep 2020 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579487;
        bh=1fxuIfBwAjEqiOizcTcWza3Cdoa0cViFmNnsCS2gGew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNpqNSyMaz0n/CGIhcBjOtXBgocEl2mxDn26przAzSoM+sQStBr/pdlurdW826/wS
         MZs9Q+ScPSA5NCJunbSFs9imIwJXX7pCGLXgFsjc+QS9SGliOfY9ywEaUDbQzINLgw
         8obuCEFJJNUJHGBUzkp5Aq06hXdTy1QLWG8vO2qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 098/186] net: gemini: Fix another missing clk_disable_unprepare() in probe
Date:   Tue,  8 Sep 2020 17:24:00 +0200
Message-Id: <20200908152246.385353745@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit eb0f3bc463d59d86402f19c59aa44e82dc3fab6d ]

We recently added some calls to clk_disable_unprepare() but we missed
the last error path if register_netdev() fails.

I made a couple cleanups so we avoid mistakes like this in the future.
First I reversed the "if (!ret)" condition and pulled the code in one
indent level.  Also, the "port->netdev = NULL;" is not required because
"port" isn't used again outside this function so I deleted that line.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 34 +++++++++++++--------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 62e271aea4a50..ffec0f3dd9578 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2446,8 +2446,8 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	port->reset = devm_reset_control_get_exclusive(dev, NULL);
 	if (IS_ERR(port->reset)) {
 		dev_err(dev, "no reset\n");
-		clk_disable_unprepare(port->pclk);
-		return PTR_ERR(port->reset);
+		ret = PTR_ERR(port->reset);
+		goto unprepare;
 	}
 	reset_control_reset(port->reset);
 	usleep_range(100, 500);
@@ -2502,25 +2502,25 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 					IRQF_SHARED,
 					port_names[port->id],
 					port);
-	if (ret) {
-		clk_disable_unprepare(port->pclk);
-		return ret;
-	}
+	if (ret)
+		goto unprepare;
 
 	ret = register_netdev(netdev);
-	if (!ret) {
+	if (ret)
+		goto unprepare;
+
+	netdev_info(netdev,
+		    "irq %d, DMA @ 0x%pap, GMAC @ 0x%pap\n",
+		    port->irq, &dmares->start,
+		    &gmacres->start);
+	ret = gmac_setup_phy(netdev);
+	if (ret)
 		netdev_info(netdev,
-			    "irq %d, DMA @ 0x%pap, GMAC @ 0x%pap\n",
-			    port->irq, &dmares->start,
-			    &gmacres->start);
-		ret = gmac_setup_phy(netdev);
-		if (ret)
-			netdev_info(netdev,
-				    "PHY init failed, deferring to ifup time\n");
-		return 0;
-	}
+			    "PHY init failed, deferring to ifup time\n");
+	return 0;
 
-	port->netdev = NULL;
+unprepare:
+	clk_disable_unprepare(port->pclk);
 	return ret;
 }
 
-- 
2.25.1



