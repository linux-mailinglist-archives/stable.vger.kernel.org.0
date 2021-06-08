Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21EE3A030F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhFHTMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237560AbhFHTKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:10:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0212161943;
        Tue,  8 Jun 2021 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178118;
        bh=qH5xIdQ7LgjmBkJxxscQt//uOLHFDg2mglxvBmvwqK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXQEVpSnYpY/FldUhLgF9PSr7qfGfZnXwTeeZUYCduXE3IwN0zGcz+9kdmdgjAUWY
         JTrZLRrM56Tkm8/FaaIZh2DrDPSfWcZ3jodNyD3412mj7X9/eiwtuVbhxEY7HnNpUO
         FNOy0yUuo6WwrDpZk4bR0aNLtN0mNs4zrpWuW6To=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 049/161] ice: track AF_XDP ZC enabled queues in bitmap
Date:   Tue,  8 Jun 2021 20:26:19 +0200
Message-Id: <20210608175947.130220534@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit e102db780e1c14f10c70dafa7684af22a745b51d ]

Commit c7a219048e45 ("ice: Remove xsk_buff_pool from VSI structure")
silently introduced a regression and broke the Tx side of AF_XDP in copy
mode. xsk_pool on ice_ring is set only based on the existence of the XDP
prog on the VSI which in turn picks ice_clean_tx_irq_zc to be executed.
That is not something that should happen for copy mode as it should use
the regular data path ice_clean_tx_irq.

This results in a following splat when xdpsock is run in txonly or l2fwd
scenarios in copy mode:

<snip>
[  106.050195] BUG: kernel NULL pointer dereference, address: 0000000000000030
[  106.057269] #PF: supervisor read access in kernel mode
[  106.062493] #PF: error_code(0x0000) - not-present page
[  106.067709] PGD 0 P4D 0
[  106.070293] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  106.074721] CPU: 61 PID: 0 Comm: swapper/61 Not tainted 5.12.0-rc2+ #45
[  106.081436] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
[  106.092027] RIP: 0010:xp_raw_get_dma+0x36/0x50
[  106.096551] Code: 74 14 48 b8 ff ff ff ff ff ff 00 00 48 21 f0 48 c1 ee 30 48 01 c6 48 8b 87 90 00 00 00 48 89 f2 81 e6 ff 0f 00 00 48 c1 ea 0c <48> 8b 04 d0 48 83 e0 fe 48 01 f0 c3 66 66 2e 0f 1f 84 00 00 00 00
[  106.115588] RSP: 0018:ffffc9000d694e50 EFLAGS: 00010206
[  106.120893] RAX: 0000000000000000 RBX: ffff88984b8c8a00 RCX: ffff889852581800
[  106.128137] RDX: 0000000000000006 RSI: 0000000000000000 RDI: ffff88984cd8b800
[  106.135383] RBP: ffff888123b50001 R08: ffff889896800000 R09: 0000000000000800
[  106.142628] R10: 0000000000000000 R11: ffffffff826060c0 R12: 00000000000000ff
[  106.149872] R13: 0000000000000000 R14: 0000000000000040 R15: ffff888123b50018
[  106.157117] FS:  0000000000000000(0000) GS:ffff8897e0f40000(0000) knlGS:0000000000000000
[  106.165332] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.171163] CR2: 0000000000000030 CR3: 000000000560a004 CR4: 00000000007706e0
[  106.178408] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  106.185653] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  106.192898] PKRU: 55555554
[  106.195653] Call Trace:
[  106.198143]  <IRQ>
[  106.200196]  ice_clean_tx_irq_zc+0x183/0x2a0 [ice]
[  106.205087]  ice_napi_poll+0x3e/0x590 [ice]
[  106.209356]  __napi_poll+0x2a/0x160
[  106.212911]  net_rx_action+0xd6/0x200
[  106.216634]  __do_softirq+0xbf/0x29b
[  106.220274]  irq_exit_rcu+0x88/0xc0
[  106.223819]  common_interrupt+0x7b/0xa0
[  106.227719]  </IRQ>
[  106.229857]  asm_common_interrupt+0x1e/0x40
</snip>

