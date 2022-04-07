Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48AC4F8167
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 16:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343849AbiDGOTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 10:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiDGOTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 10:19:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C9D182AC1;
        Thu,  7 Apr 2022 07:17:31 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 61C2D1F85F;
        Thu,  7 Apr 2022 14:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649340469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZeyhWDWe3VQJDbVFe6ALa/xuqG9ur0lFXdtYBiNjvF4=;
        b=rNJj0vahzMBzkVeyWABeOvfPZ+gwVL8jFq73tfory1t83lvPjPrMYYUj9+ERa0LDE5U2Hl
        CMj29hnmoIcBKkCmv+XiJxJEJIwkRSYbbYUGK7l0bDhsjEiooqQrXU/ZRZAD/TQnIcDFNA
        qCVaN1J+377XNAW4LHylAlY+NVrQlAY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649340469;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZeyhWDWe3VQJDbVFe6ALa/xuqG9ur0lFXdtYBiNjvF4=;
        b=6Umfv4ZjAG6g9cUpr3+QcujVZ0SXQLjgqSR9cnSlZ8OyjGkgoFVwmgYjSKaVVwe2ZqiuRP
        NzzsfptJqx1yy+DQ==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3C54DA3B87;
        Thu,  7 Apr 2022 14:07:49 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C5863A061A; Thu,  7 Apr 2022 16:07:48 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Chris Murphy <lists@colorremedies.com>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] bfq: Fix warning in bfqq_request_over_limit()
Date:   Thu,  7 Apr 2022 16:07:38 +0200
Message-Id: <20220407140738.9723-1-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2227; h=from:subject; bh=RGBELGd9kRiiBqyO8iLOf/EMYrWHMTI9dTyXfqVDzHw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiTvAj+ioUFsElYUHwAQ0Gjj0yDsHmUM8Nv8iHKzOT Y/4aL8qJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYk7wIwAKCRCcnaoHP2RA2VXgCA CJh7DB3gmlXPCQBvwW5OXLtIiPwN4fui2KYgLJM2UktZcajLfOq+kq888HYbqClId2sv/ztqgTfNlK aF6NwMq61KVoOQYz6fNRCcO2HObts2jNvJ3fvYdkGAtSDqI8jqgJz8d4eBTyskblpnWet6tOhDUMwe Lm8mf4LIIvPYfaJ1mICkKHZB+j4IhWnb/kFJtyq/j/Hn8A9iNkCcMI+un3Wo4APd9jGBQyKFJLrqCx zFbBjvr0b9bGHf5OupDNEmSCNGEMXCp2PwQ5NW7nqLJuqAreiVcd6/QlyNcqfYxnMT8Lrwr8LlCD7z dzjvOFEMdd5IJLYNh0gQoHmXa14veV
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 block/bfq-iosched.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index e47c75f1fa0f..272d48d8f326 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -569,7 +569,7 @@ static bool bfqq_request_over_limit(struct bfq_queue *bfqq, int limit)
 	struct bfq_entity *entity = &bfqq->entity;
 	struct bfq_entity *inline_entities[BFQ_LIMIT_INLINE_DEPTH];
 	struct bfq_entity **entities = inline_entities;
-	int depth, level;
+	int depth, level, alloc_depth = BFQ_LIMIT_INLINE_DEPTH;
 	int class_idx = bfqq->ioprio_class - 1;
 	struct bfq_sched_data *sched_data;
 	unsigned long wsum;
@@ -578,15 +578,21 @@ static bool bfqq_request_over_limit(struct bfq_queue *bfqq, int limit)
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
-- 
2.34.1

