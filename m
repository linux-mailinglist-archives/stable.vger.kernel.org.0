Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C896B51A9EB
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357943AbiEDRUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357455AbiEDRPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B63954BFB;
        Wed,  4 May 2022 09:58:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C94B4B82416;
        Wed,  4 May 2022 16:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79736C385A4;
        Wed,  4 May 2022 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683514;
        bh=L7DYpejEYREcuXWD29M7l9A1VyzsjUx/u8M06UpSmMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6vzjX4N2rSPw2BOzd2qwbGHwi6wBU/P54hKntcLFXd3jYRZP0PotnFfA/xGM0JJO
         HGi/MyfrDTWQIDMiLHh1/bC+C0w+mpS7/KTL/LuKQuLy6TBAo1YGurOCCHwrXWStF8
         ZrKJaBrf+akiuFZK6woCm315TCE6GeW0BKLy+SjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 177/225] bfq: Fix warning in bfqq_request_over_limit()
Date:   Wed,  4 May 2022 18:46:55 +0200
Message-Id: <20220504153126.156084152@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 09df6a75fffa68169c5ef9bef990cd7ba94f3eef upstream.

People are occasionally reporting a warning bfqq_request_over_limit()
triggering reporting that BFQ's idea of cgroup hierarchy (and its depth)
does not match what generic blkcg code thinks. This can actually happen
when bfqq gets moved between BFQ groups while bfqq_request_over_limit()
is running. Make sure the code is safe against BFQ queue being moved to
a different BFQ group.

Fixes: 76f1df88bbc2 ("bfq: Limit number of requests consumed by each cgroup")
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/all/CAJCQCtTw_2C7ZSz7as5Gvq=OmnDiio=HRkQekqWpKot84sQhFA@mail.gmail.com/
Reported-by: Chris Murphy <lists@colorremedies.com>
Reported-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220407140738.9723-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -569,7 +569,7 @@ static bool bfqq_request_over_limit(stru
 	struct bfq_entity *entity = &bfqq->entity;
 	struct bfq_entity *inline_entities[BFQ_LIMIT_INLINE_DEPTH];
 	struct bfq_entity **entities = inline_entities;
-	int depth, level;
+	int depth, level, alloc_depth = BFQ_LIMIT_INLINE_DEPTH;
 	int class_idx = bfqq->ioprio_class - 1;
 	struct bfq_sched_data *sched_data;
 	unsigned long wsum;
@@ -578,15 +578,21 @@ static bool bfqq_request_over_limit(stru
 	if (!entity->on_st_or_in_serv)
 		return false;
 
+retry:
+	spin_lock_irq(&bfqd->lock);
 	/* +1 for bfqq entity, root cgroup not included */
 	depth = bfqg_to_blkg(bfqq_group(bfqq))->blkcg->css.cgroup->level + 1;
-	if (depth > BFQ_LIMIT_INLINE_DEPTH) {
+	if (depth > alloc_depth) {
+		spin_unlock_irq(&bfqd->lock);
+		if (entities != inline_entities)
+			kfree(entities);
 		entities = kmalloc_array(depth, sizeof(*entities), GFP_NOIO);
 		if (!entities)
 			return false;
+		alloc_depth = depth;
+		goto retry;
 	}
 
-	spin_lock_irq(&bfqd->lock);
 	sched_data = entity->sched_data;
 	/* Gather our ancestors as we need to traverse them in reverse order */
 	level = 0;


