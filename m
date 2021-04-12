Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7CD35BF37
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbhDLJDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239858AbhDLJB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D145261354;
        Mon, 12 Apr 2021 08:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217978;
        bh=+evaxZaux8g2s6jvFO5jx2rp82SnMF/KzcOptjIjyM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIDhBiTSoicZeXnWZuRoEeSFQf/EULvGaY1cG2XPLO41VN3BxTXQm3/sUyVg9g7w5
         vN9pdLm6zFYluzEm79j5SW6zGCO9id+03SB5wtzsrNLHqAIf/+yMe2yXFJozFBKLot
         pE4weVLH4sYoZPorfKuLNu4zNNl/i0YxsfIpdkE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.11 027/210] IB/hfi1: Fix probe time panic when AIP is enabled with a buggy BIOS
Date:   Mon, 12 Apr 2021 10:38:52 +0200
Message-Id: <20210412084016.914709243@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

commit 5de61a47eb9064cbbc5f3360d639e8e34a690a54 upstream.

A panic can result when AIP is enabled:

  BUG: unable to handle kernel NULL pointer dereference at 000000000000000
  PGD 0 P4D 0
  Oops: 0000 1 SMP PTI
  CPU: 70 PID: 981 Comm: systemd-udevd Tainted: G OE --------- - - 4.18.0-240.el8.x86_64 #1
  Hardware name: Intel Corporation S2600KP/S2600KP, BIOS SE5C610.86B.01.01.0005.101720141054 10/17/2014
  RIP: 0010:__bitmap_and+0x1b/0x70
  RSP: 0018:ffff99aa0845f9f0 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff8d5a6fc18000 RCX: 0000000000000048
  RDX: 0000000000000000 RSI: ffffffffc06336f0 RDI: ffff8d5a8fa67750
  RBP: 0000000000000079 R08: 0000000fffffffff R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffc06336f0
  R13: 00000000000000a0 R14: ffff8d5a6fc18000 R15: 0000000000000003
  FS: 00007fec137a5980(0000) GS:ffff8d5a9fa80000(0000) knlGS:0000000000000000
  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000a04b48002 CR4: 00000000001606e0
  Call Trace:
  hfi1_num_netdev_contexts+0x7c/0x110 [hfi1]
  hfi1_init_dd+0xd7f/0x1a90 [hfi1]
  ? pci_bus_read_config_dword+0x49/0x70
  ? pci_mmcfg_read+0x3e/0xe0
  do_init_one.isra.18+0x336/0x640 [hfi1]
  local_pci_probe+0x41/0x90
  pci_device_probe+0x105/0x1c0
  really_probe+0x212/0x440
  driver_probe_device+0x49/0xc0
  device_driver_attach+0x50/0x60
  __driver_attach+0x61/0x130
  ? device_driver_attach+0x60/0x60
  bus_for_each_dev+0x77/0xc0
  ? klist_add_tail+0x3b/0x70
  bus_add_driver+0x14d/0x1e0
  ? dev_init+0x10b/0x10b [hfi1]
  driver_register+0x6b/0xb0
  ? dev_init+0x10b/0x10b [hfi1]
  hfi1_mod_init+0x1e6/0x20a [hfi1]
  do_one_initcall+0x46/0x1c3
  ? free_unref_page_commit+0x91/0x100
  ? _cond_resched+0x15/0x30
  ? kmem_cache_alloc_trace+0x140/0x1c0
  do_init_module+0x5a/0x220
  load_module+0x14b4/0x17e0
  ? __do_sys_finit_module+0xa8/0x110
  __do_sys_finit_module+0xa8/0x110
  do_syscall_64+0x5b/0x1a0

The issue happens when pcibus_to_node() returns NO_NUMA_NODE.

Fix this issue by moving the initialization of dd->node to hfi1_devdata
allocation and remove the other pcibus_to_node() calls in the probe path
and use dd->node instead.

Affinity logic is adjusted to use a new field dd->affinity_entry as a
guard instead of dd->node.

Fixes: 4730f4a6c6b2 ("IB/hfi1: Activate the dummy netdev")
Link: https://lore.kernel.org/r/1617025700-31865-4-git-send-email-dennis.dalessandro@cornelisnetworks.com
Cc: stable@vger.kernel.org
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/affinity.c  |   21 +++++----------------
 drivers/infiniband/hw/hfi1/hfi.h       |    1 +
 drivers/infiniband/hw/hfi1/init.c      |   10 +++++++++-
 drivers/infiniband/hw/hfi1/netdev_rx.c |    3 +--
 4 files changed, 16 insertions(+), 19 deletions(-)

