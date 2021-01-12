Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477632F305C
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404133AbhALM5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404099AbhALM5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47AF52313F;
        Tue, 12 Jan 2021 12:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456178;
        bh=8DETE4qvxjEPP9TvGPKT+tGZ8XZWlA4kvG1zg6+WAPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEuvG8DOMV0Y7SMAyGptbR8pBBExDRH5ApKdcDIfudrtDYxDBJZNGHcSsXVdNznNG
         sEXgLgaGRR89AlzFLwX7M9gOya5L3rljvJMXebCjovVpofujIFNBnusQFmZv8PRtO9
         69pkfmIUe9YTbEoI8YKnqe+5SLbdL1vAPGWFRRfpDMfSJbihifAm9wi5CKMHg4uQPD
         oKERc6+vBLrKhwpcUR/yoF9gQg076KCxbv7vfW4WZXTUGNyX97lhzk5qFqrVcnmr9e
         iC1C2Uc5iWIhvmzNtUSXOhhCzitlh2NUj5CDMJotKZHpyA/dXniLBedh8+WqUUvOTL
         ShYAB+MUOt94w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 33/51] bfq: Fix computation of shallow depth
Date:   Tue, 12 Jan 2021 07:55:15 -0500
Message-Id: <20210112125534.70280-33-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 6d4d273588378c65915acaf7b2ee74e9dd9c130a ]

BFQ computes number of tags it allows to be allocated for each request type
based on tag bitmap. However it uses 1 << bitmap.shift as number of
available tags which is wrong. 'shift' is just an internal bitmap value
containing logarithm of how many bits bitmap uses in each bitmap word.
Thus number of tags allowed for some request types can be far to low.
Use proper bitmap.depth which has the number of tags instead.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 9e81d1052091f..9e4eb0fc1c16e 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6332,13 +6332,13 @@ static unsigned int bfq_update_depths(struct bfq_data *bfqd,
 	 * limit 'something'.
 	 */
 	/* no more than 50% of tags for async I/O */
-	bfqd->word_depths[0][0] = max((1U << bt->sb.shift) >> 1, 1U);
+	bfqd->word_depths[0][0] = max(bt->sb.depth >> 1, 1U);
 	/*
 	 * no more than 75% of tags for sync writes (25% extra tags
 	 * w.r.t. async I/O, to prevent async I/O from starving sync
 	 * writes)
 	 */
-	bfqd->word_depths[0][1] = max(((1U << bt->sb.shift) * 3) >> 2, 1U);
+	bfqd->word_depths[0][1] = max((bt->sb.depth * 3) >> 2, 1U);
 
 	/*
 	 * In-word depths in case some bfq_queue is being weight-
@@ -6348,9 +6348,9 @@ static unsigned int bfq_update_depths(struct bfq_data *bfqd,
 	 * shortage.
 	 */
 	/* no more than ~18% of tags for async I/O */
-	bfqd->word_depths[1][0] = max(((1U << bt->sb.shift) * 3) >> 4, 1U);
+	bfqd->word_depths[1][0] = max((bt->sb.depth * 3) >> 4, 1U);
 	/* no more than ~37% of tags for sync writes (~20% extra tags) */
-	bfqd->word_depths[1][1] = max(((1U << bt->sb.shift) * 6) >> 4, 1U);
+	bfqd->word_depths[1][1] = max((bt->sb.depth * 6) >> 4, 1U);
 
 	for (i = 0; i < 2; i++)
 		for (j = 0; j < 2; j++)
-- 
2.27.0

