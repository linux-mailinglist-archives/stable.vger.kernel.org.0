Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D86C6245F
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388592AbfGHPZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388584AbfGHPZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:25:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 033E421783;
        Mon,  8 Jul 2019 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599525;
        bh=if0EIBPsFsgQs35NsIDRgDUOAbmIkxolApa+jgCYInA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9bZ1Oggincz111iCFw85BEE69i17sFBzkuUIMVXfHud3NACdibNyL5ma3IXlsLzQ
         qTLNuvLn/y9+yWW7jIHyrI039t/3tBCQvtZ2LSrBI9OEA87SpmVaeJvcdM+ZTzXgdR
         VU+7FvnIa0zD1xJoduHeqgFPqzEZzedlHIYaT16Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Balbir Singh <sblbir@amzn.com>
Subject: [PATCH 4.14 44/56] vhost: introduce vhost_exceeds_weight()
Date:   Mon,  8 Jul 2019 17:13:36 +0200
Message-Id: <20190708150523.754548980@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

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
Signed-off-by: Balbir Singh <sblbir@amzn.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/net.c   |   18 +++++-------------
 drivers/vhost/scsi.c  |    8 +++++++-
 drivers/vhost/vhost.c |   20 +++++++++++++++++++-
 drivers/vhost/vhost.h |    6 +++++-
 drivers/vhost/vsock.c |   11 ++++++++++-
 5 files changed, 46 insertions(+), 17 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -446,12 +446,6 @@ static bool vhost_exceeds_maxpend(struct
 		== nvq->done_idx;
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
@@ -584,10 +578,9 @@ static void handle_tx(struct vhost_net *
 		else
 			vhost_zerocopy_signal_used(net, vq);
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
@@ -867,10 +860,8 @@ static void handle_rx(struct vhost_net *
 			vhost_log_write(vq, vq_log, log, vhost_len,
 					vq->iov, in);
 		total_len += vhost_len;
-		if (unlikely(vhost_exceeds_weight(++recv_pkts, total_len))) {
-			vhost_poll_queue(&vq->poll);
+		if (unlikely(vhost_exceeds_weight(vq, ++recv_pkts, total_len)))
 			goto out;
-		}
 	}
 	vhost_net_enable_vq(net, vq);
 out:
@@ -949,7 +940,8 @@ static int vhost_net_open(struct inode *
 		n->vqs[i].sock_hlen = 0;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
-	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX);
+	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
+		       VHOST_NET_WEIGHT, VHOST_NET_PKT_WEIGHT);
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, POLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, POLLIN, dev);
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
@@ -1427,7 +1433,7 @@ static int vhost_scsi_open(struct inode
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ);
+	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, VHOST_SCSI_WEIGHT, 0);
 
 	vhost_scsi_init_inflight(vs, NULL);
 
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -412,8 +412,24 @@ static void vhost_dev_free_iovecs(struct
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
@@ -427,6 +443,8 @@ void vhost_dev_init(struct vhost_dev *de
 	dev->iotlb = NULL;
 	dev->mm = NULL;
 	dev->worker = NULL;
+	dev->weight = weight;
+	dev->byte_weight = byte_weight;
 	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -173,9 +173,13 @@ struct vhost_dev {
 	struct list_head read_list;
 	struct list_head pending_list;
 	wait_queue_head_t wait;
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
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -21,6 +21,14 @@
 #include "vhost.h"
 
 #define VHOST_VSOCK_DEFAULT_HOST_CID	2
+/* Max number of bytes transferred before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others. */
+#define VHOST_VSOCK_WEIGHT 0x80000
+/* Max number of packets transferred before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others with
+ * small pkts.
+ */
+#define VHOST_VSOCK_PKT_WEIGHT 256
 
 enum {
 	VHOST_VSOCK_FEATURES = VHOST_FEATURES,
@@ -531,7 +539,8 @@ static int vhost_vsock_dev_open(struct i
 	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
 
-	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs));
+	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
+		       VHOST_VSOCK_PKT_WEIGHT, VHOST_VSOCK_WEIGHT);
 
 	file->private_data = vsock;
 	spin_lock_init(&vsock->send_pkt_list_lock);