--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -632,22 +632,11 @@ static void _dev_comp_vect_cpu_mask_clea
  */
 int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 {
-	int node = pcibus_to_node(dd->pcidev->bus);
 	struct hfi1_affinity_node *entry;
 	const struct cpumask *local_mask;
 	int curr_cpu, possible, i, ret;
 	bool new_entry = false;
 
-	/*
-	 * If the BIOS does not have the NUMA node information set, select
-	 * NUMA 0 so we get consistent performance.
-	 */
-	if (node < 0) {
-		dd_dev_err(dd, "Invalid PCI NUMA node. Performance may be affected\n");
-		node = 0;
-	}
-	dd->node = node;
-
 	local_mask = cpumask_of_node(dd->node);
 	if (cpumask_first(local_mask) >= nr_cpu_ids)
 		local_mask = topology_core_cpumask(0);
@@ -660,7 +649,7 @@ int hfi1_dev_affinity_init(struct hfi1_d
 	 * create an entry in the global affinity structure and initialize it.
 	 */
 	if (!entry) {
-		entry = node_affinity_allocate(node);
+		entry = node_affinity_allocate(dd->node);
 		if (!entry) {
 			dd_dev_err(dd,
 				   "Unable to allocate global affinity node\n");
@@ -751,6 +740,7 @@ int hfi1_dev_affinity_init(struct hfi1_d
 	if (new_entry)
 		node_affinity_add_tail(entry);
 
+	dd->affinity_entry = entry;
 	mutex_unlock(&node_affinity.lock);
 
 	return 0;
@@ -766,10 +756,9 @@ void hfi1_dev_affinity_clean_up(struct h
 {
 	struct hfi1_affinity_node *entry;
 
-	if (dd->node < 0)
-		return;
-
 	mutex_lock(&node_affinity.lock);
+	if (!dd->affinity_entry)
+		goto unlock;
 	entry = node_affinity_lookup(dd->node);
 	if (!entry)
 		goto unlock;
@@ -780,8 +769,8 @@ void hfi1_dev_affinity_clean_up(struct h
 	 */
 	_dev_comp_vect_cpu_mask_clean_up(dd, entry);
 unlock:
+	dd->affinity_entry = NULL;
 	mutex_unlock(&node_affinity.lock);
-	dd->node = NUMA_NO_NODE;
 }
 
 /*
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1409,6 +1409,7 @@ struct hfi1_devdata {
 	spinlock_t irq_src_lock;
 	int vnic_num_vports;
 	struct net_device *dummy_netdev;
+	struct hfi1_affinity_node *affinity_entry;
 
 	/* Keeps track of IPoIB RSM rule users */
 	atomic_t ipoib_rsm_usr_num;
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1277,7 +1277,6 @@ static struct hfi1_devdata *hfi1_alloc_d
 	dd->pport = (struct hfi1_pportdata *)(dd + 1);
 	dd->pcidev = pdev;
 	pci_set_drvdata(pdev, dd);
-	dd->node = NUMA_NO_NODE;
 
 	ret = xa_alloc_irq(&hfi1_dev_table, &dd->unit, dd, xa_limit_32b,
 			GFP_KERNEL);
@@ -1287,6 +1286,15 @@ static struct hfi1_devdata *hfi1_alloc_d
 		goto bail;
 	}
 	rvt_set_ibdev_name(&dd->verbs_dev.rdi, "%s_%d", class_name(), dd->unit);
+	/*
+	 * If the BIOS does not have the NUMA node information set, select
+	 * NUMA 0 so we get consistent performance.
+	 */
+	dd->node = pcibus_to_node(pdev->bus);
+	if (dd->node == NUMA_NO_NODE) {
+		dd_dev_err(dd, "Invalid PCI NUMA node. Performance may be affected\n");
+		dd->node = 0;
+	}
 
 	/*
 	 * Initialize all locks for the device. This needs to be as early as
--- a/drivers/infiniband/hw/hfi1/netdev_rx.c
+++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
@@ -173,8 +173,7 @@ u32 hfi1_num_netdev_contexts(struct hfi1
 		return 0;
 	}
 
-	cpumask_and(node_cpu_mask, cpu_mask,
-		    cpumask_of_node(pcibus_to_node(dd->pcidev->bus)));
+	cpumask_and(node_cpu_mask, cpu_mask, cpumask_of_node(dd->node));
 
 	available_cpus = cpumask_weight(node_cpu_mask);
 


