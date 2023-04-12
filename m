Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9466DEEBA
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjDLIoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjDLIo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ED87D86
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83A4562AE6
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724BFC433EF;
        Wed, 12 Apr 2023 08:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289006;
        bh=gG6ouSqh8QkBppjSq44+i1x1Ams8TTluv3t01YzupRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RnvdJdD5Rr52QGj7414JLJrs3GxlI6Z2POWi7Qw6ONCp6LDOsD+56UyFV83biDLo
         2LF2t96Ni8tnbogNq2KO1fnItUYgmdA6XUwOgx8opGITzRIRz7omVqLWgTRLYWr8mf
         jl/par+c0iuYS+OQz3UZkYngsJ7VLHMO+ysUSv3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Martin Belanger <Martin.Belanger@dell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 100/164] blk-mq: directly poll requests
Date:   Wed, 12 Apr 2023 10:33:42 +0200
Message-Id: <20230412082840.899002135@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit 38a8c4d1d45006841f0643f4cb29b5e50758837c upstream.

Polling needs a bio with a valid bi_bdev, but neither of those are
guaranteed for polled driver requests. Make request based polling
directly use blk-mq's polling function instead.

When executing a request from a polled hctx, we know the request's
cookie, and that it's from a live blk-mq queue that supports polling, so
we can safely skip everything that bio_poll provides.

Cc: stable@kernel.org
Reported-by: Martin Belanger <Martin.Belanger@dell.com>
Reported-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Tested-by: Daniel Wagner <dwagner@suse.de>
Revieded-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20230331180056.1155862-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1327,8 +1327,6 @@ bool blk_rq_is_poll(struct request *rq)
 		return false;
 	if (rq->mq_hctx->type != HCTX_TYPE_POLL)
 		return false;
-	if (WARN_ON_ONCE(!rq->bio))
-		return false;
 	return true;
 }
 EXPORT_SYMBOL_GPL(blk_rq_is_poll);
@@ -1336,7 +1334,7 @@ EXPORT_SYMBOL_GPL(blk_rq_is_poll);
 static void blk_rq_poll_completion(struct request *rq, struct completion *wait)
 {
 	do {
-		bio_poll(rq->bio, NULL, 0);
+		blk_mq_poll(rq->q, blk_rq_to_qc(rq), NULL, 0);
 		cond_resched();
 	} while (!completion_done(wait));
 }


