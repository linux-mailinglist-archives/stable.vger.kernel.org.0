Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F07233BA8F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhCOOJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234532AbhCOOEM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA0DB64E83;
        Mon, 15 Mar 2021 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817052;
        bh=WPjeWVA1ttw7p/Rkyh3FafAywGgPmhm9Sf7XLwNoQCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Po3S2V0zf3Al2m16NlaF5ngr9RpO/kaaVXJDecGojJ0LBKai1YW8j2tL4OEBx5xlp
         6iYktc/HdJeSrgjpNMNjNS/QMzb7w9uAKcBQR7m07aninMF261WL2PWMkabWPq8WYf
         iK75YkBdflbYHwHOTfusSuO9mH+brEE1pdPbFMOQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>
Subject: [PATCH 5.11 276/306] sched: Optimize migration_cpu_stop()
Date:   Mon, 15 Mar 2021 14:55:39 +0100
Message-Id: <20210315135516.995722029@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Peter Zijlstra <peterz@infradead.org>

commit 3f1bc119cd7fc987c8ed25ffb717f99403bb308c upstream.

When the purpose of migration_cpu_stop() is to migrate the task to
'any' valid CPU, don't migrate the task when it's already running on a
valid CPU.

Fixes: 6d337eab041d ("sched: Fix migrate_disable() vs set_cpus_allowed_ptr()")
Cc: stable@kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210224131355.569238629@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1936,14 +1936,25 @@ static int migration_cpu_stop(void *data
 			complete = true;
 		}
 
-		if (dest_cpu < 0)
+		if (dest_cpu < 0) {
+			if (cpumask_test_cpu(task_cpu(p), &p->cpus_mask))
+				goto out;
+
 			dest_cpu = cpumask_any_distribute(&p->cpus_mask);
+		}
 
 		if (task_on_rq_queued(p))
 			rq = __migrate_task(rq, &rf, p, dest_cpu);
 		else
 			p->wake_cpu = dest_cpu;
 
+		/*
+		 * XXX __migrate_task() can fail, at which point we might end
+		 * up running on a dodgy CPU, AFAICT this can only happen
+		 * during CPU hotplug, at which point we'll get pushed out
+		 * anyway, so it's probably not a big deal.
+		 */
+
 	} else if (pending) {
 		/*
 		 * This happens when we get migrated between migrate_enable()'s


