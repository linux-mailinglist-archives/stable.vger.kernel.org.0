Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0371D0EDB
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733209AbgEMJtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733205AbgEMJtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:49:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E1AB20740;
        Wed, 13 May 2020 09:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363355;
        bh=Fj3VzgxU/YecRjG8k70EozfZJX8Zs6fcFj/gnZ5pIpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4xG7sMEG1NqNXY9i+7dfyAo5BsBF0mlasvLKlFD3ujlRoI3G9gSPuRbzA091lVHF
         uuAoW9YyruKYZWsl1qIrdtKuU2meagVLFXyqsSyqTeaaBc4UoJ0AlRTupf1sonwko4
         XjZYJeJdbHK58hQDwHSAB9XMEdwCYYeDNcdCYfNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/90] net: macb: Fix runtime PM refcounting
Date:   Wed, 13 May 2020 11:44:01 +0200
Message-Id: <20200513094409.652936438@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0ce205d4660c312cdeb4a81066616dcc6f3799c4 ]

The commit e6a41c23df0d, while trying to fix an issue,

    ("net: macb: ensure interface is not suspended on at91rm9200")

introduced a refcounting regression, because in error case refcounter
must be balanced. Fix it by calling pm_runtime_put_noidle() in error case.

While here, fix the same mistake in other couple of places.

Fixes: e6a41c23df0d ("net: macb: ensure interface is not suspended on at91rm9200")
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 234c13ebbc41b..dd2a605c5c2ed 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -334,8 +334,10 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	int status;
 
 	status = pm_runtime_get_sync(&bp->pdev->dev);
-	if (status < 0)
+	if (status < 0) {
+		pm_runtime_put_noidle(&bp->pdev->dev);
 		goto mdio_pm_exit;
+	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
@@ -367,8 +369,10 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	int status;
 
 	status = pm_runtime_get_sync(&bp->pdev->dev);
-	if (status < 0)
+	if (status < 0) {
+		pm_runtime_put_noidle(&bp->pdev->dev);
 		goto mdio_pm_exit;
+	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
@@ -3691,8 +3695,10 @@ static int at91ether_open(struct net_device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(&lp->pdev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(&lp->pdev->dev);
 		return ret;
+	}
 
 	/* Clear internal statistics */
 	ctl = macb_readl(lp, NCR);
-- 
2.20.1



