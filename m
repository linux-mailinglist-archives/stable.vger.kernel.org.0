Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B09E88DCA
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfHJUtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:49:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54710 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbfHJUn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDV-00058O-Br; Sat, 10 Aug 2019 21:43:57 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003jG-7m; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        "Jason Wang" <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.210832900@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 132/157] vhost: introduce vhost_exceeds_weight()
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16:
 - Drop changes to vhost_vsock
 - In vhost_net, both Tx modes are handled in one loop in handle_tx()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -335,12 +335,6 @@ static void vhost_zerocopy_callback(stru
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
@@ -463,10 +457,8 @@ static void handle_tx(struct vhost_net *
 			vhost_zerocopy_signal_used(net, vq);
 		total_len += len;
 		vhost_net_tx_packet(net);
-		if (unlikely(vhost_exceeds_weight(++sent_pkts, total_len))) {
-			vhost_poll_queue(&vq->poll);
+		if (vhost_exceeds_weight(vq, ++sent_pkts, total_len))
 			break;
-		}
 	}
 out:
 	mutex_unlock(&vq->mutex);
@@ -673,10 +665,8 @@ static void handle_rx(struct vhost_net *
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
@@ -746,7 +736,8 @@ static int vhost_net_open(struct inode *
 		n->vqs[i].vhost_hlen = 0;
 		n->vqs[i].sock_hlen = 0;
 	}
-	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX);
+	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
+		       VHOST_NET_WEIGHT, VHOST_NET_PKT_WEIGHT);
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, POLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, POLLIN, dev);
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -60,6 +60,12 @@
 #define TCM_VHOST_PREALLOC_UPAGES 2048
 #define TCM_VHOST_PREALLOC_PROT_SGLS 512
 
+/* Max number of requests before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others with
+ * request.
+ */
+#define VHOST_SCSI_WEIGHT 256
+
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
 	struct completion comp;
@@ -1576,7 +1582,8 @@ static int vhost_scsi_open(struct inode
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ);
+	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ,
+		       VHOST_SCSI_WEIGHT, 0);
 
 	tcm_vhost_init_inflight(vs, NULL);
 
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -292,8 +292,24 @@ static void vhost_dev_free_iovecs(struct
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
@@ -308,6 +324,8 @@ void vhost_dev_init(struct vhost_dev *de
 	spin_lock_init(&dev->work_lock);
 	INIT_LIST_HEAD(&dev->work_list);
 	dev->worker = NULL;
+	dev->weight = weight;
+	dev->byte_weight = byte_weight;
 
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -123,9 +123,13 @@ struct vhost_dev {
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

