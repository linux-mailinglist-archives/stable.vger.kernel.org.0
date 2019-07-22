Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E6F70077
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 15:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbfGVNDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 09:03:17 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34462 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfGVNDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 09:03:17 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so5720697edb.1
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 06:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c1hNjJTNWvmR1u8yOIjwRCx6CXteUEmQaXJMzR9m85M=;
        b=cJ3W7pOfn9ZECWjxeovENt9PfrjEBGJ8eoTYqA2zB2zuuxi0QAb9ul533vSRCrL5cP
         shlGqGwRYG0zBYCbc/o3PmCggp5OyOLGDnju5UjJierYeOuc+Qpgp3At9EppDiALNZF1
         MTWMdO6a8bfIKMeO8BVPU+Sse4xzxqFi/Sp3Knk4gdH7n1nN7uEyizoemfQxh3XwfNKT
         747YyNypEv3B9DfI09jH/YC6MEl44tlYPfQekSEydoXGFDFiOHvEAIAD68fyxMnHqOHz
         UgK75XvtU0oVUe+ymCsC+z9bhTO/rHh4fBzD9vBeEEtG3bAjr9kEmjDS3qyDELJSXEhU
         mIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=c1hNjJTNWvmR1u8yOIjwRCx6CXteUEmQaXJMzR9m85M=;
        b=e5Lf9/RCavN/P6cXMWPMpeT3XyvBR0jLaIWZRcWF3YJlbvlNjS6Tb3EklUwIj626rV
         AoUkYxy8+RxrbYEJ4zyOsTIlB/RA9baBiAZdK6KY/Q/ixQGOQyszoyXJILHHhC8gSr2k
         Ehi1eCiF70dq3p8DCQsLCfbV+FmJ5Qk4HYNnrp8d2mTxitwAgxkyTWMf4WHqHYk1pGic
         +HH2pQxIGRYaLysDfXH6pQTGOemZT9fin30IGrC9J+4VnyEYEHgI38QzRqz/yWK9vFUP
         FP8CkxZ/qKUIufxshI0pNy7uKM8FXDmxvk9bdRAv1VbRIunTdNWiBQ2gPx9blTN30Tbq
         l5NA==
X-Gm-Message-State: APjAAAXoR2pqYYo8KWD213+fyHdO/GISY+gEt1TMLDFU6D3PKN3DsvGQ
        yNUQqjZEvAQD/qWumKVk6UDi2/En
X-Google-Smtp-Source: APXvYqx3F2uUlqDSFqCv9Hr+d8FqxNcEUeRuX12wrPIzPhyi5zdp1HejdkFlrgJVmm3edYhrucrbWw==
X-Received: by 2002:a50:ac07:: with SMTP id v7mr60447898edc.205.1563800595840;
        Mon, 22 Jul 2019 06:03:15 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([62.217.45.26])
        by smtp.gmail.com with ESMTPSA id v12sm7996085ejj.52.2019.07.22.06.03.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 06:03:15 -0700 (PDT)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [stable-4.19 1/4] vhost: introduce vhost_exceeds_weight()
Date:   Mon, 22 Jul 2019 15:03:10 +0200
Message-Id: <20190722130313.18562-2-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722130313.18562-1-jinpuwang@gmail.com>
References: <20190722130313.18562-1-jinpuwang@gmail.com>
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
[jwang: backport to 4.19, fix conflict in net.c]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/vhost/net.c   | 22 ++++++----------------
 drivers/vhost/scsi.c  |  9 ++++++++-
 drivers/vhost/vhost.c | 20 +++++++++++++++++++-
 drivers/vhost/vhost.h |  5 ++++-
 drivers/vhost/vsock.c | 12 +++++++++++-
 5 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 39155d7cc894..f6cf6825c15f 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -497,12 +497,6 @@ static size_t init_iov_iter(struct vhost_virtqueue *vq, struct iov_iter *iter,
 	return iov_iter_count(iter);
 }
 
-static bool vhost_exceeds_weight(int pkts, int total_len)
-{
-	return total_len >= VHOST_NET_WEIGHT ||
-	       pkts >= VHOST_NET_PKT_WEIGHT;
-}
-
 static int get_tx_bufs(struct vhost_net *net,
 		       struct vhost_net_virtqueue *nvq,
 		       struct msghdr *msg,
@@ -598,10 +592,8 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				 err, len);
 		if (++nvq->done_idx >= VHOST_NET_BATCH)
 			vhost_net_signal_used(nvq);
-		if (vhost_exceeds_weight(++sent_pkts, total_len)) {
-			vhost_poll_queue(&vq->poll);
+		if (vhost_exceeds_weight(vq, ++sent_pkts, total_len))
 			break;
-		}
 	}
 
 	vhost_net_signal_used(nvq);
@@ -701,10 +693,9 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
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
 }
 
@@ -1027,10 +1018,8 @@ static void handle_rx(struct vhost_net *net)
 			vhost_log_write(vq, vq_log, log, vhost_len,
 					vq->iov, in);
 		total_len += vhost_len;
-		if (unlikely(vhost_exceeds_weight(++recv_pkts, total_len))) {
-			vhost_poll_queue(&vq->poll);
+		if (unlikely(vhost_exceeds_weight(vq, ++recv_pkts, total_len)))
 			goto out;
-		}
 	}
 	if (unlikely(busyloop_intr))
 		vhost_poll_queue(&vq->poll);
@@ -1115,7 +1104,8 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
-		       UIO_MAXIOV + VHOST_NET_BATCH);
+		       UIO_MAXIOV + VHOST_NET_BATCH,
+		       VHOST_NET_WEIGHT, VHOST_NET_PKT_WEIGHT);
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0cfa925be4ec..087ce17b0c39 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -57,6 +57,12 @@
 #define VHOST_SCSI_PREALLOC_UPAGES 2048
 #define VHOST_SCSI_PREALLOC_PROT_SGLS 2048
 
+/* Max number of requests before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others with
+ * request.
+ */
+#define VHOST_SCSI_WEIGHT 256
+
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
 	struct completion comp;
@@ -1398,7 +1404,8 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV);
+	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
+		       VHOST_SCSI_WEIGHT, 0);
 
 	vhost_scsi_init_inflight(vs, NULL);
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c163bc15976a..0752f8dc47b1 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -413,8 +413,24 @@ static void vhost_dev_free_iovecs(struct vhost_dev *dev)
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
-		    struct vhost_virtqueue **vqs, int nvqs, int iov_limit)
+		    struct vhost_virtqueue **vqs, int nvqs,
+		    int iov_limit, int weight, int byte_weight)
 {
 	struct vhost_virtqueue *vq;
 	int i;
@@ -428,6 +444,8 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->mm = NULL;
 	dev->worker = NULL;
 	dev->iov_limit = iov_limit;
+	dev->weight = weight;
+	dev->byte_weight = byte_weight;
 	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9490e7ddb340..27a78a9b8cc7 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -171,10 +171,13 @@ struct vhost_dev {
 	struct list_head pending_list;
 	wait_queue_head_t wait;
 	int iov_limit;
+	int weight;
+	int byte_weight;
 };
 
+bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
-		    int nvqs, int iov_limit);
+		    int nvqs, int iov_limit, int weight, int byte_weight);
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index e440f87ae1d6..58c5c82bc0be 100644
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
@@ -531,7 +539,9 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
 
-	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs), UIO_MAXIOV);
+	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
+		       UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
+		       VHOST_VSOCK_WEIGHT);
 
 	file->private_data = vsock;
 	spin_lock_init(&vsock->send_pkt_list_lock);
-- 
2.17.1

