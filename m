Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6992E402A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439190AbgL1OWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441686AbgL1OWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D649520731;
        Mon, 28 Dec 2020 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165319;
        bh=DT+JgyDmWanLqDIAzzZ+1jqPi8DVkBgpjT3FkD4Z/c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYY/qPjf5qQYwnPY0Bl1qtHc1ITdrfPUwOeRumrVC2bFxTHUK9C1Oyferm+pWXniW
         1Dx7KKVrYUQ2XgxHU1tkuMvAPSKuOj5qO6Y4bZxd+jplb1QnjL/kza0n6cvIkR8eNX
         +qJhgG0Q0M9poPSK2yL5dwztKDaDoQgddlLCSb+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Robert Buhren <robert.buhren@sect.tu-berlin.de>,
        Felicitas Hetzelt <file@sect.tu-berlin.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 491/717] virtio_ring: Fix two use after free bugs
Date:   Mon, 28 Dec 2020 13:48:09 +0100
Message-Id: <20201228125044.489456056@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e152d8af4220a05c9797591609151d404866beaa ]

The "vq" struct is added to the "vdev->vqs" list prematurely.  If we
encounter an error later in the function then the "vq" is freed, but
since it is still on the list that could lead to a use after free bug.

Fixes: cbeedb72b97a ("virtio_ring: allocate desc state for split ring separately")
Reported-by: Robert Buhren <robert.buhren@sect.tu-berlin.de>
Reported-by: Felicitas Hetzelt <file@sect.tu-berlin.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X8pGaG/zkI3jk8mk@mwanda
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 924b6b85376bd..71e16b53e9c18 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1608,7 +1608,6 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->num_added = 0;
 	vq->packed_ring = true;
 	vq->use_dma_api = vring_use_dma_api(vdev);
-	list_add_tail(&vq->vq.list, &vdev->vqs);
 #ifdef DEBUG
 	vq->in_use = false;
 	vq->last_add_time_valid = false;
@@ -1669,6 +1668,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 			cpu_to_le16(vq->packed.event_flags_shadow);
 	}
 
+	list_add_tail(&vq->vq.list, &vdev->vqs);
 	return &vq->vq;
 
 err_desc_extra:
@@ -2085,7 +2085,6 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->last_used_idx = 0;
 	vq->num_added = 0;
 	vq->use_dma_api = vring_use_dma_api(vdev);
-	list_add_tail(&vq->vq.list, &vdev->vqs);
 #ifdef DEBUG
 	vq->in_use = false;
 	vq->last_add_time_valid = false;
@@ -2127,6 +2126,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	memset(vq->split.desc_state, 0, vring.num *
 			sizeof(struct vring_desc_state_split));
 
+	list_add_tail(&vq->vq.list, &vdev->vqs);
 	return &vq->vq;
 }
 EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
-- 
2.27.0



