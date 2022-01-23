Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D53249730F
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiAWQpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:45:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35396 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiAWQpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:45:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E869FCE0E02
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B14C340E2;
        Sun, 23 Jan 2022 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642956338;
        bh=UT8o5e9ImWn0D2uUBGDVhL5vGHvCxNnuUKQ147pRmTE=;
        h=Subject:To:Cc:From:Date:From;
        b=xzzuDxMBtAonD83GthXbrSRJmJy4GZPiKapPgpRChjQd1n1abwAUZXg13xF4ZWxF+
         84QTe9XQi81G/TJJFoRGzbTkB4CZ2JJxbp7PgqLLPk0HQBs/oqgwmu0q44GYchjHSc
         i6LtZxkP68ybtS1jwrlusaSwK1EpVepQCyO+F+Pc=
Subject: FAILED: patch "[PATCH] cputime, cpuacct: Include guest time in user time in" failed to apply to 4.9-stable tree
To:     arbn@yandex-team.com, daniel.m.jordan@oracle.com,
        peterz@infradead.org, stable@vger.kernel.org, tj@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:45:27 +0100
Message-ID: <164295632712235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9731698ecb9c851f353ce2496292ff9fcea39dff Mon Sep 17 00:00:00 2001
From: Andrey Ryabinin <arbn@yandex-team.com>
Date: Mon, 15 Nov 2021 19:46:04 +0300
Subject: [PATCH] cputime, cpuacct: Include guest time in user time in
 cpuacct.stat

cpuacct.stat in no-root cgroups shows user time without guest time
included int it. This doesn't match with user time shown in root
cpuacct.stat and /proc/<pid>/stat. This also affects cgroup2's cpu.stat
in the same way.

Make account_guest_time() to add user time to cgroup's cpustat to
fix this.

Fixes: ef12fefabf94 ("cpuacct: add per-cgroup utime/stime statistics")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211115164607.23784-1-arbn@yandex-team.com

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 872e481d5098..042a6dbce8f3 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -148,10 +148,10 @@ void account_guest_time(struct task_struct *p, u64 cputime)
 
 	/* Add guest time to cpustat. */
 	if (task_nice(p) > 0) {
-		cpustat[CPUTIME_NICE] += cputime;
+		task_group_account_field(p, CPUTIME_NICE, cputime);
 		cpustat[CPUTIME_GUEST_NICE] += cputime;
 	} else {
-		cpustat[CPUTIME_USER] += cputime;
+		task_group_account_field(p, CPUTIME_USER, cputime);
 		cpustat[CPUTIME_GUEST] += cputime;
 	}
 }

