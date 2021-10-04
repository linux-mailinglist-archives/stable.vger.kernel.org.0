Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F527420DF7
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbhJDNUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236615AbhJDNSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A22A61501;
        Mon,  4 Oct 2021 13:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352874;
        bh=knhnxQ4qB49HdDyRuZ4hbJOq9y5nztVWRotn+7bmwto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7F1WSJ95LVvo0zLiKU6yCbIl4VGDItNU3MMk2GsfGXbUahc3Eb9hdvHw1OENmvL3
         aQjeITQ+7Un2wPSSclI6a/wZVgfvnzTLL3UiRul0IomduqWYIGiVXhBOegCkxn3PZk
         +h24KBrMI8fPEi8A9SvSVXe+Jlltw0i++aceMQQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/56] Revert "block, bfq: honor already-setup queue merges"
Date:   Mon,  4 Oct 2021 14:52:46 +0200
Message-Id: <20211004125030.828342920@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
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
index 8dee243e639f..73bffd7af15c 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2523,15 +2523,6 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
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
@@ -2591,10 +2582,6 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
-	/* if a merge has already been setup, then proceed with that first */
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
-
 	/*
 	 * Do not perform queue merging if the device is non
 	 * rotational and performs internal queueing. In fact, such a
@@ -2649,6 +2636,9 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (bfq_too_late_for_merging(bfqq))
 		return NULL;
 
+	if (bfqq->new_bfqq)
+		return bfqq->new_bfqq;
+
 	if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
 		return NULL;
 
-- 
2.33.0



