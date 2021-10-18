Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8272431DE9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhJRNzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234425AbhJRNxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84A08619E4;
        Mon, 18 Oct 2021 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564356;
        bh=ib/xevrLUR0c/2TEb2suW9cNY1t6krRKSP7YFHh3+sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9SDli1dXBFu9DcjENpm1FR2+UMFRtKNT1iu1/JrBghBsPJb+KdNXcZ8cIpSY8zlO
         idpnfBfeuVmQfRYSsjRsQdmF/4ZxhOZ7vnvpzpdANAHkS7oMIdOil5syjMmK4vuWBY
         QXPwSA7+UgU58M2oxHRMCw8WbCMnBe0oi4q3YtCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.14 058/151] virtio-blk: remove unneeded "likely" statements
Date:   Mon, 18 Oct 2021 15:23:57 +0200
Message-Id: <20211018132342.579875204@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

commit 6105d1fe6f4c24ce8c13e2e6568b16b76e04983d upstream.

Usually we use "likely/unlikely" to optimize the fast path. Remove
redundant "likely/unlikely" statements in the control path to simplify
the code and make it easier to read.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Link: https://lore.kernel.org/r/20210905085717.7427-1-mgurtovoy@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/virtio_blk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -765,7 +765,7 @@ static int virtblk_probe(struct virtio_d
 		goto out_free_vblk;
 
 	/* Default queue sizing is to fill the ring. */
-	if (likely(!virtblk_queue_depth)) {
+	if (!virtblk_queue_depth) {
 		queue_depth = vblk->vqs[0].vq->num_free;
 		/* ... but without indirect descs, we use 2 descs per req */
 		if (!virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
@@ -839,7 +839,7 @@ static int virtblk_probe(struct virtio_d
 	else
 		blk_size = queue_logical_block_size(q);
 
-	if (unlikely(blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE)) {
+	if (blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE) {
 		dev_err(&vdev->dev,
 			"block size is changed unexpectedly, now is %u\n",
 			blk_size);


