Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9202F2FB1
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 13:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404719AbhALM6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:58:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404586AbhALM6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7046823127;
        Tue, 12 Jan 2021 12:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456228;
        bh=/TpIWJHKIKeo3ag1s8Vm+eQe+JfpDBJA6BfFKVg4ZZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2I0OCNQ1QJQZSg+tB8nWfI276xIKDV4I7oDPARzNc7oWnuMbAe8mGhKZmw+PlNjb
         AZyR4gbGrKDBbfoRB1mYPOFvqIv+4tryZMkpp89LSEgrM/vdMDPKph6VSUeMNI2h5s
         KRkmLkChRXBxoVqyP0HxuzRir/Ut35rfYpBc5e6oSAh4b3g5RQoL0/fZdei/hZIOEg
         8S4sCPG6vXfnM5I2n1As1ODSjidvdYLCGc6SJG2aGpxzFTjJO8k2yTpFPg09SP+qZS
         yfHIsCtLvXUqyYA89jjtKkGPliOzLfcEzcbEz1OxNUxc8yFoj0cVbcpwv6X0jVobXZ
         +6xgbzU+4aVaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/28] bfq: Fix computation of shallow depth
Date:   Tue, 12 Jan 2021 07:56:33 -0500
Message-Id: <20210112125645.70739-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
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
index ba32adaeefdd0..7d19aae015aeb 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6320,13 +6320,13 @@ static unsigned int bfq_update_depths(struct bfq_data *bfqd,
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
@@ -6336,9 +6336,9 @@ static unsigned int bfq_update_depths(struct bfq_data *bfqd,
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

