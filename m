Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF00F39A748
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhFCRKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232086AbhFCRKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DCB2613F1;
        Thu,  3 Jun 2021 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740135;
        bh=i+GWwBCbT//ZLnz835h5F36GFByWtg/gV/usZYFT0iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpvV0TgvEQxTftZRwFKf3VAlXUdXrybCPqS1mx8neXBRxH6rsAPLw6ByBftdVlk8a
         L64SJdAc65EnRAuyQkrN9mBVPVMy7u+C7ncPGM/oki4iq9nLQa9uFpojRa0ojYN1OY
         BIkSA6OTJirh7tSdY9nJqhp59q9ZDT81yMvTD0qSYMH2wmcd7bZNwYQfGOC5FQPaAz
         g0KKfNxUTcXlbxg2VSEfdv/F1tpJpAYgHsdhc9bxWexeGJZcBK6pMRpBPde1lhf9Y1
         brP5aqBH89VLbq388HCdsYtad2e7TuyH00PW8re5oSE0XJSBBV2BkAxyqOKLqTt8vy
         91jZ9PTXZ+L6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 21/39] wq: handle VM suspension in stall detection
Date:   Thu,  3 Jun 2021 13:08:11 -0400
Message-Id: <20210603170829.3168708-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 940d71c6462e8151c78f28e4919aa8882ff2054e ]

If VCPU is suspended (VM suspend) in wq_watchdog_timer_fn() then
once this VCPU resumes it will see the new jiffies value, while it
may take a while before IRQ detects PVCLOCK_GUEST_STOPPED on this
VCPU and updates all the watchdogs via pvclock_touch_watchdogs().
There is a small chance of misreported WQ stalls in the meantime,
because new jiffies is time_after() old 'ts + thresh'.

wq_watchdog_timer_fn()
{
	for_each_pool(pool, pi) {
		if (time_after(jiffies, ts + thresh)) {
			pr_emerg("BUG: workqueue lockup - pool");
		}
	}
}

Save jiffies at the beginning of this function and use that value
for stall detection. If VM gets suspended then we continue using
"old" jiffies value and old WQ touch timestamps. If IRQ at some
point restarts the stall detection cycle (pvclock_touch_watchdogs())
then old jiffies will always be before new 'ts + thresh'.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1e2ca744dadb..b23f7d1044be 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -50,6 +50,7 @@
 #include <linux/uaccess.h>
 #include <linux/sched/isolation.h>
 #include <linux/nmi.h>
+#include <linux/kvm_para.h>
 
 #include "workqueue_internal.h"
 
@@ -5758,6 +5759,7 @@ static void wq_watchdog_timer_fn(struct timer_list *unused)
 {
 	unsigned long thresh = READ_ONCE(wq_watchdog_thresh) * HZ;
 	bool lockup_detected = false;
+	unsigned long now = jiffies;
 	struct worker_pool *pool;
 	int pi;
 
@@ -5772,6 +5774,12 @@ static void wq_watchdog_timer_fn(struct timer_list *unused)
 		if (list_empty(&pool->worklist))
 			continue;
 
+		/*
+		 * If a virtual machine is stopped by the host it can look to
+		 * the watchdog like a stall.
+		 */
+		kvm_check_and_clear_guest_paused();
+
 		/* get the latest of pool and touched timestamps */
 		pool_ts = READ_ONCE(pool->watchdog_ts);
 		touched = READ_ONCE(wq_watchdog_touched);
@@ -5790,12 +5798,12 @@ static void wq_watchdog_timer_fn(struct timer_list *unused)
 		}
 
 		/* did we stall? */
-		if (time_after(jiffies, ts + thresh)) {
+		if (time_after(now, ts + thresh)) {
 			lockup_detected = true;
 			pr_emerg("BUG: workqueue lockup - pool");
 			pr_cont_pool_info(pool);
 			pr_cont(" stuck for %us!\n",
-				jiffies_to_msecs(jiffies - pool_ts) / 1000);
+				jiffies_to_msecs(now - pool_ts) / 1000);
 		}
 	}
 
-- 
2.30.2

