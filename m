Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE464EC69F
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 16:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346896AbiC3OgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 10:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244899AbiC3OgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 10:36:01 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CE510AB
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:34:15 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id h23so29582772wrb.8
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LqhdzbzYIfRAxDfKXhfa8no6OcyzRsKpB11DUGwcFoQ=;
        b=ECANHb0BRvjteMKy0RHWtKwF2xm4l4wVF3JIsZH3Zi3C09Kg2t3aguxAoxAZxUmOst
         i5nh1Kz9goPqtWmLi0y+IiBBET4o4+wUxRP9DVTj3lR/vwQbk8vKL6R5HgW2OujeU1HA
         qad37Kdgh2y2H6vIR8BUmXdDjPGVJ37SnBl7zZR/9UNU5OLhEHkMD0iiaGOHXK8rQ7xF
         5ZpS3UJbbhpr+6vJdm6m2VnY0R10nEjKHU4Z5nBY6tlynBKWpheDD2PRw4Sd+2KhIoMI
         Nzkz2lEWXqOK+S6+yA8jiC+/gdWKQ0a9ys9dtX23IjjpOFZpaBnnF6cCxrlSw0peok4+
         53Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LqhdzbzYIfRAxDfKXhfa8no6OcyzRsKpB11DUGwcFoQ=;
        b=oScMlsNHWluTFZlSbJNT/Iis9n0ib81Vy1wABy9rp4GHFL7sYgMJVGy6x7KMS4f8p2
         G614A1gMw+Rzbolcht7+qrICVnFHE53AObIoTfAnb5VSAV+KSA8Iw4cQNEv1PChUdxB+
         VrMZj1Ah5H/VaMm6UH23dMbp4EExakH1kdrsMjgWttfa3WhR7Y9nQioqVaH6kDDgz7LU
         ViPhlQPX8BDKjdGnm+NVRDI7q8UJg+qQZ6pI1Qwxtkth9BQz1+Qa/pQQgxBxnszeGDZv
         qBfY0eqEd9cLNwgdi2nV9FSv5y+hHFX6Cfsdx9ThAqQWCYnnuX34B1BfNGKdflasA3mw
         LA0g==
X-Gm-Message-State: AOAM532Zj8WlNauge1LDLOVDWms3Pex9C1jF4iPV2Tw1ZOfBTyTv9auD
        QhH2oRJIPg8DzGzM5rlEFkVaFg==
X-Google-Smtp-Source: ABdhPJwDCzlnxb19pBaxmRzAXqzP80AMjyWCwOFtoa3aIgC8UIWTpHDPqvRt2S4lkOYk5EwPcCKEEQ==
X-Received: by 2002:a5d:59a5:0:b0:205:c33c:44ad with SMTP id p5-20020a5d59a5000000b00205c33c44admr18647446wrr.103.1648650854014;
        Wed, 30 Mar 2022 07:34:14 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id a11-20020a5d456b000000b0020406ce0e06sm17176511wrc.94.2022.03.30.07.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 07:34:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 2/2] virtio-blk: Use blk_validate_block_size() to validate block size
Date:   Wed, 30 Mar 2022 15:34:09 +0100
Message-Id: <20220330143409.1230642-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
In-Reply-To: <20220330143409.1230642-1-lee.jones@linaro.org>
References: <20220330143409.1230642-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 57a13a5b8157d9a8606490aaa1b805bafe6c37e1 ]

The block layer can't support a block size larger than
page size yet. And a block size that's too small or
not a power of two won't work either. If a misconfigured
device presents an invalid block size in configuration space,
it will result in the kernel crash something like below:

[  506.154324] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  506.160416] RIP: 0010:create_empty_buffers+0x24/0x100
[  506.174302] Call Trace:
[  506.174651]  create_page_buffers+0x4d/0x60
[  506.175207]  block_read_full_page+0x50/0x380
[  506.175798]  ? __mod_lruvec_page_state+0x60/0xa0
[  506.176412]  ? __add_to_page_cache_locked+0x1b2/0x390
[  506.177085]  ? blkdev_direct_IO+0x4a0/0x4a0
[  506.177644]  ? scan_shadow_nodes+0x30/0x30
[  506.178206]  ? lru_cache_add+0x42/0x60
[  506.178716]  do_read_cache_page+0x695/0x740
[  506.179278]  ? read_part_sector+0xe0/0xe0
[  506.179821]  read_part_sector+0x36/0xe0
[  506.180337]  adfspart_check_ICS+0x32/0x320
[  506.180890]  ? snprintf+0x45/0x70
[  506.181350]  ? read_part_sector+0xe0/0xe0
[  506.181906]  bdev_disk_changed+0x229/0x5c0
[  506.182483]  blkdev_get_whole+0x6d/0x90
[  506.183013]  blkdev_get_by_dev+0x122/0x2d0
[  506.183562]  device_add_disk+0x39e/0x3c0
[  506.184472]  virtblk_probe+0x3f8/0x79b [virtio_blk]
[  506.185461]  virtio_dev_probe+0x15e/0x1d0 [virtio]

So let's use a block layer helper to validate the block size.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20211026144015.188-5-xieyongji@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/block/virtio_blk.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 302260e9002c7..45bd0d7d6a942 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -692,9 +692,17 @@ static int virtblk_probe(struct virtio_device *vdev)
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
 				   struct virtio_blk_config, blk_size,
 				   &blk_size);
-	if (!err)
+	if (!err) {
+		err = blk_validate_block_size(blk_size);
+		if (err) {
+			dev_err(&vdev->dev,
+				"virtio_blk: invalid block size: 0x%x\n",
+				blk_size);
+			goto out_free_tags;
+		}
+
 		blk_queue_logical_block_size(q, blk_size);
-	else
+	} else
 		blk_size = queue_logical_block_size(q);
 
 	/* Use topology information if available */
-- 
2.35.1.1021.g381101b075-goog

