Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3E21FFB13
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 20:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgFRSca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 14:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbgFRSc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 14:32:29 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D544CC06174E
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 11:32:28 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c22so5089069qtp.9
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 11:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eiPLzsJk0g1+SlwOarSq4GnaDiP7oCbmgH1CbyTDn/4=;
        b=PBz173l44hYE4jJcQEWieXWLdH9Di2KtnTlMO3XyAC1nuSfwhRmj8cdE/jc7DVoeoy
         b/eX4d4RmUAD8KoprvWTJuwdSu4TgIYQK7rdnIUEpqUgmfkSK/bbPCHQLFn4b4685xZL
         sInAfcIVbaQb3wLWmzv5AJYyIznAn8smVzKJFUlWroaDLnfXQTUOZHLL7RXNqrR7UpA1
         gZPlNh2H+IW3BkOEckvQgt1ZQSHRn7d6+fYDHPD3g+04+8JFZCGm5nKO/SbC1n4AYD29
         VgkENR/0B91c9vmxeZuJpvqE6ZjomaSBmvs+g4oeHTjy3cgSkzqZ5ire1DzEXIWCJoAG
         YwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eiPLzsJk0g1+SlwOarSq4GnaDiP7oCbmgH1CbyTDn/4=;
        b=ahx3E3nF8Azj/cCnTbeyYWC8cP7ofHt3/+YUtKV9hWnWi2dM3stoom3Ws4Ijn8CxB6
         mdMnv4+MdInfufAlTLL8ByLcBX/cZEsoXFa3mjntefqPqj8wySeC8+916BuYqw9cYRhG
         TIqEipGOz23nZttTdF268H1r1zpul8Bb85IYAkGuhTnnDjMgXXFATnRDnI6zw4Vl86BP
         LKwsX2/4lRaos1NsQZNWb6Os+HYfncJt7FLS2o/PcuMNLOXS57PffsfynJV1etUqxUDw
         6mbyBt71xSHI0sonVmVEJqQRLJv4EK8rUfzAllP8OiDZNRFGEjCdwhlrDvZ1JlNICJZa
         /n4g==
X-Gm-Message-State: AOAM533+yf6gcVwPtYNmomlklC73Bx49rUR3fUOqhrh3ToECiKsvJA50
        AmGp4TKq6014MsM0vugi2PMYNFBHS+RHyg==
X-Google-Smtp-Source: ABdhPJyGVBXBbAGCOpXv2MTM1esjGojZsIDr6KfhSou/o3fkAMYHiZWWuEfEy2ezwILUgmR29K7uIyUOunukzQ==
X-Received: by 2002:a05:6214:a0e:: with SMTP id dw14mr4965912qvb.109.1592505148043;
 Thu, 18 Jun 2020 11:32:28 -0700 (PDT)
Date:   Thu, 18 Jun 2020 19:32:23 +0100
Message-Id: <20200618183223.213179-1-gprocida@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH] blk-mq: move _blk_mq_update_nr_hw_queues synchronize_rcu call
From:   Giuliano Procida <gprocida@google.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, axboe@kernel.dk,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes the
4.14 backport commit 574eb136ec7f315c3ef2ca68fa9b3e16c56baa24
which was
upstream commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f.

The upstream commit added a call to synchronize_rcu to
_blk_mq_update_nr_hw_queues, just after freezing queues.

In the backport this landed just after unfreezeing queues.

This commit moves the call to its intended place.

Fixes: 574eb136ec7f ("blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter")
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
2.27.0.290.gba653c62da-goog

