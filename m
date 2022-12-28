Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03056582E5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiL1QnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiL1Qmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:42:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9851F9E1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1128061584
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24999C433EF;
        Wed, 28 Dec 2022 16:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245417;
        bh=eZ2p5/ltQ9FlwI0FEwRaUY7sV4JC5v1Bu6GG5amWVNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9H8pTpMtAoCyTbFfnoQYmSY4pe+LeTHqt+75ZZN8AlQC1JHM4QKbsrqZpLOo26Mo
         HEtHv2gFbtQYx1AiPl/7ICBYivaXVwAQInxY0wK+encDzY+0avt8+VWsk0zKjEN6ne
         Xsn4Ma/YcZXzrwNbMJN6XA7u5OSrqAxy/n56QGDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0858/1073] block: mark blk_put_queue as potentially blocking
Date:   Wed, 28 Dec 2022 15:40:46 +0100
Message-Id: <20221228144351.323678813@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 63f93fd6fa5717769a78d6d7bea6f7f9a1ccca8e ]

We can't just say that the last reference release may block, as any
reference dropped could be the last one.  So move the might_sleep() from
blk_free_queue to blk_put_queue and update the documentation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221114042637.1009333-6-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d36a9ea5e776 ("block: fix use-after-free of q->q_usage_counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3920e101654f..818002b8be7c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -261,8 +261,6 @@ static void blk_free_queue_rcu(struct rcu_head *rcu_head)
 
 static void blk_free_queue(struct request_queue *q)
 {
-	might_sleep();
-
 	percpu_ref_exit(&q->q_usage_counter);
 
 	if (q->poll_stat)
@@ -286,11 +284,11 @@ static void blk_free_queue(struct request_queue *q)
  * Decrements the refcount of the request_queue and free it when the refcount
  * reaches 0.
  *
- * Context: Any context, but the last reference must not be dropped from
- *          atomic context.
+ * Context: Can sleep.
  */
 void blk_put_queue(struct request_queue *q)
 {
+	might_sleep();
 	if (refcount_dec_and_test(&q->refs))
 		blk_free_queue(q);
 }
-- 
2.35.1



