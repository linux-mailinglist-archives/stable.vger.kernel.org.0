Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737E81F2B53
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731671AbgFIAOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730741AbgFHXTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AEF02083E;
        Mon,  8 Jun 2020 23:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658352;
        bh=455i9YpdBs7gqDTT9okDLeK5g807fcJ/fdxIEM9G10w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ec5ghmQnfqLQE3dWBNYaKEA+6sEWMYA2Oaqm/OHOI7BuxNxkIfRClAEVJLhHvg7zP
         1KwINkn47C8uBYrRjdc6B0fL6GMZBcCnr7t/3meBtCCOzokH/AtdP07LllIwiGC5iU
         s8Cirq0FoUy6l383FWGkKNsoOZE0NVntWuMw7bnw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huaixin Chang <changhuaixin@linux.alibaba.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 019/175] sched/fair: Refill bandwidth before scaling
Date:   Mon,  8 Jun 2020 19:16:12 -0400
Message-Id: <20200608231848.3366970-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huaixin Chang <changhuaixin@linux.alibaba.com>

[ Upstream commit 5a6d6a6ccb5f48ca8cf7c6d64ff83fd9c7999390 ]

In order to prevent possible hardlockup of sched_cfs_period_timer()
loop, loop count is introduced to denote whether to scale quota and
period or not. However, scale is done between forwarding period timer
and refilling cfs bandwidth runtime, which means that period timer is
forwarded with old "period" while runtime is refilled with scaled
"quota".

Move do_sched_cfs_period_timer() before scaling to solve this.

Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup")
Signed-off-by: Huaixin Chang <changhuaixin@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Reviewed-by: Phil Auld <pauld@redhat.com>
Link: https://lkml.kernel.org/r/20200420024421.22442-3-changhuaixin@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 193b6ab74d7f..3116734630c6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4942,6 +4942,8 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
 		if (!overrun)
 			break;
 
+		idle = do_sched_cfs_period_timer(cfs_b, overrun, flags);
+
 		if (++count > 3) {
 			u64 new, old = ktime_to_ns(cfs_b->period);
 
@@ -4971,8 +4973,6 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
 			/* reset count so we don't come right back in here */
 			count = 0;
 		}
-
-		idle = do_sched_cfs_period_timer(cfs_b, overrun, flags);
 	}
 	if (idle)
 		cfs_b->period_active = 0;
-- 
2.25.1

