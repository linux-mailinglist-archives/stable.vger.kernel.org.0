Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC3059D39E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242407AbiHWIQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242853AbiHWIQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:16:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E387F4CA26;
        Tue, 23 Aug 2022 01:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 331D7CE1B34;
        Tue, 23 Aug 2022 08:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EBDC433D7;
        Tue, 23 Aug 2022 08:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242231;
        bh=e9/obfON0SGjLdk8YP68PwFGB6cUPYEn5IAuShp4TRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JB8rQH5fnLAkEUbPAxyTS+vOr5tanSH5LSx3i3mWj2/Z87I3OJkuKE4jIMO0Y128I
         wN2+p9tb5+uTpvokxbNdxpzWsT2ye8awlUYcqFaKydUbq99HLVa8EAUYJInwQT0Hsv
         Rd44NZO1yCEW2esiJKbKZIrhYOW2KufGWOuuB0V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Suwan Kim" <suwan.kim027@gmail.com>,
        Shigeru Yoshida <syoshida@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.19 080/365] virtio-blk: Avoid use-after-free on suspend/resume
Date:   Tue, 23 Aug 2022 09:59:41 +0200
Message-Id: <20220823080121.539401933@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

commit 8d12ec10292877751ee4463b11a63bd850bc09b5 upstream.

hctx->user_data is set to vq in virtblk_init_hctx().  However, vq is
freed on suspend and reallocated on resume.  So, hctx->user_data is
invalid after resume, and it will cause use-after-free accessing which
will result in the kernel crash something like below:

[   22.428391] Call Trace:
[   22.428899]  <TASK>
[   22.429339]  virtqueue_add_split+0x3eb/0x620
[   22.430035]  ? __blk_mq_alloc_requests+0x17f/0x2d0
[   22.430789]  ? kvm_clock_get_cycles+0x14/0x30
[   22.431496]  virtqueue_add_sgs+0xad/0xd0
[   22.432108]  virtblk_add_req+0xe8/0x150
[   22.432692]  virtio_queue_rqs+0xeb/0x210
[   22.433330]  blk_mq_flush_plug_list+0x1b8/0x280
[   22.434059]  __blk_flush_plug+0xe1/0x140
[   22.434853]  blk_finish_plug+0x20/0x40
[   22.435512]  read_pages+0x20a/0x2e0
[   22.436063]  ? folio_add_lru+0x62/0xa0
[   22.436652]  page_cache_ra_unbounded+0x112/0x160
[   22.437365]  filemap_get_pages+0xe1/0x5b0
[   22.437964]  ? context_to_sid+0x70/0x100
[   22.438580]  ? sidtab_context_to_sid+0x32/0x400
[   22.439979]  filemap_read+0xcd/0x3d0
[   22.440917]  xfs_file_buffered_read+0x4a/0xc0
[   22.441984]  xfs_file_read_iter+0x65/0xd0
[   22.442970]  __kernel_read+0x160/0x2e0
[   22.443921]  bprm_execve+0x21b/0x640
[   22.444809]  do_execveat_common.isra.0+0x1a8/0x220
[   22.446008]  __x64_sys_execve+0x2d/0x40
[   22.446920]  do_syscall_64+0x37/0x90
[   22.447773]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

This patch fixes this issue by getting vq from vblk, and removes
virtblk_init_hctx().

Fixes: 4e0400525691 ("virtio-blk: support polling I/O")
Cc: "Suwan Kim" <suwan.kim027@gmail.com>
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Message-Id: <20220810160948.959781-1-syoshida@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/virtio_blk.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6fc7850c2b0a..d756423e0059 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -101,6 +101,14 @@ static inline blk_status_t virtblk_result(struct virtblk_req *vbr)
 	}
 }
 
+static inline struct virtio_blk_vq *get_virtio_blk_vq(struct blk_mq_hw_ctx *hctx)
+{
+	struct virtio_blk *vblk = hctx->queue->queuedata;
+	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
+
+	return vq;
+}
+
 static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr)
 {
 	struct scatterlist hdr, status, *sgs[3];
@@ -416,7 +424,7 @@ static void virtio_queue_rqs(struct request **rqlist)
 	struct request *requeue_list = NULL;
 
 	rq_list_for_each_safe(rqlist, req, next) {
-		struct virtio_blk_vq *vq = req->mq_hctx->driver_data;
+		struct virtio_blk_vq *vq = get_virtio_blk_vq(req->mq_hctx);
 		bool kick;
 
 		if (!virtblk_prep_rq_batch(req)) {
@@ -837,7 +845,7 @@ static void virtblk_complete_batch(struct io_comp_batch *iob)
 static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 {
 	struct virtio_blk *vblk = hctx->queue->queuedata;
-	struct virtio_blk_vq *vq = hctx->driver_data;
+	struct virtio_blk_vq *vq = get_virtio_blk_vq(hctx);
 	struct virtblk_req *vbr;
 	unsigned long flags;
 	unsigned int len;
@@ -862,22 +870,10 @@ static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 	return found;
 }
 
-static int virtblk_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
-			  unsigned int hctx_idx)
-{
-	struct virtio_blk *vblk = data;
-	struct virtio_blk_vq *vq = &vblk->vqs[hctx_idx];
-
-	WARN_ON(vblk->tag_set.tags[hctx_idx] != hctx->tags);
-	hctx->driver_data = vq;
-	return 0;
-}
-
 static const struct blk_mq_ops virtio_mq_ops = {
 	.queue_rq	= virtio_queue_rq,
 	.queue_rqs	= virtio_queue_rqs,
 	.commit_rqs	= virtio_commit_rqs,
-	.init_hctx	= virtblk_init_hctx,
 	.complete	= virtblk_request_done,
 	.map_queues	= virtblk_map_queues,
 	.poll		= virtblk_poll,
-- 
2.37.2



