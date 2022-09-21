Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA4A5C0252
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiIUPvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiIUPu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:50:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36669DFB4;
        Wed, 21 Sep 2022 08:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ABE5B830AE;
        Wed, 21 Sep 2022 15:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107C0C433D6;
        Wed, 21 Sep 2022 15:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775321;
        bh=m9fBFgTkUYazqlw1sNkNTr2KnM7kgiZnwAFGwC9yHZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDLeHI4w4zdmE3FDmeL/hjyRpeLPcq12UGyPyxvfLqwsBx2NQs8T/YAE7M5ApU6t8
         FxQ+q00mtQbWQPDbJ6KsgjLMg+OtI502OHPFbm7V2n94I5aMvL1bV49ToQMX9sbVE4
         pqsFeG2rQpQpiqjzxo00svBWSHP5EckYrJkFMCUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Roesch <shr@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/45] block: blk_queue_enter() / __bio_queue_enter() must return -EAGAIN for nowait
Date:   Wed, 21 Sep 2022 17:46:04 +0200
Message-Id: <20220921153647.356578998@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Roesch <shr@fb.com>

[ Upstream commit 56f99b8d06ef1ed1c9730948f9f05ac2b930a20b ]

Today blk_queue_enter() and __bio_queue_enter() return -EBUSY for the
nowait code path. This is not correct: they should return -EAGAIN
instead.

This problem was detected by fio. The following command exposed the
above problem:

t/io_uring -p0 -d128 -b4096 -s32 -c32 -F1 -B0 -R0 -X1 -n24 -P1 -u1 -O0 /dev/ng0n1

By applying the patch, the retry case is handled correctly in the slow
path.

Signed-off-by: Stefan Roesch <shr@fb.com>
Fixes: bfd343aa1718 ("blk-mq: don't wait in blk_mq_queue_enter() if __GFP_WAIT isn't set")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5009b9f1c3c9..13e1fca1e923 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -447,7 +447,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 
 	while (!blk_try_enter_queue(q, pm)) {
 		if (flags & BLK_MQ_REQ_NOWAIT)
-			return -EBUSY;
+			return -EAGAIN;
 
 		/*
 		 * read pair of barrier in blk_freeze_queue_start(), we need to
@@ -478,7 +478,7 @@ static inline int bio_queue_enter(struct bio *bio)
 			if (test_bit(GD_DEAD, &disk->state))
 				goto dead;
 			bio_wouldblock_error(bio);
-			return -EBUSY;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.35.1



