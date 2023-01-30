Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECD7680FC8
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbjA3N4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbjA3N4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:56:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C11D39CD5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:56:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1A2161011
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3C9C433EF;
        Mon, 30 Jan 2023 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087009;
        bh=U6YvlK8tcuoTFfKwo97HsGcAlZ6VlEClNHr4LJZxba4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3t5sA6KBfW4WlGT5rbHP2DKDaSFbQYHN1b7BxMKYBW11edf1s5jBbsBSvVo5VD1H
         oQXjONPE4vuEhDBbpVRaEsZON5GKfWuyBQ+TU71GGc9o/hLgPnhZDVW4sySkIMWIwv
         5uXfcqUP69QU+l+zOEwQ4gpjQ4FBI/GzHaR+lQBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tejun Heo <tj@kernel.org>,
        Dan Carpenter <error27@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/313] block: Drop spurious might_sleep() from blk_put_queue()
Date:   Mon, 30 Jan 2023 14:47:55 +0100
Message-Id: <20230130134338.554818046@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 49e4d04f0486117ac57a97890eb1db6d52bf82b3 ]

Dan reports the following smatch detected the following:

  block/blk-cgroup.c:1863 blkcg_schedule_throttle() warn: sleeping in atomic context

caused by blkcg_schedule_throttle() calling blk_put_queue() in an
non-sleepable context.

blk_put_queue() acquired might_sleep() in 63f93fd6fa57 ("block: mark
blk_put_queue as potentially blocking") which transferred the might_sleep()
from blk_free_queue().

blk_free_queue() acquired might_sleep() in e8c7d14ac6c3 ("block: revert back
to synchronous request_queue removal") while turning request_queue removal
synchronous. However, this isn't necessary as nothing in the free path
actually requires sleeping.

It's pretty unusual to require a sleeping context in a put operation and
it's not needed in the first place. Let's drop it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lkml.kernel.org/r/Y7g3L6fntnTtOm63@kili
Cc: Christoph Hellwig <hch@lst.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Fixes: e8c7d14ac6c3 ("block: revert back to synchronous request_queue removal") # v5.9+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/Y7iFwjN+XzWvLv3y@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 815ffce6b988..f5ae527fb0c3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -282,12 +282,9 @@ static void blk_free_queue(struct request_queue *q)
  *
  * Decrements the refcount of the request_queue and free it when the refcount
  * reaches 0.
- *
- * Context: Can sleep.
  */
 void blk_put_queue(struct request_queue *q)
 {
-	might_sleep();
 	if (refcount_dec_and_test(&q->refs))
 		blk_free_queue(q);
 }
-- 
2.39.0



