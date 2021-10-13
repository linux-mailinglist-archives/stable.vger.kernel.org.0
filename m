Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF4942C07D
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhJMMsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 08:48:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231294AbhJMMsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 08:48:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634129174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=pio+Rp9lSXqTgcX0jd1ToQMieUTpIAr4Wm8ggp456+o=;
        b=fDi80G8h49m015tHrzDRZ4dnqOQz0tumxczgdg4RqrZK9kUk+sxseASBtqJwMu98wFSVv+
        S26k9vkQSgyDok8hhvjNtlVGQc+sWGXq9I+FCQzYrISs42izR6FhOYKkrFLxywRPClTBkd
        yMxLe2DuDR0GAMUuJa0Ll+tDy/ZZCjw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-ROu3zRRKMta2fW194hWj1w-1; Wed, 13 Oct 2021 08:46:13 -0400
X-MC-Unique: ROu3zRRKMta2fW194hWj1w-1
Received: by mail-wr1-f72.google.com with SMTP id d13-20020adf9b8d000000b00160a94c235aso1904582wrc.2
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 05:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=pio+Rp9lSXqTgcX0jd1ToQMieUTpIAr4Wm8ggp456+o=;
        b=YBIovqlfSGnpFyw6LPwxAqOEpiaqmbUock6Dlv1VIKKS7OV5gBFKJvM05PQwgAPD0L
         an2lg1Acow/poNDwwUQhwIbNSyrMXFfDYfxPfFaEW3+nA9gikSo5DmvnKbVRKgC+hYTf
         fqyGbnK/XjWjl71B5s+puGingxQc2lo+/eahhx2ndtY0Ha+PYvqArE4bYoMxv1oNXM53
         0pGZWlHhgOPNxeCprek6KnmM6ieB9aubK0Qk0PGRRbIiO7xnNK2BdNisup5kCyG9q9fJ
         Fgt7dUmxEV/b3AwLrYhH313+4FU7Qe3BwJ9xlHI87BuG//ydL+NHk6lrygU2dOac9fhN
         sR2g==
X-Gm-Message-State: AOAM530vtsJFNMtPQP3kczkrjRSWMElvZ+v/H430hhz8FLaWDYNmhXmg
        qXH5WPrTS18E9VIo5o/YvgiWPUMV0ygEbQZYPnxbhifdi4QtyzhIXlvxVYYr3rkAEmg+oFCpEXs
        qxjPy6Ingbcgc8p1h
X-Received: by 2002:a1c:3586:: with SMTP id c128mr12804920wma.78.1634129172058;
        Wed, 13 Oct 2021 05:46:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWON28WQcyoAHS7/UuoGSQN5DfnmTJuEAcV0OBwnEccLiKLDK1QD4fr9pYUdKD+eXE6vI3mA==
X-Received: by 2002:a1c:3586:: with SMTP id c128mr12804894wma.78.1634129171809;
        Wed, 13 Oct 2021 05:46:11 -0700 (PDT)
Received: from redhat.com ([2.55.30.112])
        by smtp.gmail.com with ESMTPSA id s1sm5015348wmc.47.2021.10.13.05.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 05:46:11 -0700 (PDT)
Date:   Wed, 13 Oct 2021 08:46:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org
Subject: [PATCH] Revert "virtio-blk: Add validation for block size in config
 space"
Message-ID: <20211013124553.23803-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/block/virtio_blk.c | 37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 9b3bd083b411..303caf2d17d0 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -689,28 +689,6 @@ static const struct blk_mq_ops virtio_mq_ops = {
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
@@ -722,6 +700,12 @@ static int virtblk_probe(struct virtio_device *vdev)
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
@@ -836,14 +820,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 	else
 		blk_size = queue_logical_block_size(q);
 
-	if (blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE) {
-		dev_err(&vdev->dev,
-			"block size is changed unexpectedly, now is %u\n",
-			blk_size);
-		err = -EINVAL;
-		goto out_cleanup_disk;
-	}
-
 	/* Use topology information if available */
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_TOPOLOGY,
 				   struct virtio_blk_config, physical_block_exp,
@@ -1009,7 +985,6 @@ static struct virtio_driver virtio_blk = {
 	.driver.name			= KBUILD_MODNAME,
 	.driver.owner			= THIS_MODULE,
 	.id_table			= id_table,
-	.validate			= virtblk_validate,
 	.probe				= virtblk_probe,
 	.remove				= virtblk_remove,
 	.config_changed			= virtblk_config_changed,
-- 
MST

