Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE374E9456
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiC1L2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240827AbiC1LZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579B56153;
        Mon, 28 Mar 2022 04:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7A4B61169;
        Mon, 28 Mar 2022 11:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D9BC34111;
        Mon, 28 Mar 2022 11:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466610;
        bh=MwXCBmvgBIfUGIiNvssXa/owXggBXD34ni9XDeQdfnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNADgYvggZKRRwqwIGiJmxWcNDpQkkW+q5YCB/Y7GRIxITPOkj4xd3YW3ZBfn7xmW
         iJ5CKgZl/XnBVrketJIsvLEzbHgKwFqfycPlFKLV2JOhFLKXq+z4Uhf+mlAuRjN0U9
         rNTSD6mGy+06jixZdKXartcxCrorBO5efBpT0kNZHriK2SxwuiYICa2dwti7Rklwtt
         DHsWvL4mhPV2TMPJT4h1syWYnsrHxCjWbPlHmYYkaMMbrd0YCbMiBxkZd486cQ/sO1
         /1U/3n5RcpHsWuLU0pJvwYLx23Z39VMQNp/kjPe15lBKXO68DOWRKD62ejbrI1s49M
         WOeuVSW1y3kAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        =?UTF-8?q?Holger=20Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/21] Revert "Revert "block, bfq: honor already-setup queue merges""
Date:   Mon, 28 Mar 2022 07:22:49 -0400
Message-Id: <20220328112254.1556286-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112254.1556286-1-sashal@kernel.org>
References: <20220328112254.1556286-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit 15729ff8143f8135b03988a100a19e66d7cb7ecd ]

A crash [1] happened to be triggered in conjunction with commit
2d52c58b9c9b ("block, bfq: honor already-setup queue merges"). The
latter was then reverted by commit ebc69e897e17 ("Revert "block, bfq:
honor already-setup queue merges""). Yet, the reverted commit was not
the one introducing the bug. In fact, it actually triggered a UAF
introduced by a different commit, and now fixed by commit d29bd41428cf
("block, bfq: reset last_bfqq_created on group change").

So, there is no point in keeping commit 2d52c58b9c9b ("block, bfq:
honor already-setup queue merges") out. This commit restores it.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=214503

Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Link: https://lore.kernel.org/r/20211125181510.15004-1-paolo.valente@linaro.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 138541996dd5..de2cd4bd602f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2526,6 +2526,15 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
 	 * are likely to increase the throughput.
 	 */
 	bfqq->new_bfqq = new_bfqq;
+	/*
+	 * The above assignment schedules the following redirections:
+	 * each time some I/O for bfqq arrives, the process that
+	 * generated that I/O is disassociated from bfqq and
+	 * associated with new_bfqq. Here we increases new_bfqq->ref
+	 * in advance, adding the number of processes that are
+	 * expected to be associated with new_bfqq as they happen to
+	 * issue I/O.
+	 */
 	new_bfqq->ref += process_refs;
 	return new_bfqq;
 }
@@ -2585,6 +2594,10 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
+	/* if a merge has already been setup, then proceed with that first */
+	if (bfqq->new_bfqq)
+		return bfqq->new_bfqq;
+
 	/*
 	 * Do not perform queue merging if the device is non
 	 * rotational and performs internal queueing. In fact, such a
@@ -2639,9 +2652,6 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (bfq_too_late_for_merging(bfqq))
 		return NULL;
 
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
-
 	if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
 		return NULL;
 
-- 
2.34.1

