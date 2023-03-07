Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D06A6AEE18
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjCGSJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjCGSJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AC596F0B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:03:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9513B819BC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38475C4339B;
        Tue,  7 Mar 2023 18:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212197;
        bh=AM/Ud54adwBqpWgifSYWZpBCL7Pz9Dxq3m9E6o4lDzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRTFDYAw+Rzc8eR+onXSSpu4XceJqfnghA+ycanne9Lkt+rLf7pyZBdtm9fSokpJr
         jyaz8A0RQzryZBliCGmaEHeEYv3OGqGEc7hx2Ysq7wmA3cAAn+NhOhon1FAxyTKHfT
         eB1jUgxWfOCu/mSq8mflI+PjkvD6fOTh96BkRIVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tejun Heo <tj@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/885] block: sync mixed merged requests failfast with 1st bios
Date:   Tue,  7 Mar 2023 17:50:41 +0100
Message-Id: <20230307170006.535188121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 3ce6a115980c019928fcd06e01f64003886af79c ]

We support mixed merge for requests/bios with different fastfail
settings. When request fails, each time we only handle the portion
with same failfast setting, then bios with failfast can be failed
immediately, and bios without failfast can be retried.

The idea is pretty good, but the current implementation has several
defects:

1) initially RA bio doesn't set failfast, however bio merge code
doesn't consider this point, and just check its failfast setting for
deciding if mixed merge is required. Fix this issue by adding helper
of bio_failfast().

2) when merging bio to request front, if this request is mixed
merged, we have to sync request's faifast setting with 1st bio's
failfast. Fix it by calling blk_update_mixed_merge().

3) when merging bio to request back, if this request is mixed
merged, we have to mark the bio as failfast, because blk_update_request
simply updates request failfast with 1st bio's failfast. Fix
it by calling blk_update_mixed_merge().

Fixes one normal EXT4 READ IO failure issue, because it is observed
that the normal READ IO is merged with RA IO, and the mixed merged
request has different failfast setting with 1st bio's, so finally
the normal READ IO doesn't get retried.

Cc: Tejun Heo <tj@kernel.org>
Fixes: 80a761fd33cf ("block: implement mixed merge of different failfast requests")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230209125527.667004-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 84f03d066cb31..914da38523b5a 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -747,6 +747,33 @@ void blk_rq_set_mixed_merge(struct request *rq)
 	rq->rq_flags |= RQF_MIXED_MERGE;
 }
 
+static inline unsigned int bio_failfast(const struct bio *bio)
+{
+	if (bio->bi_opf & REQ_RAHEAD)
+		return REQ_FAILFAST_MASK;
+
+	return bio->bi_opf & REQ_FAILFAST_MASK;
+}
+
+/*
+ * After we are marked as MIXED_MERGE, any new RA bio has to be updated
+ * as failfast, and request's failfast has to be updated in case of
+ * front merge.
+ */
+static inline void blk_update_mixed_merge(struct request *req,
+		struct bio *bio, bool front_merge)
+{
+	if (req->rq_flags & RQF_MIXED_MERGE) {
+		if (bio->bi_opf & REQ_RAHEAD)
+			bio->bi_opf |= REQ_FAILFAST_MASK;
+
+		if (front_merge) {
+			req->cmd_flags &= ~REQ_FAILFAST_MASK;
+			req->cmd_flags |= bio->bi_opf & REQ_FAILFAST_MASK;
+		}
+	}
+}
+
 static void blk_account_io_merge_request(struct request *req)
 {
 	if (blk_do_io_stat(req)) {
@@ -944,7 +971,7 @@ enum bio_merge_status {
 static enum bio_merge_status bio_attempt_back_merge(struct request *req,
 		struct bio *bio, unsigned int nr_segs)
 {
-	const blk_opf_t ff = bio->bi_opf & REQ_FAILFAST_MASK;
+	const blk_opf_t ff = bio_failfast(bio);
 
 	if (!ll_back_merge_fn(req, bio, nr_segs))
 		return BIO_MERGE_FAILED;
@@ -955,6 +982,8 @@ static enum bio_merge_status bio_attempt_back_merge(struct request *req,
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
 
+	blk_update_mixed_merge(req, bio, false);
+
 	req->biotail->bi_next = bio;
 	req->biotail = bio;
 	req->__data_len += bio->bi_iter.bi_size;
@@ -968,7 +997,7 @@ static enum bio_merge_status bio_attempt_back_merge(struct request *req,
 static enum bio_merge_status bio_attempt_front_merge(struct request *req,
 		struct bio *bio, unsigned int nr_segs)
 {
-	const blk_opf_t ff = bio->bi_opf & REQ_FAILFAST_MASK;
+	const blk_opf_t ff = bio_failfast(bio);
 
 	if (!ll_front_merge_fn(req, bio, nr_segs))
 		return BIO_MERGE_FAILED;
@@ -979,6 +1008,8 @@ static enum bio_merge_status bio_attempt_front_merge(struct request *req,
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
 
+	blk_update_mixed_merge(req, bio, true);
+
 	bio->bi_next = req->bio;
 	req->bio = bio;
 
-- 
2.39.2



