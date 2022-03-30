Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E501E4EC544
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 15:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345744AbiC3NLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 09:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345587AbiC3NLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 09:11:34 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA53DFD72
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 06:09:48 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so3431461wmp.5
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 06:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r7tt8ndQAXuB163zKHjLbbRiFR2BMQryHsBFfJl4z70=;
        b=Lx8ZHVaKVxmU7XYB0bAyxf8JftHgyoA2Owzujm3ViLNlyc9YDn21EKkCWsVBP2TVW8
         g8cCzCQd+fblocTLFGExAQrGz4PpCo3F2s7etujdw7D33yPZBOYjgzwilRxIcBqb4al/
         WALE1TtOLdaXatVe+ErLf50o2ED2KNDyz4xxQcDbfOJ0djwpi3hHX19cdRXx2cRd/H+5
         ZgZVSBxSj2finExchfe0hfK02pQWMk1aRTqzZ+PZdzJ2rXcD3C4KH2mwya1b3gvBe0Vf
         mFcTcEZ7GOn5iRlts1nZnqmW4gO9nA37kKlmqyE54TfVseaJeyA9dW9o6kMH3shES27p
         5C7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r7tt8ndQAXuB163zKHjLbbRiFR2BMQryHsBFfJl4z70=;
        b=Pdg9gWl4A6rP2mgMH0p4AvJq0pFDOvjF2gg32MmbOs/MAdCgPTDQk2eK0/fJWKGivb
         KWVrN+wmDS5NBG8d787OI8+DVOv4xH90rlz1nr/92zcPuLrJ2LrkQPj3WbEHWv/niyRY
         E8/3E3zcG+Stx2vsNQwDO2r9bHfcUsOjemjJbjPkvJn93R2lXjA3InSm5c9rYviKEvOi
         eD7TdSxFWB/mCsrMvmJ1fuuBOcTJbWHKDA3V1YY5kuWKcyW9/RY1fOF0NMrY0Sl8wLFy
         sJwwU6ugy6d836kWIS7fN+O6/0adHxVO4PpE62a8MsAwWMuuc8f/JVJWDYPStihoubFF
         ypPw==
X-Gm-Message-State: AOAM531mOMX770T8Ie8L2qp0toovtZtDSMYsCySYTeMjwsj3qFezpUsX
        BuUZ7INwIH6LWC0uE1PkObhbMw==
X-Google-Smtp-Source: ABdhPJyVDZw1B9CPX55T2OQF7yRbGpd1MlGZKftyXI8cLlFwOErfCyMsrQLolFoedI9MB4NLf+GgdQ==
X-Received: by 2002:a05:600c:a48:b0:38c:c582:c3c7 with SMTP id c8-20020a05600c0a4800b0038cc582c3c7mr4361274wmq.171.1648645787065;
        Wed, 30 Mar 2022 06:09:47 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id c8-20020a056000184800b002040e925afasm20857932wri.59.2022.03.30.06.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 06:09:46 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 5.4 2/2] virtio-blk: Use blk_validate_block_size() to validate block size
Date:   Wed, 30 Mar 2022 14:09:42 +0100
Message-Id: <20220330130942.882258-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
In-Reply-To: <20220330130942.882258-1-lee.jones@linaro.org>
References: <20220330130942.882258-1-lee.jones@linaro.org>
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
index 4b3645e648ee9..2a5cd502feae7 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -936,9 +936,17 @@ static int virtblk_probe(struct virtio_device *vdev)
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

