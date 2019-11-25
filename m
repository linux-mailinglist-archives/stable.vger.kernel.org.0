Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36276109309
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfKYRoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:44:37 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55553 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725851AbfKYRoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 12:44:37 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 89B432276D;
        Mon, 25 Nov 2019 12:44:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 25 Nov 2019 12:44:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zJeieG
        Lk3OWbTGny4UMQIB6yWrjT84rwTj1uCj2Fpxg=; b=By+BT/OXwFP1YnQuyzzMxP
        shTO6+LWrN3EyZaOw/ojDukk1tTVcaYmZ95wui5W+Sd6MV4XAc8FV7TUIXE3bIqq
        au3Oq6ihtC3JATyVCT+s2/35OTGUkblP7rVP0Dm5NYEnTJ7MYkMxmz3dmAwhaXEG
        2Hi4ZgnbOd4Tl67DDgNjc5ypbhwQDpGzNgpxPhOTFroDf/36+H1nB2wkUFGvNslM
        Wrs0r8Svy/2of0uc4L3g3xRwaKGdLtZaF6A8wXhIBs2nefhFioiHiVEkNHNo8XNB
        yJtco0mosgWxcy6OC0gFcUeeriiFWSC8RdlOlrHnaBZauV7YtLUNZ95+MV6R8/0g
        ==
X-ME-Sender: <xms:BBPcXYsJYYCbZ72mAeiF-_2-QHn6rlMAt-VDCGYsPeJiSAI6oE1nwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeiuddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:BBPcXRk95jgGN0dEdm1DXiAlWjY2_K5VZJuW9yke3A8oeKIN3gaGgA>
    <xmx:BBPcXdCVTdNF76MlYWurXjytJI5C24zfTYRtPDuOmiIoA2_hkynehA>
    <xmx:BBPcXaQORXydWvB2HvpRAUnv66977Kc4PRzkBpO_kcZozvvl7u4LCQ>
    <xmx:BBPcXf7TiKDdKFzwV1bmUu-jeWOikzWVpB6W-R2HHYW2__d-AaXSTQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23BC7306005C;
        Mon, 25 Nov 2019 12:44:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] virtio_ring: fix return code on DMA mapping fails" failed to apply to 4.9-stable tree
To:     pasic@linux.ibm.com, mimu@linux.ibm.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Nov 2019 18:44:27 +0100
Message-ID: <1574703867181183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

