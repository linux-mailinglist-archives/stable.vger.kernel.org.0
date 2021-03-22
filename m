Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17576344149
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhCVMcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231299AbhCVMbf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DADA2619A8;
        Mon, 22 Mar 2021 12:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416295;
        bh=ejwbeehcbsg5J+1zLmhrtDCxcqjFz5xG6qEf599DLOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXA49x9pKjuxJrl9IyA2QgG9hitopNdkcWwEB/PXfWafMEIYx/Gw6B1wFOeYeiDaA
         F5GCn3WVHTMpohpHaJcRh1GeDJiiOPoC2h6ymaOX4d+X5EcRqANHbwwUOoFTU4wFKU
         733f2Lx18xMynw8DMPJa9f93vcF8pwAkYCQP2slE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gautam Dawar <gdawar.xilinx@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.11 052/120] vhost_vdpa: fix the missing irq_bypass_unregister_producer() invocation
Date:   Mon, 22 Mar 2021 13:27:15 +0100
Message-Id: <20210322121931.421888960@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gautam Dawar <gdawar.xilinx@gmail.com>

commit 4c050286bb202cffd5467c1cba982dff391d62e1 upstream.

When qemu with vhost-vdpa netdevice is run for the first time,
it works well. But after the VM is powered off, the next qemu run
causes kernel panic due to a NULL pointer dereference in
irq_bypass_register_producer().

When the VM is powered off, vhost_vdpa_clean_irq() misses on calling
irq_bypass_unregister_producer() for irq 0 because of the existing check.

This leaves stale producer nodes, which are reset in
vhost_vring_call_reset() when vhost_dev_init() is invoked during the
second qemu run.

As the node member of struct irq_bypass_producer is also initialized
to zero, traversal on the producers list causes crash due to NULL
pointer dereference.

Fixes: 2cf1ba9a4d15c ("vhost_vdpa: implement IRQ offloading in vhost_vdpa")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211711
Signed-off-by: Gautam Dawar <gdawar.xilinx@gmail.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210224114845.104173-1-gdawar.xilinx@gmail.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vdpa.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -906,14 +906,10 @@ err:
 
 static void vhost_vdpa_clean_irq(struct vhost_vdpa *v)
 {
-	struct vhost_virtqueue *vq;
 	int i;
 
-	for (i = 0; i < v->nvqs; i++) {
-		vq = &v->vqs[i];
-		if (vq->call_ctx.producer.irq)
-			irq_bypass_unregister_producer(&vq->call_ctx.producer);
-	}
+	for (i = 0; i < v->nvqs; i++)
+		vhost_vdpa_unsetup_vq_irq(v, i);
 }
 
 static int vhost_vdpa_release(struct inode *inode, struct file *filep)


