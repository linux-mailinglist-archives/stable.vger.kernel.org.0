Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4C0A8E37
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387680AbfIDR4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387660AbfIDR4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:56:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 532A122CF7;
        Wed,  4 Sep 2019 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619801;
        bh=lndBLTP9WJoUmNrqBoF+i/+LEAPtoRlvTT46g5CiN5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWhqBwmIMWSi0Goz8Wqrio/gmG9DW7YY3al+Vtw0vtvZjTVqeaDdzqj/YXIEeyzt0
         rDdn4WsKP249xmbixjbatXaaMZO/Vd1ddejCNwGU8x08QTrowNXKVBUyh9PWHrSgOT
         8+6kfxgwCBafiJ528ngMj+0f41PijICeXbDlwU7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 39/77] vhost: introduce vhost_exceeds_weight()
Date:   Wed,  4 Sep 2019 19:53:26 +0200
Message-Id: <20190904175307.232878711@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e82b9b0727ff6d665fff2d326162b460dded554d upstream.

We used to have vhost_exceeds_weight() for vhost-net to:

- prevent vhost kthread from hogging the cpu
- balance the time spent between TX and RX

This function could be useful for vsock and scsi as well. So move it
to vhost.c. Device must specify a weight which counts the number of
requests, or it can also specific a byte_weight which counts the
number of bytes that has been processed.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
[bwh: Backported to 4.4:
 - Drop changes to vhost_vsock
 - In vhost_net, both Tx modes are handled in one loop in handle_tx()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c   | 18 +++++-------------
 drivers/vhost/scsi.c  |  9 ++++++++-
 drivers/vhost/vhost.c | 20 +++++++++++++++++++-
 drivers/vhost/vhost.h |  6 +++++-
 4 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 38c3120f92be4..20062531f1eaa 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -293,12 +293,6 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 	rcu_read_unlock_bh();
 }
 
-static bool vhost_exceeds_weight(int pkts, int total_len)
-{
-	return total_len >= VHOST_NET_WEIGHT ||
-	       pkts >= VHOST_NET_PKT_WEIGHT;
-}
-
 /* Expects to be always run from workqueue - which acts as
  * read-size critical section for our kind of RCU. */
 static void handle_tx(struct vhost_net *net)
@@ -421,10 +415,9 @@ static void handle_tx(struct vhost_net *net)
 			vhost_zerocopy_signal_used(net, vq);
 		total_len += len;
 		vhost_net_tx_packet(net);
-		if (unlikely(vhost_exceeds_weight(++sent_pkts, total_len))) {
-			vhost_poll_queue(&vq->poll);
+		if (unlikely(vhost_exceeds_weight(vq, ++sent_pkts,
+						  total_len)))
 			break;
-		}
 	}
 out:
 	mutex_unlock(&vq->mutex);
@@ -645,10 +638,8 @@ static void handle_rx(struct vhost_net *net)
 		if (unlikely(vq_log))
 			vhost_log_write(vq, vq_log, log, vhost_len);
 		total_len += vhost_len;
-		if (unlikely(vhost_exceeds_weight(++recv_pkts, total_len))) {
-			vhost_poll_queue(&vq->poll);
+		if (unlikely(vhost_exceeds_weight(vq, ++recv_pkts, total_len)))
 			break;
-		}
 	}
 out:
 	mutex_unlock(&vq->mutex);
@@ -718,7 +709,8 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].vhost_hlen = 0;
 		n->vqs[i].sock_hlen = 0;
 	}
-	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX);
+	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
+		       VHOST_NET_WEIGHT, VHOST_NET_PKT_WEIGHT);
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, POLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, POLLIN, dev);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 8fc62a03637a7..47e659eacf17e 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -58,6 +58,12 @@
 #define VHOST_SCSI_PREALLOC_UPAGES 2048
 #define VHOST_SCSI_PREALLOC_PROT_SGLS 512
 
+/* Max number of requests before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others with
+ * request.
+ */
+#define VHOST_SCSI_WEIGHT 256
+
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
 	struct completion comp;
@@ -1443,7 +1449,8 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ);
+	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ,
+		       VHOST_SCSI_WEIGHT, 0);
 
 	vhost_scsi_init_inflight(vs, NULL);
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2ed0a356d1d33..0f653f314876e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -370,8 +370,24 @@ static void vhost_dev_free_iovecs(struct vhost_dev *dev)
 		vhost_vq_free_iovecs(dev->vqs[i]);
 }
 
+bool vhost_exceeds_weight(struct vhost_virtqueue *vq,
+			  int pkts, int total_len)
+{
+	struct vhost_dev *dev = vq->dev;
+
+	if ((dev->byte_weight && total_len >= dev->byte_weight) ||
+	    pkts >= dev->weight) {
+		vhost_poll_queue(&vq->poll);
+		return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(vhost_exceeds_weight);
+
 void vhost_dev_init(struct vhost_dev *dev,
-		    struct vhost_virtqueue **vqs, int nvqs)
+		    struct vhost_virtqueue **vqs, int nvqs,
+		    int weight, int byte_weight)
 {
 	struct vhost_virtqueue *vq;
 	int i;
@@ -386,6 +402,8 @@ void vhost_dev_init(struct vhost_dev *dev,
 	spin_lock_init(&dev->work_lock);
 	INIT_LIST_HEAD(&dev->work_list);
 	dev->worker = NULL;
+	dev->weight = weight;
+	dev->byte_weight = byte_weight;
 
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d3f767448a72c..5ac4869705696 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -127,9 +127,13 @@ struct vhost_dev {
 	spinlock_t work_lock;
 	struct list_head work_list;
 	struct task_struct *worker;
+	int weight;
+	int byte_weight;
 };
 
-void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs, int nvqs);
+bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
+void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
+		    int nvqs, int weight, int byte_weight);
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
-- 
2.20.1



