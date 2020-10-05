Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8691F2839D5
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgJEP2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbgJEP2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:28:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE3DE20637;
        Mon,  5 Oct 2020 15:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911729;
        bh=5/wBDxBkT6n1prrroZYsTF2lIb1bR1flgjLeEgcYkdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+T0mTMz+QppsrdPDk8ZdAmS4+qjL5ZhYu0jsUZ449TmCLm7znPLvfuz80tLz+EkQ
         IULbOY6/5q+IxgJZc8UjtuCvSl0q4LVC0QMMUhgJAuERDIhI5g+1kEOUJHDMBXurjv
         iuqCgRnt6fHfU1S/+DEGuqvYi1cADmpMbPvFi8cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/57] vsock/virtio: add transport parameter to the virtio_transport_reset_no_sock()
Date:   Mon,  5 Oct 2020 17:26:20 +0200
Message-Id: <20201005142110.208721915@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
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
index ca68a27b98edd..f21f5bfbb78dc 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -384,6 +384,52 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
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
@@ -440,7 +486,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		if (le64_to_cpu(pkt->hdr.src_cid) == vsock->guest_cid &&
 		    le64_to_cpu(pkt->hdr.dst_cid) ==
 		    vhost_transport_get_local_cid())
-			virtio_transport_recv_pkt(pkt);
+			virtio_transport_recv_pkt(&vhost_transport, pkt);
 		else
 			virtio_transport_free_pkt(pkt);
 
@@ -793,52 +839,6 @@ static struct miscdevice vhost_vsock_misc = {
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
index 07875ccc7bb50..b139f76060a65 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -150,7 +150,8 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 
 void virtio_transport_destruct(struct vsock_sock *vsk);
 
-void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt);
+void virtio_transport_recv_pkt(struct virtio_transport *t,
+			       struct virtio_vsock_pkt *pkt);
 void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt);
 void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt);
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 861ec9a671f9d..5905f0cddc895 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -86,33 +86,6 @@ static u32 virtio_transport_get_local_cid(void)
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
index fb2060dffb0af..f0b8ad2656f5e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -696,9 +696,9 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
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
@@ -718,7 +718,6 @@ static int virtio_transport_reset_no_sock(struct virtio_vsock_pkt *pkt)
 	if (!reply)
 		return -ENOMEM;
 
-	t = virtio_transport_get_ops();
 	if (!t) {
 		virtio_transport_free_pkt(reply);
 		return -ENOTCONN;
@@ -1060,7 +1059,8 @@ static bool virtio_transport_space_update(struct sock *sk,
 /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
  * lock.
  */
-void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)
+void virtio_transport_recv_pkt(struct virtio_transport *t,
+			       struct virtio_vsock_pkt *pkt)
 {
 	struct sockaddr_vm src, dst;
 	struct vsock_sock *vsk;
@@ -1082,7 +1082,7 @@ void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)
 					le32_to_cpu(pkt->hdr.fwd_cnt));
 
 	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
-		(void)virtio_transport_reset_no_sock(pkt);
+		(void)virtio_transport_reset_no_sock(t, pkt);
 		goto free_pkt;
 	}
 
@@ -1093,7 +1093,7 @@ void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)
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



