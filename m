Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7444077B7
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbhIKNTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236952AbhIKNRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:17:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC9BC6134F;
        Sat, 11 Sep 2021 13:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366018;
        bh=L32oegpyEQPKIBnsy5I8XBdZeqB9VYJevWiD5xNPNSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWDyqxT6miKqdb0o0V2EnnJ9rZQgyE+ltIkIthb7aWEaE2jIZ0g3qWvq5FyzxoTp8
         sWQsg5I//494di4cVF6fJpzi87SKu2hsD2+snUW6XUTg2JYUmD+NNhWGuPMKegU4nD
         VewOhGFX43EZqwWECwrLiillzb767vVOM5tXEQqOu2RHwDTf+1TjuuXYTxwOFkLNH0
         ieJB5OmVzmWoFbrfidGdT6+BAmibtjoNOnAI8wEUsVXSYXU2UFXpfRRLRUXv9xrGkG
         kKtLBFHFEltsIMvnWyTHb/ZFP7gD2Ofks3gUQ3AjBNPhqpyyoT/IHuWe9WtFl4I6kL
         lTVphSleA2ipA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Davide Zini <davidezini2@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/25] block, bfq: honor already-setup queue merges
Date:   Sat, 11 Sep 2021 09:13:07 -0400
Message-Id: <20210911131312.285225-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c91dca641eb4..46d74cfbe19b 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2523,6 +2523,15 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
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
@@ -2582,6 +2591,10 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
+	/* if a merge has already been setup, then proceed with that first */
+	if (bfqq->new_bfqq)
+		return bfqq->new_bfqq;
+
 	/*
 	 * Do not perform queue merging if the device is non
 	 * rotational and performs internal queueing. In fact, such a
@@ -2636,9 +2649,6 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (bfq_too_late_for_merging(bfqq))
 		return NULL;
 
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
-
 	if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
 		return NULL;
 
-- 
2.30.2

