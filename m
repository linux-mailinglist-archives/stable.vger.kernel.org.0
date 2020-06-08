Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5BB1F159A
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 11:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgFHJj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 05:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729111AbgFHJj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 05:39:59 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D1CC08C5C3
        for <stable@vger.kernel.org>; Mon,  8 Jun 2020 02:39:59 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id d2so14943230qtw.4
        for <stable@vger.kernel.org>; Mon, 08 Jun 2020 02:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=B6zTpyju0destxPbCvxJajIW5XHXx2iK9qXuUmJWBWk=;
        b=lXZtHUdPLGLKz9za//o5Zz0fDtiW8LWdH91wa9murZhteHOs/K52mANRp/lOq5Im6X
         dXaZQJ93p6Px4walMrEJ1Qcyu2jlrZZ556xzIswZFBnGhc49doy8aKBDhMAY+7sGO7LL
         6IMcY8lrQ0ut0fxdR0z+vM+u0J4Sn9ZC/ZBAbzr8KuJQkrs6BsLui07WzrdQQzzjR+HB
         6XBP0fvunwJyfpCWf/nMgJRSkNcr4vzSkH7iPxI2ZuR7ZLxBhJx/+DBpLj0b0nt3CKyH
         tOpS+bs6mdZGrKqxTmmRvJ/hW5Jqj9MHPieHThQx1XelCUusQGq01fdgZVXvNcMMGC7a
         jV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=B6zTpyju0destxPbCvxJajIW5XHXx2iK9qXuUmJWBWk=;
        b=fT92Sx0YxJM9vAz0uWRz+iWLed4HG9dGIu38YKMOZSWaLUWCQkmHlpxwxeQIDqIgZ9
         DX+7pe4TozvbVx22e0JpwbQjhoT4Wz03jj5dOMGyl65NyDs5NOB8dE+oDxgc7npMGuaH
         XSHgtVqP+8JUgbjmqVHVCt9X+r/vY2w6818PzHMO+vxquMJ++8aTYEjIfb/w0392i0We
         R7vIPcqftNMoLzlv3U/ONvgTOnQt6TTsvpbDOWao95zNGl+wc/kEsHF8Sw3p9dEdCS/X
         g048NcnC1rkI71odQuRYAUF+YBn2ZQMW3WYiqbCSOO9gc/8fy3TFnH0/9p2xBHyCK3ZW
         UTAA==
X-Gm-Message-State: AOAM530LjCDp2br/ALW6rGYJxp//frwux4xuys4o8+XpqURQ7JrZ9r9P
        KWgRAAhP3qc+zET0olRPgRbQHMsv1dxenw==
X-Google-Smtp-Source: ABdhPJxwzNk80svl7XEc+5fQTXaVzPh6D6rx95yr5iBT+nrXDsYv4S1RHMBGd3SE0BZGLpJGZIXa38VHu+wWqQ==
X-Received: by 2002:a0c:fa47:: with SMTP id k7mr20396226qvo.132.1591609197576;
 Mon, 08 Jun 2020 02:39:57 -0700 (PDT)
Date:   Mon,  8 Jun 2020 10:39:50 +0100
Message-Id: <20200608093950.86293-1-gprocida@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
Subject: [PATCH] blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Jianchao Wang <jianchao.w.wang@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianchao Wang <jianchao.w.wang@oracle.com>

commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f upstream.

For blk-mq, part_in_flight/rw will invoke blk_mq_in_flight/rw to
account the inflight requests. It will access the queue_hw_ctx and
nr_hw_queues w/o any protection. When updating nr_hw_queues and
blk_mq_in_flight/rw occur concurrently, panic comes up.

Before update nr_hw_queues, the q will be frozen. So we could use
q_usage_counter to avoid the race. percpu_ref_is_zero is used here
so that we will not miss any in-flight request. The access to
nr_hw_queues and queue_hw_ctx in blk_mq_queue_tag_busy_iter are
under rcu critical section, __blk_mq_update_nr_hw_queues could use
synchronize_rcu to ensure the zeroed q_usage_counter to be globally
visible.

Backporting Notes

This is a re-backport, landing synchronize_rcu in the right place.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 block/blk-mq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9d53f476c517..cf56bdad2e06 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2738,6 +2738,10 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_freeze_queue(q);
+	/*
+	 * Sync with blk_mq_queue_tag_busy_iter.
+	 */
+	synchronize_rcu();
 
 	set->nr_hw_queues = nr_hw_queues;
 	blk_mq_update_queue_map(set);
@@ -2748,10 +2752,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_unfreeze_queue(q);
-	/*
-	 * Sync with blk_mq_queue_tag_busy_iter.
-	 */
-	synchronize_rcu();
 }
 
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
-- 
2.27.0.278.ge193c7cf3a9-goog

