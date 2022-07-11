Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB2656FC94
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiGKJpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiGKJoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:44:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6895A79E5;
        Mon, 11 Jul 2022 02:22:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D50FD612B7;
        Mon, 11 Jul 2022 09:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC69C341C0;
        Mon, 11 Jul 2022 09:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531327;
        bh=wzKm2vevtd6ICYsl21LmVAkfMbeqROkn+UFyIa7wBMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MA/UVr91pSg3trMZTOLihXqGNMTMq8epe8qh6Ms9tBqs8e8om0PwdIwLhkZfsVCwa
         N7VgqABmYSOX6X9f67nqwJiOGQ01rYW7QkQ58RXRjF/yKf2K6LPQfa9bGjSXQj8YwK
         VfWfsOvqCOs0l6pcs7tFKeiPaTdZozOPTgVv4RAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Feng Li <lifeng1519@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 065/230] virtio-blk: avoid preallocating big SGL for data
Date:   Mon, 11 Jul 2022 11:05:21 +0200
Message-Id: <20220711090605.921067778@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

[ Upstream commit 02746e26c39ee473b975e0f68d1295abc92672ed ]

No need to pre-allocate a big buffer for the IO SGL anymore. If a device
has lots of deep queues, preallocation for the sg list can consume
substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
can be 64 or 128 and each queue's depth might be 128. This means the
resulting preallocation for the data SGLs is big.

Switch to runtime allocation for SGL for lists longer than 2 entries.
This is the approach used by NVMe drivers so it should be reasonable for
virtio block as well. Runtime SGL allocation has always been the case
for the legacy I/O path so this is nothing new.

The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
support SG_CHAIN, use only runtime allocation for the SGL.

Re-organize the setup of the IO request to fit the new sg chain
mechanism.

No performance degradation was seen (fio libaio engine with 16 jobs and
128 iodepth):

IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
--------     ---------------------------------    ----------------------------------
512B          318K/316K                                    329K/325K

4KB           323K/321K                                    353K/349K

16KB          199K/208K                                    250K/275K

128KB         36K/36.1K                                    39.2K/41.7K

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Israel Rukshin <israelr@nvidia.com>
Link: https://lore.kernel.org/r/20210901131434.31158-1-mgurtovoy@nvidia.com
Reviewed-by: Feng Li <lifeng1519@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Tested-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de> # kconfig fixups
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/Kconfig      |   1 +
 drivers/block/virtio_blk.c | 156 ++++++++++++++++++++++++-------------
 2 files changed, 101 insertions(+), 56 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index f93cb989241c..28ed157b1203 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -410,6 +410,7 @@ config XEN_BLKDEV_BACKEND
 config VIRTIO_BLK
 	tristate "Virtio block driver"
 	depends on VIRTIO
+	select SG_POOL
 	help
 	  This is the virtual block driver for virtio.  It can be used with
           QEMU based VMMs (like KVM or Xen).  Say Y or M.
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c05138a28475..ccc5770d7654 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -24,6 +24,12 @@
 /* The maximum number of sg elements that fit into a virtqueue */
 #define VIRTIO_BLK_MAX_SG_ELEMS 32768
 
+#ifdef CONFIG_ARCH_NO_SG_CHAIN
+#define VIRTIO_BLK_INLINE_SG_CNT	0
+#else
+#define VIRTIO_BLK_INLINE_SG_CNT	2
+#endif
+
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
@@ -77,6 +83,7 @@ struct virtio_blk {
 struct virtblk_req {
 	struct virtio_blk_outhdr out_hdr;
 	u8 status;
+	struct sg_table sg_table;
 	struct scatterlist sg[];
 };
 
@@ -162,12 +169,92 @@ static int virtblk_setup_discard_write_zeroes(struct request *req, bool unmap)
 	return 0;
 }
 
-static inline void virtblk_request_done(struct request *req)
+static void virtblk_unmap_data(struct request *req, struct virtblk_req *vbr)
 {
-	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
+	if (blk_rq_nr_phys_segments(req))
+		sg_free_table_chained(&vbr->sg_table,
+				      VIRTIO_BLK_INLINE_SG_CNT);
+}
+
+static int virtblk_map_data(struct blk_mq_hw_ctx *hctx, struct request *req,
+		struct virtblk_req *vbr)
+{
+	int err;
+
+	if (!blk_rq_nr_phys_segments(req))
+		return 0;
+
+	vbr->sg_table.sgl = vbr->sg;
+	err = sg_alloc_table_chained(&vbr->sg_table,
+				     blk_rq_nr_phys_segments(req),
+				     vbr->sg_table.sgl,
+				     VIRTIO_BLK_INLINE_SG_CNT);
+	if (unlikely(err))
+		return -ENOMEM;
 
+	return blk_rq_map_sg(hctx->queue, req, vbr->sg_table.sgl);
+}
+
+static void virtblk_cleanup_cmd(struct request *req)
+{
 	if (req->rq_flags & RQF_SPECIAL_PAYLOAD)
 		kfree(bvec_virt(&req->special_vec));
+}
+
+static int virtblk_setup_cmd(struct virtio_device *vdev, struct request *req,
+		struct virtblk_req *vbr)
+{
+	bool unmap = false;
+	u32 type;
+
+	vbr->out_hdr.sector = 0;
+
+	switch (req_op(req)) {
+	case REQ_OP_READ:
+		type = VIRTIO_BLK_T_IN;
+		vbr->out_hdr.sector = cpu_to_virtio64(vdev,
+						      blk_rq_pos(req));
+		break;
+	case REQ_OP_WRITE:
+		type = VIRTIO_BLK_T_OUT;
+		vbr->out_hdr.sector = cpu_to_virtio64(vdev,
+						      blk_rq_pos(req));
+		break;
+	case REQ_OP_FLUSH:
+		type = VIRTIO_BLK_T_FLUSH;
+		break;
+	case REQ_OP_DISCARD:
+		type = VIRTIO_BLK_T_DISCARD;
+		break;
+	case REQ_OP_WRITE_ZEROES:
+		type = VIRTIO_BLK_T_WRITE_ZEROES;
+		unmap = !(req->cmd_flags & REQ_NOUNMAP);
+		break;
+	case REQ_OP_DRV_IN:
+		type = VIRTIO_BLK_T_GET_ID;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return BLK_STS_IOERR;
+	}
+
+	vbr->out_hdr.type = cpu_to_virtio32(vdev, type);
+	vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
+
+	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
+		if (virtblk_setup_discard_write_zeroes(req, unmap))
+			return BLK_STS_RESOURCE;
+	}
+
+	return 0;
+}
+
+static inline void virtblk_request_done(struct request *req)
+{
+	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
+
+	virtblk_unmap_data(req, vbr);
+	virtblk_cleanup_cmd(req);
 	blk_mq_end_request(req, virtblk_result(vbr));
 }
 
