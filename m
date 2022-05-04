Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250B051A9E6
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357865AbiEDRUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357216AbiEDROz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC1254690;
        Wed,  4 May 2022 09:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 232B56179D;
        Wed,  4 May 2022 16:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A661C385AA;
        Wed,  4 May 2022 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683504;
        bh=DosKk7dVzX8SYgoTdF/LccHpUnW5A2jQ9D2iz4RgMQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBVG1XaU9mhV6W9L6NF/N53eJ21v4B7jTuTVvBCaUXP2pb7Mdpzf9j3nsiJ75oFZ+
         ALL4husBt/Htpr7mNjRjZktkM89TnI9q9w3szLwAXOLzQ7eOHC6zh2yyKw/YeCC0SA
         UpXavzGoj2XJG+pwgrlAOIz+kn9GCrdJz/6b5jME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 179/225] Revert "block: inherit request start time from bio for BLK_CGROUP"
Date:   Wed,  4 May 2022 18:46:57 +0200
Message-Id: <20220504153126.455057466@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Tejun Heo <tj@kernel.org>

commit 4cddeacad6d4b23493a108d0705e7d2ab89ba5a3 upstream.

This reverts commit 0006707723233cb2a9a23ca19fc3d0864835704c. It has a
couple problems:

* bio_issue_time() is stored in bio->bi_issue truncated to 51 bits. This
  overflows in slightly over 26 days. Setting rq->io_start_time_ns with it
  means that io duration calculation would yield >26days after 26 days of
  uptime. This, for example, confuses kyber making it cause high IO
  latencies.

* rq->io_start_time_ns should record the time that the IO is issued to the
  device so that on-device latency can be measured. However,
  bio_issue_time() is set before the bio goes through the rq-qos controllers
  (wbt, iolatency, iocost), so when the bio gets throttled in any of the
  mechanisms, the measured latencies make no sense - on-device latencies end
  up higher than request-alloc-to-completion latencies.

We'll need a smarter way to avoid calling ktime_get_ns() repeatedly
back-to-back. For now, let's revert the commit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org # v5.16+
Link: https://lore.kernel.org/r/YmmeOLfo5lzc+8yI@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1122,14 +1122,7 @@ void blk_mq_start_request(struct request
 	trace_block_rq_issue(rq);
 
 	if (test_bit(QUEUE_FLAG_STATS, &q->queue_flags)) {
-		u64 start_time;
-#ifdef CONFIG_BLK_CGROUP
-		if (rq->bio)
-			start_time = bio_issue_time(&rq->bio->bi_issue);
-		else
-#endif
-			start_time = ktime_get_ns();
-		rq->io_start_time_ns = start_time;
+		rq->io_start_time_ns = ktime_get_ns();
 		rq->stats_sectors = blk_rq_sectors(rq);
 		rq->rq_flags |= RQF_STATS;
 		rq_qos_issue(q, rq);


