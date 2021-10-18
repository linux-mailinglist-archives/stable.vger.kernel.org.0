Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4753C431DEB
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbhJRNz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234457AbhJRNxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22F51619E5;
        Mon, 18 Oct 2021 13:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564358;
        bh=N2J78hwogc9FKBO7wWEoEnUM8+mUkfXV5928r1UksnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSZirEdKY6wRNgTYpZI25TEumhC7pqZYmeBV7FjxG1kOlhy9ydP+yzC6oomG9GBr+
         fY/GtKomCGDD7AMSuou+wdbBAmrcxLMYRHbG/18CS8CyPx3xbf2NMB7pfVh8L0HDmX
         hYSEZz6eIweIgEXWL0l4FZ0HF3/nSeKd2SdUXWIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.14 059/151] Revert "virtio-blk: Add validation for block size in config space"
Date:   Mon, 18 Oct 2021 15:23:58 +0200
Message-Id: <20211018132342.609512899@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

commit ff63198850f33eab54b2da6905380fd4d4fc0739 upstream.

It turns out that access to config space before completing the feature
negotiation is broken for big endian guests at least with QEMU hosts up
to 6.1 inclusive.  This affects any device that accesses config space in
the validate callback: at the moment that is virtio-net with
VIRTIO_NET_F_MTU but since 82e89ea077b9 ("virtio-blk: Add validation for
block size in config space") that also started affecting virtio-blk with
VIRTIO_BLK_F_BLK_SIZE. Further, unlike VIRTIO_NET_F_MTU which is off by
default on QEMU, VIRTIO_BLK_F_BLK_SIZE is on by default, which resulted
in lots of people not being able to boot VMs on BE.

The spec is very clear that what we are doing is legal so QEMU needs to
be fixed, but given it's been broken for so many years and no one
noticed, we need to give QEMU a bit more time before applying this.

Further, this patch is incomplete (does not check blk size is a power
of two) and it duplicates the logic from nbd.

Revert for now, and we'll reapply a cleaner logic in the next release.

Cc: stable@vger.kernel.org
Fixes: 82e89ea077b9 ("virtio-blk: Add validation for block size in config space")
Cc: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/virtio_blk.c |   39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -692,28 +692,6 @@ static const struct blk_mq_ops virtio_mq
 static unsigned int virtblk_queue_depth;
 module_param_named(queue_depth, virtblk_queue_depth, uint, 0444);
 
-static int virtblk_validate(struct virtio_device *vdev)
-{
-	u32 blk_size;
-
-	if (!vdev->config->get) {
-		dev_err(&vdev->dev, "%s failure: config access disabled\n",
-			__func__);
-		return -EINVAL;
-	}
-
-	if (!virtio_has_feature(vdev, VIRTIO_BLK_F_BLK_SIZE))
-		return 0;
-
-	blk_size = virtio_cread32(vdev,
-			offsetof(struct virtio_blk_config, blk_size));
-
-	if (blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE)
-		__virtio_clear_bit(vdev, VIRTIO_BLK_F_BLK_SIZE);
-
-	return 0;
-}
-
 static int virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -725,6 +703,12 @@ static int virtblk_probe(struct virtio_d
 	u8 physical_block_exp, alignment_offset;
 	unsigned int queue_depth;
 
+	if (!vdev->config->get) {
+		dev_err(&vdev->dev, "%s failure: config access disabled\n",
+			__func__);
+		return -EINVAL;
+	}
+
 	err = ida_simple_get(&vd_index_ida, 0, minor_to_index(1 << MINORBITS),
 			     GFP_KERNEL);
 	if (err < 0)
@@ -839,14 +823,6 @@ static int virtblk_probe(struct virtio_d
 	else
 		blk_size = queue_logical_block_size(q);
 
-	if (blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE) {
-		dev_err(&vdev->dev,
-			"block size is changed unexpectedly, now is %u\n",
-			blk_size);
-		err = -EINVAL;
-		goto err_cleanup_disk;
-	}
-
 	/* Use topology information if available */
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_TOPOLOGY,
 				   struct virtio_blk_config, physical_block_exp,
@@ -905,8 +881,6 @@ static int virtblk_probe(struct virtio_d
 	device_add_disk(&vdev->dev, vblk->disk, virtblk_attr_groups);
 	return 0;
 
-err_cleanup_disk:
-	blk_cleanup_disk(vblk->disk);
 out_free_tags:
 	blk_mq_free_tag_set(&vblk->tag_set);
 out_free_vq:
@@ -1009,7 +983,6 @@ static struct virtio_driver virtio_blk =
 	.driver.name			= KBUILD_MODNAME,
 	.driver.owner			= THIS_MODULE,
 	.id_table			= id_table,
-	.validate			= virtblk_validate,
 	.probe				= virtblk_probe,
 	.remove				= virtblk_remove,
 	.config_changed			= virtblk_config_changed,


