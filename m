Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AFD28B6AB
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbgJLNgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730868AbgJLNfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3937B2074F;
        Mon, 12 Oct 2020 13:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509752;
        bh=5gIp2ADyAyFMb59jSVGzJtWs1+8nMdYs+8Bal17LoZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iK/fNqK8OOvgeo3HhHkJdLC/s77ONEjLxj4cCQ+Yi5V0bWx5+1PhoZL9dE0PbvvNQ
         I7AUvsb+lK0DGq1M3p2UdOJK6b7SroCDiw0Pj6//U9wChVj2UZHcGZDcSo3ynGN5ne
         f4SLrGQU8Gtyp/SXd3DDievcJJ1NtQo2YW3Eqyvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/70] vsock/virtio: stop workers during the .remove()
Date:   Mon, 12 Oct 2020 15:26:18 +0200
Message-Id: <20201012132630.322621560@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 17dd1367389cfe7f150790c83247b68e0c19d106 ]

Before to call vdev->config->reset(vdev) we need to be sure that
no one is accessing the device, for this reason, we add new variables
in the struct virtio_vsock to stop the workers during the .remove().

This patch also add few comments before vdev->config->reset(vdev)
and vdev->config->del_vqs(vdev).

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport.c | 51 +++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 68186419c445f..4bc217ef56945 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -39,6 +39,7 @@ struct virtio_vsock {
 	 * must be accessed with tx_lock held.
 	 */
 	struct mutex tx_lock;
+	bool tx_run;
 
 	struct work_struct send_pkt_work;
 	spinlock_t send_pkt_list_lock;
@@ -54,6 +55,7 @@ struct virtio_vsock {
 	 * must be accessed with rx_lock held.
 	 */
 	struct mutex rx_lock;
+	bool rx_run;
 	int rx_buf_nr;
 	int rx_buf_max_nr;
 
@@ -61,6 +63,7 @@ struct virtio_vsock {
 	 * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
 	 */
 	struct mutex event_lock;
+	bool event_run;
 	struct virtio_vsock_event event_list[8];
 
 	u32 guest_cid;
@@ -95,6 +98,10 @@ static void virtio_transport_loopback_work(struct work_struct *work)
 	spin_unlock_bh(&vsock->loopback_list_lock);
 
 	mutex_lock(&vsock->rx_lock);
+
+	if (!vsock->rx_run)
+		goto out;
+
 	while (!list_empty(&pkts)) {
 		struct virtio_vsock_pkt *pkt;
 
@@ -103,6 +110,7 @@ static void virtio_transport_loopback_work(struct work_struct *work)
 
 		virtio_transport_recv_pkt(pkt);
 	}
+out:
 	mutex_unlock(&vsock->rx_lock);
 }
 
@@ -131,6 +139,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 	mutex_lock(&vsock->tx_lock);
 
+	if (!vsock->tx_run)
+		goto out;
+
 	vq = vsock->vqs[VSOCK_VQ_TX];
 
 	for (;;) {
@@ -189,6 +200,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 	if (added)
 		virtqueue_kick(vq);
 
+out:
 	mutex_unlock(&vsock->tx_lock);
 
 	if (restart_rx)
@@ -324,6 +336,10 @@ static void virtio_transport_tx_work(struct work_struct *work)
 
 	vq = vsock->vqs[VSOCK_VQ_TX];
 	mutex_lock(&vsock->tx_lock);
+
+	if (!vsock->tx_run)
+		goto out;
+
 	do {
 		struct virtio_vsock_pkt *pkt;
 		unsigned int len;
@@ -334,6 +350,8 @@ static void virtio_transport_tx_work(struct work_struct *work)
 			added = true;
 		}
 	} while (!virtqueue_enable_cb(vq));
+
+out:
 	mutex_unlock(&vsock->tx_lock);
 
 	if (added)
@@ -362,6 +380,9 @@ static void virtio_transport_rx_work(struct work_struct *work)
 
 	mutex_lock(&vsock->rx_lock);
 
+	if (!vsock->rx_run)
+		goto out;
+
 	do {
 		virtqueue_disable_cb(vq);
 		for (;;) {
@@ -471,6 +492,9 @@ static void virtio_transport_event_work(struct work_struct *work)
 
 	mutex_lock(&vsock->event_lock);
 
+	if (!vsock->event_run)
+		goto out;
+
 	do {
 		struct virtio_vsock_event *event;
 		unsigned int len;
@@ -485,7 +509,7 @@ static void virtio_transport_event_work(struct work_struct *work)
 	} while (!virtqueue_enable_cb(vq));
 
 	virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
-
+out:
 	mutex_unlock(&vsock->event_lock);
 }
 
@@ -621,12 +645,18 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 	INIT_WORK(&vsock->loopback_work, virtio_transport_loopback_work);
 
+	mutex_lock(&vsock->tx_lock);
+	vsock->tx_run = true;
+	mutex_unlock(&vsock->tx_lock);
+
 	mutex_lock(&vsock->rx_lock);
 	virtio_vsock_rx_fill(vsock);
+	vsock->rx_run = true;
 	mutex_unlock(&vsock->rx_lock);
 
 	mutex_lock(&vsock->event_lock);
 	virtio_vsock_event_fill(vsock);
+	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
 	vdev->priv = vsock;
@@ -661,6 +691,24 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	/* Reset all connected sockets when the device disappear */
 	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
 
+	/* Stop all work handlers to make sure no one is accessing the device,
+	 * so we can safely call vdev->config->reset().
+	 */
+	mutex_lock(&vsock->rx_lock);
+	vsock->rx_run = false;
+	mutex_unlock(&vsock->rx_lock);
+
+	mutex_lock(&vsock->tx_lock);
+	vsock->tx_run = false;
+	mutex_unlock(&vsock->tx_lock);
+
+	mutex_lock(&vsock->event_lock);
+	vsock->event_run = false;
+	mutex_unlock(&vsock->event_lock);
+
+	/* Flush all device writes and interrupts, device will not use any
+	 * more buffers.
+	 */
 	vdev->config->reset(vdev);
 
 	mutex_lock(&vsock->rx_lock);
@@ -691,6 +739,7 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	}
 	spin_unlock_bh(&vsock->loopback_list_lock);
 
+	/* Delete virtqueues and flush outstanding callbacks if any */
 	vdev->config->del_vqs(vdev);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.25.1



