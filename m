Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DEA232D78
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbgG3IK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729901AbgG3IK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:10:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 566512074B;
        Thu, 30 Jul 2020 08:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096655;
        bh=ocQitoteaM9KCkLV7fP43lZRJgiX38p88GYiGm/HNN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MlUOWn8/j2vVFDmX23TLgKU82H1iYne5WnQfnMrvvmf2fO/1QnFkOcrS5WXd8/Z1
         kXchJRYizH21UzHWz6zAHZqAV6BnQ0l+VgtDz8IGUm2K1GSi6pXt5SRqtNLX28ATIb
         1+5q1rWzUKi5MpXRW3uyNMgAtOk8ib09GdLPQYsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 10/54] perf/core: Fix locking for children siblings group read
Date:   Thu, 30 Jul 2020 10:04:49 +0200
Message-Id: <20200730074421.712538730@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

commit 2aeb1883547626d82c597cce2c99f0b9c62e2425 upstream.

We're missing ctx lock when iterating children siblings
within the perf_read path for group reading. Following
race and crash can happen:

User space doing read syscall on event group leader:

T1:
  perf_read
    lock event->ctx->mutex
    perf_read_group
      lock leader->child_mutex
      __perf_read_group_add(child)
        list_for_each_entry(sub, &leader->sibling_list, group_entry)

---->   sub might be invalid at this point, because it could
        get removed via perf_event_exit_task_context in T2

Child exiting and cleaning up its events:

T2:
  perf_event_exit_task_context
    lock ctx->mutex
    list_for_each_entry_safe(child_event, next, &child_ctx->event_list,...
      perf_event_exit_event(child)
        lock ctx->lock
        perf_group_detach(child)
        unlock ctx->lock

---->   child is removed from sibling_list without any sync
        with T1 path above

        ...
        free_event(child)

Before the child is removed from the leader's child_list,
(and thus is omitted from perf_read_group processing), we
need to ensure that perf_read_group touches child's
siblings under its ctx->lock.

Peter further notes:

| One additional note; this bug got exposed by commit:
|
|   ba5213ae6b88 ("perf/core: Correct event creation with PERF_FORMAT_GROUP")
|
| which made it possible to actually trigger this code-path.

Tested-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: ba5213ae6b88 ("perf/core: Correct event creation with PERF_FORMAT_GROUP")
Link: http://lkml.kernel.org/r/20170720141455.2106-1-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3940,7 +3940,9 @@ EXPORT_SYMBOL_GPL(perf_event_read_value)
 static int __perf_read_group_add(struct perf_event *leader,
 					u64 read_format, u64 *values)
 {
+	struct perf_event_context *ctx = leader->ctx;
 	struct perf_event *sub;
+	unsigned long flags;
 	int n = 1; /* skip @nr */
 	int ret;
 
@@ -3970,12 +3972,15 @@ static int __perf_read_group_add(struct
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
 
+	raw_spin_lock_irqsave(&ctx->lock, flags);
+
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		values[n++] += perf_event_count(sub);
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
 	}
 
+	raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	return 0;
 }
 


