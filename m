Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307CF344218
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhCVMio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhCVMhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:37:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F10A4619B0;
        Mon, 22 Mar 2021 12:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416594;
        bh=O4s0c9JoysGQ5mVTheWhFvVgaK+FQc/o3HURvt+AD8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0Xy3uHO0Oyo3OIeFvYX9enN7sFxOQZWf+LYlFitZ+lb+PQOnHgngPDuzpF7HbtoF
         PZnM65ZobxM74K18mXv+y26lz+J5Vjgo6giv7l8JOhW6hnPNymVL6EpJ/Sz2EN3V2k
         Bx9i9gyb+5w6BVOc9ynHEplQz+QWQY0Yqf1KvAww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gautam Dawar <gdawar.xilinx@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 047/157] vhost_vdpa: fix the missing irq_bypass_unregister_producer() invocation
Date:   Mon, 22 Mar 2021 13:26:44 +0100
Message-Id: <20210322121935.241064318@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
@@ -910,14 +910,10 @@ err:
 
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


