Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0DA10BF68
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfK0UjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728877AbfK0UjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:39:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BEE7215A5;
        Wed, 27 Nov 2019 20:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887152;
        bh=WtrCndhZCOt4K7hFDVg2mYom8qkt0Vjzm/evnWBH+ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZKvUJml/TMsKPRjC0D10uuhTSov4KUvSunVMw8aa9hhd/LyjDARcl0TQEo2VhTby
         3rDwJfQogpITFDWfILUT0poGnk/7KCKhJ4tLMNLmHahpltBKaS8rL4tjOGnuSREF2r
         r5EetMTwlh2qieh1SSNO+TyvzHi1stiXhOIlKKf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 117/132] virtio_console: dont tie bufs to a vq
Date:   Wed, 27 Nov 2019 21:31:48 +0100
Message-Id: <20191127203032.170467614@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
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
index 78aab6e246e13..1a566e3b16e07 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -417,7 +417,7 @@ static void reclaim_dma_bufs(void)
 	}
 }
 
-static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
+static struct port_buffer *alloc_buf(struct virtio_device *vdev, size_t buf_size,
 				     int pages)
 {
 	struct port_buffer *buf;
@@ -440,7 +440,7 @@ static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
 		return buf;
 	}
 
-	if (is_rproc_serial(vq->vdev)) {
+	if (is_rproc_serial(vdev)) {
 		/*
 		 * Allocate DMA memory from ancestor. When a virtio
 		 * device is created by remoteproc, the DMA memory is
@@ -450,9 +450,9 @@ static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
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
@@ -835,7 +835,7 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 
 	count = min((size_t)(32 * 1024), count);
 
-	buf = alloc_buf(port->out_vq, count, 0);
+	buf = alloc_buf(port->portdev->vdev, count, 0);
 	if (!buf)
 		return -ENOMEM;
 
@@ -954,7 +954,7 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
 	if (ret < 0)
 		goto error_out;
 
-	buf = alloc_buf(port->out_vq, 0, pipe->nrbufs);
+	buf = alloc_buf(port->portdev->vdev, 0, pipe->nrbufs);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto error_out;
@@ -1371,7 +1371,7 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 
 	nr_added_bufs = 0;
 	do {
-		buf = alloc_buf(vq, PAGE_SIZE, 0);
+		buf = alloc_buf(vq->vdev, PAGE_SIZE, 0);
 		if (!buf)
 			break;
 
-- 
2.20.1



