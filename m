Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859A5420FDF
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237597AbhJDNjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238202AbhJDNhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3EF1611C2;
        Mon,  4 Oct 2021 13:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353421;
        bh=eyaRu31su1+/2x/IVtiIXP+xz8jnUm3D6HT3Yr56L1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssg4UPXs+Fjmm1HjW11J3M7cLzdebJegMhl9D9GZl6LcYjt3ayFl5+sHzB7K4mWXl
         mwnQraNbesAvwImKYkyKk3WFqEkmDPXoOKMZVqNFbpUfW+zfiqIqiG2d1p0ucfjfGj
         sENdP5u/h4jSj4wd+z1FKPsnELOtFVQ4iX6WIuag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 121/172] Revert "block, bfq: honor already-setup queue merges"
Date:   Mon,  4 Oct 2021 14:52:51 +0200
Message-Id: <20211004125048.888344150@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
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
index 3a1038b6eeb3..9360c65169ff 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2662,15 +2662,6 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
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
@@ -2733,10 +2724,6 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
-	/* if a merge has already been setup, then proceed with that first */
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
-
 	/*
 	 * Check delayed stable merge for rotational or non-queueing
 	 * devs. For this branch to be executed, bfqq must not be
@@ -2838,6 +2825,9 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (bfq_too_late_for_merging(bfqq))
 		return NULL;
 
+	if (bfqq->new_bfqq)
+		return bfqq->new_bfqq;
+
 	if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
 		return NULL;
 
-- 
2.33.0



