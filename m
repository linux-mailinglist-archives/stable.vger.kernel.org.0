Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C1920E6FB
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391525AbgF2Vwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A55B246EB;
        Mon, 29 Jun 2020 15:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444032;
        bh=vabRyVgDkFUg3lNiwlmdoEUpny39lVxyEzxQS9PmrX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xY2HGCBzCWcXRC0YnqoOiFBFvs25R2qm0qdHzOLWW4WZ9F7UXZiOK9nxeIdPx/E5V
         TNm9bJEPwraWTDGGoKo6Z/NselJrWPkxoThAni0Td02oJ6LSBhofbMRRUAPtJZjQVD
         XuerHe2UPf8UxriBu5+Jx750K+fkgW2MdbhFZhb4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        Jonathan Toppins <jtoppins@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 140/265] ionic: tame the watchdog timer on reconfig
Date:   Mon, 29 Jun 2020 11:16:13 -0400
Message-Id: <20200629151818.2493727-141-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit b59eabd23ee53e8c3492602722e1697f9a2f63ad ]

Even with moving netif_tx_disable() to an earlier point when
taking down the queues for a reconfiguration, we still end
up with the occasional netdev watchdog Tx Timeout complaint.
The old method of using netif_trans_update() works fine for
queue 0, but has no effect on the remaining queues.  Using
netif_device_detach() allows us to signal to the watchdog to
ignore us for the moment.

Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Acked-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 2729b0bb12739..790d4854b8ef5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1682,8 +1682,8 @@ static void ionic_stop_queues(struct ionic_lif *lif)
 	if (!test_and_clear_bit(IONIC_LIF_F_UP, lif->state))
 		return;
 
-	ionic_txrx_disable(lif);
 	netif_tx_disable(lif->netdev);
+	ionic_txrx_disable(lif);
 }
 
 int ionic_stop(struct net_device *netdev)
@@ -1949,18 +1949,19 @@ int ionic_reset_queues(struct ionic_lif *lif)
 	bool running;
 	int err = 0;
 
-	/* Put off the next watchdog timeout */
-	netif_trans_update(lif->netdev);
-
 	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
 	if (err)
 		return err;
 
 	running = netif_running(lif->netdev);
-	if (running)
+	if (running) {
+		netif_device_detach(lif->netdev);
 		err = ionic_stop(lif->netdev);
-	if (!err && running)
+	}
+	if (!err && running) {
 		ionic_open(lif->netdev);
+		netif_device_attach(lif->netdev);
+	}
 
 	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
 
-- 
2.25.1

