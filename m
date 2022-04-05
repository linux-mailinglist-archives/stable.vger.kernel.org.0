Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D3F4F355A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbiDEI6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbiDEIjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:39:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02D821802;
        Tue,  5 Apr 2022 01:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36FADB81A32;
        Tue,  5 Apr 2022 08:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F263C385A0;
        Tue,  5 Apr 2022 08:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147580;
        bh=aFHFFMUipHtG2lH2cH1iKH9i2DXXPKMIpLsnTSvrAjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ea+Em23vH2+LlNZg6SuEIUl/C4kE9sgPEk0iHIeJ60CLZNpcoYSiNHUl0eZGxDAvK
         W67coiOw2dMiRkntxYueSpXRi6sHzCUU4RMs6VIEQ1VRwGaPOgOkf7imLHJFJM8801
         oQS7YHln+QaDpxObdHf5Inwt0Sn8JGcV67h67f4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Subject: [PATCH 5.16 0030/1017] block: ensure plug merging checks the correct queue at least once
Date:   Tue,  5 Apr 2022 09:15:43 +0200
Message-Id: <20220405070355.072987835@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jens Axboe <axboe@kernel.dk>

commit 5b2050718d095cd3242d1f42aaaea3a2fec8e6f0 upstream.

Song reports that a RAID rebuild workload runs much slower recently,
and it is seeing a lot less merging than it did previously. The reason
is that a previous commit reduced the amount of work we do for plug
merging. RAID rebuild interleaves requests between disks, so a last-entry
check in plug merging always misses a merge opportunity since we always
find a different disk than what we are looking for.

Modify the logic such that it's still a one-hit cache, but ensure that
we check enough to find the right target before giving up.

Fixes: d38a9c04c0d5 ("block: only check previous entry for plug merge attempt")
Reported-and-tested-by: Song Liu <song@kernel.org>
Reviewed-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-merge.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -1093,18 +1093,21 @@ bool blk_attempt_plug_merge(struct reque
 	if (!plug || rq_list_empty(plug->mq_list))
 		return false;
 
-	/* check the previously added entry for a quick merge attempt */
-	rq = rq_list_peek(&plug->mq_list);
-	if (rq->q == q) {
+	rq_list_for_each(&plug->mq_list, rq) {
+		if (rq->q == q) {
+			*same_queue_rq = true;
+			if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
+			    BIO_MERGE_OK)
+				return true;
+			break;
+		}
+
 		/*
-		 * Only blk-mq multiple hardware queues case checks the rq in
-		 * the same queue, there should be only one such rq in a queue
+		 * Only keep iterating plug list for merges if we have multiple
+		 * queues
 		 */
-		*same_queue_rq = true;
-
-		if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
-				BIO_MERGE_OK)
-			return true;
+		if (!plug->multiple_queues)
+			break;
 	}
 	return false;
 }


