Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838543A60C6
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhFNKhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233175AbhFNKf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C67FC61407;
        Mon, 14 Jun 2021 10:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666774;
        bh=yCIrM2YCEREfws3zQzUwYiMb4cPdjUcMGWaBVJu7oZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0ytpXxdpVTSij9Ot1XfJB011zjIac+kHja5zBceU3kZZImp9xx/yXfH8TnKG/eTv
         TtdB8BmBye30KEKagVIS9K1PHNZxArYN85jr3Wz7ZEHQd8+RCr07ajtCP8dyhDPNWU
         1CHxp4nULTP8jz10EgGhpBKpbqLi5RMzTCL8SrkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/49] wq: handle VM suspension in stall detection
Date:   Mon, 14 Jun 2021 12:27:02 +0200
Message-Id: <20210614102642.177540897@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
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
index bc32ed4a4cf3..58e7eefe4dbf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -49,6 +49,7 @@
 #include <linux/moduleparam.h>
 #include <linux/uaccess.h>
 #include <linux/nmi.h>
+#include <linux/kvm_para.h>
 
 #include "workqueue_internal.h"
 
@@ -5465,6 +5466,7 @@ static void wq_watchdog_timer_fn(unsigned long data)
 {
 	unsigned long thresh = READ_ONCE(wq_watchdog_thresh) * HZ;
 	bool lockup_detected = false;
+	unsigned long now = jiffies;
 	struct worker_pool *pool;
 	int pi;
 
@@ -5479,6 +5481,12 @@ static void wq_watchdog_timer_fn(unsigned long data)
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
@@ -5497,12 +5505,12 @@ static void wq_watchdog_timer_fn(unsigned long data)
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



