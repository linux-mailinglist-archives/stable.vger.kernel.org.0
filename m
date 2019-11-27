Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A2010BED7
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbfK0Uo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729668AbfK0Uoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:44:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBB3421780;
        Wed, 27 Nov 2019 20:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887494;
        bh=2RQazaZHdMRFzzw+CHytliBKPTuap16KOhaHKyHHtMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hr2i4D/aAHvmS0OtjzDeDibmDkXa524s5nbh9v0i/U72y2ag7+9OJ5eNRGzR4/2YB
         umvWbfZ5cfXI3/JAewLvB81BQbuuODyFQpZ/PEAZPJCx79b5pHDFlYdsBu6pOXya+6
         APKi9iHPtRHXHvYcpFE2rB0KFDdCs/voOiEBpjes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 133/151] virtio_console: dont tie bufs to a vq
Date:   Wed, 27 Nov 2019 21:31:56 +0100
Message-Id: <20191127203046.581934430@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 2855b33514d290c51d52d94e25d3ef942cd4d578 ]

an allocated buffer doesn't need to be tied to a vq -
only vq->vdev is ever used. Pass the function the
just what it needs - the vdev.

Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 43724bd8a0c0a..b09fc4553dc81 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -422,7 +422,7 @@ static void reclaim_dma_bufs(void)
 	}
 }
 
-static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
+static struct port_buffer *alloc_buf(struct virtio_device *vdev, size_t buf_size,
 				     int pages)
 {
 	struct port_buffer *buf;
@@ -445,7 +445,7 @@ static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
 		return buf;
 	}
 
-	if (is_rproc_serial(vq->vdev)) {
+	if (is_rproc_serial(vdev)) {
 		/*
 		 * Allocate DMA memory from ancestor. When a virtio
 		 * device is created by remoteproc, the DMA memory is
@@ -455,9 +455,9 @@ static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
 		 * DMA_MEMORY_INCLUDES_CHILDREN had been supported
 		 * in dma-coherent.c
 		 */
-		if (!vq->vdev->dev.parent || !vq->vdev->dev.parent->parent)
+		if (!vdev->dev.parent || !vdev->dev.parent->parent)
 			goto free_buf;
-		buf->dev = vq->vdev->dev.parent->parent;
+		buf->dev = vdev->dev.parent->parent;
 
 		/* Increase device refcnt to avoid freeing it */
 		get_device(buf->dev);
@@ -841,7 +841,7 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 
 	count = min((size_t)(32 * 1024), count);
 
-	buf = alloc_buf(port->out_vq, count, 0);
+	buf = alloc_buf(port->portdev->vdev, count, 0);
 	if (!buf)
 		return -ENOMEM;
 
@@ -960,7 +960,7 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
 	if (ret < 0)
 		goto error_out;
 
-	buf = alloc_buf(port->out_vq, 0, pipe->nrbufs);
+	buf = alloc_buf(port->portdev->vdev, 0, pipe->nrbufs);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto error_out;
@@ -1377,7 +1377,7 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 
 	nr_added_bufs = 0;
 	do {
-		buf = alloc_buf(vq, PAGE_SIZE, 0);
+		buf = alloc_buf(vq->vdev, PAGE_SIZE, 0);
 		if (!buf)
 			break;
 
-- 
2.20.1



