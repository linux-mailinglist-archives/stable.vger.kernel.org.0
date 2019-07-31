Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD79B7C87A
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 18:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfGaQW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 12:22:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33097 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfGaQWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 12:22:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so70460798wru.0
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 09:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YeoiCtnIA3FCQkYyQ2M9I57lrfcnJ1UBrovIww+RCt4=;
        b=KgjtwTkHjHJ8fsNXl6PlPy7mG4VmX6LLDY1lX6kWxthKuznMchhjUn6wyu2oLq91yL
         dBrnGSZuzhm6UIbvHjHrX+Ypx/XpOrL5tw5BGUPyWrR+ZEc96mVHMiL7G56B7zIv+gfB
         DXmwk+4ORHruOsYk/Elvi5QI8YRTaFcz3vQZedERcygDi2sgbYb43zR4tZFERuZ3+U/M
         nzhTX5X/0CwzVmoOedZe41aEVU2alRiRJBKbm2xC5TNqDuaiUnY6+IG6JdY/R4GtjxAW
         Pa0NoQ5gBhW+T/T/kJSfHXO4WlnN12weP/t6sdgN71S13zoRgGKIC95iqq0LJZdrVx3i
         1BnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YeoiCtnIA3FCQkYyQ2M9I57lrfcnJ1UBrovIww+RCt4=;
        b=uIWYZ4inJzkisTkHU1MP+M1sI5EXBF5NY9KXduThu6DVOIiNDb+6tv79p5W1SAMSDy
         SQCQyrQnOCj5AXTVpPNQNtLpq0coiVO5WkLl8VVRzFXxvPXn1vDxGQQsQG92+iTTs37a
         liDSKKMorPvAA5Eu2aJbztnM9XndPmvfgodkecUQ0VWy9D07mWcuD8aD+jT4cxmF6q2+
         WfmQMfra8DtLTQvFOl+3E+pAvWuyC+NW9zR52gOd2G6Mgk/C+kmnR9d0zKgQO+SGtIvc
         u389p7FmkLa7gvBtPqkwoNZw2XA73gF26mD6e6JQBNz/kJCUQFkMaSgOfKvhf7F3mGQR
         XJGw==
X-Gm-Message-State: APjAAAWWtd4eMmhrkzzbmxezPTJxRSaQ4R7UAaNyFtOGety7/iG9cWA8
        gjHxCFqENtKDFwzpV6FNNHK/UMAq9r8EELHby991TOFhHi+EDm6FutNnvjSIkctahjB1oZCeEml
        O2xwyrKYzhw+nPS0tEfNY3W+4ki/xRxZnUJtPG5iv651p6sKdXtYf5asQIaftzHMqVLR5YJaX+j
        eXuQ9L8Fr/P/jyF+92zQ==
X-Google-Smtp-Source: APXvYqz9S7QmoPDz3fYMMdxHwzMODK+2Qg9W8Jc8SuEtzchh9SCFL7sC2p5OfuNzQEfSLFepKTkegw==
X-Received: by 2002:adf:f104:: with SMTP id r4mr45171126wro.140.1564590143270;
        Wed, 31 Jul 2019 09:22:23 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n9sm114557717wrp.54.2019.07.31.09.22.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 09:22:22 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     0x7f454c46@gmail.com, Dmitry Safonov <dima@arista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org
Subject: [PATCH-4.19-stable 1/2] iommu/vt-d: Don't queue_iova() if there is no flush queue
Date:   Wed, 31 Jul 2019 17:22:19 +0100
Message-Id: <20190731162220.24364-2-dima@arista.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731162220.24364-1-dima@arista.com>
References: <20190731162220.24364-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CLOUD-SEC-AV-Info: arista,google_mail,monitor
X-CLOUD-SEC-AV-Sent: true
X-Gm-Spam: 0
X-Gm-Phishy: 0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit effa467870c7612012885df4e246bdb8ffd8e44c ]

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
[v4.14-port notes:
o minor conflict with untrusted IOMMU devices check under if-condition]
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 drivers/iommu/intel-iommu.c |  2 +-
 drivers/iommu/iova.c        | 18 ++++++++++++++----
 include/linux/iova.h        |  6 ++++++
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c1439019dd12..b9af2419006f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3721,7 +3721,7 @@ static void intel_unmap(struct device *dev, dma_addr_t dev_addr, size_t size)
 
 	freelist = domain_unmap(domain, start_pfn, last_pfn);
 
-	if (intel_iommu_strict) {
+	if (intel_iommu_strict || !has_iova_flush_queue(&domain->iovad)) {
 		iommu_flush_iotlb_psi(iommu, domain, start_pfn,
 				      nrpages, !freelist, 0);
 		/* free iova */
diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 83fe2621effe..60348d707b99 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -65,9 +65,14 @@ init_iova_domain(struct iova_domain *iovad, unsigned long granule,
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
@@ -85,13 +90,14 @@ static void free_iova_flush_queue(struct iova_domain *iovad)
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
@@ -100,13 +106,17 @@ int init_iova_flush_queue(struct iova_domain *iovad,
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
index 928442dda565..073dc27d2e5f 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -156,6 +156,7 @@ struct iova *reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
 void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
 void init_iova_domain(struct iova_domain *iovad, unsigned long granule,
 	unsigned long start_pfn);
+bool has_iova_flush_queue(struct iova_domain *iovad);
 int init_iova_flush_queue(struct iova_domain *iovad,
 			  iova_flush_cb flush_cb, iova_entry_dtor entry_dtor);
 struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn);
@@ -236,6 +237,11 @@ static inline void init_iova_domain(struct iova_domain *iovad,
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
-- 
2.22.0

