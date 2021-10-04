Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1E0420ED5
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbhJDN26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236722AbhJDN1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:27:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 523FA61B72;
        Mon,  4 Oct 2021 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353118;
        bh=90CvL/O49qy5C+G7Aq+mqE2wEL7AFDCuIoCUyt0bVfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RitOpha2BlF+fZIwoUQhzAXnlCD+xDXCOUNvNoLYovcmy6qo7EBbFsyNAtdpZnlS9
         5f2OTjrtiBJe2JuG/Duc6p3B/hl0LYPrwmq+x1VLxhKclq77MXUFz+8q5i8Catg3gE
         9YwqxlDVWNhTeGMoye3wAp3EVf0qG6ddyQ6E/x4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/93] Revert "block, bfq: honor already-setup queue merges"
Date:   Mon,  4 Oct 2021 14:52:51 +0200
Message-Id: <20211004125036.331527780@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit ebc69e897e17373fbe1daaff1debaa77583a5284 ]

This reverts commit 2d52c58b9c9bdae0ca3df6a1eab5745ab3f7d80b.

We have had several folks complain that this causes hangs for them, which
is especially problematic as the commit has also hit stable already.

As no resolution seems to be forthcoming right now, revert the patch.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=214503
Fixes: 2d52c58b9c9b ("block, bfq: honor already-setup queue merges")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 65c200e0ecb5..b8c2ddc01aec 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2526,15 +2526,6 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
 	 * are likely to increase the throughput.
 	 */
 	bfqq->new_bfqq = new_bfqq;
-	/*
-	 * The above assignment schedules the following redirections:
-	 * each time some I/O for bfqq arrives, the process that
-	 * generated that I/O is disassociated from bfqq and
-	 * associated with new_bfqq. Here we increases new_bfqq->ref
-	 * in advance, adding the number of processes that are
-	 * expected to be associated with new_bfqq as they happen to
-	 * issue I/O.
-	 */
 	new_bfqq->ref += process_refs;
 	return new_bfqq;
 }
@@ -2594,10 +2585,6 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
-	/* if a merge has already been setup, then proceed with that first */
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
-
 	/*
 	 * Do not perform queue merging if the device is non
 	 * rotational and performs internal queueing. In fact, such a
@@ -2652,6 +2639,9 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (bfq_too_late_for_merging(bfqq))
 		return NULL;
 
+	if (bfqq->new_bfqq)
+		return bfqq->new_bfqq;
+
 	if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
 		return NULL;
 
-- 
2.33.0



