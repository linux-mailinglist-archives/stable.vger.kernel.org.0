Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580333A607C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhFNKfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:35:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233293AbhFNKde (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:33:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 734586120E;
        Mon, 14 Jun 2021 10:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666691;
        bh=lyi+/9dYeef39pewHEjqb0lVxSDEswyJcOGb5KzVVOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zqq+6/VGSuU2Zinr8nyRh3Hdd7IL9oeH9SG52mgVwlYAkQ7dHgZtYaq5zo3+kwd8
         0vmXuZJ9f3I/GyKnu+d/XHuCBXZH8E0XDMC9r4S17k2/rG6j81cR9Cac3D6UERFIkb
         TpZAE9aeyoH3/LQevIrQeX6pK0O/Gg6FTllg12NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/42] wq: handle VM suspension in stall detection
Date:   Mon, 14 Jun 2021 12:27:00 +0200
Message-Id: <20210614102643.002172619@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3231088afd73..a410d5827a73 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -49,6 +49,7 @@
 #include <linux/moduleparam.h>
 #include <linux/uaccess.h>
 #include <linux/nmi.h>
+#include <linux/kvm_para.h>
 
 #include "workqueue_internal.h"
 
@@ -5387,6 +5388,7 @@ static void wq_watchdog_timer_fn(unsigned long data)
 {
 	unsigned long thresh = READ_ONCE(wq_watchdog_thresh) * HZ;
 	bool lockup_detected = false;
+	unsigned long now = jiffies;
 	struct worker_pool *pool;
 	int pi;
 
@@ -5401,6 +5403,12 @@ static void wq_watchdog_timer_fn(unsigned long data)
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
@@ -5419,12 +5427,12 @@ static void wq_watchdog_timer_fn(unsigned long data)
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



