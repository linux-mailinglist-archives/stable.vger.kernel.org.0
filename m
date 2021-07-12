Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82B93C534A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352256AbhGLHy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349332AbhGLHuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C80261574;
        Mon, 12 Jul 2021 07:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075812;
        bh=e2L0I2VZaiXf+U9hDNswEpWhZU5XEmsDz2GSAHxB1PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXYXD466tg2XywLPOKQ50oXOdsggL7HYsEq/w3w/VJD/JTkIk7Htmt9fj/gTkb9IX
         EpaxIKsepuPBD7piSuu9LjTUJuQX91Bsg3YzjMKXb/zcu+9EFaPRWRtbUqBjJGrlJU
         LGJV7OWAwbN9c8bP8baQELdopmfGR6Tg2lFRVN2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Holger=20Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 373/800] block, bfq: avoid delayed merge of async queues
Date:   Mon, 12 Jul 2021 08:06:36 +0200
Message-Id: <20210712061006.756343654@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit bd3664b362381c4c1473753ebedf0ab242a60d1d ]

Since commit 430a67f9d616 ("block, bfq: merge bursts of newly-created
queues"), BFQ may schedule a merge between a newly created sync
bfq_queue, say Q2, and the last sync bfq_queue created, say Q1. To this
goal, BFQ stores the address of Q1 in the field bic->stable_merge_bfqq
of the bic associated with Q2. So, when the time for the possible merge
arrives, BFQ knows which bfq_queue to merge Q2 with. In particular,
BFQ checks for possible merges on request arrivals.

Yet the same bic may also be associated with an async bfq_queue, say
Q3. So, if a request for Q3 arrives, then the above check may happen
to be executed while the bfq_queue at hand is Q3, instead of Q2. In
this case, Q1 happens to be merged with an async bfq_queue. This is
not only a conceptual mistake, because async queues are to be kept out
of queue merging, but also a bug that leads to inconsistent states.

This commits simply filters async queues out of delayed merges.

Fixes: 430a67f9d616 ("block, bfq: merge bursts of newly-created queues")
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Link: https://lore.kernel.org/r/20210619140948.98712-6-paolo.valente@linaro.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index d00c89f6ba59..7c62bf093199 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2703,7 +2703,13 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	 * costly and complicated.
 	 */
 	if (unlikely(!bfqd->nonrot_with_queueing)) {
-		if (bic->stable_merge_bfqq &&
+		/*
+		 * Make sure also that bfqq is sync, because
+		 * bic->stable_merge_bfqq may point to some queue (for
+		 * stable merging) also if bic is associated with a
+		 * sync queue, but this bfqq is async
+		 */
+		if (bfq_bfqq_sync(bfqq) && bic->stable_merge_bfqq &&
 		    !bfq_bfqq_just_created(bfqq) &&
 		    time_is_before_jiffies(bfqq->split_time +
 					  msecs_to_jiffies(200))) {
-- 
2.30.2



