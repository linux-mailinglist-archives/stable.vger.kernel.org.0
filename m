Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45B83F296F
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 11:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbhHTJmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 05:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236843AbhHTJmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 05:42:38 -0400
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9ED6C061575;
        Fri, 20 Aug 2021 02:42:00 -0700 (PDT)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 6A9172E1647;
        Fri, 20 Aug 2021 12:40:07 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id WRJxvzCyIu-e6ueY01n;
        Fri, 20 Aug 2021 12:40:07 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1629452407; bh=Si8KE1JJWs1mAy9P/ti0+l+WDdAkm3UF36Akx8W4YOM=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=QXbuP8kz8GHvwopKbXXt1NV6c1q55sqAepWaAnDLtj8CX/jQEK3BpptH1re2TfJjx
         iNXzsUpoQuPfry0/uyEzMSN5+A75rs4yXa6i87Lj6xyjK5QHDPd7KQV8G8ZIQAtzZe
         ZxyoYdcFSUA7y4AHw5KZUiWJ2fE5DuYiwccG5DqQ=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dynamic-red3.dhcp.yndx.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id G4f2cCJGSV-e624XJtp;
        Fri, 20 Aug 2021 12:40:06 +0300
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
Subject: [PATCH v2 3/5] cgroup: Fix 'usage_usec' time in root's cpu.stat
Date:   Fri, 20 Aug 2021 12:40:03 +0300
Message-Id: <20210820094005.20596-3-arbn@yandex-team.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820094005.20596-1-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210820094005.20596-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Global CPUTIME_USER counter already includes CPUTIME_GUEST
Also CPUTIME_NICE already includes CPUTIME_GUEST_NICE.

Remove additions of CPUTIME_GUEST[_NICE] to total ->sum_exec_runtime
to not account them twice.

Fixes: 936f2a70f207 ("cgroup: add cpu.stat file to root cgroup")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Tested-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 Changes since v1:
  - Add review/tested tags in changelog
---
 kernel/cgroup/rstat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index b264ab5652ba..1486768f2318 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -433,8 +433,6 @@ static void root_cgroup_cputime(struct task_cputime *cputime)
 		cputime->sum_exec_runtime += user;
 		cputime->sum_exec_runtime += sys;
 		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST_NICE];
 	}
 }
 
-- 
2.31.1

