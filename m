Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B56420D44
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhJDNN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235453AbhJDNLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88B2261B03;
        Mon,  4 Oct 2021 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352661;
        bh=1ghMdtphKXKe1KwNpRdVfyD26RNIR5e27bdtHbqO+24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13CrINBWTfLM0iAgUZ27gXGDczGiXcos0h0vhEflfM/XzqgmefqglyaoE0d2Ebue9
         2nbOTiITNLufWhuoD3yQMap5Bjn61bARU9bC/RUTElSp4VTLsdCK5bZh8PT0XrD+i/
         8XJPi5MeN7f77eqGZZB8+tCSi/fUAZ9PDu1u2aJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 72/95] Revert "block, bfq: honor already-setup queue merges"
Date:   Mon,  4 Oct 2021 14:52:42 +0200
Message-Id: <20211004125035.932083278@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
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
index c8c94e8e0f72..b2bad345c523 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2137,15 +2137,6 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
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
@@ -2205,10 +2196,6 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
-	/* if a merge has already been setup, then proceed with that first */
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
-
 	/*
 	 * Prevent bfqq from being merged if it has been created too
 	 * long ago. The idea is that true cooperating processes, and
@@ -2223,6 +2210,9 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (bfq_too_late_for_merging(bfqq))
 		return NULL;
 
+	if (bfqq->new_bfqq)
+		return bfqq->new_bfqq;
+
 	if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
 		return NULL;
 
-- 
2.33.0



