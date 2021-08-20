Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD793F2964
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 11:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhHTJkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 05:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbhHTJkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 05:40:47 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BC6C061575;
        Fri, 20 Aug 2021 02:40:09 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 69E4B2E14CF;
        Fri, 20 Aug 2021 12:40:04 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id ZMBJ0uOxJU-e30mumHi;
        Fri, 20 Aug 2021 12:40:04 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1629452404; bh=FqDPCT9ctoYxeVdn5G+2qe+3q2FXvJMdHHVeOhYs3u8=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=jy6G9vh5Ch/oNVcH0z/JK48fJHzXflzju710tdCLdCo8ApeWTBvzIn/F3HSMc/rsc
         qkc/nAtOLdwiKLzP8BPA6XbWWf7Ru7NOCFcUCSqzvFQd02iyXst+kNkKTenaMYUwXI
         5ls5/RGTkYNGkqW8o1NmpHZUIF0qNUHbpxirZcrY=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dynamic-red3.dhcp.yndx.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id G4f2cCJGSV-e224CNHt;
        Fri, 20 Aug 2021 12:40:03 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com, boris@bur.io,
        Andrey Ryabinin <arbn@yandex-team.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/5] cputime, cpuacct: Include guest time in user time in cpuacct.stat
Date:   Fri, 20 Aug 2021 12:40:01 +0300
Message-Id: <20210820094005.20596-1-arbn@yandex-team.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210217120004.7984-1-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
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
Cc: <stable@vger.kernel.org>
---
Changes since v1:
   - Don't CPUTIME_GUEST* since they aren't used cgroups
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
2.31.1

