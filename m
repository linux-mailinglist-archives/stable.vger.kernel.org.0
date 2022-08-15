Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D92B59441B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345474AbiHOW2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344115AbiHOWX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:23:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01223125D4D;
        Mon, 15 Aug 2022 12:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1104B80EAD;
        Mon, 15 Aug 2022 19:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA33EC433C1;
        Mon, 15 Aug 2022 19:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592648;
        bh=GUWeR2HkTWqWqurKf6GRL4U6LrltBq3vNnVNzkov6Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/18iCHYaWZFIJtA08G+I/KnO97auFmng/BrB8cGqCfulioErKkufsyXeVDQTRQ0y
         HQtJcpbvzU4e20437CsEr8xUFAigbNeu2mwphTk7rMTSQ4OUy4iUkORui5YfguPI/g
         KOqBFyR9lT5JwjfawzdiWz+unnBKSnu2PqUKiZ/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0821/1095] block: ensure iov_iter advances for added pages
Date:   Mon, 15 Aug 2022 20:03:40 +0200
Message-Id: <20220815180503.259550889@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 325347d965e7ccf5424a05398807a6d801846612 ]

There are cases where a bio may not accept additional pages, and the iov
needs to advance to the last data length that was accepted. The zone
append used to handle this correctly, but was inadvertently broken when
the setup was made common with the normal r/w case.

Fixes: 576ed9135489c ("block: use bio_add_page in bio_iov_iter_get_pages")
Fixes: c58c0074c54c2 ("block/bio: remove duplicate append pages code")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20220712153256.2202024-1-kbusch@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 6f6e6e23889c..7d4d5723350b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1181,6 +1181,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	ssize_t size, left;
 	unsigned len, i;
 	size_t offset;
+	int ret = 0;
 
 	/*
 	 * Move page array up in the allocated memory for the bio vecs as far as
@@ -1196,7 +1197,6 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 
 	for (left = size, i = 0; left > 0; left -= len, i++) {
 		struct page *page = pages[i];
-		int ret;
 
 		len = min_t(size_t, PAGE_SIZE - offset, left);
 		if (bio_op(bio) == REQ_OP_ZONE_APPEND)
@@ -1207,13 +1207,13 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 
 		if (ret) {
 			bio_put_pages(pages + i, left, offset);
-			return ret;
+			break;
 		}
 		offset = 0;
 	}
 
-	iov_iter_advance(iter, size);
-	return 0;
+	iov_iter_advance(iter, size - left);
+	return ret;
 }
 
 /**
-- 
2.35.1



