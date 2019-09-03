Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10EABA6206
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 08:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfICG5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 02:57:54 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42498 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfICG5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 02:57:54 -0400
Received: by mail-pg1-f195.google.com with SMTP id p3so8576481pgb.9
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 23:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AeeV14OyLBTF7KaAD5jDBEtXBCp8zTp9/udCZix5Xks=;
        b=p9W6jfMk6gjNMTcRQ3sw84ltehgzUrnBrlh77posPmyU5yfQhoe+6buCNhGW0ouOGj
         fLnPvg2yonl4VXRxfOkrpbcSHkZHd5RiscvSIOx0ZOJ1y1Mw2BDydU+Tq8i/qIRcBIZx
         +kx/N9qbHhYCGyQIec7LgW6gKOBQYvgFJt2UMX6odCHU2GQWEMxkr04++3zHyCeXc34L
         7eZJiEuJTgcyNT/uahiEanGfJOlJFyMwu44Dr5DfitUxj8zsp5SQ7BWzq2z52GmNkFUl
         3SedRw8KmftQPXKutX0FC5A5QVg0B13e2mT1t0uKzT/BB0taIQEJma/91cTQ5vfguCNO
         LMhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AeeV14OyLBTF7KaAD5jDBEtXBCp8zTp9/udCZix5Xks=;
        b=QgDG9HYsYpQYEmDecVLg2nOIs4j2bYU6rA19Vqa2wvrLqWKkGutLCd3UXqHGB+UCvW
         JFa92eq4xI8AjYy0qyUS2gdGaAiE7ZCt73Ggbbar2O5M5m0LKTDOffSM/A4Sve6tmvoZ
         hjy03KDqpNOh9uRzKWmCNKa2NYK0pmS5vMlWY5cW+D2lJEnoBYdJ1tPh/rOFti21o387
         6MJoJBrZCXaIZNEPeKDQGzYkhGPcxMfDMByjOhMRFvVCp79DhzWQatd/7J9OOdhgw0JW
         3QiSqGM3rZZvUrfKTnX2wzvWr48wTiV3chkR1CCqaa0vo6cCu7M1PjFtWFpjYpfxOVuT
         N+WQ==
X-Gm-Message-State: APjAAAWvVn6dCuYNHVfdIpa5z6uaaTic/kKv2PIOpdHI5wAakpLRshct
        kpUypYv6sSh8Xa1sHPOJO+4ynweYiPuYMQ==
X-Google-Smtp-Source: APXvYqw+7WbV27ga/InS0ExF8ZO/V01r9VugBLs7kebePYey1RQXVTmSVaNT4QvEWAHG7OpHeIYVHw==
X-Received: by 2002:a17:90a:b781:: with SMTP id m1mr16250972pjr.141.1567493873489;
        Mon, 02 Sep 2019 23:57:53 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id n66sm307197pfn.90.2019.09.02.23.57.50
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Sep 2019 23:57:53 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Cc:     longman@redhat.com, arnd@arndb.de, baolin.wang@linaro.org,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y 3/8] locking/lockdep: Add debug_locks check in __lock_downgrade()
Date:   Tue,  3 Sep 2019 14:57:21 +0800
Message-Id: <ecdae1a4a913695b66404f0d34250b6812f7c1dd.1567492316.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1567492316.git.baolin.wang@linaro.org>
References: <cover.1567492316.git.baolin.wang@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

Tetsuo Handa had reported he saw an incorrect "downgrading a read lock"
warning right after a previous lockdep warning. It is likely that the
previous warning turned off lock debugging causing the lockdep to have
inconsistency states leading to the lock downgrade warning.

Fix that by add a check for debug_locks at the beginning of
__lock_downgrade().

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Reported-by: syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Link: https://lkml.kernel.org/r/1547093005-26085-1-git-send-email-longman@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 kernel/locking/lockdep.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 565005a..5c370c6 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3650,6 +3650,9 @@ static int reacquire_held_locks(struct task_struct *curr, unsigned int depth,
 	unsigned int depth;
 	int i;
 
+	if (unlikely(!debug_locks))
+		return 0;
+
 	depth = curr->lockdep_depth;
 	/*
 	 * This function is about (re)setting the class of a held lock,
-- 
1.7.9.5

