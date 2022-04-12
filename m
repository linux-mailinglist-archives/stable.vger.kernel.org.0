Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C786B4FD57F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354144AbiDLHia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353581AbiDLHZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3DA43AE6;
        Tue, 12 Apr 2022 00:01:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C76B81A8F;
        Tue, 12 Apr 2022 07:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBB2C385A6;
        Tue, 12 Apr 2022 07:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746910;
        bh=vp7/qqClhnpA0UO7khQRIFogAEbd0t/N2cEVVt2Ldwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxYSkMlhL37yduVeoFWGug2Gmh4XKhZFLqqcvougtXAs/aVsPYxjoaBp8KhRpQYBY
         dPThomiKv8Oghh3AH6B7rfIL5E3khOw9qKqljyeN3UqCaPJq/qMrl0ivjg/9EH1tqc
         LIoJN6qjHKYGk26d3AN/c4tDYDBIilIvTlCU0YlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 175/285] bnxt_en: Synchronize tx when xdp redirects happen on same ring
Date:   Tue, 12 Apr 2022 08:30:32 +0200
Message-Id: <20220412062948.718876034@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 4f81def272de17dc4bbd89ac38f49b2676c9b3d2 ]

If there are more CPUs than the number of TX XDP rings, multiple XDP
redirects can select the same TX ring based on the CPU on which
XDP redirect is called.  Add locking when needed and use static
key to decide whether to take the lock.

Fixes: f18c2b77b2e4 ("bnxt_en: optimized XDP_REDIRECT support")
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 7 +++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 8 ++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h | 2 ++
 4 files changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fab8dd73fa84..fdbcd48d991d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3196,6 +3196,7 @@ static int bnxt_alloc_tx_rings(struct bnxt *bp)
 		}
 		qidx = bp->tc_to_qidx[j];
 		ring->queue_id = bp->q_info[qidx].queue_id;
+		spin_lock_init(&txr->xdp_tx_lock);
 		if (i < bp->tx_nr_rings_xdp)
 			continue;
 		if (i % bp->tx_nr_rings_per_tc == (bp->tx_nr_rings_per_tc - 1))
@@ -10274,6 +10275,12 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	if (irq_re_init)
 		udp_tunnel_nic_reset_ntf(bp->dev);
 
+	if (bp->tx_nr_rings_xdp < num_possible_cpus()) {
+		if (!static_key_enabled(&bnxt_xdp_locking_key))
+			static_branch_enable(&bnxt_xdp_locking_key);
+	} else if (static_key_enabled(&bnxt_xdp_locking_key)) {
+		static_branch_disable(&bnxt_xdp_locking_key);
+	}
 	set_bit(BNXT_STATE_OPEN, &bp->state);
 	bnxt_enable_int(bp);
 	/* Enable TX queues */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 2846d1475667..5f4a0bb36af3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -800,6 +800,8 @@ struct bnxt_tx_ring_info {
 	u32			dev_state;
 
 	struct bnxt_ring_struct	tx_ring_struct;
+	/* Synchronize simultaneous xdp_xmit on same ring */
+	spinlock_t		xdp_tx_lock;
 };
 
 #define BNXT_LEGACY_COAL_CMPL_PARAMS					\
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c8083df5e0ab..c59e46c7a1ca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -20,6 +20,8 @@
 #include "bnxt.h"
 #include "bnxt_xdp.h"
 
+DEFINE_STATIC_KEY_FALSE(bnxt_xdp_locking_key);
+
 struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   struct bnxt_tx_ring_info *txr,
 				   dma_addr_t mapping, u32 len)
@@ -227,6 +229,9 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 	ring = smp_processor_id() % bp->tx_nr_rings_xdp;
 	txr = &bp->tx_ring[ring];
 
+	if (static_branch_unlikely(&bnxt_xdp_locking_key))
+		spin_lock(&txr->xdp_tx_lock);
+
 	for (i = 0; i < num_frames; i++) {
 		struct xdp_frame *xdp = frames[i];
 
@@ -250,6 +255,9 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 		bnxt_db_write(bp, &txr->tx_db, txr->tx_prod);
 	}
 
+	if (static_branch_unlikely(&bnxt_xdp_locking_key))
+		spin_unlock(&txr->xdp_tx_lock);
+
 	return nxmit;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 0df40c3beb05..067bb5e821f5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -10,6 +10,8 @@
 #ifndef BNXT_XDP_H
 #define BNXT_XDP_H
 
+DECLARE_STATIC_KEY_FALSE(bnxt_xdp_locking_key);
+
 struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   struct bnxt_tx_ring_info *txr,
 				   dma_addr_t mapping, u32 len);
-- 
2.35.1



