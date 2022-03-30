Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBED44EC65A
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 16:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241080AbiC3OVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 10:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346706AbiC3OVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 10:21:37 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD7690FE9
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:19:52 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n35so12349872wms.5
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LjPuoefH1pL1+wXgPjg1EYngVZScOvX20WtaEOxGwMM=;
        b=pb7lOPzJNTEsHJOVm6OprE01UQwBRrQJnuRMYQXIPchNfgLq8et9Dl7m31gPFdLCrt
         eLbG/I3tfp1ZyI86EwB09VBpxLFiZTs7rgmbIMtCdlF3ZRDRkXUHvx+8GK0TLJnb7PSf
         UTc9drWx2eDnu4BaAC8VkJrxh6hzBeEMSwBsw2SU0AVmKtmPb+7CGQWidrrqi2wELPDq
         /LhQniA6USkgfdp+S+wx6HQf678G+vKQ6rSzd2UeNWlFaubllmf/EWVW9cELlTlT/WXo
         aQhA5BdjrWZ7jHxw6dLrVeVHfHI1li6exqg+zTsCsfh9I5cq3x7MMAzeoZ6jSTUhUWq1
         d9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LjPuoefH1pL1+wXgPjg1EYngVZScOvX20WtaEOxGwMM=;
        b=6CG2ch5/d6p+C35KwZ3dfkguczbdUR0lKoJ6PVkO2jBL9X5Y6bptHDHb2IZH9Plkx7
         OnRo2vc0qdOwKj/UG1EitS6GlhYN/g/6cUv6Wb7gZMKECWNgpsjUfqb+X4946VTLvZN5
         Ys+BrR+qrzqYEFR+7IKRPl7UQePk6I88Bg6qvOahA3IxNdFcgZgEIUtkoQaN2zQuRqQm
         Mfe2DCQqXVWNxyrlc29TI1VvDSf8zlgPHW06OGkzSc02tl/EQnkX6LQ+VeZ4f2q202C+
         pf2gxfPspUxEc5tP45Jenqr+4e8Jbmdj7l0wJDU/Zb5nmyLvEgdDiSTezoHrn4+cdCRz
         oR4Q==
X-Gm-Message-State: AOAM532UKQZIfw2wKqg4YnbRBBOhBHpxQuzZjWYQEjyYdWcLldb8Tpj1
        uAu2Nf0kBaR6ydHVK9tYJUxG5w==
X-Google-Smtp-Source: ABdhPJy3Duh+eLP661JTo1qurJuamASd8ahU2akVq1EVPlPJwHXbUvkPQI3ohpGg5Po5Kk+yzM4mLg==
X-Received: by 2002:a7b:ce92:0:b0:38b:ed80:9e66 with SMTP id q18-20020a7bce92000000b0038bed809e66mr4742786wmj.82.1648649990763;
        Wed, 30 Mar 2022 07:19:50 -0700 (PDT)
Received: from joneslee-l.cable.virginm.net (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id y13-20020adffa4d000000b00203e3ca2701sm24027645wrr.45.2022.03.30.07.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 07:19:50 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 4.14 2/2] virtio-blk: Use blk_validate_block_size() to validate block size
Date:   Wed, 30 Mar 2022 15:19:44 +0100
Message-Id: <20220330141944.1172191-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
In-Reply-To: <20220330141944.1172191-1-lee.jones@linaro.org>
References: <20220330141944.1172191-1-lee.jones@linaro.org>
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
index 437d43747c6d0..7e8f58c2f65b3 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -822,9 +822,17 @@ static int virtblk_probe(struct virtio_device *vdev)
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

