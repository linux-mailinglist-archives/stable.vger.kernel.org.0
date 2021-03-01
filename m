Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DEA328510
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhCAQsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:48:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234821AbhCAQlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:41:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1B6F64EDD;
        Mon,  1 Mar 2021 16:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616115;
        bh=AfV4/UGIq0C/7gZ55xd8netA3mDW9CfA07VzkzVJiYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ft+L6vkELvUioQcUp2b4H5IHs72lHapm8vCyu+x8VOusfHlCi39kUUt6s9OcK5y5W
         bYNWxI/j4jhHpGSJb1vZm4rMqE6pdyHhmQ0+BMKBtXykrx/PM3rDjLFcjUPzKA8Qzt
         B8iNxvzYxIgbB4h3MkpAHBMJoappRd5po37P7Gwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 040/176] net: mvneta: Remove per-cpu queue mapping for Armada 3700
Date:   Mon,  1 Mar 2021 17:11:53 +0100
Message-Id: <20210301161022.961918089@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index a115e51dc2115..cc0414fd13557 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2958,7 +2958,9 @@ static int mvneta_txq_init(struct mvneta_port *pp,
 	mvneta_tx_done_pkts_coal_set(pp, txq, txq->done_pkts_coal);
 
 	/* Setup XPS mapping */
-	if (txq_number > 1)
+	if (pp->neta_armada3700)
+		cpu = 0;
+	else if (txq_number > 1)
 		cpu = txq->id % num_present_cpus();
 	else
 		cpu = pp->rxq_def % num_present_cpus();
@@ -3409,6 +3411,11 @@ static int mvneta_cpu_online(unsigned int cpu, struct hlist_node *node)
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



