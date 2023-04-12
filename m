Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021EC6DE993
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 04:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjDLCio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 22:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDLCio (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 22:38:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025CC170F
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 19:38:43 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63af68592f0so859946b3a.1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 19:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681267122; x=1683859122;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RNWG2HLYVu8lISkZ1sV4u+6+PLx7BcJ7lAq9oMLMvNk=;
        b=he62bc8OveLb0DVwvJVNFeL8V9939ycFrKnUYdFQveUBL6N8KkND5MSvuP7n0DMR3I
         qcv8jPZ2mpLHZ2ATdlDQaERA3ie780MAiMLaOB6fIKe13CHm+J9Xxpt59jLJiVwAjNfe
         sCg+faCVAXXsYScFe8ETvtzBFg5G/5NrTrnxa4JFQNymZiDDOF1dBOp4JONT0MmUQ6c7
         QPqkAX8pQYakP6xFuTb5rReqycTe5bpeWtPZvcvgYweS96ActIKmr6uwaDMBlKMQZAgP
         6uMdd1JtpdKeXUC77A7OT/nv4ApemHGnE8jq9dGJA3LxGlaUXnOSLaQo9tsLs5qHgHq7
         jeow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681267122; x=1683859122;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RNWG2HLYVu8lISkZ1sV4u+6+PLx7BcJ7lAq9oMLMvNk=;
        b=1ellCp1J1C1xtF17xNABBv9BXT1CiJZei8g8tW/KxyvxTY9m3i4UJMlQtJ+MuRFcgU
         ynEF311YYdKhiaB5Mn5NQQj1VqIfxQ30zFEDzWYzrgOwkP85U9bGT0SlakC76eScChKr
         kYz5qqewwt0lqcAsQCuEEIySoLxSnT7x5e25/AkIU1IMkdwvXHKWBEnmYyhJr5SbFW6X
         Bd/i00nZRny1d4csMPwXIPOOQSWTmDGbTNCEoqcZcfIPYXHerI/VoE16WN1VdbMem8XV
         +8fn4qzG0rNzHfOEuyQpplhYuPJ6XV7qMkHx1tw4fZRWQNwFkam23VaME6QzkSFB/zmU
         c92g==
X-Gm-Message-State: AAQBX9f2KbCY8rC7A42Kn9VoLtSy408bLmVWQ9wNJ+PbTejQEsBWqnmV
        qQIlZiN1QQyl3yMHLRILniv4j9XpDMY=
X-Google-Smtp-Source: AKy350bDT1s8PAqQU63jFNJ65fDC8ReNM/DryIQ8gPGrrq5Vrqhki098rPAbm73qeZxAqs+8RhGiflRK3iUR
X-Received: from jstultz-noogler2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:600])
 (user=jstultz job=sendgmr) by 2002:a05:6a00:1ca4:b0:63a:2000:6e0c with SMTP
 id y36-20020a056a001ca400b0063a20006e0cmr545417pfw.3.1681267122451; Tue, 11
 Apr 2023 19:38:42 -0700 (PDT)
Date:   Wed, 12 Apr 2023 02:38:39 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412023839.2869114-1-jstultz@google.com>
Subject: [RFC][PATCH] locking/rwsem: Add __sched annotation to __down_read_common()
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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

So this patch adds __sched annotation to the function so
the calling function will instead be listed.

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
 kernel/locking/rwsem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index acb5a50309a1..cde2f22e65a8 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1240,7 +1240,7 @@ static struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 /*
  * lock for reading
  */
-static inline int __down_read_common(struct rw_semaphore *sem, int state)
+static inline __sched int __down_read_common(struct rw_semaphore *sem, int state)
 {
 	int ret = 0;
 	long count;
-- 
2.40.0.577.gac1e443424-goog

