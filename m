Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50891321636
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhBVMT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230235AbhBVMQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:16:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1421D64F0B;
        Mon, 22 Feb 2021 12:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996163;
        bh=axZ0Jl2Xd0A1Y4Llp/hS6PE0wj1Pn8dRYAEkgCvlvr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brySSSiopWlyfVjGl3Iq3lFos/8Z8cQmcfuoFtqlADlvzr9lIo+5rCP0rhYtM+FH/
         0e12Kaj2g7zWeMXXBfxVnBS9cjkwhvfTusn5atI0Ca6LR24FBrOtlO8LavryMG+8qq
         WOzkWSKR+uzRgy9zyGVQ40efP+61cZcHhPEnBECY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Feng <linf@wangsu.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/50] bfq-iosched: Revert "bfq: Fix computation of shallow depth"
Date:   Mon, 22 Feb 2021 13:13:03 +0100
Message-Id: <20210222121022.170793596@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b7ad8ac6bb41e..5198ed1b36690 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5280,13 +5280,13 @@ static unsigned int bfq_update_depths(struct bfq_data *bfqd,
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
@@ -5296,9 +5296,9 @@ static unsigned int bfq_update_depths(struct bfq_data *bfqd,
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



