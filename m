Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD40553C99
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355686AbiFUVAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355527AbiFUU6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:58:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D913326D8;
        Tue, 21 Jun 2022 13:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F2C46188C;
        Tue, 21 Jun 2022 20:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42702C341C4;
        Tue, 21 Jun 2022 20:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844677;
        bh=RIdDEKj+MQfkgDUjcAgeu30faZzXlK9VLc7sThZiCgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnXcmc/qs6LeqN2HfVaZHrhxFkQZPh3pGHSF9s0SzdEROvHlqqPr+TYpzGZt3ExWP
         ovrmrhX5+LA45T4XpSnWnTqqn3QfuSpDuTe0nMAeZTME59frkquDDHolN7dKnbuANP
         Ge0Emt8Ejbt/3CJUC80rL+pX8gph2bpfTM2tYknQShU/Ec35uRbjTDUfKU214Ls06a
         KGSZSzEZy2xwED1lSKjHMV4Z6x3NGiMHZvG+AlW49COjiBKlANQNCsNYycJ4S8gcbx
         J2SXyHEthIu19SAn7kFg6SK0pn+q+e5MHRhGn7f/RtKJIFTEkRMQ05zVnBJIxavbM7
         cN5Td5VBfG2DQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Yu Kuai <yukuai3@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/11] blk-mq: don't clear flush_rq from tags->rqs[]
Date:   Tue, 21 Jun 2022 16:51:04 -0400
Message-Id: <20220621205105.250640-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205105.250640-1-sashal@kernel.org>
References: <20220621205105.250640-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 6cfeadbff3f8905f2854735ebb88e581402c16c4 ]

commit 364b61818f65 ("blk-mq: clearing flush request reference in
tags->rqs[]") is added to clear the to-be-free flush request from
tags->rqs[] for avoiding use-after-free on the flush rq.

Yu Kuai reported that blk_mq_clear_flush_rq_mapping() slows down boot time
by ~8s because running scsi probe which may create and remove lots of
unpresent LUNs on megaraid-sas which uses BLK_MQ_F_TAG_HCTX_SHARED and
each request queue has lots of hw queues.

Improve the situation by not running blk_mq_clear_flush_rq_mapping if
disk isn't added when there can't be any flush request issued.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reported-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220616014401.817001-4-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d5979cfcf8d8..00459f727ce5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2645,8 +2645,9 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 	if (blk_mq_hw_queue_mapped(hctx))
 		blk_mq_tag_idle(hctx);
 
-	blk_mq_clear_flush_rq_mapping(set->tags[hctx_idx],
-			set->queue_depth, flush_rq);
+	if (blk_queue_init_done(q))
+		blk_mq_clear_flush_rq_mapping(set->tags[hctx_idx],
+				set->queue_depth, flush_rq);
 	if (set->ops->exit_request)
 		set->ops->exit_request(set, flush_rq, hctx_idx);
 
-- 
2.35.1

