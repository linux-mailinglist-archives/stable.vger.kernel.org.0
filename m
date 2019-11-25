Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D129C10930B
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfKYRoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:44:39 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33397 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725851AbfKYRoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 12:44:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 226E52271C;
        Mon, 25 Nov 2019 12:44:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 25 Nov 2019 12:44:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hYRgZX
        UgwvW/qV6p3kHNVx7LH9DJ+163sC8sVD3YYCE=; b=NE35Eex9z0mhoqDrjJo2hX
        Bqso0yd//yCc9RZ03DbKPsrJsaZ6qcLAgrmloxOiwROA0dL/kN5rUd5KrJktynNk
        x48WE6RwCdt5G9VyQaBkEW/rVNBc0CKHGsyybLdP4R2i7sheaYC6OvSjrCKd7MqK
        XycM1NTKcXacojxruAZPRjSKkkbLRZvCzdfrSrhULlPAZ8YBeE1dC9DsNc80kK1P
        SDy7txTKIq0K5WCXBwpmO6s/NoshZ8qX6gayYRybbYYTXc1moQDGI2rSWDplTwWs
        bUpOoZ9f3mqArcpFOp5UTWQnz+X303p5XY0AuT9qehnfcar/6mB2OLzbmvQ1eOlw
        ==
X-ME-Sender: <xms:BhPcXRJpD0gjQVmPmpb8bUYh08yaBsjY9-Y1DqOPt4ojJhBeMxaYyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeiuddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:BhPcXUGjYgGYbOa5HNTVEDueOjdZXdKkNFulCqeusq3A2nenJQAJaw>
    <xmx:BhPcXSoeC96oLALs1holWeeRQzkPVogdUzs89OqsTJVYdbJ6OvaAsw>
    <xmx:BhPcXaOLWx9eNVbcky4zmE4Q_ze69VB7zd8A3eI5VMNKvajrc6zZ4Q>
    <xmx:BhPcXUyFhZkiXZ05Wc5YW_su5Za0EOsBQJZkcKbp6BIdqWicDKhvVg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9EC0A80069;
        Mon, 25 Nov 2019 12:44:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] virtio_ring: fix return code on DMA mapping fails" failed to apply to 4.14-stable tree
To:     pasic@linux.ibm.com, mimu@linux.ibm.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Nov 2019 18:44:27 +0100
Message-ID: <1574703867188135@kroah.com>
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

From f7728002c1c7bfa787b276a31c3ef458739b8e7c Mon Sep 17 00:00:00 2001
From: Halil Pasic <pasic@linux.ibm.com>
Date: Thu, 14 Nov 2019 13:46:46 +0100
Subject: [PATCH] virtio_ring: fix return code on DMA mapping fails

Commit 780bc7903a32 ("virtio_ring: Support DMA APIs")  makes
virtqueue_add() return -EIO when we fail to map our I/O buffers. This is
a very realistic scenario for guests with encrypted memory, as swiotlb
may run out of space, depending on it's size and the I/O load.

The virtio-blk driver interprets -EIO form virtqueue_add() as an IO
error, despite the fact that swiotlb full is in absence of bugs a
recoverable condition.

Let us change the return code to -ENOMEM, and make the block layer
recover form these failures when virtio-blk encounters the condition
described above.

Cc: stable@vger.kernel.org
Fixes: 780bc7903a32 ("virtio_ring: Support DMA APIs")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Michael Mueller <mimu@linux.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index a8041e451e9e..867c7ebd3f10 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -583,7 +583,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 		kfree(desc);
 
 	END_USE(vq);
-	return -EIO;
+	return -ENOMEM;
 }
 
 static bool virtqueue_kick_prepare_split(struct virtqueue *_vq)
@@ -1085,7 +1085,7 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 	kfree(desc);
 
 	END_USE(vq);
-	return -EIO;
+	return -ENOMEM;
 }
 
 static inline int virtqueue_add_packed(struct virtqueue *_vq,

