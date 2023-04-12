Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707D36DEA0F
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 05:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDLD7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 23:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLD7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 23:59:10 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485F640FB
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 20:59:09 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f87e44598so20695857b3.5
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 20:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681271948; x=1683863948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fyiqpLvToGpX9zbSN0SmDzV1gui0tF1l+0pOfCKBwUY=;
        b=qLE2elCx/bFwG+/CQp/dg66GoBw4Ge7nInCKKielTmGl9IJxhqm8otj0WWoOXBr49L
         G5VdoyGtTSE09rWAd06Z1vgXPRplhAEKo+VI9ZNmVbpZnzyEexvwmAQC+vMFUjECVwXm
         7TSLiL2FTAxAXj48fiSRHfnHLr4PJOtHvUTySmVSYaxsIA1COHxXvzIjfReGb2Rc7SQz
         rm0cCu3vFTpGPlyOS3GhJgfj9R8+3dgCE+wYmuNBUkLJxNu1bcavBTQIvi2PFgwc9t+J
         tzFiaRX1iRUm5GSpL5kFzSa/1jQVoFFZmwwRLvN6wirPEImzKpsd4OiDQ8mCeycC5UP5
         YzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681271948; x=1683863948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fyiqpLvToGpX9zbSN0SmDzV1gui0tF1l+0pOfCKBwUY=;
        b=NdYyviEDhw7Un8D9ImINZPpPB6l+P1omxxWd5jsOcXifzkM4Q0EZqEy9/tDWaFO6pQ
         cwF7UA9DiCe/RjwLd1P9c6kIhBo58vQr9F+fkz2p2oKmXaHXrxSPgD8wgEiwOIzy85Hz
         Mtxk9dG0yS/BptJUhQWLQTgl4HN/3nB69PgsFdjVOlRtc8+TCh5rBMK1+XCEs2hj/TGJ
         +eUkG1/VcLTesvIWMcMgb7nlplJ8/eQRqqTxpU6UqfrFFZmh41E7y4KPk7aXk0/mmf/b
         X6GQzTMLnAo0MpVKsHtMHunvRufKiyn7siZEzJWdZdIvoULX4ZeJrNd8UThFkTZa49yQ
         iYmA==
X-Gm-Message-State: AAQBX9eE8QJFkauBNSVLJVxP8rBYOQA2DKzVtR5mgsT0ebGRvuwCnZVn
        RafyQI9sQOFeYzwZz4/Jk7bfhRXdxho=
X-Google-Smtp-Source: AKy350ZloRliCFbOCCbKcsUE6C+Z+2wYZ9OCrUmkCg8LueCGkR1KcBbnjSO2nUqBbrSDXR9Mi6UI7Li0gpKs
X-Received: from jstultz-noogler2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:600])
 (user=jstultz job=sendgmr) by 2002:a81:d002:0:b0:533:9185:fc2c with SMTP id
 v2-20020a81d002000000b005339185fc2cmr3181437ywi.7.1681271948571; Tue, 11 Apr
 2023 20:59:08 -0700 (PDT)
Date:   Wed, 12 Apr 2023 03:59:05 +0000
In-Reply-To: <20230412023839.2869114-1-jstultz@google.com>
Mime-Version: 1.0
References: <20230412023839.2869114-1-jstultz@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412035905.3184199-1-jstultz@google.com>
Subject: [PATCH v2] locking/rwsem: Add __always_inline annotation to __down_read_common()
From:   John Stultz <jstultz@google.com>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     John Stultz <jstultz@google.com>, Minchan Kim <minchan@kernel.org>,
        Tim Murray <timmurray@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>, kernel-team@android.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Apparently despite it being marked inline, the compiler
may not inline __down_read_common() which makes it difficult
to identify the cause of lock contention, as the blocked
function will always be listed as __down_read_common().

So this patch adds __always_inline annotation to the
function to force it to be inlines so the calling function
will be listed.

Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Murray <timmurray@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: kernel-team@android.com
Cc: stable@vger.kernel.org
Fixes: c995e638ccbb ("locking/rwsem: Fold __down_{read,write}*()")
Reported-by: Tim Murray <timmurray@google.com>
Signed-off-by: John Stultz <jstultz@google.com>
---
v2: Reworked to use __always_inline instead of __sched as
    suggested by Waiman Long
---
 kernel/locking/rwsem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index acb5a50309a1..e99eef8ea552 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1240,7 +1240,7 @@ static struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 /*
  * lock for reading
  */
-static inline int __down_read_common(struct rw_semaphore *sem, int state)
+static __always_inline int __down_read_common(struct rw_semaphore *sem, int state)
 {
 	int ret = 0;
 	long count;
-- 
2.40.0.577.gac1e443424-goog

