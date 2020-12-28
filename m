Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658BF2E3B9F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407054AbgL1Nwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:52:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407115AbgL1Nwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62A002072C;
        Mon, 28 Dec 2020 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163508;
        bh=bmNgRTxWozi8gjgcCMuA96egiw+HgS/DBgxVB2JDmyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ij+pYcRZmYFgKdtocuj1PsrUzmOBkZGhHSfQuRG6wEV+MhkhVVAKLYYR1WHvQtFwr
         ZBeTmzGqm7N1ZeR7lH+81+IJ6oFIv+nLdM49awPvgM0qdhVpyVWHfZzAX7ov9fa+ct
         urBTgBwTTaYajevTmbsdd3fqT/qBq9ydoLztYT94=
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
Subject: [PATCH 5.4 303/453] virtio_ring: Cut and paste bugs in vring_create_virtqueue_packed()
Date:   Mon, 28 Dec 2020 13:48:59 +0100
Message-Id: <20201228124951.788689418@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ae93d8ea0fa701e84ab9df0db9fb60ec6c80d7b8 ]

There is a copy and paste bug in the error handling of this code and
it uses "ring_dma_addr" three times instead of "device_event_dma_addr"
and "driver_event_dma_addr".

Fixes: 1ce9e6055fa0 (" virtio_ring: introduce packed ring support")
Reported-by: Robert Buhren <robert.buhren@sect.tu-berlin.de>
Reported-by: Felicitas Hetzelt <file@sect.tu-berlin.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X8pGRJlEzyn+04u2@mwanda
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4f7c73e6052f6..e3e8cab81abdf 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1676,9 +1676,9 @@ err_desc_extra:
 err_desc_state:
 	kfree(vq);
 err_vq:
-	vring_free_queue(vdev, event_size_in_bytes, device, ring_dma_addr);
+	vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
 err_device:
-	vring_free_queue(vdev, event_size_in_bytes, driver, ring_dma_addr);
+	vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dma_addr);
 err_driver:
 	vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
 err_ring:
-- 
2.27.0



