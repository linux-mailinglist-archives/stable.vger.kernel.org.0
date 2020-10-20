Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5567728398D
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgJEP1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgJEP1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:27:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAE50207BC;
        Mon,  5 Oct 2020 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911626;
        bh=WOq6F0OTwlG2u0z5gGFdWlRGkyN36j0oFsiui/6FhEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B71YoRrff5NuTM4TFm4AWFVKq8UvWIzbnodislaLi78nDp8JPs1dgZTvKgpenjPOe
         nEJc7OMGK45A5nDecxQwQ0fvY9y3KrTUGpCYsDx1yArTMPoifva7/7lilTtt1rUIEy
         crdOdKjJtMXOdbJiiGDg5XWIPON+Gj9V/+HusMMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/38] vsock/virtio: add transport parameter to the virtio_transport_reset_no_sock()
Date:   Mon,  5 Oct 2020 17:26:25 +0200
Message-Id: <20201005142109.064480304@linuxfoundation.org>
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

[ Upstream commit 4c7246dc45e2706770d5233f7ce1597a07e069ba ]

We are going to add 'struct vsock_sock *' parameter to
virtio_transport_get_ops().

In some cases, like in the virtio_transport_reset_no_sock(),
we don't have any socket assigned to the packet received,
so we can't use the virtio_transport_get_ops().

In order to allow virtio_transport_reset_no_sock() to use the
'.send_pkt' callback from the 'vhost_transport' or 'virtio_transport',
we add the 'struct virtio_transport *' to it and to its caller:
virtio_transport_recv_pkt().

We moved the 'vhost_transport' and 'virtio_transport' definition,
to pass their address to the virtio_transport_recv_pkt().

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c                   |  94 +++++++-------
 include/linux/virtio_vsock.h            |   3 +-
 net/vmw_vsock/virtio_transport.c        | 160 ++++++++++++------------
 net/vmw_vsock/virtio_transport_common.c |  12 +-
 4 files changed, 135 insertions(+), 134 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 7891bd40ebd82..6ee320259e4f7 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -383,6 +383,52 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
 	return val < vq->num;
 }
 
