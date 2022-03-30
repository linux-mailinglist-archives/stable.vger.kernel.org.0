Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E924EC59F
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 15:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiC3Nab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 09:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346028AbiC3Naa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 09:30:30 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122D711161
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 06:28:44 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p189so12255220wmp.3
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 06:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fOUfslRpfzYKP1M6xyPpWUybpW3g0vYVR+KbYeDvLk8=;
        b=xYwKK/uNwuX4DCR+S2pMu0fxoXmexIfFFJ1sDAgK42p/yYA+VPPIgpSTdmHdXb2Gfo
         W8zV4cpelLblahE31ksnQaAf77Cdtjzt/Ug+C8fhA4UdxhFPgEi3O/cvdQBXLoDqSmnu
         mKlAPzC7HfZYFCszHsDhyB3BXz7uQxw7of4JvM81PnOd3vT2Dx7g+hR5So85HR7vJscY
         klrygTepOnF1YTljWZm4dTjYtNbqOiJ54XKIGK3wPKTwcntVOBpI1nEkKNOWD7z2IggW
         hhrim28LaeRWoapbiVh6+d/a/KeIwOYfv2KBvhbOSKXA3MUmYO/ChvHjSjjW7IbcKbaG
         tIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fOUfslRpfzYKP1M6xyPpWUybpW3g0vYVR+KbYeDvLk8=;
        b=FyVu7pXsmc6xkI1B4ZWzznvaIK5yV99dQKxeloUstZVi+iyg41L7oRtwYafTrA2s2l
         n070BtYE45kU4emptPXeE9BfdzHhWGJgr3ghFc2GCpgsB2jAWLHd69zzA8ny/T7HjCGI
         XZNwd44VIgFR9Jox6nU2YIjJYKWJmOBllCtcYDMSPPxQXtFDMJtU1h0IRXGkyuZ5PCGG
         Efb2CY0/Y9PSSYbvW9nLeHwvVmblh+fLgiJbNuislD4wSW/jXCZGLNVX3UoqyYR9ekAp
         kM/DyTObV2naQ7P0z5QlCfNl6emFMFjFyaFRKaHSIlSSpQVAg40xPlT0fbEBokTSxkXg
         AAaA==
X-Gm-Message-State: AOAM531D0TWh4llFF1/1eDUJzOv3yrNKGXPqSqISjidmxdIirkc/dvvF
        NcGDW0t3p5OuTiea5q95FhP3Rrw2fXlBXQ==
X-Google-Smtp-Source: ABdhPJzh4NnFg247isFJQmgxuQZuKmTELXAwknynzRzlVnTm1wbXeqCTfnheBsAHckBSWHqZqBpbUw==
X-Received: by 2002:a7b:c774:0:b0:38c:9f3f:4bdd with SMTP id x20-20020a7bc774000000b0038c9f3f4bddmr4666008wmk.28.1648646922478;
        Wed, 30 Mar 2022 06:28:42 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d588a000000b002052e4aaf89sm17682274wrf.80.2022.03.30.06.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 06:28:42 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 4.19 2/2] virtio-blk: Use blk_validate_block_size() to validate block size
Date:   Wed, 30 Mar 2022 14:28:37 +0100
Message-Id: <20220330132837.1002748-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
In-Reply-To: <20220330132837.1002748-1-lee.jones@linaro.org>
References: <20220330132837.1002748-1-lee.jones@linaro.org>
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
index dac1769146d7f..8b3bf11329ba0 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -849,9 +849,17 @@ static int virtblk_probe(struct virtio_device *vdev)
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

