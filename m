Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FA94EBF62
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 12:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245648AbiC3LAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245667AbiC3LAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:00:46 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940EB2E9C6
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 03:58:52 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l7-20020a05600c1d0700b0038c99618859so983742wms.2
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 03:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WMkIX//dbnt24kW3ukKzdm+1GsdeDe1UbjAwXet6EAw=;
        b=FkoY3GUbSALj45mBktEZn0FY2R4v6mMieOMWjOzv4cBjuydqziibGIwdPPgKv3v9a6
         icX0XVMth8eq/e0gV4LK7+ivwjyGlHVgiEvzZGijRBNe6evYU2aQUpiPRiTmhla2EufQ
         cFwz/6mm9HMcLKLnHsXdtAcT02L+iZptaCmPeQvR2ic29KHpPR/3PhzMHSabChb430o9
         lcl17UwVjojT2YSL6UZjcLchA9Vx0ESHDUssDUUdHoAv/6+Tej7j+Jy0QVdxexs1TPq/
         0siQb3rCI2vd5wTkxzBhfzWKOUCfeVbOevbtowEMMbsPRQHzfv8Ism2Ac8GlsWqZRr6Q
         kvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WMkIX//dbnt24kW3ukKzdm+1GsdeDe1UbjAwXet6EAw=;
        b=vUG/Qf3lxX1EAJG38nw++Z6i6TsCqcuyEzWGYRHqWx+HkCVnuMW+RJlPCFTFEvtDUK
         tKL2/6eE9IwMefGizhy/6hq1Q8Sc2erf2agvTPKZXlgF5b8AQl328S+Dn4s3zatwhPUv
         zYy4xJIWjr1K6Q+WJxp7OlmHhsBYANlv4l6nq0Pxkp6vSsH8g9pApPJjqhtNs9b9Zj3c
         s/bhvdHMdD61b55m6+i1ICnUl3mfpBufI3OXRDZEmLHZF/dfcpTV44tV4KjCpQl7oWUv
         ckeNmcYudf8cO/6DveNSTPgQra7VYSwbZ2e3MPUesF4Pos2s+zIEjGKpwwkytcmnav45
         v8rA==
X-Gm-Message-State: AOAM531Dvrcgg5hYpXigsvPFFjEGevgw95edl9xZ0/kqVtdJ/Hf17J67
        e4l1FHwBgDr5ruxxbJjxElGuFg==
X-Google-Smtp-Source: ABdhPJwBjMFm4gNUC+R0LSwhYjdgYCguXt6XpRfkqihzbFN1cQraz5QTvzC0bz58MwU9SRKYRuBPcw==
X-Received: by 2002:a7b:cb83:0:b0:37e:bc50:3c6b with SMTP id m3-20020a7bcb83000000b0037ebc503c6bmr3883489wmi.67.1648637930562;
        Wed, 30 Mar 2022 03:58:50 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id m2-20020a1c2602000000b0038ca9ffac53sm4457910wmm.11.2022.03.30.03.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 03:58:50 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1] virtio-blk: Use blk_validate_block_size() to validate block size
Date:   Wed, 30 Mar 2022 11:58:41 +0100
Message-Id: <20220330105841.464954-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
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
index a03390127741f..f8a7a77e08be0 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -825,9 +825,17 @@ static int virtblk_probe(struct virtio_device *vdev)
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
+			goto out_cleanup_disk;
+		}
+
 		blk_queue_logical_block_size(q, blk_size);
-	else
+	} else
 		blk_size = queue_logical_block_size(q);
 
 	/* Use topology information if available */
-- 
2.35.1.1021.g381101b075-goog

