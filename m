Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323A031D914
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 13:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhBQMDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 07:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbhBQMDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 07:03:11 -0500
X-Greylist: delayed 138 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 Feb 2021 04:02:31 PST
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774A3C061786;
        Wed, 17 Feb 2021 04:02:31 -0800 (PST)
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 778F12E1541;
        Wed, 17 Feb 2021 14:58:56 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id XlXJk3ag59-wtxeY82n;
        Wed, 17 Feb 2021 14:58:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1613563136; bh=LuoQeMQQrtl1XmsM4uDiGZRevLihMSflRpO6W5fFyf0=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=iybY8AoBRftH99ramFuGRb5GUmT6U/wQcK1Gi1xbBbUU7TBa1/tc/Ot7KuEvV1pO7
         U1ZgzNTf7n/OF1Tz1XJKJxD3U16PrTGUMlORyWBJcO2nEEnj+PX6ELkP/rOjz7qyA6
         7ICJfly+A12/+0hR2VwnVkUsWxW9eq3lehDr9Q8A=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b080:7222::1:5])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id GINHK1nK2P-wsnW8SHi;
        Wed, 17 Feb 2021 14:58:55 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Boris Burkov <boris@bur.io>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <arbn@yandex-team.com>, stable@vger.kernel.org
Subject: [PATCH 2/4] cgroup: Fix 'usage_usec' time in root's cpu.stat
Date:   Wed, 17 Feb 2021 15:00:02 +0300
Message-Id: <20210217120004.7984-2-arbn@yandex-team.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210217120004.7984-1-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
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
---
 kernel/cgroup/rstat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index d51175cedfca..89ca9b61aa0d 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -421,8 +421,6 @@ static void root_cgroup_cputime(struct task_cputime *cputime)
 		cputime->sum_exec_runtime += user;
 		cputime->sum_exec_runtime += sys;
 		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST_NICE];
 	}
 }
 
-- 
2.26.2

