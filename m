Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81F4328853
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238801AbhCARit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238040AbhCAR3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:29:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3068B64F1B;
        Mon,  1 Mar 2021 16:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617511;
        bh=CT1+ZZdTDKMrvwB13fXDFBIQUZEMvtdNQUU2734wyVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4zPzS9+H28xN7co+CQzdhfYJUMmFalyEB0+6dzRzYIDnQ2FTtnSgw8w73LIK/IKN
         rASzTqMxq7/Pnt9L7iJHdWYbfosAIZy4u+Km9Kjtfr2W+o/B3Jzoo0fy21jAN1Dm8C
         EuVI+/Fb9RNdgEmK/EYwQd+zRbbDZkz+pmEo9efQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/340] net: mvneta: Remove per-cpu queue mapping for Armada 3700
Date:   Mon,  1 Mar 2021 17:10:13 +0100
Message-Id: <20210301161051.719195119@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 94e3f8b869be4..7b0543056b101 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3027,7 +3027,9 @@ static int mvneta_txq_sw_init(struct mvneta_port *pp,
 	}
 
 	/* Setup XPS mapping */
-	if (txq_number > 1)
+	if (pp->neta_armada3700)
+		cpu = 0;
+	else if (txq_number > 1)
 		cpu = txq->id % num_present_cpus();
 	else
 		cpu = pp->rxq_def % num_present_cpus();
@@ -3764,6 +3766,11 @@ static int mvneta_cpu_online(unsigned int cpu, struct hlist_node *node)
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



