Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D537C32865B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhCARIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:08:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235272AbhCARDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:03:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AFE164EC8;
        Mon,  1 Mar 2021 16:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616718;
        bh=EIVnKeBTvCuy8skJ1s58bt5TKX4aecLWzQO1Vfu+E2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrQ8ppczG4Uemy4G5vyt5ZZ603N9ghgb4gw1ewxoQVtsAHGpO64hDDw2zTRAjTLFS
         nmjgY3rXlqYHQyyriBR9Tgl47lpEHoSKIuiWrH9BLMKRL/szpD8V7YecmsenhPNw6h
         aD2btN7EiLxJjf1/sDMQ7a2SH3rSon5N/qXTHtJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/247] net: mvneta: Remove per-cpu queue mapping for Armada 3700
Date:   Mon,  1 Mar 2021 17:11:32 +0100
Message-Id: <20210301161035.212197791@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 30a16cf796c7a..fda5dd8c71ebd 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3022,7 +3022,9 @@ static int mvneta_txq_sw_init(struct mvneta_port *pp,
 	}
 
 	/* Setup XPS mapping */
-	if (txq_number > 1)
+	if (pp->neta_armada3700)
+		cpu = 0;
+	else if (txq_number > 1)
 		cpu = txq->id % num_present_cpus();
 	else
 		cpu = pp->rxq_def % num_present_cpus();
@@ -3667,6 +3669,11 @@ static int mvneta_cpu_online(unsigned int cpu, struct hlist_node *node)
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



