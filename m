Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47243450A02
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 17:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhKOQub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 11:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbhKOQt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 11:49:58 -0500
X-Greylist: delayed 92 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Nov 2021 08:46:50 PST
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76896C061202;
        Mon, 15 Nov 2021 08:46:47 -0800 (PST)
Received: from vla1-a78d115f8d22.qloud-c.yandex.net (vla1-a78d115f8d22.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:2906:0:640:a78d:115f])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id B4C6D2E049A;
        Mon, 15 Nov 2021 19:44:41 +0300 (MSK)
Received: from myt6-10e59078d438.qloud-c.yandex.net (myt6-10e59078d438.qloud-c.yandex.net [2a02:6b8:c12:5209:0:640:10e5:9078])
        by vla1-a78d115f8d22.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id hOlDRbklxT-ifsuAXrS;
        Mon, 15 Nov 2021 19:44:41 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636994681; bh=IrYt5MMKvMGkiv1f4WYXd7ucQOljaPxik4BhGGjfmzQ=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=CWHoIMgtpMlSq2b3O2tN9O/rz0FXjrLJxj8NIqum8Vju46OaQouRWDpfwoECmB+t7
         xIJ2Kt4uCyGziCGgtO3iTxOIFLDS4sV1YfTxlaesYT8cnQZpE3LvfHLLCJCO9uFoYQ
         CV5lgUPqoysVecg/onWn8Fg1KNvNirOF7LTBZrmU=
Authentication-Results: vla1-a78d115f8d22.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dellarbn.yandex.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by myt6-10e59078d438.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id 7goUWCU60O-ifwSgdBU;
        Mon, 15 Nov 2021 19:44:41 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Andrey Ryabinin <arbn@yandex-team.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH v3 1/4] cputime, cpuacct: Include guest time in user time in cpuacct.stat
Date:   Mon, 15 Nov 2021 19:46:04 +0300
Message-Id: <20211115164607.23784-1-arbn@yandex-team.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cpuacct.stat in no-root cgroups shows user time without guest time
included int it. This doesn't match with user time shown in root
cpuacct.stat and /proc/<pid>/stat. This also affects cgroup2's cpu.stat
in the same way.

Make account_guest_time() to add user time to cgroup's cpustat to
fix this.

Fixes: ef12fefabf94 ("cpuacct: add per-cgroup utime/stime statistics")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
---
 kernel/sched/cputime.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
2.32.0

