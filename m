Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F7E52FEE1
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 20:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345074AbiEUS4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 14:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344865AbiEUS4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 14:56:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9BB5C37F
        for <stable@vger.kernel.org>; Sat, 21 May 2022 11:56:34 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z11so811756pjc.3
        for <stable@vger.kernel.org>; Sat, 21 May 2022 11:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0A8tk/FZyjoCZiFMRTs3XVXcvmG1Yi5VNzrHoMW6Lis=;
        b=ofXzbJUS7/sHfRdWNCkRIvC8HtfRYkAGQ3M2+94U5S79Ekg06RWlBTEDsaa9zdCFC8
         A99nRN5bTqur0RWuMYq/oGB2uLfVoAnGIE0lJ4ItqtBdnIv0O555ZlczmasaGiYSyYSm
         0TBUmaYA+tPYyUASaGtIwmKMW0A8Gh3yburOk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0A8tk/FZyjoCZiFMRTs3XVXcvmG1Yi5VNzrHoMW6Lis=;
        b=j7HBSMCeNsYQA7KH5iMymXmLTXjiiNSqGskYcY+rtZ0ukXJCDQJCD5zrmOPdCX9udq
         xnfFjTcocOUSdU3bN9WUbKCVE71CS3ZXdDyMlTnCgTIQB22itNB2zXgBprdJrFwOuOw0
         WeUPyWdJfoZzVI18+dyTr80fzVwmtQM3iZgC2U5h4MlybJuuHLa+F0QiDGBOa5Bh6z8f
         Jks6TZunbMPReN6lGwKzJ731f7RlpDQ8rDlj8N0VA8blXUCTA+FDf0toO9fvKNjkTaIS
         8jwW2h6+If2L2R9gyhm6Lii6pPs3/5xy3RoGzDzvKeBNYsiHC5t8eZW937z2yQWldoa6
         XbJA==
X-Gm-Message-State: AOAM530UMV3Dw36apD+mRJ5ud3yFE6xGB1mO327iiZDUEOH952vpgrGF
        3VjL9dE0ymf8aBF1YgRgNj2sKA==
X-Google-Smtp-Source: ABdhPJzXg2f+/9R12RrMT81tzukQF/GwSVmBZHzA//D3QqCaKBPndIJ3AOONrohN/v30ykK4bhgmKw==
X-Received: by 2002:a17:903:404d:b0:161:558a:4375 with SMTP id n13-20020a170903404d00b00161558a4375mr15928091pla.86.1653159394388;
        Sat, 21 May 2022 11:56:34 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:3726:7e92:2051:7436])
        by smtp.gmail.com with UTF8SMTPSA id ne2-20020a17090b374200b001df4c5cab51sm4045583pjb.15.2022.05.21.11.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 May 2022 11:56:33 -0700 (PDT)
From:   Gwendal Grignou <gwendal@chromium.org>
To:     paolo.valente@linaro.org, axboe@kernel.dk,
        gregkh@linuxfoundation.org, xieyongji@bytedance.com,
        ming.lei@redhat.com
Cc:     linux-block@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH] block: return ELEVATOR_DISCARD_MERGE if possible
Date:   Sat, 21 May 2022 11:56:26 -0700
Message-Id: <20220521185626.3333530-1-gwendal@chromium.org>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

When merging one bio to request, if they are discard IO and the queue
supports multi-range discard, we need to return ELEVATOR_DISCARD_MERGE
because both block core and related drivers(nvme, virtio-blk) doesn't
handle mixed discard io merge(traditional IO merge together with
discard merge) well.

Fix the issue by returning ELEVATOR_DISCARD_MERGE in this situation,
so both blk-mq and drivers just need to handle multi-range discard.

Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Fixes: 2705dfb20947 ("block: fix discard request merge")
Link: https://lore.kernel.org/r/20210729034226.1591070-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

commit 866663b7b52d2 upstream.

Similar to commit 87aa69aa10b42 ("block: return ELEVATOR_DISCARD_MERGE if possible")
in 5.10 kernel.

Conflicts:
   block/blk-merge.c: function at a different place.
   block/mq-deadline-main.c: not in 5.4, use mq-deadline.c instead.

Cc: <stable@vger.kernel.org> # 5.4.y
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 block/bfq-iosched.c    |  3 +++
 block/blk-merge.c      | 15 ---------------
 block/elevator.c       |  3 +++
 block/mq-deadline.c    |  2 ++
 include/linux/blkdev.h | 16 ++++++++++++++++
 5 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 1d443d17cf7c5..d46806182b051 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2251,6 +2251,9 @@ static int bfq_request_merge(struct request_queue *q, struct request **req,
 	__rq = bfq_find_rq_fmerge(bfqd, bio, q);
 	if (__rq && elv_bio_merge_ok(__rq, bio)) {
 		*req = __rq;
+
+		if (blk_discard_mergable(__rq))
+			return ELEVATOR_DISCARD_MERGE;
 		return ELEVATOR_FRONT_MERGE;
 	}
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index a62692d135660..5219064cd72bb 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -721,21 +721,6 @@ static void blk_account_io_merge(struct request *req)
 		part_stat_unlock();
 	}
 }
-/*
- * Two cases of handling DISCARD merge:
- * If max_discard_segments > 1, the driver takes every bio
- * as a range and send them to controller together. The ranges
- * needn't to be contiguous.
- * Otherwise, the bios/requests will be handled as same as
- * others which should be contiguous.
- */
-static inline bool blk_discard_mergable(struct request *req)
-{
-	if (req_op(req) == REQ_OP_DISCARD &&
-	    queue_max_discard_segments(req->q) > 1)
-		return true;
-	return false;
-}
 
 static enum elv_merge blk_try_req_merge(struct request *req,
 					struct request *next)
diff --git a/block/elevator.c b/block/elevator.c
index 78805c74ea8a4..3ba826230c578 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -337,6 +337,9 @@ enum elv_merge elv_merge(struct request_queue *q, struct request **req,
 	__rq = elv_rqhash_find(q, bio->bi_iter.bi_sector);
 	if (__rq && elv_bio_merge_ok(__rq, bio)) {
 		*req = __rq;
+
+		if (blk_discard_mergable(__rq))
+			return ELEVATOR_DISCARD_MERGE;
 		return ELEVATOR_BACK_MERGE;
 	}
 
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 19c6922e85f1b..6d6dda5cfffa3 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -452,6 +452,8 @@ static int dd_request_merge(struct request_queue *q, struct request **rq,
 
 		if (elv_bio_merge_ok(__rq, bio)) {
 			*rq = __rq;
+			if (blk_discard_mergable(__rq))
+				return ELEVATOR_DISCARD_MERGE;
 			return ELEVATOR_FRONT_MERGE;
 		}
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8cc766743270f..308c2d8cdca19 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1409,6 +1409,22 @@ static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector
 	return offset << SECTOR_SHIFT;
 }
 
+/*
+ * Two cases of handling DISCARD merge:
+ * If max_discard_segments > 1, the driver takes every bio
+ * as a range and send them to controller together. The ranges
+ * needn't to be contiguous.
+ * Otherwise, the bios/requests will be handled as same as
+ * others which should be contiguous.
+ */
+static inline bool blk_discard_mergable(struct request *req)
+{
+	if (req_op(req) == REQ_OP_DISCARD &&
+	    queue_max_discard_segments(req->q) > 1)
+		return true;
+	return false;
+}
+
 static inline int bdev_discard_alignment(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-- 
2.36.1.124.g0e6072fb45-goog

