Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFC66AE890
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjCGRRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjCGRQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:16:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B975294767
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:12:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E242B819A4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B79C433EF;
        Tue,  7 Mar 2023 17:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209148;
        bh=BcUj8HfmhMlDOaNw2ot+sTFsOS13yskXVublgwQLUPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcVYyP4vYTAdlLVCo59PSJWSVIDmgxmbh3UGTnoh1ewhj+Yn2XwC8EA1t/Ref3zZ6
         UiGgqwWXNe9iK9qMt5g1LrcW8GHaKBAjDfALQj04/iUkWtS/24gkCh6mT0l81Bynww
         /X8VNCyHd4fsoqaFBHlWESN2l3kR+YZT2WdfGzMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0096/1001] sbitmap: correct wake_batch recalculation to avoid potential IO hung
Date:   Tue,  7 Mar 2023 17:47:48 +0100
Message-Id: <20230307170026.334576716@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit b5fcf7871acb7f9a3a8ed341a68bd86aba3e254a ]

Commit 180dccb0dba4f ("blk-mq: fix tag_get wait task can't be awakened")
mentioned that in case of shared tags, there could be just one real
active hctx(queue) because of lazy detection of tag idle. Then driver tag
allocation may wait forever on this real active hctx(queue) if wake_batch
is > hctx_max_depth where hctx_max_depth is available tags depth for the
actve hctx(queue). However, the condition wake_batch > hctx_max_depth is
not strong enough to avoid IO hung as the sbitmap_queue_wake_up will only
wake up one wait queue for each wake_batch even though there is only one
waiter in the woken wait queue. After this, there is only one tag to free
and wake_batch may not be reached anymore. Commit 180dccb0dba4f ("blk-mq:
fix tag_get wait task can't be awakened") methioned that driver tag
allocation may wait forever. Actually, the inactive hctx(queue) will be
truely idle after at most 30 seconds and will call blk_mq_tag_wakeup_all
to wake one waiter per wait queue to break the hung. But IO hung for 30
seconds is also not acceptable. Set batch size to small enough that depth
of the shared hctx(queue) is enough to wake up all of the queues like
sbq_calc_wake_batch do to fix this potential IO hung.

Although hctx_max_depth will be clamped to at least 4 while wake_batch
recalculation does not do the clamp, the wake_batch will be always
recalculated to 1 when hctx_max_depth <= 4.

Fixes: 180dccb0dba4 ("blk-mq: fix tag_get wait task can't be awakened")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://lore.kernel.org/r/20230116205059.3821738-6-shikemeng@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/sbitmap.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 2281fbb49d5c6..888c51235bd3c 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -464,13 +464,10 @@ void sbitmap_queue_recalculate_wake_batch(struct sbitmap_queue *sbq,
 					    unsigned int users)
 {
 	unsigned int wake_batch;
-	unsigned int min_batch;
 	unsigned int depth = (sbq->sb.depth + users - 1) / users;
 
-	min_batch = sbq->sb.depth >= (4 * SBQ_WAIT_QUEUES) ? 4 : 1;
-
 	wake_batch = clamp_val(depth / SBQ_WAIT_QUEUES,
-			min_batch, SBQ_WAKE_BATCH);
+			1, SBQ_WAKE_BATCH);
 
 	WRITE_ONCE(sbq->wake_batch, wake_batch);
 }
-- 
2.39.2



