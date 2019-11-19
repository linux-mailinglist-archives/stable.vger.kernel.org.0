Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0D51018DB
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKSGKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbfKSF0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 392FC21823;
        Tue, 19 Nov 2019 05:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141189;
        bh=LoGSwEhWqUDWuPoWcpmAiDNc+LQbBg12CiqsW0Xkyo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKkmEgQG7m+I1KYi6vpBRwsSQYbckk/17PRd6BNeAo34d2DgH8dF/JhjF+aKnWBgQ
         06mj30/kL8PuNzvadG02gmrkAY4IUn3Z6cNTvdyEqnkH9IfnUVkKPz4S6J1goBK4WH
         f/3ipNhDRL7p4O6yH/A9EctIPvpWH7zphzzqf+0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rick Farrington <ricardo.farrington@cavium.com>,
        Felix Manlunas <felix.manlunas@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/422] liquidio: fix race condition in instruction completion processing
Date:   Tue, 19 Nov 2019 06:14:32 +0100
Message-Id: <20191119051404.419226516@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rick Farrington <ricardo.farrington@cavium.com>

[ Upstream commit b943f17e06493fd2c7fd00743093ad5dcdb90e7f ]

In lio_enable_irq, the pkt_in_done count register was being cleared to
zero.  However, there could be some completed instructions which were not
yet processed due to budget and limit constraints.
So, only write this register with the number of actual completions
that were processed.

Signed-off-by: Rick Farrington <ricardo.farrington@cavium.com>
Signed-off-by: Felix Manlunas <felix.manlunas@cavium.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/octeon_device.c   | 5 +++--
 drivers/net/ethernet/cavium/liquidio/octeon_iq.h       | 2 ++
 drivers/net/ethernet/cavium/liquidio/request_manager.c | 2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
index f878a552fef3b..d0ed6c4f9e1a2 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
@@ -1450,8 +1450,9 @@ void lio_enable_irq(struct octeon_droq *droq, struct octeon_instr_queue *iq)
 	}
 	if (iq) {
 		spin_lock_bh(&iq->lock);
-		writel(iq->pkt_in_done, iq->inst_cnt_reg);
-		iq->pkt_in_done = 0;
+		writel(iq->pkts_processed, iq->inst_cnt_reg);
+		iq->pkt_in_done -= iq->pkts_processed;
+		iq->pkts_processed = 0;
 		/* this write needs to be flushed before we release the lock */
 		mmiowb();
 		spin_unlock_bh(&iq->lock);
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_iq.h b/drivers/net/ethernet/cavium/liquidio/octeon_iq.h
index 2327062e8af6b..aecd0d36d6349 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_iq.h
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_iq.h
@@ -94,6 +94,8 @@ struct octeon_instr_queue {
 
 	u32 pkt_in_done;
 
+	u32 pkts_processed;
+
 	/** A spinlock to protect access to the input ring.*/
 	spinlock_t iq_flush_running_lock;
 
diff --git a/drivers/net/ethernet/cavium/liquidio/request_manager.c b/drivers/net/ethernet/cavium/liquidio/request_manager.c
index 3deb3c07681fd..1d9ab7f4a2fef 100644
--- a/drivers/net/ethernet/cavium/liquidio/request_manager.c
+++ b/drivers/net/ethernet/cavium/liquidio/request_manager.c
@@ -123,6 +123,7 @@ int octeon_init_instr_queue(struct octeon_device *oct,
 	iq->do_auto_flush = 1;
 	iq->db_timeout = (u32)conf->db_timeout;
 	atomic_set(&iq->instr_pending, 0);
+	iq->pkts_processed = 0;
 
 	/* Initialize the spinlock for this instruction queue */
 	spin_lock_init(&iq->lock);
@@ -497,6 +498,7 @@ octeon_flush_iq(struct octeon_device *oct, struct octeon_instr_queue *iq,
 				lio_process_iq_request_list(oct, iq, 0);
 
 		if (inst_processed) {
+			iq->pkts_processed += inst_processed;
 			atomic_sub(inst_processed, &iq->instr_pending);
 			iq->stats.instr_processed += inst_processed;
 		}
-- 
2.20.1



