Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A444548610
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382931AbiFMOWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382963AbiFMOV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:21:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2873A2E092;
        Mon, 13 Jun 2022 04:44:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09C9B6124E;
        Mon, 13 Jun 2022 11:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1519FC34114;
        Mon, 13 Jun 2022 11:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120639;
        bh=ifA7lA7FbfM0V7ZenCFcpEE+5IR5N5Fy03biaMdVr9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2AGIeky2qGcPCN2mlpfN5hMfrZf3ZiYOEGqhYnGapdAANd0QF+opk+rrcA3/juse
         aXHZYqidjo3Sa9+dssQ9UeiBqIObOblFCe5bTne4Wfn1jBmSM8mXUR6TUw2L6tpGkn
         UZg6uFq7aTUHshP2VsPETxDMZQZFARlqDP6MlHVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 104/298] block: make bioset_exit() fully resilient against being called twice
Date:   Mon, 13 Jun 2022 12:09:58 +0200
Message-Id: <20220613094928.104799885@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index 738fea03edbf..dc6940621d7d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -668,6 +668,7 @@ static void bio_alloc_cache_destroy(struct bio_set *bs)
 		bio_alloc_cache_prune(cache, -1U);
 	}
 	free_percpu(bs->cache);
+	bs->cache = NULL;
 }
 
 /**
-- 
2.35.1