+static struct virtio_transport vhost_transport = {
+	.transport = {
+		.get_local_cid            = vhost_transport_get_local_cid,
+
+		.init                     = virtio_transport_do_socket_init,
+		.destruct                 = virtio_transport_destruct,
+		.release                  = virtio_transport_release,
+		.connect                  = virtio_transport_connect,
+		.shutdown                 = virtio_transport_shutdown,
+		.cancel_pkt               = vhost_transport_cancel_pkt,
+
+		.dgram_enqueue            = virtio_transport_dgram_enqueue,
+		.dgram_dequeue            = virtio_transport_dgram_dequeue,
+		.dgram_bind               = virtio_transport_dgram_bind,
+		.dgram_allow              = virtio_transport_dgram_allow,
+
+		.stream_enqueue           = virtio_transport_stream_enqueue,
+		.stream_dequeue           = virtio_transport_stream_dequeue,
+		.stream_has_data          = virtio_transport_stream_has_data,
+		.stream_has_space         = virtio_transport_stream_has_space,
+		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
+		.stream_is_active         = virtio_transport_stream_is_active,
+		.stream_allow             = virtio_transport_stream_allow,
+
+		.notify_poll_in           = virtio_transport_notify_poll_in,
+		.notify_poll_out          = virtio_transport_notify_poll_out,
+		.notify_recv_init         = virtio_transport_notify_recv_init,
+		.notify_recv_pre_block    = virtio_transport_notify_recv_pre_block,
+		.notify_recv_pre_dequeue  = virtio_transport_notify_recv_pre_dequeue,
+		.notify_recv_post_dequeue = virtio_transport_notify_recv_post_dequeue,
+		.notify_send_init         = virtio_transport_notify_send_init,
+		.notify_send_pre_block    = virtio_transport_notify_send_pre_block,
+		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
+		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
+
+		.set_buffer_size          = virtio_transport_set_buffer_size,
+		.set_min_buffer_size      = virtio_transport_set_min_buffer_size,
+		.set_max_buffer_size      = virtio_transport_set_max_buffer_size,
+		.get_buffer_size          = virtio_transport_get_buffer_size,
+		.get_min_buffer_size      = virtio_transport_get_min_buffer_size,
+		.get_max_buffer_size      = virtio_transport_get_max_buffer_size,
+	},
+
+	.send_pkt = vhost_transport_send_pkt,
+};
+
 static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 {
 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
@@ -439,7 +485,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		if (le64_to_cpu(pkt->hdr.src_cid) == vsock->guest_cid &&
 		    le64_to_cpu(pkt->hdr.dst_cid) ==
 		    vhost_transport_get_local_cid())
-			virtio_transport_recv_pkt(pkt);
+			virtio_transport_recv_pkt(&vhost_transport, pkt);
 		else
 			virtio_transport_free_pkt(pkt);
 
@@ -792,52 +838,6 @@ static struct miscdevice vhost_vsock_misc = {
 	.fops = &vhost_vsock_fops,
 };
 
-static struct virtio_transport vhost_transport = {
-	.transport = {
-		.get_local_cid            = vhost_transport_get_local_cid,
-
-		.init                     = virtio_transport_do_socket_init,
-		.destruct                 = virtio_transport_destruct,
-		.release                  = virtio_transport_release,
-		.connect                  = virtio_transport_connect,
-		.shutdown                 = virtio_transport_shutdown,
-		.cancel_pkt               = vhost_transport_cancel_pkt,
-
-		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
-		.dgram_bind               = virtio_transport_dgram_bind,
-		.dgram_allow              = virtio_transport_dgram_allow,
-
-		.stream_enqueue           = virtio_transport_stream_enqueue,
-		.stream_dequeue           = virtio_transport_stream_dequeue,
-		.stream_has_data          = virtio_transport_stream_has_data,
-		.stream_has_space         = virtio_transport_stream_has_space,
-		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
-		.stream_is_active         = virtio_transport_stream_is_active,
-		.stream_allow             = virtio_transport_stream_allow,
-
-		.notify_poll_in           = virtio_transport_notify_poll_in,
-		.notify_poll_out          = virtio_transport_notify_poll_out,
-		.notify_recv_init         = virtio_transport_notify_recv_init,
-		.notify_recv_pre_block    = virtio_transport_notify_recv_pre_block,
-		.notify_recv_pre_dequeue  = virtio_transport_notify_recv_pre_dequeue,
-		.notify_recv_post_dequeue = virtio_transport_notify_recv_post_dequeue,
-		.notify_send_init         = virtio_transport_notify_send_init,
-		.notify_send_pre_block    = virtio_transport_notify_send_pre_block,
-		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
-		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
-
-		.set_buffer_size          = virtio_transport_set_buffer_size,
-		.set_min_buffer_size      = virtio_transport_set_min_buffer_size,
-		.set_max_buffer_size      = virtio_transport_set_max_buffer_size,
-		.get_buffer_size          = virtio_transport_get_buffer_size,
-		.get_min_buffer_size      = virtio_transport_get_min_buffer_size,
-		.get_max_buffer_size      = virtio_transport_get_max_buffer_size,
-	},
-
-	.send_pkt = vhost_transport_send_pkt,
-};
-
 static int __init vhost_vsock_init(void)
 {
 	int ret;
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index e223e2632eddd..8b8d13f01caee 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -149,7 +149,8 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 
 void virtio_transport_destruct(struct vsock_sock *vsk);
 
-void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt);
+void virtio_transport_recv_pkt(struct virtio_transport *t,
+			       struct virtio_vsock_pkt *pkt);
 void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt);
 void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt);
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 4bc217ef56945..cc70d651d13e0 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -87,33 +87,6 @@ static u32 virtio_transport_get_local_cid(void)
 	return ret;
 }
 