Fix this by introducing the bitmap of queues that are zero-copy enabled,
where each bit, corresponding to a queue id that xsk pool is being
configured on, will be set/cleared within ice_xsk_pool_{en,dis}able and
checked within ice_xsk_pool(). The latter is a function used for
deciding which napi poll routine is executed.
Idea is being taken from our other drivers such as i40e and ixgbe.

Fixes: c7a219048e45 ("ice: Remove xsk_buff_pool from VSI structure")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h     |  8 +++++---
 drivers/net/ethernet/intel/ice/ice_lib.c | 10 ++++++++++
 drivers/net/ethernet/intel/ice/ice_xsk.c |  3 +++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 17101c45cbcd..f668296ca677 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -325,6 +325,7 @@ struct ice_vsi {
 	struct ice_tc_cfg tc_cfg;
 	struct bpf_prog *xdp_prog;
 	struct ice_ring **xdp_rings;	 /* XDP ring array */
+	unsigned long *af_xdp_zc_qps;	 /* tracks AF_XDP ZC enabled qps */
 	u16 num_xdp_txq;		 /* Used XDP queues */
 	u8 xdp_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */
 
@@ -534,15 +535,16 @@ static inline void ice_set_ring_xdp(struct ice_ring *ring)
  */
 static inline struct xsk_buff_pool *ice_xsk_pool(struct ice_ring *ring)
 {
+	struct ice_vsi *vsi = ring->vsi;
 	u16 qid = ring->q_index;
 
 	if (ice_ring_is_xdp(ring))
-		qid -= ring->vsi->num_xdp_txq;
+		qid -= vsi->num_xdp_txq;
 
-	if (!ice_is_xdp_ena_vsi(ring->vsi))
+	if (!ice_is_xdp_ena_vsi(vsi) || !test_bit(qid, vsi->af_xdp_zc_qps))
 		return NULL;
 
-	return xsk_get_pool_from_qid(ring->vsi->netdev, qid);
+	return xsk_get_pool_from_qid(vsi->netdev, qid);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 195d122c9cb2..9b38b2768884 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -105,8 +105,14 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 	if (!vsi->q_vectors)
 		goto err_vectors;
 
+	vsi->af_xdp_zc_qps = bitmap_zalloc(max_t(int, vsi->alloc_txq, vsi->alloc_rxq), GFP_KERNEL);
+	if (!vsi->af_xdp_zc_qps)
+		goto err_zc_qps;
+
 	return 0;
 
+err_zc_qps:
+	devm_kfree(dev, vsi->q_vectors);
 err_vectors:
 	devm_kfree(dev, vsi->rxq_map);
 err_rxq_map:
@@ -286,6 +292,10 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
 
 	dev = ice_pf_to_dev(pf);
 
+	if (vsi->af_xdp_zc_qps) {
+		bitmap_free(vsi->af_xdp_zc_qps);
+		vsi->af_xdp_zc_qps = NULL;
+	}
 	/* free the ring and vector containers */
 	if (vsi->q_vectors) {
 		devm_kfree(dev, vsi->q_vectors);
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 9f94d9159acd..47efc89a336f 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -273,6 +273,7 @@ static int ice_xsk_pool_disable(struct ice_vsi *vsi, u16 qid)
 	if (!pool)
 		return -EINVAL;
 
+	clear_bit(qid, vsi->af_xdp_zc_qps);
 	xsk_pool_dma_unmap(pool, ICE_RX_DMA_ATTR);
 
 	return 0;
@@ -303,6 +304,8 @@ ice_xsk_pool_enable(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	if (err)
 		return err;
 
+	set_bit(qid, vsi->af_xdp_zc_qps);
+
 	return 0;
 }
 
-- 
2.30.2



