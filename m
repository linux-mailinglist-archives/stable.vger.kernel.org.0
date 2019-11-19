Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D827610153C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfKSFmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730294AbfKSFl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DDF3208C3;
        Tue, 19 Nov 2019 05:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142118;
        bh=fNH4Qq25MAwaTI4SdJfjPmd7MjSxfVKnMDG2gOHHYAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRwLsxcZ7wi3E1qme7l95xt+m2NkkBieyPDaG+kLEI4/LY/88xpmJdYcAjvCrh/V2
         hstrX+THJAmgkhwb9fT2SQjRktIyEqZBpAGb41b/AdAx/C6q3MRgvyZw4ly8+csLm2
         mfpybepsrzk02mk0t5xaIrNfh7rt1f/NR1U5H6dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 357/422] vmbus: keep pointer to ring buffer page
Date:   Tue, 19 Nov 2019 06:19:14 +0100
Message-Id: <20191119051422.151656832@linuxfoundation.org>
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

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 52a42c2a90226dc61c99bbd0cb096deeb52c334b ]

Avoid going from struct page to virt address (and back) by just
keeping pointer to the allocated pages instead of virt address.

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel.c         | 20 +++++++++-----------
 drivers/uio/uio_hv_generic.c |  5 +++--
 include/linux/hyperv.h       |  2 +-
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index fdb0f832fadef..5e515533e9cdb 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -91,11 +91,14 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	unsigned long flags;
 	int ret, err = 0;
 	struct page *page;
+	unsigned int order;
 
 	if (send_ringbuffer_size % PAGE_SIZE ||
 	    recv_ringbuffer_size % PAGE_SIZE)
 		return -EINVAL;
 
+	order = get_order(send_ringbuffer_size + recv_ringbuffer_size);
+
 	spin_lock_irqsave(&newchannel->lock, flags);
 	if (newchannel->state == CHANNEL_OPEN_STATE) {
 		newchannel->state = CHANNEL_OPENING_STATE;
@@ -110,21 +113,17 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	/* Allocate the ring buffer */
 	page = alloc_pages_node(cpu_to_node(newchannel->target_cpu),
-				GFP_KERNEL|__GFP_ZERO,
-				get_order(send_ringbuffer_size +
-				recv_ringbuffer_size));
+				GFP_KERNEL|__GFP_ZERO, order);
 
 	if (!page)
-		page = alloc_pages(GFP_KERNEL|__GFP_ZERO,
-				   get_order(send_ringbuffer_size +
-					     recv_ringbuffer_size));
+		page = alloc_pages(GFP_KERNEL|__GFP_ZERO, order);
 
 	if (!page) {
 		err = -ENOMEM;
 		goto error_set_chnstate;
 	}
 
-	newchannel->ringbuffer_pages = page_address(page);
+	newchannel->ringbuffer_page = page;
 	newchannel->ringbuffer_pagecount = (send_ringbuffer_size +
 					   recv_ringbuffer_size) >> PAGE_SHIFT;
 
@@ -239,8 +238,7 @@ error_free_gpadl:
 error_free_pages:
 	hv_ringbuffer_cleanup(&newchannel->outbound);
 	hv_ringbuffer_cleanup(&newchannel->inbound);
-	__free_pages(page,
-		     get_order(send_ringbuffer_size + recv_ringbuffer_size));
+	__free_pages(page, order);
 error_set_chnstate:
 	newchannel->state = CHANNEL_OPEN_STATE;
 	return err;
@@ -666,8 +664,8 @@ static int vmbus_close_internal(struct vmbus_channel *channel)
 	hv_ringbuffer_cleanup(&channel->outbound);
 	hv_ringbuffer_cleanup(&channel->inbound);
 
-	free_pages((unsigned long)channel->ringbuffer_pages,
-		get_order(channel->ringbuffer_pagecount * PAGE_SIZE));
+	__free_pages(channel->ringbuffer_page,
+		     get_order(channel->ringbuffer_pagecount << PAGE_SHIFT));
 
 out:
 	return ret;
diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index e401be8321ab5..170fa1f8f00e0 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -131,11 +131,12 @@ static int hv_uio_ring_mmap(struct file *filp, struct kobject *kobj,
 		= container_of(kobj, struct vmbus_channel, kobj);
 	struct hv_device *dev = channel->primary_channel->device_obj;
 	u16 q_idx = channel->offermsg.offer.sub_channel_index;
+	void *ring_buffer = page_address(channel->ringbuffer_page);
 
 	dev_dbg(&dev->device, "mmap channel %u pages %#lx at %#lx\n",
 		q_idx, vma_pages(vma), vma->vm_pgoff);
 
-	return vm_iomap_memory(vma, virt_to_phys(channel->ringbuffer_pages),
+	return vm_iomap_memory(vma, virt_to_phys(ring_buffer),
 			       channel->ringbuffer_pagecount << PAGE_SHIFT);
 }
 
@@ -224,7 +225,7 @@ hv_uio_probe(struct hv_device *dev,
 	/* mem resources */
 	pdata->info.mem[TXRX_RING_MAP].name = "txrx_rings";
 	pdata->info.mem[TXRX_RING_MAP].addr
-		= (uintptr_t)dev->channel->ringbuffer_pages;
+		= (uintptr_t)page_address(dev->channel->ringbuffer_page);
 	pdata->info.mem[TXRX_RING_MAP].size
 		= dev->channel->ringbuffer_pagecount << PAGE_SHIFT;
 	pdata->info.mem[TXRX_RING_MAP].memtype = UIO_MEM_LOGICAL;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index bbde887ed3931..c43e694fef7dd 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -739,7 +739,7 @@ struct vmbus_channel {
 	u32 ringbuffer_gpadlhandle;
 
 	/* Allocated memory for ring buffer */
-	void *ringbuffer_pages;
+	struct page *ringbuffer_page;
 	u32 ringbuffer_pagecount;
 	struct hv_ring_buffer_info outbound;	/* send to parent */
 	struct hv_ring_buffer_info inbound;	/* receive from parent */
-- 
2.20.1



