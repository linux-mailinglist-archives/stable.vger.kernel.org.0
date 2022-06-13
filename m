Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4682C548988
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377737AbiFMNlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379190AbiFMNkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F32F63;
        Mon, 13 Jun 2022 04:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9F606101F;
        Mon, 13 Jun 2022 11:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078A2C34114;
        Mon, 13 Jun 2022 11:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119777;
        bh=zXBnwl3dRR2fllwyEC5SpVSqZXvI6ZpxC9v+Z9lz+78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khwLBk/mWWMxwJbPkRH2sB3vTJHeLZQIHK3hDxE6sF2J3ItJExhFXk3apZHDnFBWC
         2bVteDIFqYxOynErvLOqG+Q44Nf/tsOFLwNEFyD5nKfyQ12Hz+QcZ+iwggbUWUn5OS
         3iR2Sx9CRkwJdIidnFGogYwyusc/lvp+4r7f1/9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 116/339] block: make bioset_exit() fully resilient against being called twice
Date:   Mon, 13 Jun 2022 12:09:01 +0200
Message-Id: <20220613094930.027035477@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 605f7415ecfb426610195dd6c7577b30592b3369 ]

Most of bioset_exit() is fine being called twice, as it clears the
various allocations etc when they are freed. The exception is
bio_alloc_cache_destroy(), which does not clear ->cache when it has
freed it.

This isn't necessarily a bug, but can be if buggy users does call the
exit path more then once, or with just a memset() bioset which has
never been initialized. dm appears to be one such user.

Fixes: be4d234d7aeb ("bio: add allocation cache abstraction")
Link: https://lore.kernel.org/linux-block/YpK7m+14A+pZKs5k@casper.infradead.org/
Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio.c b/block/bio.c
index ac29c87c6735..d3ca79c3ebdf 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -693,6 +693,7 @@ static void bio_alloc_cache_destroy(struct bio_set *bs)
 		bio_alloc_cache_prune(cache, -1U);
 	}
 	free_percpu(bs->cache);
+	bs->cache = NULL;
 }
 
 /**
-- 
2.35.1



