Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E592FA303
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389676AbhARLos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:44:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390662AbhARLng (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB72122227;
        Mon, 18 Jan 2021 11:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970201;
        bh=8DETE4qvxjEPP9TvGPKT+tGZ8XZWlA4kvG1zg6+WAPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7P8Wbkfx+vIItnyJSR/HEhzTy2qLsg1evkM0+XAyzKVEu+kP3VTIkkqEF4/OF1oi
         z1f9iW473iX8GGx43nlKQ4X+j1zXodcodOZQFu2jaTVzGbdJ5MgmiNCxxak9cUiOXy
         4cUtL6gPInqnhbReiNuXkjpOe3Hu6sMrjst+euts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/152] bfq: Fix computation of shallow depth
Date:   Mon, 18 Jan 2021 12:34:15 +0100
Message-Id: <20210118113356.607964169@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



