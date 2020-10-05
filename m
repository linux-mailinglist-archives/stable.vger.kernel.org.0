Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954A0283987
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgJEP1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgJEP1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:27:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8442E20874;
        Mon,  5 Oct 2020 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911621;
        bh=taaef21lw35xaPlY/fj6bPvHcf5PI4zenGANS9t1kgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bE1uGx7PG24+VppPIKF4EuBY67SLYfsFcpX2l7hRtoLFL58iwDKFxA1WvFnOwmGC4
         ymixWPJMPFWX2qyblqZ8QGHlFpKWK5yb3E7mIvvA/fhuXu6Qs9FrTLnifFxEhF72Nj
         LORevIkAcxTbo5INVqyy0wSHVwJ5uWMAz5VAoC3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/38] vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock
Date:   Mon,  5 Oct 2020 17:26:23 +0200
Message-Id: <20201005142108.963891179@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142108.650363140@linuxfoundation.org>
References: <20201005142108.650363140@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 9c7a5582f5d720dc35cfcc42ccaded69f0642e4a ]

Some callbacks used by the upper layers can run while we are in the
.remove(). A potential use-after-free can happen, because we free
the_virtio_vsock without knowing if the callbacks are over or not.

To solve this issue we move the assignment of the_virtio_vsock at the
end of .probe(), when we finished all the initialization, and at the
beginning of .remove(), before to release resources.
For the same reason, we do the same also for the vdev->priv.

We use RCU to be sure that all callbacks that use the_virtio_vsock
ended before freeing it. This is not required for callbacks that
use vdev->priv, because after the vdev->config->del_vqs() we are sure
that they are ended and will no longer be invoked.

We also take the mutex during the .remove() to avoid that .probe() can
run while we are resetting the device.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport.c | 70 +++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 96ab344f17bbc..68186419c445f 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -66,19 +66,22 @@ struct virtio_vsock {
 	u32 guest_cid;
 };
 
-static struct virtio_vsock *virtio_vsock_get(void)
-{
-	return the_virtio_vsock;
-}
-
 static u32 virtio_transport_get_local_cid(void)
 {
-	struct virtio_vsock *vsock = virtio_vsock_get();
+	struct virtio_vsock *vsock;
+	u32 ret;
 
-	if (!vsock)
-		return VMADDR_CID_ANY;
+	rcu_read_lock();
+	vsock = rcu_dereference(the_virtio_vsock);
+	if (!vsock) {
+		ret = VMADDR_CID_ANY;
+		goto out_rcu;
+	}
 
-	return vsock->guest_cid;
+	ret = vsock->guest_cid;
+out_rcu:
+	rcu_read_unlock();
+	return ret;
 }
 
 static void virtio_transport_loopback_work(struct work_struct *work)
@@ -198,14 +201,18 @@ virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 	struct virtio_vsock *vsock;
 	int len = pkt->len;
 
-	vsock = virtio_vsock_get();
+	rcu_read_lock();
+	vsock = rcu_dereference(the_virtio_vsock);
 	if (!vsock) {
 		virtio_transport_free_pkt(pkt);
-		return -ENODEV;
+		len = -ENODEV;
+		goto out_rcu;
 	}
 
-	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid)
-		return virtio_transport_send_pkt_loopback(vsock, pkt);
+	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid) {
+		len = virtio_transport_send_pkt_loopback(vsock, pkt);
+		goto out_rcu;
+	}
 
 	if (pkt->reply)
 		atomic_inc(&vsock->queued_replies);
@@ -215,6 +222,9 @@ virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 	spin_unlock_bh(&vsock->send_pkt_list_lock);
 
 	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
+
+out_rcu:
+	rcu_read_unlock();
 	return len;
 }
 
@@ -223,12 +233,14 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct virtio_vsock *vsock;
 	struct virtio_vsock_pkt *pkt, *n;
-	int cnt = 0;
+	int cnt = 0, ret;
 	LIST_HEAD(freeme);
 
-	vsock = virtio_vsock_get();
+	rcu_read_lock();
+	vsock = rcu_dereference(the_virtio_vsock);
 	if (!vsock) {
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_rcu;
 	}
 
 	spin_lock_bh(&vsock->send_pkt_list_lock);
@@ -256,7 +268,11 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 			queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 	}
 
-	return 0;
+	ret = 0;
+
+out_rcu:
+	rcu_read_unlock();
+	return ret;
 }
 
 static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
@@ -566,7 +582,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 		return ret;
 
 	/* Only one virtio-vsock device per guest is supported */
-	if (the_virtio_vsock) {
+	if (rcu_dereference_protected(the_virtio_vsock,
+				lockdep_is_held(&the_virtio_vsock_mutex))) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -591,8 +608,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vsock->rx_buf_max_nr = 0;
 	atomic_set(&vsock->queued_replies, 0);
 
-	vdev->priv = vsock;
-	the_virtio_vsock = vsock;
 	mutex_init(&vsock->tx_lock);
 	mutex_init(&vsock->rx_lock);
 	mutex_init(&vsock->event_lock);
@@ -614,6 +629,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	virtio_vsock_event_fill(vsock);
 	mutex_unlock(&vsock->event_lock);
 
+	vdev->priv = vsock;
+	rcu_assign_pointer(the_virtio_vsock, vsock);
+
 	mutex_unlock(&the_virtio_vsock_mutex);
 	return 0;
 
@@ -628,6 +646,12 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	struct virtio_vsock *vsock = vdev->priv;
 	struct virtio_vsock_pkt *pkt;
 
+	mutex_lock(&the_virtio_vsock_mutex);
+
+	vdev->priv = NULL;
+	rcu_assign_pointer(the_virtio_vsock, NULL);
+	synchronize_rcu();
+
 	flush_work(&vsock->loopback_work);
 	flush_work(&vsock->rx_work);
 	flush_work(&vsock->tx_work);
@@ -667,12 +691,10 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	}
 	spin_unlock_bh(&vsock->loopback_list_lock);
 
-	mutex_lock(&the_virtio_vsock_mutex);
-	the_virtio_vsock = NULL;
-	mutex_unlock(&the_virtio_vsock_mutex);
-
 	vdev->config->del_vqs(vdev);
 
+	mutex_unlock(&the_virtio_vsock_mutex);
+
 	kfree(vsock);
 }
 
-- 
2.25.1



