Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840984417A3
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhKAJiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233300AbhKAJgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 501046127C;
        Mon,  1 Nov 2021 09:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758781;
        bh=jiK+PCob6Sk2ymDtepSMnFrxqelL0ZC47dy5ShLG2ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+Iv+ahSkdtE5KiN5fDJZjpfWn4xcFL03F0KyQknWS3jT1OFTrYmkY0ayiXVSDYT3
         2RIgR6LxjSqZeO3OLInt7EnyDTNk9JRyl/0KpzasOcgju/btJgGSdPvgULsdSHbZtH
         txPIJz805m6bJa/w75hXPfOlqs8tZOcgMdq8Wskk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 56/77] mlxsw: pci: Recycle received packet upon allocation failure
Date:   Mon,  1 Nov 2021 10:17:44 +0100
Message-Id: <20211101082523.466579976@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

commit 759635760a804b0d8ad0cc677b650f1544cae22f upstream.

When the driver fails to allocate a new Rx buffer, it passes an empty Rx
descriptor (contains zero address and size) to the device and marks it
as invalid by setting the skb pointer in the descriptor's metadata to
NULL.

After processing enough Rx descriptors, the driver will try to process
the invalid descriptor, but will return immediately seeing that the skb
pointer is NULL. Since the driver no longer passes new Rx descriptors to
the device, the Rx queue will eventually become full and the device will
start to drop packets.

Fix this by recycling the received packet if allocation of the new
packet failed. This means that allocation is no longer performed at the
end of the Rx routine, but at the start, before tearing down the DMA
mapping of the received packet.

Remove the comment about the descriptor being zeroed as it is no longer
correct. This is OK because we either use the descriptor as-is (when
recycling) or overwrite its address and size fields with that of the
newly allocated Rx buffer.

The issue was discovered when a process ("perf") consumed too much
memory and put the system under memory pressure. It can be reproduced by
injecting slab allocation failures [1]. After the fix, the Rx queue no
longer comes to a halt.

[1]
 # echo 10 > /sys/kernel/debug/failslab/times
 # echo 1000 > /sys/kernel/debug/failslab/interval
 # echo 100 > /sys/kernel/debug/failslab/probability

 FAULT_INJECTION: forcing a failure.
 name failslab, interval 1000, probability 100, space 0, times 8
 [...]
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x34/0x44
  should_fail.cold+0x32/0x37
  should_failslab+0x5/0x10
  kmem_cache_alloc_node+0x23/0x190
  __alloc_skb+0x1f9/0x280
  __netdev_alloc_skb+0x3a/0x150
  mlxsw_pci_rdq_skb_alloc+0x24/0x90
  mlxsw_pci_cq_tasklet+0x3dc/0x1200
  tasklet_action_common.constprop.0+0x9f/0x100
  __do_softirq+0xb5/0x252
  irq_exit_rcu+0x7a/0xa0
  common_interrupt+0x83/0xa0
  </IRQ>
  asm_common_interrupt+0x1e/0x40
 RIP: 0010:cpuidle_enter_state+0xc8/0x340
 [...]
 mlxsw_spectrum2 0000:06:00.0: Failed to alloc skb for RDQ

Fixes: eda6500a987a ("mlxsw: Add PCI bus implementation")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/20211024064014.1060919-1-idosch@idosch.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -353,13 +353,10 @@ static int mlxsw_pci_rdq_skb_alloc(struc
 	struct sk_buff *skb;
 	int err;
 
-	elem_info->u.rdq.skb = NULL;
 	skb = netdev_alloc_skb_ip_align(NULL, buf_len);
 	if (!skb)
 		return -ENOMEM;
 
-	/* Assume that wqe was previously zeroed. */
-
 	err = mlxsw_pci_wqe_frag_map(mlxsw_pci, wqe, 0, skb->data,
 				     buf_len, DMA_FROM_DEVICE);
 	if (err)
@@ -548,21 +545,26 @@ static void mlxsw_pci_cqe_rdq_handle(str
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 	struct mlxsw_pci_queue_elem_info *elem_info;
 	struct mlxsw_rx_info rx_info = {};
-	char *wqe;
+	char wqe[MLXSW_PCI_WQE_SIZE];
 	struct sk_buff *skb;
 	u16 byte_count;
 	int err;
 
 	elem_info = mlxsw_pci_queue_elem_info_consumer_get(q);
-	skb = elem_info->u.sdq.skb;
-	if (!skb)
-		return;
-	wqe = elem_info->elem;
-	mlxsw_pci_wqe_frag_unmap(mlxsw_pci, wqe, 0, DMA_FROM_DEVICE);
+	skb = elem_info->u.rdq.skb;
+	memcpy(wqe, elem_info->elem, MLXSW_PCI_WQE_SIZE);
 
 	if (q->consumer_counter++ != consumer_counter_limit)
 		dev_dbg_ratelimited(&pdev->dev, "Consumer counter does not match limit in RDQ\n");
 
+	err = mlxsw_pci_rdq_skb_alloc(mlxsw_pci, elem_info);
+	if (err) {
+		dev_err_ratelimited(&pdev->dev, "Failed to alloc skb for RDQ\n");
+		goto out;
+	}
+
+	mlxsw_pci_wqe_frag_unmap(mlxsw_pci, wqe, 0, DMA_FROM_DEVICE);
+
 	if (mlxsw_pci_cqe_lag_get(cqe_v, cqe)) {
 		rx_info.is_lag = true;
 		rx_info.u.lag_id = mlxsw_pci_cqe_lag_id_get(cqe_v, cqe);
@@ -594,10 +596,7 @@ static void mlxsw_pci_cqe_rdq_handle(str
 	skb_put(skb, byte_count);
 	mlxsw_core_skb_receive(mlxsw_pci->core, skb, &rx_info);
 
-	memset(wqe, 0, q->elem_size);
-	err = mlxsw_pci_rdq_skb_alloc(mlxsw_pci, elem_info);
-	if (err)
-		dev_dbg_ratelimited(&pdev->dev, "Failed to alloc skb for RDQ\n");
+out:
 	/* Everything is set up, ring doorbell to pass elem to HW */
 	q->producer_counter++;
 	mlxsw_pci_queue_doorbell_producer_ring(mlxsw_pci, q);


