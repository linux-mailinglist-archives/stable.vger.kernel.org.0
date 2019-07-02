Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5AB5D98E
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfGCArp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:47:45 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:28332 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfGCAro (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:47:44 -0400
X-IronPort-AV: E=Sophos;i="5.62,444,1554768000"; 
   d="scan'208";a="409072364"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-8549039f.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 02 Jul 2019 21:02:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-8549039f.us-west-2.amazon.com (Postfix) with ESMTPS id 43A64A205D;
        Tue,  2 Jul 2019 21:02:33 +0000 (UTC)
Received: from EX13D18UWC001.ant.amazon.com (10.43.162.105) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D18UWC001.ant.amazon.com (10.43.162.105) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:32 +0000
Received: from localhost (172.23.204.141) by mail-relay.amazon.com
 (10.43.162.232) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 2 Jul 2019 21:02:32 +0000
From:   Balbir Singh <sblbir@amzn.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        Balbir Singh <sblbir@amzn.com>
Subject: [backport to v4.14 CVE-2019-3900 4/7] vhost: introduce vhost_exceeds_weight()
Date:   Tue, 2 Jul 2019 21:02:07 +0000
Message-ID: <20190702210210.2375-5-sblbir@amzn.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20190702210210.2375-1-sblbir@amzn.com>
References: <20190702210210.2375-1-sblbir@amzn.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

We used to have vhost_exceeds_weight() for vhost-net to:

- prevent vhost kthread from hogging the cpu
- balance the time spent between TX and RX

This function could be useful for vsock and scsi as well. So move it
to vhost.c. Device must specify a weight which counts the number of
requests, or it can also specific a byte_weight which counts the
number of bytes that has been processed.

[upstream e82b9b0727ff6d665fff2d326162b460dded554d
Balbir - backport to stable 4.14]
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Balbir Singh <sblbir@amzn.com>
---
 drivers/vhost/net.c   | 18 +++++-------------
 drivers/vhost/scsi.c  |  8 +++++++-
 drivers/vhost/vhost.c | 20 +++++++++++++++++++-
 drivers/vhost/vhost.h |  6 +++++-
 drivers/vhost/vsock.c | 11 ++++++++++-
 5 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 81b9c908ca56..a4ca0346da3e 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -446,12 +446,6 @@ static bool vhost_exceeds_maxpend(struct vhost_net *net)
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
@@ -584,10 +578,9 @@ static void handle_tx(struct vhost_net *net)
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
@@ -867,10 +860,8 @@ static void handle_rx(struct vhost_net *net)
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
@@ -949,7 +940,8 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].sock_hlen = 0;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
-	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX);
+	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
+		       VHOST_NET_WEIGHT, VHOST_NET_PKT_WEIGHT);
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, POLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, POLLIN, dev);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 35ebf06d9ecb..0abb7cbf54b7 100644
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
@@ -1427,7 +1433,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ);
+	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, VHOST_SCSI_WEIGHT, 0);
 
 	vhost_scsi_init_inflight(vs, NULL);
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 0e93ac888a5f..88fa81c482e8 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -412,8 +412,24 @@ static void vhost_dev_free_iovecs(struct vhost_dev *dev)
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
@@ -427,6 +443,8 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->iotlb = NULL;
 	dev->mm = NULL;
 	dev->worker = NULL;
+	dev->weight = weight;
+	dev->byte_weight = byte_weight;
 	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 75d21d4a8354..950c5c4e4ee3 100644
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
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index d0cf3d5aa570..d67663983656 100644
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
@@ -531,7 +539,8 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
 
-	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs));
+	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
+		       VHOST_VSOCK_PKT_WEIGHT, VHOST_VSOCK_WEIGHT);
 
 	file->private_data = vsock;
 	spin_lock_init(&vsock->send_pkt_list_lock);
-- 
2.16.5

