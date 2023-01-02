Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8901465B0ED
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbjABL3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236077AbjABL3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF3C64F8
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:28:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51236B80D1D
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0E6C433EF;
        Mon,  2 Jan 2023 11:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658891;
        bh=HJztrE50RodWQQ7ph+MW1RWnCJQr7t+NC275WE3vOKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXR9TosKIHIu2BlNGlKrEJRdHcPT460butWzdqxcSifkNa5bqFBP+RhdDCiNWg0ZY
         jyjeVX1kBepHwCegBTmzIa0Pt+SFlnMkB49oP7OnK18ZaFBCw95DEa2MRatbJlxqEA
         8pb4CO8+U7xRWQuOkn1TX4vcW8/hmQ8f6qRZ17gE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Andreas Herrmann <aherrmann@suse.de>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 08/74] blk-cgroup: pass a gendisk to blkg_destroy_all
Date:   Mon,  2 Jan 2023 12:21:41 +0100
Message-Id: <20230102110552.401151201@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 00ad6991bbae116b7c83f68754edd6f4d5e65e01 ]

Pass the gendisk to blkg_destroy_all as part of moving the blk-cgroup
infrastructure to be gendisk based.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220921180501.1539876-16-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 813e693023ba ("blk-iolatency: Fix memory leak on add_disk() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index afe802e1180f..cd682fe46d2f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -462,14 +462,9 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	percpu_ref_kill(&blkg->refcnt);
 }
 
-/**
- * blkg_destroy_all - destroy all blkgs associated with a request_queue
- * @q: request_queue of interest
- *
- * Destroy all blkgs associated with @q.
- */
-static void blkg_destroy_all(struct request_queue *q)
+static void blkg_destroy_all(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
 	struct blkcg_gq *blkg, *n;
 	int count = BLKG_DESTROY_BATCH_SIZE;
 
@@ -1292,7 +1287,7 @@ int blkcg_init_disk(struct gendisk *disk)
 err_ioprio_exit:
 	blk_ioprio_exit(q);
 err_destroy_all:
-	blkg_destroy_all(q);
+	blkg_destroy_all(disk);
 	return ret;
 err_unlock:
 	spin_unlock_irq(&q->queue_lock);
@@ -1303,7 +1298,7 @@ int blkcg_init_disk(struct gendisk *disk)
 
 void blkcg_exit_disk(struct gendisk *disk)
 {
-	blkg_destroy_all(disk->queue);
+	blkg_destroy_all(disk);
 	blk_throtl_exit(disk);
 }
 
-- 
2.35.1



