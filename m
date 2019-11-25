Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67A9109308
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKYRo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:44:29 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51721 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725851AbfKYRo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 12:44:29 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 17142226BD;
        Mon, 25 Nov 2019 12:44:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 25 Nov 2019 12:44:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7Ppzmi
        iPmzdPbczQClH8vKGpEFzldIhO9PpKtVc7Lpk=; b=HKCoxnfyUQWTSQ/ZUWk3+c
        gxdDbnj4EvM5k56I2nFTqpnRURezPP5yQ2Wgw7QrSG62R9wCOIzgstOj3FEhkfrs
        S6T3cOGsUdlRAC++tKMQI5FOZ0rHPAaTYhSe6LBzzf7cK0ohTX6x6U2Suw2qFoK/
        723jwl1m60KYLqlqy/m83ncOPOnsa1iXVz41T1AFegegt2xawEwUAFbntRBmG4KS
        wSKP8qIm/rJHBaNey0TTpuFdmPVcpxv7c5LrIyGChAMLLEKYdEfZJkMETrwYXeDl
        TunYmqe55un3yDpssCmZhOfOqc+2/TIMq5QPO5XixRnjIXwNmCgR4TtljEj/6VLw
        ==
X-ME-Sender: <xms:-xLcXQSru6ZKhBc-Y1Pr2fGkXAbbGf-tIQsu3jpcfFKMIdWFX7vwiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeiuddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:-xLcXXVgCxbxAVTPNMjpIKeNupE_w3yU2444SMFI8SYnTGrUF1GT1A>
    <xmx:-xLcXZQS6toXWIgfJDXg3W75IEgUoQ8iaY3TF3kXsZqFHDKUSp1uGw>
    <xmx:-xLcXSsiLPr85tZALBjtEfrBEwkXt1DXHw7YFP8iupko6cShOR54mA>
    <xmx:_BLcXTl634h2s0NR-UJDRMM4bJ308wbdLeQ6R9jXkw0oanypZO0IHA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A7CDC306005B;
        Mon, 25 Nov 2019 12:44:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] virtio_ring: fix return code on DMA mapping fails" failed to apply to 4.19-stable tree
To:     pasic@linux.ibm.com, mimu@linux.ibm.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Nov 2019 18:44:26 +0100
Message-ID: <1574703866101156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

