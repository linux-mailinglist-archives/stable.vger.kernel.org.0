Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2636AE8D3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCGRTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjCGRSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:18:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D333E635
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:14:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2185BB81929
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70192C433D2;
        Tue,  7 Mar 2023 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209250;
        bh=lspSyBowoCk14tPTunCA+VSAcoKQvoyRY9IHM6AyROg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Of+H0e1+sx7vdbVcvS41mjzy6QCeL+k8VVYBlkVrLr8DwjRnVEXPJ69zHozrEyCG1
         y3l6GkcHsK0ZelOXwKdDu/6s83pTJILMxLCgw7BfIhjzpAo9s5LST5tIwFcQv2JbZf
         o0tW0fsyfNPg79cawPbJ7DAhEIoBh1C6b7ILKz0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tejun Heo <tj@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0128/1001] block: sync mixed merged requests failfast with 1st bios
Date:   Tue,  7 Mar 2023 17:48:20 +0100
Message-Id: <20230307170027.615928813@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index b7c193d67185d..30e4a99c2276b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -757,6 +757,33 @@ void blk_rq_set_mixed_merge(struct request *rq)
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
@@ -954,7 +981,7 @@ enum bio_merge_status {
 static enum bio_merge_status bio_attempt_back_merge(struct request *req,
 		struct bio *bio, unsigned int nr_segs)
 {
-	const blk_opf_t ff = bio->bi_opf & REQ_FAILFAST_MASK;
+	const blk_opf_t ff = bio_failfast(bio);
 
 	if (!ll_back_merge_fn(req, bio, nr_segs))
 		return BIO_MERGE_FAILED;
@@ -965,6 +992,8 @@ static enum bio_merge_status bio_attempt_back_merge(struct request *req,
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
 
+	blk_update_mixed_merge(req, bio, false);
+
 	req->biotail->bi_next = bio;
 	req->biotail = bio;
 	req->__data_len += bio->bi_iter.bi_size;
@@ -978,7 +1007,7 @@ static enum bio_merge_status bio_attempt_back_merge(struct request *req,
 static enum bio_merge_status bio_attempt_front_merge(struct request *req,
 		struct bio *bio, unsigned int nr_segs)
 {
-	const blk_opf_t ff = bio->bi_opf & REQ_FAILFAST_MASK;
+	const blk_opf_t ff = bio_failfast(bio);
 
 	if (!ll_front_merge_fn(req, bio, nr_segs))
 		return BIO_MERGE_FAILED;
@@ -989,6 +1018,8 @@ static enum bio_merge_status bio_attempt_front_merge(struct request *req,
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
 
+	blk_update_mixed_merge(req, bio, true);
+
 	bio->bi_next = req->bio;
 	req->bio = bio;
 
-- 
2.39.2



