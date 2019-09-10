Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6FCAE914
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 13:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfIJL0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 07:26:35 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:48915 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726475AbfIJL0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 07:26:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0895153C;
        Tue, 10 Sep 2019 07:26:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 10 Sep 2019 07:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DBSd59
        12ut0jLPOEdKJ/PYqloM/5WJ6CBAhornwMqAA=; b=GTfN0F397ZXMEBSZ12rZ4c
        Yrwn7jz56cs1LEwLVLGYDaBGsCQ1e7yHf/1ysmaVfR/Mw15tmKVzEO0lmlS7d4sn
        bvmzmExMDa7aRZVb+GppWP4Ks4MV/UAgBZIn5jhWYPcRIyGummnq+y4UX2NZ67hP
        5cazzyxarS2T+dLQ2SCEQf0xGfjRJ2WBIURjL/4KLGQM5a212FPKZ5xf0QLi4nbf
        PEyAkmiNpKvVUXD3QtVR8AxGdpp06MsnOZBv4rFbqT7Sl2yERSw6Kn8+4PDrkAUr
        XLZ1nGXre3DGLGfBhfr4muXLHflRt/jXp/Fas9BQ1dUvTV0kxhcsbRME6TThpUUg
        ==
X-ME-Sender: <xms:aYh3Xa0fFKGLAXiBQkiuH13THaIc_lIj6nJNHMkesvkbSamHCChJdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtddtgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepvddufedrfedtrdekrdduuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:aYh3XUClV-XHl19E7CWjIxS8lExTCCAfySZylayLspFOOEP0Q3MoKQ>
    <xmx:aYh3Xb0RPAYjCPvvpw3XqYU-qwcSCazawpbDu_zrFXVrfNctMSRIIg>
    <xmx:aYh3XTpTjTyJf-PTQlIziG6mNVR13SGxcEeA802A152Dr3oweqJjMw>
    <xmx:aYh3XT84XLAjVt27JOycNXBt-tmJbqARdt4PxVDhe8OzYMRR08Ogkw>
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        by mail.messagingengine.com (Postfix) with ESMTPA id EED038005A;
        Tue, 10 Sep 2019 07:26:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] vhost/test: fix build for vhost test" failed to apply to 4.14-stable tree
To:     tiwei.bie@intel.com, jasowang@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Sep 2019 12:26:28 +0100
Message-ID: <1568114788544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 264b563b8675771834419057cbe076c1a41fb666 Mon Sep 17 00:00:00 2001
From: Tiwei Bie <tiwei.bie@intel.com>
Date: Wed, 28 Aug 2019 13:37:00 +0800
Subject: [PATCH] vhost/test: fix build for vhost test

Since vhost_exceeds_weight() was introduced, callers need to specify
the packet weight and byte weight in vhost_dev_init(). Note that, the
packet weight isn't counted in this patch to keep the original behavior
unchanged.

Fixes: e82b9b0727ff ("vhost: introduce vhost_exceeds_weight()")
Cc: stable@vger.kernel.org
Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index ac4f762c4f65..7804869c6a31 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -22,6 +22,12 @@
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
@@ -80,10 +86,8 @@ static void handle_vq(struct vhost_test *n)
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
@@ -115,7 +119,8 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV);
+	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
+		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
 
 	f->private_data = n;
 

