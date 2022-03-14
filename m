Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8924D8419
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbiCNMWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243351AbiCNMUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:20:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D25344F2;
        Mon, 14 Mar 2022 05:15:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 780E4608C4;
        Mon, 14 Mar 2022 12:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111E3C340E9;
        Mon, 14 Mar 2022 12:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260147;
        bh=vIM6AUwnOl+uW/m2jIG6QnLVc2yWJTjJ5mdHCQ0xwYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4Ytoh73pVsG11ScPCMHKzTZCPqlYbMXFXloecOCbwoAAc/5wsXZ1fqxP9TKElugh
         H5QYcVWKZwNep5vp3dhZ/JSf97CHz2I/RPAnLnwQYCmbBh/cFqehmMdnJtFpC/m0sF
         SUx87KxB+4G+seCglZ0dT7Ru84tpyvQtpNKwiS9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Xie Yongji <xieyongji@bytedance.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 019/121] virtio-blk: Remove BUG_ON() in virtio_queue_rq()
Date:   Mon, 14 Mar 2022 12:53:22 +0100
Message-Id: <20220314112744.664541917@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit e030759a1ddcbf61d42b6e996bfeb675e0032d8b ]

Currently we have a BUG_ON() to make sure the number of sg
list does not exceed queue_max_segments() in virtio_queue_rq().
However, the block layer uses queue_max_discard_segments()
instead of queue_max_segments() to limit the sg list for
discard requests. So the BUG_ON() might be triggered if
virtio-blk device reports a larger value for max discard
segment than queue_max_segments(). To fix it, let's simply
remove the BUG_ON() which has become unnecessary after commit
02746e26c39e("virtio-blk: avoid preallocating big SGL for data").
And the unused vblk->sg_elems can also be removed together.

Fixes: 1f23816b8eb8 ("virtio_blk: add discard and write zeroes support")
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Link: https://lore.kernel.org/r/20220304100058.116-2-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 87f239eb0a99..b3df5e5452a7 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -76,9 +76,6 @@ struct virtio_blk {
 	 */
 	refcount_t refs;
 
-	/* What host tells us, plus 2 for header & tailer. */
-	unsigned int sg_elems;
-
 	/* Ida index - used to track minor number allocations. */
 	int index;
 
@@ -322,8 +319,6 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 	blk_status_t status;
 	int err;
 
-	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
-
 	status = virtblk_setup_cmd(vblk->vdev, req, vbr);
 	if (unlikely(status))
 		return status;
@@ -783,8 +778,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 	/* Prevent integer overflows and honor max vq size */
 	sg_elems = min_t(u32, sg_elems, VIRTIO_BLK_MAX_SG_ELEMS - 2);
 
-	/* We need extra sg elements at head and tail. */
-	sg_elems += 2;
 	vdev->priv = vblk = kmalloc(sizeof(*vblk), GFP_KERNEL);
 	if (!vblk) {
 		err = -ENOMEM;
@@ -796,7 +789,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 	mutex_init(&vblk->vdev_mutex);
 
 	vblk->vdev = vdev;
-	vblk->sg_elems = sg_elems;
 
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 
@@ -854,7 +846,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 		set_disk_ro(vblk->disk, 1);
 
 	/* We can handle whatever the host told us to handle. */
-	blk_queue_max_segments(q, vblk->sg_elems-2);
+	blk_queue_max_segments(q, sg_elems);
 
 	/* No real sector limit. */
 	blk_queue_max_hw_sectors(q, -1U);
@@ -932,7 +924,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 		 * handled it.
 		 */
 		if (!v)
-			v = sg_elems - 2;
+			v = sg_elems;
 		blk_queue_max_discard_segments(q,
 					       min(v, MAX_DISCARD_SEGMENTS));
 
-- 
2.34.1



