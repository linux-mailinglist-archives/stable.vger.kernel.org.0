Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A090F501257
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244885AbiDNNg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343498AbiDNN3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:29:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4EB95A3C;
        Thu, 14 Apr 2022 06:24:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A597B82984;
        Thu, 14 Apr 2022 13:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83744C385A5;
        Thu, 14 Apr 2022 13:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942654;
        bh=8eD3NBqN/q0rqhEJ4PrIDbklKcrEr68iBunmR+/7aRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gy1FJe8RokNYsGpEfZHKdSiX3s0lgkhQS+BKEkQk6kiKbqfEHg9uo8yc1vLeVcwHY
         805cXOErTrWO4l2otdfv0Hdirug++G/5lNk+rMgoAYGUtokqjdqHhooohkFdaI09Te
         JovFTxNSkRUoeMTps33OUcyIZ0KVpAd68fnpDZNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Holger=20Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 196/338] Revert "Revert "block, bfq: honor already-setup queue merges""
Date:   Thu, 14 Apr 2022 15:11:39 +0200
Message-Id: <20220414110844.475505816@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit 15729ff8143f8135b03988a100a19e66d7cb7ecd ]

A crash [1] happened to be triggered in conjunction with commit
2d52c58b9c9b ("block, bfq: honor already-setup queue merges"). The
latter was then reverted by commit ebc69e897e17 ("Revert "block, bfq:
honor already-setup queue merges""). Yet, the reverted commit was not
the one introducing the bug. In fact, it actually triggered a UAF
introduced by a different commit, and now fixed by commit d29bd41428cf
("block, bfq: reset last_bfqq_created on group change").

So, there is no point in keeping commit 2d52c58b9c9b ("block, bfq:
honor already-setup queue merges") out. This commit restores it.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=214503

Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Link: https://lore.kernel.org/r/20211125181510.15004-1-paolo.valente@linaro.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index dfd55037dc6f..a9f42df92ea3 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2155,6 +2155,15 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
 	 * are likely to increase the throughput.
 	 */
 	bfqq->new_bfqq = new_bfqq;
+	/*
+	 * The above assignment schedules the following redirections:
+	 * each time some I/O for bfqq arrives, the process that
+	 * generated that I/O is disassociated from bfqq and
+	 * associated with new_bfqq. Here we increases new_bfqq->ref
+	 * in advance, adding the number of processes that are
+	 * expected to be associated with new_bfqq as they happen to
+	 * issue I/O.
+	 */
 	new_bfqq->ref += process_refs;
 	return new_bfqq;
 }
@@ -2214,6 +2223,10 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
+	/* if a merge has already been setup, then proceed with that first */
+	if (bfqq->new_bfqq)
+		return bfqq->new_bfqq;
+
 	/*
 	 * Prevent bfqq from being merged if it has been created too
 	 * long ago. The idea is that true cooperating processes, and
@@ -2228,9 +2241,6 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (bfq_too_late_for_merging(bfqq))
 		return NULL;
 
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
-
 	if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
 		return NULL;
 
-- 
2.34.1



