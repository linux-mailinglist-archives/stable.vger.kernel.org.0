Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D7F3E3969
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhHHHXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhHHHXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:23:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62A6160C40;
        Sun,  8 Aug 2021 07:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628407379;
        bh=uhLAo5FfyVe5NiACB2W/CyEoXjolokTW49NauGIkC0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQ+6c+w8KrSmz/WDTHGYr/YENGI2CdfxWr+Ow+EMbqp/QfdYFuLnDze2wHox7yNAx
         umnnxmvFcIvpzxT3i+Ov316Hg+kng6MiIX9iWv6M776hC0VNs087TrS7MB1k4wDoY5
         vnzbV7lUEDIXucG7JUfqvWe8JcXFy2yntGvrjYnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        bigeasy@linutronix.de, Zhen Lei <thunder.leizhen@huawei.com>,
        Joe Korty <joe.korty@concurrent-rt.com>
Subject: [PATCH 4.4 11/11] rcu: Update documentation of rcu_read_unlock()
Date:   Sun,  8 Aug 2021 09:22:46 +0200
Message-Id: <20210808072217.704630357@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210808072217.322468704@linuxfoundation.org>
References: <20210808072217.322468704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna-Maria Gleixner <anna-maria@linutronix.de>

[ Upstream commit ec84b27f9b3b569f9235413d1945a2006b97b0aa ]

Since commit b4abf91047cf ("rtmutex: Make wait_lock irq safe") the
explanation in rcu_read_unlock() documentation about irq unsafe rtmutex
wait_lock is no longer valid.

Remove it to prevent kernel developers reading the documentation to rely on
it.

Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: bigeasy@linutronix.de
Link: https://lkml.kernel.org/r/20180525090507.22248-2-anna-maria@linutronix.de
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Joe Korty <joe.korty@concurrent-rt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rcupdate.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -880,9 +880,7 @@ static __always_inline void rcu_read_loc
  * Unfortunately, this function acquires the scheduler's runqueue and
  * priority-inheritance spinlocks.  This means that deadlock could result
  * if the caller of rcu_read_unlock() already holds one of these locks or
- * any lock that is ever acquired while holding them; or any lock which
- * can be taken from interrupt context because rcu_boost()->rt_mutex_lock()
- * does not disable irqs while taking ->wait_lock.
+ * any lock that is ever acquired while holding them.
  *
  * That said, RCU readers are never priority boosted unless they were
  * preempted.  Therefore, one way to avoid deadlock is to make sure


