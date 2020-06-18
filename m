Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3328F1FFB0D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 20:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgFRSa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 14:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgFRSa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 14:30:29 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7CCC06174E
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 11:30:27 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id x21so5046189qtp.16
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 11:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=s0vOHsRrTORPfOph5CMfwS7Oey2+6q5t3Muceum0ejs=;
        b=s09qgo0CCphAyG22nuqn3HUayHPTpjDRPwek1yPWzRc52ow9DApaj07fwZ76RmcSGC
         +42Moe3PQGhEgCnWRpmybWT914qFpzaSg3SEHLHafC9uXr1Zqku7LOgKdBThlX1ZXHTB
         K8dXK3h5PO1GBhGwdErFkGLFTUXALbtp2ofJwr8FXBH8eXsiaSC7bYb9jWqO8D8UQXuL
         BBDrSe5bgni1P5GRNIASPhwsd7YMMDd0skN5LYJpOZkX9aHUl6C7eq5KMdEcvXsPfC5v
         Yfh/h7ujCkqxtbZTc//AYlSrd9N276XIqakqYn3hmI1VTLVGeLQi0RJ+SV+1ikPCUQ1V
         xV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=s0vOHsRrTORPfOph5CMfwS7Oey2+6q5t3Muceum0ejs=;
        b=gxRDG6vknhpZLac3uIcMaCDNARkLZ3+dVhhUQwOUCpKJYza3IMF6PQpSjeLJaNoZpx
         VIz+xEKd+vdRy8j+F9HgD9KF4jfRbQLFZtcx8t6ObV/A6XGuZe6q8ezKnVLDR0Eh7R0d
         zrJkWRLDbbk5wMPhq0EDwoGDuxo6Krq/mB90jSTb/CaZEgx+tUAyvVuUycrjpI+TJ5UD
         kWO4w5FURDYSbmlxttZXHc/5qU3x+0hmds6e62wQKd1PezpvjVWl12I3ssyoZV0IX1Fy
         w6DLGGyBCOpcfM5/j32/Ex+1Tszjb9vAheKpFMwHzLa/kyXe0z7TrOWe0n4+RwUrRQO9
         7goQ==
X-Gm-Message-State: AOAM532HoNTcZb6f+PSE0X9pkqMy0qNZ0pXCb7QOU7VegITLKvOD0u4N
        Wcpfqq32xV+92WUFC/uZfYdONyFIowOo0w==
X-Google-Smtp-Source: ABdhPJximr1GTEXZjT2tHSRviPtSrGqF9DzguLuMtAvNjDLHc/7zp6hvsvd4bt2PB51CKH1YRi2+hDmM3tgaPg==
X-Received: by 2002:a0c:ffc5:: with SMTP id h5mr4974780qvv.201.1592505026470;
 Thu, 18 Jun 2020 11:30:26 -0700 (PDT)
Date:   Thu, 18 Jun 2020 19:30:22 +0100
Message-Id: <20200618183022.212135-1-gprocida@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH] blk-mq: move blk_mq_update_nr_hw_queues synchronize_rcu call
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
4.9 backport commit f530afb974c2e82047bd6220303a2dbe30eff304
which was
upstream commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f.

The upstream commit added a call to synchronize_rcu to
_blk_mq_update_nr_hw_queues, just after freezing queues.

In the backport this landed (in blk_mq_update_nr_hw_queues instead),
just after unfreezeing queues.

This commit moves the call to its intended place.

Fixes: f530afb974c2 ("blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter")
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 block/blk-mq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 58be2eaa5aaa..e0ed7317e98c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2331,6 +2331,10 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_freeze_queue(q);
+	/*
+	 * Sync with blk_mq_queue_tag_busy_iter.
+	 */
+	synchronize_rcu();
 
 	set->nr_hw_queues = nr_hw_queues;
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
@@ -2346,10 +2350,6 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_unfreeze_queue(q);
-	/*
-	 * Sync with blk_mq_queue_tag_busy_iter.
-	 */
-	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(blk_mq_update_nr_hw_queues);
 
-- 
2.27.0.290.gba653c62da-goog

