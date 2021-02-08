Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4DA313C7F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhBHSHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:07:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235337AbhBHSDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21C0B64ED4;
        Mon,  8 Feb 2021 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807159;
        bh=nubV/1ygv6kqsM4aIbnBzomM+6P/DuLH9iUpEwabiJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXibZl9195HYu61maEJ2xxxX2qCeWklrVHPgD4wpigCWMeI8mmG+2k9lOBZ+hfcBy
         XZbWSrFX2RFW9rnlmdHBnsLRcrgryjf5vaFPapQlc25hP+XaV2n8/nAynHbkItXfvH
         Qdp3GmkszvT+U/H5Vl67eMSaVFVSVaN6aERUFNFOEHzsjDbc17/Qg37ow0H3oack4a
         bIlFMlro3AS+kTxbZbDegG+e8h8XjU3uq5D/FSDFwayTTQ6JaxQIpPuqcQB+5YWuHx
         HusYHM/rQXGYtrhd8AzSr6LuMaqBJmL/WrcYq/eULMdwhj4wJPLWz3pXkjcQ3WBl1H
         wSN4rJ8DEPAVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Feng <linf@wangsu.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/19] bfq-iosched: Revert "bfq: Fix computation of shallow depth"
Date:   Mon,  8 Feb 2021 12:58:54 -0500
Message-Id: <20210208175858.2092008-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175858.2092008-1-sashal@kernel.org>
References: <20210208175858.2092008-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Feng <linf@wangsu.com>

[ Upstream commit 388c705b95f23f317fa43e6abf9ff07b583b721a ]

This reverts commit 6d4d273588378c65915acaf7b2ee74e9dd9c130a.

bfq.limit_depth passes word_depths[] as shallow_depth down to sbitmap core
sbitmap_get_shallow, which uses just the number to limit the scan depth of
each bitmap word, formula:
scan_percentage_for_each_word = shallow_depth / (1 << sbimap->shift) * 100%

That means the comments's percentiles 50%, 75%, 18%, 37% of bfq are correct.
But after commit patch 'bfq: Fix computation of shallow depth', we use
sbitmap.depth instead, as a example in following case:

sbitmap.depth = 256, map_nr = 4, shift = 6; sbitmap_word.depth = 64.
The resulsts of computed bfqd->word_depths[] are {128, 192, 48, 96}, and
three of the numbers exceed core dirver's 'sbitmap_word.depth=64' limit
nothing.

Signed-off-by: Lin Feng <linf@wangsu.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7d19aae015aeb..ba32adaeefdd0 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6320,13 +6320,13 @@ static unsigned int bfq_update_depths(struct bfq_data *bfqd,
 	 * limit 'something'.
 	 */
 	/* no more than 50% of tags for async I/O */
-	bfqd->word_depths[0][0] = max(bt->sb.depth >> 1, 1U);
+	bfqd->word_depths[0][0] = max((1U << bt->sb.shift) >> 1, 1U);
 	/*
 	 * no more than 75% of tags for sync writes (25% extra tags
 	 * w.r.t. async I/O, to prevent async I/O from starving sync
 	 * writes)
 	 */
-	bfqd->word_depths[0][1] = max((bt->sb.depth * 3) >> 2, 1U);
+	bfqd->word_depths[0][1] = max(((1U << bt->sb.shift) * 3) >> 2, 1U);
 
 	/*
 	 * In-word depths in case some bfq_queue is being weight-
@@ -6336,9 +6336,9 @@ static unsigned int bfq_update_depths(struct bfq_data *bfqd,
 	 * shortage.
 	 */
 	/* no more than ~18% of tags for async I/O */
-	bfqd->word_depths[1][0] = max((bt->sb.depth * 3) >> 4, 1U);
+	bfqd->word_depths[1][0] = max(((1U << bt->sb.shift) * 3) >> 4, 1U);
 	/* no more than ~37% of tags for sync writes (~20% extra tags) */
-	bfqd->word_depths[1][1] = max((bt->sb.depth * 6) >> 4, 1U);
+	bfqd->word_depths[1][1] = max(((1U << bt->sb.shift) * 6) >> 4, 1U);
 
 	for (i = 0; i < 2; i++)
 		for (j = 0; j < 2; j++)
-- 
2.27.0