-static void virtio_transport_loopback_work(struct work_struct *work)
-{
-	struct virtio_vsock *vsock =
-		container_of(work, struct virtio_vsock, loopback_work);
-	LIST_HEAD(pkts);
-
-	spin_lock_bh(&vsock->loopback_list_lock);
-	list_splice_init(&vsock->loopback_list, &pkts);
-	spin_unlock_bh(&vsock->loopback_list_lock);
-
-	mutex_lock(&vsock->rx_lock);
-
-	if (!vsock->rx_run)
-		goto out;
-
-	while (!list_empty(&pkts)) {
-		struct virtio_vsock_pkt *pkt;
-
-		pkt = list_first_entry(&pkts, struct virtio_vsock_pkt, list);
-		list_del_init(&pkt->list);
-
-		virtio_transport_recv_pkt(pkt);
-	}
-out:
-	mutex_unlock(&vsock->rx_lock);
-}
-
 static int virtio_transport_send_pkt_loopback(struct virtio_vsock *vsock,
 					      struct virtio_vsock_pkt *pkt)
 {
@@ -370,59 +343,6 @@ static bool virtio_transport_more_replies(struct virtio_vsock *vsock)
 	return val < virtqueue_get_vring_size(vq);
 }
 
-static void virtio_transport_rx_work(struct work_struct *work)
-{
-	struct virtio_vsock *vsock =
-		container_of(work, struct virtio_vsock, rx_work);
-	struct virtqueue *vq;
-
-	vq = vsock->vqs[VSOCK_VQ_RX];
-
-	mutex_lock(&vsock->rx_lock);
-
-	if (!vsock->rx_run)
-		goto out;
-
-	do {
-		virtqueue_disable_cb(vq);
-		for (;;) {
-			struct virtio_vsock_pkt *pkt;
-			unsigned int len;
-
-			if (!virtio_transport_more_replies(vsock)) {
-				/* Stop rx until the device processes already
-				 * pending replies.  Leave rx virtqueue
-				 * callbacks disabled.
-				 */
-				goto out;
-			}
-
-			pkt = virtqueue_get_buf(vq, &len);
-			if (!pkt) {
-				break;
-			}
-
-			vsock->rx_buf_nr--;
-
-			/* Drop short/long packets */
-			if (unlikely(len < sizeof(pkt->hdr) ||
-				     len > sizeof(pkt->hdr) + pkt->len)) {
-				virtio_transport_free_pkt(pkt);
-				continue;
-			}
-
-			pkt->len = len - sizeof(pkt->hdr);
-			virtio_transport_deliver_tap_pkt(pkt);
-			virtio_transport_recv_pkt(pkt);
-		}
-	} while (!virtqueue_enable_cb(vq));
-
-out:
-	if (vsock->rx_buf_nr < vsock->rx_buf_max_nr / 2)
-		virtio_vsock_rx_fill(vsock);
-	mutex_unlock(&vsock->rx_lock);
-}
-
 /* event_lock must be held */
 static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
 				       struct virtio_vsock_event *event)
@@ -586,6 +506,86 @@ static struct virtio_transport virtio_transport = {
 	.send_pkt = virtio_transport_send_pkt,
 };
 
