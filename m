Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81874F2528
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiDEHqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiDEHpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:45:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F4897B8F;
        Tue,  5 Apr 2022 00:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8B2E616C4;
        Tue,  5 Apr 2022 07:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECB9C340EE;
        Tue,  5 Apr 2022 07:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144485;
        bh=G+YiT66kRz8BTTb98UipvbU30K5XF4BkKoHnpGnAnow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1uRV3RRo4O5qyqa+SUW0pzMuSuybCSUtHDRIuereHJTvhODRwzt90UBzT9eY/z8pX
         d/kAkfCzMphjHgS8SP4KBAsJDYVQ3H2yiEgvf1vqH9gWTgNndNp/e0kKb7vuggPIr6
         RfgKCt9IcQhW1V4h+hKrYGr98ioAxPaIdSai2yDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Subject: [PATCH 5.17 0012/1126] block: ensure plug merging checks the correct queue at least once
Date:   Tue,  5 Apr 2022 09:12:39 +0200
Message-Id: <20220405070407.899704431@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
 block/blk-merge.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -1089,12 +1089,20 @@ bool blk_attempt_plug_merge(struct reque
 	if (!plug || rq_list_empty(plug->mq_list))
 		return false;
 
-	/* check the previously added entry for a quick merge attempt */
-	rq = rq_list_peek(&plug->mq_list);
-	if (rq->q == q) {
-		if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
-				BIO_MERGE_OK)
-			return true;
+	rq_list_for_each(&plug->mq_list, rq) {
+		if (rq->q == q) {
+			if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
+			    BIO_MERGE_OK)
+				return true;
+			break;
+		}
+
+		/*
+		 * Only keep iterating plug list for merges if we have multiple
+		 * queues
+		 */
+		if (!plug->multiple_queues)
+			break;
 	}
 	return false;
 }


