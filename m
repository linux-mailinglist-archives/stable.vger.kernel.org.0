Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DE1790A7
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 18:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfG2QTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 12:19:18 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49445 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728665AbfG2QTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 12:19:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B7D4B222FF;
        Mon, 29 Jul 2019 12:19:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 12:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HeJrE5
        +7hLtPdi8qOK+CIQ7U7iID91nxG+bPn8F6k2M=; b=FaAr3LfUqEwENufdUw8GXY
        dmen+1aKp/V9mFQj1nd2p40wyuWa/C7kS9z0ZExE2iGCWMg8jComNwW4eWvEtKwL
        nbwb+CDqd6qclFgOga07+YA9+cvubNP+3NHqowc1uUyE0l8xSCI9a71VX/jmgyr9
        v1W/hER+BD+t4qzyFuEqYDP/n/jaABPd/2k2YrNCnsEWM+HvSeunE8HRWSfTw0vf
        CcVDG6609+dRFtvpmkHzdW1hoR5+6/k8g/QKiMJGKmb0S7a/DEhIRZLbrrNOhND8
        t7quIDZi+N5CNPnnd3f2LG6vVpY42rQ4s1M1HyizB3DhtHTt7qIBNWP4xi+4vfEA
        ==
X-ME-Sender: <xms:hBw_XbjNh0i5khMxwlQ2FuoLFhpMNi2x0R7Ygrd3C_lhd-UY4zGnzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdellecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:hBw_XSxd_2Meuh5g_SiHi82_HIMKmndNDBf3Kmdf1VtJxYpaHJWWtQ>
    <xmx:hBw_XUYeNZq6akZHtNS0ktj8bzGLVGhjmO7ImFeRrhQV3yi6YvMSIQ>
    <xmx:hBw_XXAYtPiJLtfFbW5BLux1JqzqxYaCPh9MiLbwXM_A0YuXtvqKAA>
    <xmx:hBw_XXBmP6q-L3f8cO0qY0M2mfwr-8e8Lzg9mmSiHsNqpGbkNlwYJg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B671380079;
        Mon, 29 Jul 2019 12:19:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iommu/vt-d: Don't queue_iova() if there is no flush queue" failed to apply to 4.9-stable tree
To:     dima@arista.com, baolu.lu@linux.intel.com, dwmw2@infradead.org,
        joro@8bytes.org, jroedel@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jul 2019 18:19:14 +0200
Message-ID: <1564417154125183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From effa467870c7612012885df4e246bdb8ffd8e44c Mon Sep 17 00:00:00 2001
From: Dmitry Safonov <dima@arista.com>
Date: Tue, 16 Jul 2019 22:38:05 +0100
Subject: [PATCH] iommu/vt-d: Don't queue_iova() if there is no flush queue

Intel VT-d driver was reworked to use common deferred flushing
implementation. Previously there was one global per-cpu flush queue,
afterwards - one per domain.

Before deferring a flush, the queue should be allocated and initialized.

Currently only domains with IOMMU_DOMAIN_DMA type initialize their flush
queue. It's probably worth to init it for static or unmanaged domains
too, but it may be arguable - I'm leaving it to iommu folks.

Prevent queuing an iova flush if the domain doesn't have a queue.
The defensive check seems to be worth to keep even if queue would be
initialized for all kinds of domains. And is easy backportable.

On 4.19.43 stable kernel it has a user-visible effect: previously for
devices in si domain there were crashes, on sata devices:

 BUG: spinlock bad magic on CPU#6, swapper/0/1
  lock: 0xffff88844f582008, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
 CPU: 6 PID: 1 Comm: swapper/0 Not tainted 4.19.43 #1
 Call Trace:
  <IRQ>
  dump_stack+0x61/0x7e
  spin_bug+0x9d/0xa3
  do_raw_spin_lock+0x22/0x8e
  _raw_spin_lock_irqsave+0x32/0x3a
  queue_iova+0x45/0x115
  intel_unmap+0x107/0x113
  intel_unmap_sg+0x6b/0x76
  __ata_qc_complete+0x7f/0x103
  ata_qc_complete+0x9b/0x26a
  ata_qc_complete_multiple+0xd0/0xe3
  ahci_handle_port_interrupt+0x3ee/0x48a
  ahci_handle_port_intr+0x73/0xa9
  ahci_single_level_irq_intr+0x40/0x60
  __handle_irq_event_percpu+0x7f/0x19a
  handle_irq_event_percpu+0x32/0x72
  handle_irq_event+0x38/0x56
  handle_edge_irq+0x102/0x121
  handle_irq+0x147/0x15c
  do_IRQ+0x66/0xf2
  common_interrupt+0xf/0xf
 RIP: 0010:__do_softirq+0x8c/0x2df

