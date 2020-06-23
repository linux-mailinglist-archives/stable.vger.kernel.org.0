Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9E6205CB6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388240AbgFWUEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388236AbgFWUEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:04:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0E502080C;
        Tue, 23 Jun 2020 20:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942678;
        bh=oWN/GHMJ1I/nfSKHPsEfpd0EtGfTOxA4OujpXXhXAN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDL82bVEr8NNXB3x0M8rdHRzC9Ms9KhLaIf23vG8t3YjaEA+CONZSZaliGmL/jWYx
         4AoRiBxB5YX1J9M8CSEiaXMg8hR9VWDVwA8eu+g2IkUNnvReAPvY56aREA7XikV69o
         FBZI9v7YBq4Gk9ANQNRxs1q9NX5E/AA2H+zMqHpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 092/477] net: mdiobus: Disable preemption upon u64_stats update
Date:   Tue, 23 Jun 2020 21:51:29 +0200
Message-Id: <20200623195411.952647146@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed S. Darwish <a.darwish@linutronix.de>

[ Upstream commit c7e261d81783387a0502878cd229327e7c54322e ]

The u64_stats mechanism uses sequence counters to protect against 64-bit
values tearing on 32-bit architectures. Updating u64_stats is thus a
sequence counter write side critical section where preemption must be
disabled.

For mdiobus_stats_acct(), disable preemption upon the u64_stats update.
It is called from process context through mdiobus_read() and
mdiobus_write().

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7a4eb3f2cb743..a1a4dee2a033a 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -757,6 +757,7 @@ EXPORT_SYMBOL(mdiobus_scan);
 
 static void mdiobus_stats_acct(struct mdio_bus_stats *stats, bool op, int ret)
 {
+	preempt_disable();
 	u64_stats_update_begin(&stats->syncp);
 
 	u64_stats_inc(&stats->transfers);
@@ -771,6 +772,7 @@ static void mdiobus_stats_acct(struct mdio_bus_stats *stats, bool op, int ret)
 		u64_stats_inc(&stats->writes);
 out:
 	u64_stats_update_end(&stats->syncp);
+	preempt_enable();
 }
 
 /**
-- 
2.25.1