+static void virtio_transport_loopback_work(struct work_struct *work)
+{
+	struct virtio_vsock *vsock =
+		container_of(work, struct virtio_vsock, loopback_work);
+	LIST_HEAD(pkts);
+
+	spin_lock_bh(&vsock->loopback_list_lock);
+	list_splice_init(&vsock->loopback_list, &pkts);
+	spin_unlock_bh(&vsock->loopback_list_lock);
+
+	mutex_lock(&vsock->rx_lock);
+
+	if (!vsock->rx_run)
+		goto out;
+
+	while (!list_empty(&pkts)) {
+		struct virtio_vsock_pkt *pkt;
+
+		pkt = list_first_entry(&pkts, struct virtio_vsock_pkt, list);
+		list_del_init(&pkt->list);
+
+		virtio_transport_recv_pkt(&virtio_transport, pkt);
+	}
+out:
+	mutex_unlock(&vsock->rx_lock);
+}
+
+static void virtio_transport_rx_work(struct work_struct *work)
+{
+	struct virtio_vsock *vsock =
+		container_of(work, struct virtio_vsock, rx_work);
+	struct virtqueue *vq;
+
+	vq = vsock->vqs[VSOCK_VQ_RX];
+
+	mutex_lock(&vsock->rx_lock);
+
+	if (!vsock->rx_run)
+		goto out;
+
+	do {
+		virtqueue_disable_cb(vq);
+		for (;;) {
+			struct virtio_vsock_pkt *pkt;
+			unsigned int len;
+
+			if (!virtio_transport_more_replies(vsock)) {
+				/* Stop rx until the device processes already
+				 * pending replies.  Leave rx virtqueue
+				 * callbacks disabled.
+				 */
+				goto out;
+			}
+
+			pkt = virtqueue_get_buf(vq, &len);
+			if (!pkt) {
+				break;
+			}
+
+			vsock->rx_buf_nr--;
+
+			/* Drop short/long packets */
+			if (unlikely(len < sizeof(pkt->hdr) ||
+				     len > sizeof(pkt->hdr) + pkt->len)) {
+				virtio_transport_free_pkt(pkt);
+				continue;
+			}
+
+			pkt->len = len - sizeof(pkt->hdr);
+			virtio_transport_deliver_tap_pkt(pkt);
+			virtio_transport_recv_pkt(&virtio_transport, pkt);
+		}
+	} while (!virtqueue_enable_cb(vq));
+
+out:
+	if (vsock->rx_buf_nr < vsock->rx_buf_max_nr / 2)
+		virtio_vsock_rx_fill(vsock);
+	mutex_unlock(&vsock->rx_lock);
+}
+
 static int virtio_vsock_probe(struct virtio_device *vdev)
 {
 	vq_callback_t *callbacks[] = {
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 52242a148c705..fae2bded5d519 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -669,9 +669,9 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 /* Normally packets are associated with a socket.  There may be no socket if an
  * attempt was made to connect to a socket that does not exist.
  */
-static int virtio_transport_reset_no_sock(struct virtio_vsock_pkt *pkt)
+static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
+					  struct virtio_vsock_pkt *pkt)
 {
-	const struct virtio_transport *t;
 	struct virtio_vsock_pkt *reply;
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RST,
@@ -691,7 +691,6 @@ static int virtio_transport_reset_no_sock(struct virtio_vsock_pkt *pkt)
 	if (!reply)
 		return -ENOMEM;
 
-	t = virtio_transport_get_ops();
 	if (!t) {
 		virtio_transport_free_pkt(reply);
 		return -ENOTCONN;
@@ -993,7 +992,8 @@ static bool virtio_transport_space_update(struct sock *sk,
 /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
  * lock.
  */
-void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)
+void virtio_transport_recv_pkt(struct virtio_transport *t,
+			       struct virtio_vsock_pkt *pkt)
 {
 	struct sockaddr_vm src, dst;
 	struct vsock_sock *vsk;
@@ -1015,7 +1015,7 @@ void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)
 					le32_to_cpu(pkt->hdr.fwd_cnt));
 
 	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
-		(void)virtio_transport_reset_no_sock(pkt);
+		(void)virtio_transport_reset_no_sock(t, pkt);
 		goto free_pkt;
 	}
 
@@ -1026,7 +1026,7 @@ void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)
 	if (!sk) {
 		sk = vsock_find_bound_socket(&dst);
 		if (!sk) {
-			(void)virtio_transport_reset_no_sock(pkt);
+			(void)virtio_transport_reset_no_sock(t, pkt);
 			goto free_pkt;
 		}
 	}
-- 
2.25.1



