Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6371FFB08
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 20:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgFRS3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 14:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgFRS3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 14:29:15 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092E6C06174E
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 11:29:15 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id d5so4754726qvo.3
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 11:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eiPLzsJk0g1+SlwOarSq4GnaDiP7oCbmgH1CbyTDn/4=;
        b=O6HeLLd9u94ziaplytRQu/wqavWky8advxgEdXWhhCSK2zDTsdGnT/udp3IktK0FfE
         pGHZcF7v/q6ZwyLACEmyZEds4CG7T1m40uubasMfESzC2+uSZOIYrRk69MQhQ624VyQL
         U4DkVlBnFMSDO81h2VkjIk8N/KeNUlAfuUgAevZmnzhACaPxlyMsKT6qQEY7Ch+12K3j
         fMrhLqzpX67+kFAhZ23aOQHK2pTJCELdSrHnb3r8hB5ZtQ5BSaFSQ3qDJJGA2h0qA7Rs
         zsKlje6yPi1SzmFyEirik4I2nbKSE8FwKavfsHBizLOg0SrTjUBRQLHW1mHEOCrkaTI9
         HH6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eiPLzsJk0g1+SlwOarSq4GnaDiP7oCbmgH1CbyTDn/4=;
        b=olVqpX51E8zbvjxd2uttHYVsbNlbr2aSF4DY4N7JQZIv7ifIpHyiU9H3Z4mVih0SJU
         1y8TeDG+45HM0LYkh9dAmKlOF0rDPIw98fzf5G3Ci7NkqahNrZTksVkoAAf1pqUhJa7Q
         0V6vEwmhZ/iDSGD4UgBUM32CT3p/gQJ8A1sy7IZqG0M3qz2FedHXxqvJfrtFw+VVVsUS
         F73IZOqpmUwwRwkrx0SI3HRsAhF7ibaWFIRrYfl4uwyPRHeBcdIQnhw8RKE6o4KlesFQ
         oqlV3ghP4CcrU5JZ5rO5RNlHfE0jODmQwzbrBD9YFNFwgr6tppds3vWlBs42E8ndaHu6
         ITng==
X-Gm-Message-State: AOAM5330BZ+Tbi0Hv0PSiWyje+06KadbuCwmNceHV4ALIx/BoRPkUsA6
        KoEcx1iUU30v7bIcsSp6e0LNKw1KeIwzsA==
X-Google-Smtp-Source: ABdhPJwdz32NnQmDxUGKyd+OnHU+eF4rikfuQVx8EpDGlrDGl3HadOwGjFzcdB/9tWlkmBGWHkNVTMnQJ9scuA==
X-Received: by 2002:a05:6214:922:: with SMTP id dk2mr5122454qvb.87.1592504954160;
 Thu, 18 Jun 2020 11:29:14 -0700 (PDT)
Date:   Thu, 18 Jun 2020 19:29:09 +0100
Message-Id: <20200618182909.211201-1-gprocida@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH] blk-mq: move _blk_mq_update_nr_hw_queues synchronize_rcu call
From:   Giuliano Procida <gprocida@google.com>
To:     greg@linuxfoundation.org
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

