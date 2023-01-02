Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCE065B0EC
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbjABL33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbjABL3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46BA64D9
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:28:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FD07B80D1D
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EA0C433D2;
        Mon,  2 Jan 2023 11:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658888;
        bh=4wlo2/Dd5CujuiBkCvx8MyiqreDK3NPxFRAy+CFsC7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsnx26Gv3EiNtBX30rsLOHp9YJFV28deQLtcR081hXQ5oOTPCENC0hyN99FKDqhZu
         SBKc4FHiIS7QEQq+J9JmCaK/p2VFKY6zG5yOsJUbo39LUMTOnnYT4rJ1V09c0SqrDw
         wlBkp83h6KeVinP7XhORmp4PaJLBTERZs1hykuNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Andreas Herrmann <aherrmann@suse.de>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 07/74] blk-throttle: pass a gendisk to blk_throtl_init and blk_throtl_exit
Date:   Mon,  2 Jan 2023 12:21:40 +0100
Message-Id: <20230102110552.361250389@linuxfoundation.org>
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

[ Upstream commit e13793bae65919cd3e6a7827f8d30f4dbb8584ee ]

Pass the gendisk to blk_throtl_init and blk_throtl_exit as part of moving
the blk-cgroup infrastructure to be gendisk based.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220921180501.1539876-13-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 813e693023ba ("blk-iolatency: Fix memory leak on add_disk() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c   | 6 +++---
 block/blk-throttle.c | 7 +++++--
 block/blk-throttle.h | 8 ++++----
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4943f36d8a84..afe802e1180f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1277,7 +1277,7 @@ int blkcg_init_disk(struct gendisk *disk)
 	if (ret)
 		goto err_destroy_all;
 
-	ret = blk_throtl_init(q);
+	ret = blk_throtl_init(disk);
 	if (ret)
 		goto err_ioprio_exit;
 
@@ -1288,7 +1288,7 @@ int blkcg_init_disk(struct gendisk *disk)
 	return 0;
 
 err_throtl_exit:
-	blk_throtl_exit(q);
+	blk_throtl_exit(disk);
 err_ioprio_exit:
 	blk_ioprio_exit(q);
 err_destroy_all:
@@ -1304,7 +1304,7 @@ int blkcg_init_disk(struct gendisk *disk)
 void blkcg_exit_disk(struct gendisk *disk)
 {
 	blkg_destroy_all(disk->queue);
-	blk_throtl_exit(disk->queue);
+	blk_throtl_exit(disk);
 }
 
 static void blkcg_bind(struct cgroup_subsys_state *root_css)
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 35cf744ea9d1..f84a6ed440c9 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2276,8 +2276,9 @@ void blk_throtl_bio_endio(struct bio *bio)
 }
 #endif
 
-int blk_throtl_init(struct request_queue *q)
+int blk_throtl_init(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
 	struct throtl_data *td;
 	int ret;
 
@@ -2319,8 +2320,10 @@ int blk_throtl_init(struct request_queue *q)
 	return ret;
 }
 
-void blk_throtl_exit(struct request_queue *q)
+void blk_throtl_exit(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
+
 	BUG_ON(!q->td);
 	del_timer_sync(&q->td->service_queue.pending_timer);
 	throtl_shutdown_wq(q);
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index ee7299e6dea9..e8c2b3d4a18b 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -159,14 +159,14 @@ static inline struct throtl_grp *blkg_to_tg(struct blkcg_gq *blkg)
  * Internal throttling interface
  */
 #ifndef CONFIG_BLK_DEV_THROTTLING
-static inline int blk_throtl_init(struct request_queue *q) { return 0; }
-static inline void blk_throtl_exit(struct request_queue *q) { }
+static inline int blk_throtl_init(struct gendisk *disk) { return 0; }
+static inline void blk_throtl_exit(struct gendisk *disk) { }
 static inline void blk_throtl_register_queue(struct request_queue *q) { }
 static inline bool blk_throtl_bio(struct bio *bio) { return false; }
 static inline void blk_throtl_cancel_bios(struct request_queue *q) { }
 #else /* CONFIG_BLK_DEV_THROTTLING */
-int blk_throtl_init(struct request_queue *q);
-void blk_throtl_exit(struct request_queue *q);
+int blk_throtl_init(struct gendisk *disk);
+void blk_throtl_exit(struct gendisk *disk);
 void blk_throtl_register_queue(struct request_queue *q);
 bool __blk_throtl_bio(struct bio *bio);
 void blk_throtl_cancel_bios(struct request_queue *q);
-- 
2.35.1