@@ -225,57 +312,23 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 	int qid = hctx->queue_num;
 	int err;
 	bool notify = false;
-	bool unmap = false;
-	u32 type;
 
 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
-	switch (req_op(req)) {
-	case REQ_OP_READ:
-	case REQ_OP_WRITE:
-		type = 0;
-		break;
-	case REQ_OP_FLUSH:
-		type = VIRTIO_BLK_T_FLUSH;
-		break;
-	case REQ_OP_DISCARD:
-		type = VIRTIO_BLK_T_DISCARD;
-		break;
-	case REQ_OP_WRITE_ZEROES:
-		type = VIRTIO_BLK_T_WRITE_ZEROES;
-		unmap = !(req->cmd_flags & REQ_NOUNMAP);
-		break;
-	case REQ_OP_DRV_IN:
-		type = VIRTIO_BLK_T_GET_ID;
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return BLK_STS_IOERR;
-	}
-
-	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, type);
-	vbr->out_hdr.sector = type ?
-		0 : cpu_to_virtio64(vblk->vdev, blk_rq_pos(req));
-	vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
+	err = virtblk_setup_cmd(vblk->vdev, req, vbr);
+	if (unlikely(err))
+		return err;
 
 	blk_mq_start_request(req);
 
-	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
-		err = virtblk_setup_discard_write_zeroes(req, unmap);
-		if (err)
-			return BLK_STS_RESOURCE;
-	}
-
-	num = blk_rq_map_sg(hctx->queue, req, vbr->sg);
-	if (num) {
-		if (rq_data_dir(req) == WRITE)
-			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_OUT);
-		else
-			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_IN);
+	num = virtblk_map_data(hctx, req, vbr);
+	if (unlikely(num < 0)) {
+		virtblk_cleanup_cmd(req);
+		return BLK_STS_RESOURCE;
 	}
 
 	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
-	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
+	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg_table.sgl, num);
 	if (err) {
 		virtqueue_kick(vblk->vqs[qid].vq);
 		/* Don't stop the queue if -ENOMEM: we may have failed to
@@ -284,6 +337,8 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 		if (err == -ENOSPC)
 			blk_mq_stop_hw_queue(hctx);
 		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
+		virtblk_unmap_data(req, vbr);
+		virtblk_cleanup_cmd(req);
 		switch (err) {
 		case -ENOSPC:
 			return BLK_STS_DEV_RESOURCE;
@@ -660,16 +715,6 @@ static const struct attribute_group *virtblk_attr_groups[] = {
 	NULL,
 };
 
-static int virtblk_init_request(struct blk_mq_tag_set *set, struct request *rq,
-		unsigned int hctx_idx, unsigned int numa_node)
-{
-	struct virtio_blk *vblk = set->driver_data;
-	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
-
-	sg_init_table(vbr->sg, vblk->sg_elems);
-	return 0;
-}
-
 static int virtblk_map_queues(struct blk_mq_tag_set *set)
 {
 	struct virtio_blk *vblk = set->driver_data;
@@ -682,7 +727,6 @@ static const struct blk_mq_ops virtio_mq_ops = {
 	.queue_rq	= virtio_queue_rq,
 	.commit_rqs	= virtio_commit_rqs,
 	.complete	= virtblk_request_done,
-	.init_request	= virtblk_init_request,
 	.map_queues	= virtblk_map_queues,
 };
 
@@ -762,7 +806,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	vblk->tag_set.cmd_size =
 		sizeof(struct virtblk_req) +
-		sizeof(struct scatterlist) * sg_elems;
+		sizeof(struct scatterlist) * VIRTIO_BLK_INLINE_SG_CNT;
 	vblk->tag_set.driver_data = vblk;
 	vblk->tag_set.nr_hw_queues = vblk->num_vqs;
 
-- 
2.35.1



