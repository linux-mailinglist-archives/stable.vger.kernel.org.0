Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F115328C28
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbhCASqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:46:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234895AbhCASjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4376964FC2;
        Mon,  1 Mar 2021 17:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620477;
        bh=kicAYfIs9IHKgNgZpi4axMiRHGEeqNxO79hUbBUNKoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=saxIGmMdbrHsU+P2AhMMhWJfLSC9y/3XAz1ns6ENK27xw1imrz1cXPzWvScYTHYfz
         hOaIvi/Ap+IwDNjUiWxMYOa6bbJzE8Bqq2IGHSRlk/mDInBgXz5DW1ztpUykgZSxEw
         WhdqPzvIuUsJuCnpwkTtraxgNZ+pn/3pWZCsWSpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 138/775] net: mvneta: Remove per-cpu queue mapping for Armada 3700
Date:   Mon,  1 Mar 2021 17:05:06 +0100
Message-Id: <20210301161208.489226451@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit cf9bf871280d9e0a8869d98c2602d29caf69dfa3 ]

According to Errata #23 "The per-CPU GbE interrupt is limited to Core
0", we can't use the per-cpu interrupt mechanism on the Armada 3700
familly.

This is correctly checked for RSS configuration, but the initial queue
mapping is still done by having the queues spread across all the CPUs in
the system, both in the init path and in the cpu_hotplug path.

Fixes: 2636ac3cc2b4 ("net: mvneta: Add network support for Armada 3700 SoC")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index bc4d8d1444019..fd5b33646ea71 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3432,7 +3432,9 @@ static int mvneta_txq_sw_init(struct mvneta_port *pp,
 		return -ENOMEM;
 
 	/* Setup XPS mapping */
-	if (txq_number > 1)
+	if (pp->neta_armada3700)
+		cpu = 0;
+	else if (txq_number > 1)
 		cpu = txq->id % num_present_cpus();
 	else
 		cpu = pp->rxq_def % num_present_cpus();
@@ -4210,6 +4212,11 @@ static int mvneta_cpu_online(unsigned int cpu, struct hlist_node *node)
 						  node_online);
 	struct mvneta_pcpu_port *port = per_cpu_ptr(pp->ports, cpu);
 
+	/* Armada 3700's per-cpu interrupt for mvneta is broken, all interrupts
+	 * are routed to CPU 0, so we don't need all the cpu-hotplug support
+	 */
+	if (pp->neta_armada3700)
+		return 0;
 
 	spin_lock(&pp->lock);
 	/*
-- 
2.27.0



