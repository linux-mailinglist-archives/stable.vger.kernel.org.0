Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6898214C9C9
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 12:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgA2Ld5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 06:33:57 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51066 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgA2LdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 06:33:06 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iwlaa-0007kL-Mh; Wed, 29 Jan 2020 12:32:56 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 05EED1C1C18;
        Wed, 29 Jan 2020 12:32:56 +0100 (CET)
Date:   Wed, 29 Jan 2020 11:32:55 -0000
From:   "tip-bot2 for Song Liu" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/cgroups: Install cgroup events to correct cpuctx
Cc:     "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Ingo Molnar <mingo@kernel.org>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200122195027.2112449-1-songliubraving@fb.com>
References: <20200122195027.2112449-1-songliubraving@fb.com>
MIME-Version: 1.0
Message-ID: <158029757582.396.8793803904243857564.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: 1.5
X-Linutronix-Spam-Level: +
X-Linutronix-Spam-Status: No , 1.5 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_DBL_ABUSE_MALW=2.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     07c5972951f088094776038006a0592a46d14bbc
Gitweb:        https://git.kernel.org/tip/07c5972951f088094776038006a0592a46d14bbc
Author:        Song Liu <songliubraving@fb.com>
AuthorDate:    Wed, 22 Jan 2020 11:50:27 -08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Tue, 28 Jan 2020 21:20:19 +01:00

perf/cgroups: Install cgroup events to correct cpuctx

cgroup events are always installed in the cpuctx. However, when it is not
installed via IPI, list_update_cgroup_event() adds it to cpuctx of current
CPU, which triggers list corruption:

  [] list_add double add: new=ffff888ff7cf0db0, prev=ffff888ff7ce82f0, next=ffff888ff7cf0db0.

To reproduce this, we can simply run:

  # perf stat -e cs -a &
  # perf stat -e cs -G anycgroup

Fix this by installing it to cpuctx that contains event->ctx, and the
proper cgrp_cpuctx_list.

Fixes: db0503e4f675 ("perf/core: Optimize perf_install_in_event()")
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200122195027.2112449-1-songliubraving@fb.com
---
 kernel/events/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2d9aeba..fdb7f7e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -951,9 +951,9 @@ list_update_cgroup_event(struct perf_event *event,
 
 	/*
 	 * Because cgroup events are always per-cpu events,
-	 * this will always be called from the right CPU.
+	 * @ctx == &cpuctx->ctx.
 	 */
-	cpuctx = __get_cpu_context(ctx);
+	cpuctx = container_of(ctx, struct perf_cpu_context, ctx);
 
 	/*
 	 * Since setting cpuctx->cgrp is conditional on the current @cgrp
@@ -979,7 +979,8 @@ list_update_cgroup_event(struct perf_event *event,
 
 	cpuctx_entry = &cpuctx->cgrp_cpuctx_entry;
 	if (add)
-		list_add(cpuctx_entry, this_cpu_ptr(&cgrp_cpuctx_list));
+		list_add(cpuctx_entry,
+			 per_cpu_ptr(&cgrp_cpuctx_list, event->cpu));
 	else
 		list_del(cpuctx_entry);
 }
