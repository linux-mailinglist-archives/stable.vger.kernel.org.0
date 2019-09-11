Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7932FAF48D
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 04:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfIKCyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 22:54:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:19080 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbfIKCyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 22:54:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 19:54:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="384545975"
Received: from dpdk-virtio-tbie-2.sh.intel.com ([10.67.104.71])
  by fmsmga005.fm.intel.com with ESMTP; 10 Sep 2019 19:54:31 -0700
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     stable@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, gregkh@linuxfoundation.org
Subject: [PATCH 4.14] vhost/test: fix build for vhost test
Date:   Wed, 11 Sep 2019 10:50:55 +0800
Message-Id: <20190911025055.26774-1-tiwei.bie@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 264b563b8675771834419057cbe076c1a41fb666 upstream.

Since vhost_exceeds_weight() was introduced, callers need to specify
the packet weight and byte weight in vhost_dev_init(). Note that, the
packet weight isn't counted in this patch to keep the original behavior
unchanged.

Fixes: e82b9b0727ff ("vhost: introduce vhost_exceeds_weight()")
Cc: stable@vger.kernel.org
Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/test.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 3cc98c07dcd3..682fc58e1f75 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -23,6 +23,12 @@
  * Using this limit prevents one virtqueue from starving others. */
 #define VHOST_TEST_WEIGHT 0x80000
 
+/* Max number of packets transferred before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others with
+ * pkts.
+ */
+#define VHOST_TEST_PKT_WEIGHT 256
+
 enum {
 	VHOST_TEST_VQ = 0,
 	VHOST_TEST_VQ_MAX = 1,
@@ -81,10 +87,8 @@ static void handle_vq(struct vhost_test *n)
 		}
 		vhost_add_used_and_signal(&n->dev, vq, head, 0);
 		total_len += len;
-		if (unlikely(total_len >= VHOST_TEST_WEIGHT)) {
-			vhost_poll_queue(&vq->poll);
+		if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
 			break;
-		}
 	}
 
 	mutex_unlock(&vq->mutex);
@@ -116,7 +120,8 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX);
+	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX,
+		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
 
 	f->private_data = n;
 
-- 
2.17.1

