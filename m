Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF5B41210C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350827AbhITSB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355975AbhITR54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C90863216;
        Mon, 20 Sep 2021 17:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158099;
        bh=ax2mhvkpee7ckuHwy+/FhcIhJe52nfgBGEDZ1nqYX9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoZB5ACHcVc8hB8pXSBCX498JnHxnl8kAuSP25hEVL2h6WmxVK7oAj5bn+qQMXumm
         K6dEPzs0P7AVZemaHTT2FsbCmvWeGKNNTUa1yuuvISmSZEjzm/eqeClz62MASt423r
         lRs6burllrrfhxw8yz6DbMMA8GeLzCgDB8ymm0gQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Zini <davidezini2@gmail.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 279/293] block, bfq: honor already-setup queue merges
Date:   Mon, 20 Sep 2021 18:44:01 +0200
Message-Id: <20210920163942.966284849@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit 2d52c58b9c9bdae0ca3df6a1eab5745ab3f7d80b ]

The function bfq_setup_merge prepares the merging between two
bfq_queues, say bfqq and new_bfqq. To this goal, it assigns
bfqq->new_bfqq = new_bfqq. Then, each time some I/O for bfqq arrives,
the process that generated that I/O is disassociated from bfqq and
associated with new_bfqq (merging is actually a redirection). In this
respect, bfq_setup_merge increases new_bfqq->ref in advance, adding
the number of processes that are expected to be associated with
new_bfqq.

Unfortunately, the stable-merging mechanism interferes with this
setup. After bfqq->new_bfqq has been set by bfq_setup_merge, and
before all the expected processes have been associated with
bfqq->new_bfqq, bfqq may happen to be stably merged with a different
queue than the current bfqq->new_bfqq. In this case, bfqq->new_bfqq
gets changed. So, some of the processes that have been already
accounted for in the ref counter of the previous new_bfqq will not be
associated with that queue.  This creates an unbalance, because those
references will never be decremented.

This commit fixes this issue by reestablishing the previous, natural
behaviour: once bfqq->new_bfqq has been set, it will not be changed
until all expected redirections have occurred.

Signed-off-by: Davide Zini <davidezini2@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Link: https://lore.kernel.org/r/20210802141352.74353-2-paolo.valente@linaro.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index b2bad345c523..c8c94e8e0f72 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2137,6 +2137,15 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
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
@@ -2196,6 +2205,10 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
+	/* if a merge has already been setup, then proceed with that first */
+	if (bfqq->new_bfqq)
+		return bfqq->new_bfqq;
+
 	/*
 	 * Prevent bfqq from being merged if it has been created too
 	 * long ago. The idea is that true cooperating processes, and
@@ -2210,9 +2223,6 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (bfq_too_late_for_merging(bfqq))
 		return NULL;
 
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
-
 	if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
 		return NULL;
 
-- 
2.30.2



