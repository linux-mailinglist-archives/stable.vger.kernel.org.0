Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC14F584F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfKHUQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 15:16:23 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38470 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKHUQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 15:16:23 -0500
Received: by mail-oi1-f195.google.com with SMTP id a14so6375514oid.5
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 12:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jGAOr4sWpvyQdjAPZyY4jrJ3FzzPz2bm+1FZX3hGAzo=;
        b=U5t9/CyUfroJzxz+x8C+23zQYjxzIKX9KnfX81ajl7tc3cKMcLXW0PkMxxCFt/9RGs
         E3SZ8dZmGsRHxfkmmGVF0IBRr4V3VMDayayqwUwb/mwMlzo/AlZ7Hrbi0cscKy15fq+O
         hUCUltZSwDtROOyCOzQev3a/60Tp3X5sW+ibc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jGAOr4sWpvyQdjAPZyY4jrJ3FzzPz2bm+1FZX3hGAzo=;
        b=lo4ogniKxTAkk/oO/8G7TccgvrQMZA1bB+D6Z2xQu15Ki8hzmFVVES4GAzqMrqBRC1
         grsnUXCwWOP2vg99o72cF29vdOPm/F2xTDqN5Tz4Pn/u62iuSAey56v53/acr5DIYl9k
         AehEsJQN52sSqm52q4UcCr8rBs8jE07rvJmFkt9Vu50gReyOFf2GweVB78dfF1uvi98/
         cGYKN2+640J8sCcelvnlDDkFDp2fd77s2Vdy1+V0Uo9Ta6/Hlx2HZRpwewcNt/WsHebW
         WPgBay6/IlvflhPCYFNqZWn7tpYPoTOzWI/wT9vOHF8JtrM3l/4AQdIUtC1FJHwnSAVj
         XMYA==
X-Gm-Message-State: APjAAAX0S6JbMHPu5taSmiE3mRYQSUrrz8B2s7bog49O49vNeTt/izhk
        c5f4QzVDwPcsazswt0g6bC3+Yw==
X-Google-Smtp-Source: APXvYqy8ANfnXkC2rYmdulYlctHsCWMDYLEeOr30a5aixZxHRJtUQ7hM0IEVaUEZ79/NlLmAwne/MA==
X-Received: by 2002:aca:484e:: with SMTP id v75mr11384020oia.6.1573244181324;
        Fri, 08 Nov 2019 12:16:21 -0800 (PST)
Received: from cando.ausoff.indeed.net ([97.105.47.162])
        by smtp.gmail.com with ESMTPSA id u126sm965129oib.45.2019.11.08.12.16.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 12:16:19 -0800 (PST)
From:   Dave Chiluk <chiluk+linux@indeed.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Qian Cai <cai@lca.pw>
Subject: [PATCH v4.14.y 2/2] sched/fair: Fix -Wunused-but-set-variable warnings
Date:   Fri,  8 Nov 2019 14:15:57 -0600
Message-Id: <1573244157-28339-3-git-send-email-chiluk+linux@indeed.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573244157-28339-1-git-send-email-chiluk+linux@indeed.com>
References: <20191104110832.GE1945210@kroah.com>
 <1573244157-28339-1-git-send-email-chiluk+linux@indeed.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 763a9ec06c409dcde2a761aac4bb83ff3938e0b3 ]

Commit:

   de53fd7aedb1 ("sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices")

introduced a few compilation warnings:

  kernel/sched/fair.c: In function '__refill_cfs_bandwidth_runtime':
  kernel/sched/fair.c:4365:6: warning: variable 'now' set but not used [-Wunused-but-set-variable]
  kernel/sched/fair.c: In function 'start_cfs_bandwidth':
  kernel/sched/fair.c:4992:6: warning: variable 'overrun' set but not used [-Wunused-but-set-variable]

Also, __refill_cfs_bandwidth_runtime() does no longer update the
expiration time, so fix the comments accordingly.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Reviewed-by: Dave Chiluk <chiluk+linux@indeed.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: pauld@redhat.com
Fixes: de53fd7aedb1 ("sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices")
Link: https://lkml.kernel.org/r/1566326455-8038-1-git-send-email-cai@lca.pw
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d5c032e..feeb528 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4091,21 +4091,16 @@ static inline u64 sched_cfs_bandwidth_slice(void)
 }
 
 /*
- * Replenish runtime according to assigned quota and update expiration time.
- * We use sched_clock_cpu directly instead of rq->clock to avoid adding
- * additional synchronization around rq->lock.
+ * Replenish runtime according to assigned quota. We use sched_clock_cpu
+ * directly instead of rq->clock to avoid adding additional synchronization
+ * around rq->lock.
  *
  * requires cfs_b->lock
  */
 void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
-	u64 now;
-
-	if (cfs_b->quota == RUNTIME_INF)
-		return;
-
-	now = sched_clock_cpu(smp_processor_id());
-	cfs_b->runtime = cfs_b->quota;
+	if (cfs_b->quota != RUNTIME_INF)
+		cfs_b->runtime = cfs_b->quota;
 }
 
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
-- 
1.8.3.1

