Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560BB6649AB
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbjAJSXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239326AbjAJSWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:22:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6357A1D0C9
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:20:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0169861871
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163F5C433EF;
        Tue, 10 Jan 2023 18:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374830;
        bh=elF3XBcpOZsBxqzqMcH6ZbTeIlKMG5eGS+rqQ2+0j9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWTcY9tqLxl2Cn9Wq8DW49FFZA/uliA444mrDsTAidzD5QFKKa1UMW3q30zd5E8Mr
         XfAtH4DsrpGxa8xeLa/mrlXLb+GV9lwPSihLYHWUj5Bp6Hmfr7WeQ4x69PWeK4ylLg
         2Wfw8ka4xo5aqjSNOC/cmEbRnmAyDuFtM+PREHJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/159] virtio-blk: use a helper to handle request queuing errors
Date:   Tue, 10 Jan 2023 19:04:56 +0100
Message-Id: <20230110180023.213648044@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

[ Upstream commit 258896fcc786b4e7db238eba26f6dd080e0ff41e ]

Define a new helper function, virtblk_fail_to_queue(), to
clean up the error handling code in virtio_queue_rq().

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Message-Id: <20221016034127.330942-2-dmitry.fomichev@wdc.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: a26116c1e740 ("virtio_blk: Fix signedness bug in virtblk_prep_rq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 19da5defd734..3efe3da5f8c2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -315,6 +315,19 @@ static void virtio_commit_rqs(struct blk_mq_hw_ctx *hctx)
 		virtqueue_notify(vq->vq);
 }
 
+static blk_status_t virtblk_fail_to_queue(struct request *req, int rc)
+{
+	virtblk_cleanup_cmd(req);
+	switch (rc) {
+	case -ENOSPC:
+		return BLK_STS_DEV_RESOURCE;
+	case -ENOMEM:
+		return BLK_STS_RESOURCE;
+	default:
+		return BLK_STS_IOERR;
+	}
+}
+
 static blk_status_t virtblk_prep_rq(struct blk_mq_hw_ctx *hctx,
 					struct virtio_blk *vblk,
 					struct request *req,
@@ -327,10 +340,8 @@ static blk_status_t virtblk_prep_rq(struct blk_mq_hw_ctx *hctx,
 		return status;
 
 	vbr->sg_table.nents = virtblk_map_data(hctx, req, vbr);
-	if (unlikely(vbr->sg_table.nents < 0)) {
-		virtblk_cleanup_cmd(req);
-		return BLK_STS_RESOURCE;
-	}
+	if (unlikely(vbr->sg_table.nents < 0))
+		return virtblk_fail_to_queue(req, -ENOMEM);
 
 	blk_mq_start_request(req);
 
@@ -364,15 +375,7 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 			blk_mq_stop_hw_queue(hctx);
 		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
 		virtblk_unmap_data(req, vbr);
-		virtblk_cleanup_cmd(req);
-		switch (err) {
-		case -ENOSPC:
-			return BLK_STS_DEV_RESOURCE;
-		case -ENOMEM:
-			return BLK_STS_RESOURCE;
-		default:
-			return BLK_STS_IOERR;
-		}
+		return virtblk_fail_to_queue(req, err);
 	}
 
 	if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
-- 
2.35.1



