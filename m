Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C34917800D
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732509AbgCCRy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:54:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732314AbgCCRyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:54:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DF19206D5;
        Tue,  3 Mar 2020 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258064;
        bh=2k1Uh2+g4UIU3FTUqMeqDDj6AHc8elwxBX5WMs5PIzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1E0sPnY2VXvnV78tbciVvjkXWYDgiQWT/+efjT0UmUm77n4ESAuiV4+cd1nm43FK
         207bOXacfQRoodMvsNxBmOIHxvZwmQaBPTX5idFTKSdgyKGHwL3bjuSzCTonNeGcEN
         7g/50gBAv+8fnQOehDG3GNow/PVuDX1ffBoD8RwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/152] net: ena: fix uses of round_jiffies()
Date:   Tue,  3 Mar 2020 18:42:28 +0100
Message-Id: <20200303174308.103154883@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit 2a6e5fa2f4c25b66c763428a3e65363214946931 ]

>From the documentation of round_jiffies():
"Rounds a time delta  in the future (in jiffies) up or down to
(approximately) full seconds. This is useful for timers for which
the exact time they fire does not matter too much, as long as
they fire approximately every X seconds.
By rounding these timers to whole seconds, all such timers will fire
at the same time, rather than at various times spread out. The goal
of this is to have the CPU wake up less, which saves power."

There are 2 parts to this patch:
================================
Part 1:
-------
In our case we need timer_service to be called approximately every
X=1 seconds, and the exact time does not matter, so using round_jiffies()
is the right way to go.

Therefore we add round_jiffies() to the mod_timer() in ena_timer_service().

Part 2:
-------
round_jiffies() is used in check_for_missing_keep_alive() when
getting the jiffies of the expiration of the keep_alive timeout. Here it
is actually a mistake to use round_jiffies() because we want the exact
time when keep_alive should expire and not an approximate rounded time,
which can cause early, false positive, timeouts.

Therefore we remove round_jiffies() in the calculation of
keep_alive_expired() in check_for_missing_keep_alive().

Fixes: 82ef30f13be0 ("net: ena: add hardware hints capability to the driver")
Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index b4a145220abae..f0cddf250cfd5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3035,8 +3035,8 @@ static void check_for_missing_keep_alive(struct ena_adapter *adapter)
 	if (adapter->keep_alive_timeout == ENA_HW_HINTS_NO_TIMEOUT)
 		return;
 
-	keep_alive_expired = round_jiffies(adapter->last_keep_alive_jiffies +
-					   adapter->keep_alive_timeout);
+	keep_alive_expired = adapter->last_keep_alive_jiffies +
+			     adapter->keep_alive_timeout;
 	if (unlikely(time_is_before_jiffies(keep_alive_expired))) {
 		netif_err(adapter, drv, adapter->netdev,
 			  "Keep alive watchdog timeout.\n");
@@ -3138,7 +3138,7 @@ static void ena_timer_service(struct timer_list *t)
 	}
 
 	/* Reset the timer */
-	mod_timer(&adapter->timer_service, jiffies + HZ);
+	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
 }
 
 static int ena_calc_io_queue_num(struct pci_dev *pdev,
-- 
2.20.1