The same for usb devices that use ehci-pci:
 BUG: spinlock bad magic on CPU#0, swapper/0/1
  lock: 0xffff88844f402008, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.19.43 #4
 Call Trace:
  <IRQ>
  dump_stack+0x61/0x7e
  spin_bug+0x9d/0xa3
  do_raw_spin_lock+0x22/0x8e
  _raw_spin_lock_irqsave+0x32/0x3a
  queue_iova+0x77/0x145
  intel_unmap+0x107/0x113
  intel_unmap_page+0xe/0x10
  usb_hcd_unmap_urb_setup_for_dma+0x53/0x9d
  usb_hcd_unmap_urb_for_dma+0x17/0x100
  unmap_urb_for_dma+0x22/0x24
  __usb_hcd_giveback_urb+0x51/0xc3
  usb_giveback_urb_bh+0x97/0xde
  tasklet_action_common.isra.4+0x5f/0xa1
  tasklet_action+0x2d/0x30
  __do_softirq+0x138/0x2df
  irq_exit+0x7d/0x8b
  smp_apic_timer_interrupt+0x10f/0x151
  apic_timer_interrupt+0xf/0x20
  </IRQ>
 RIP: 0010:_raw_spin_unlock_irqrestore+0x17/0x39

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: <stable@vger.kernel.org> # 4.14+
Fixes: 13cf01744608 ("iommu/vt-d: Make use of iova deferred flushing")
Signed-off-by: Dmitry Safonov <dima@arista.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 9b1d62d03370..72c6d647bec9 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3561,7 +3561,8 @@ static void intel_unmap(struct device *dev, dma_addr_t dev_addr, size_t size)
 
 	freelist = domain_unmap(domain, start_pfn, last_pfn);
 
-	if (intel_iommu_strict || (pdev && pdev->untrusted)) {
+	if (intel_iommu_strict || (pdev && pdev->untrusted) ||
+			!has_iova_flush_queue(&domain->iovad)) {
 		iommu_flush_iotlb_psi(iommu, domain, start_pfn,
 				      nrpages, !freelist, 0);
 		/* free iova */
diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index d499b2621239..8413ae54904a 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -54,9 +54,14 @@ init_iova_domain(struct iova_domain *iovad, unsigned long granule,
 }
 EXPORT_SYMBOL_GPL(init_iova_domain);
 
+bool has_iova_flush_queue(struct iova_domain *iovad)
+{
+	return !!iovad->fq;
+}
+
 static void free_iova_flush_queue(struct iova_domain *iovad)
 {
-	if (!iovad->fq)
+	if (!has_iova_flush_queue(iovad))
 		return;
 
 	if (timer_pending(&iovad->fq_timer))
@@ -74,13 +79,14 @@ static void free_iova_flush_queue(struct iova_domain *iovad)
 int init_iova_flush_queue(struct iova_domain *iovad,
 			  iova_flush_cb flush_cb, iova_entry_dtor entry_dtor)
 {
+	struct iova_fq __percpu *queue;
 	int cpu;
 
 	atomic64_set(&iovad->fq_flush_start_cnt,  0);
 	atomic64_set(&iovad->fq_flush_finish_cnt, 0);
 
-	iovad->fq = alloc_percpu(struct iova_fq);
-	if (!iovad->fq)
+	queue = alloc_percpu(struct iova_fq);
+	if (!queue)
 		return -ENOMEM;
 
 	iovad->flush_cb   = flush_cb;
@@ -89,13 +95,17 @@ int init_iova_flush_queue(struct iova_domain *iovad,
 	for_each_possible_cpu(cpu) {
 		struct iova_fq *fq;
 
-		fq = per_cpu_ptr(iovad->fq, cpu);
+		fq = per_cpu_ptr(queue, cpu);
 		fq->head = 0;
 		fq->tail = 0;
 
 		spin_lock_init(&fq->lock);
 	}
 
+	smp_wmb();
+
+	iovad->fq = queue;
+
 	timer_setup(&iovad->fq_timer, fq_flush_timeout, 0);
 	atomic_set(&iovad->fq_timer_on, 0);
 
diff --git a/include/linux/iova.h b/include/linux/iova.h
index 781b96ac706f..cd0f1de901a8 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -155,6 +155,7 @@ struct iova *reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
 void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
 void init_iova_domain(struct iova_domain *iovad, unsigned long granule,
 	unsigned long start_pfn);
+bool has_iova_flush_queue(struct iova_domain *iovad);
 int init_iova_flush_queue(struct iova_domain *iovad,
 			  iova_flush_cb flush_cb, iova_entry_dtor entry_dtor);
 struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn);
@@ -235,6 +236,11 @@ static inline void init_iova_domain(struct iova_domain *iovad,
 {
 }
 
+bool has_iova_flush_queue(struct iova_domain *iovad)
+{
+	return false;
+}
+
 static inline int init_iova_flush_queue(struct iova_domain *iovad,
 					iova_flush_cb flush_cb,
 					iova_entry_dtor entry_dtor)

