Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70F8540A59
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351478AbiFGSUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352398AbiFGSRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112672126F;
        Tue,  7 Jun 2022 10:51:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8871B80B66;
        Tue,  7 Jun 2022 17:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A434C385A5;
        Tue,  7 Jun 2022 17:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624302;
        bh=XNm2g0S/w5PkuuKuHkkXAlx5lsE5JPWtVLHfP2/aKY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAo33G0SwnnUzLth3hjHU0jttrWXmbFOpPE3hwgQc5//kQiqbi448XAUX1FMCjKxF
         nz7SC2jgIpHqRauNsiYmGb7B74C2OHjFUepCMASDN9lpXf+drdvV28anjoMRCbsfXS
         Qx7bttv1lHBLBaJG8SKG8wD89hAfAIc2Wa4OEWUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 279/667] virtio_blk: fix the discard_granularity and discard_alignment queue limits
Date:   Tue,  7 Jun 2022 18:59:04 +0200
Message-Id: <20220607164943.154750724@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 62952cc5bccd89b76d710de1d0b43244af0f2903 ]

The discard_alignment queue limit is named a bit misleading means the
offset into the block device at which the discard granularity starts.

On the other hand the discard_sector_alignment from the virtio 1.1 looks
similar to what Linux uses as discard granularity (even if not very well
described):

  "discard_sector_alignment can be used by OS when splitting a request
   based on alignment. "

And at least qemu does set it to the discard granularity.

So stop setting the discard_alignment and use the virtio
discard_sector_alignment to set the discard granularity.

Fixes: 1f23816b8eb8 ("virtio_blk: add discard and write zeroes support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20220418045314.360785-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c0b8a26892a5..c05138a28475 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -855,11 +855,12 @@ static int virtblk_probe(struct virtio_device *vdev)
 		blk_queue_io_opt(q, blk_size * opt_io_size);
 
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_DISCARD)) {
-		q->limits.discard_granularity = blk_size;
-
 		virtio_cread(vdev, struct virtio_blk_config,
 			     discard_sector_alignment, &v);
-		q->limits.discard_alignment = v ? v << SECTOR_SHIFT : 0;
+		if (v)
+			q->limits.discard_granularity = v << SECTOR_SHIFT;
+		else
+			q->limits.discard_granularity = blk_size;
 
 		virtio_cread(vdev, struct virtio_blk_config,
 			     max_discard_sectors, &v);
-- 
2.35.1



