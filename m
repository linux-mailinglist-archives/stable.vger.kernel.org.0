Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3403CD9D2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244258AbhGSObr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244333AbhGSO3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2EA661357;
        Mon, 19 Jul 2021 15:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707360;
        bh=xdNVNWj+EF5c1s5ti6/KbPy938IFVnsEObk7O4JrChI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tScd++kGimckHpT5JGQT3G3nbsh1HxgcUWH3zgoZ6k74NLTHhI6nrD4TkFLoaknxd
         cmfSwDIjQuFaJNpVSi8uWhnft1p2cfiJWRmlXZoQ3hufMic0n3ic+3sLTuFdoHJRbd
         UffPy2XaSgP8nArIFo6LPutBuEXgwoWmGmH6Lbhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 129/245] net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT
Date:   Mon, 19 Jul 2021 16:51:11 +0200
Message-Id: <20210719144944.574116710@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 8380c81d5c4fced6f4397795a5ae65758272bbfd ]

__napi_schedule_irqoff() is an optimized version of __napi_schedule()
which can be used where it is known that interrupts are disabled,
e.g. in interrupt-handlers, spin_lock_irq() sections or hrtimer
callbacks.

On PREEMPT_RT enabled kernels this assumptions is not true. Force-
threaded interrupt handlers and spinlocks are not disabling interrupts
and the NAPI hrtimer callback is forced into softirq context which runs
with interrupts enabled as well.

Chasing all usage sites of __napi_schedule_irqoff() is a whack-a-mole
game so make __napi_schedule_irqoff() invoke __napi_schedule() for
PREEMPT_RT kernels.

The callers of ____napi_schedule() in the networking core have been
audited and are correct on PREEMPT_RT kernels as well.

Reported-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5b69a9a41dd5..47468fc5d0c9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4998,11 +4998,18 @@ EXPORT_SYMBOL(__napi_schedule);
  * __napi_schedule_irqoff - schedule for receive
  * @n: entry to schedule
  *
- * Variant of __napi_schedule() assuming hard irqs are masked
+ * Variant of __napi_schedule() assuming hard irqs are masked.
+ *
+ * On PREEMPT_RT enabled kernels this maps to __napi_schedule()
+ * because the interrupt disabled assumption might not be true
+ * due to force-threaded interrupts and spinlock substitution.
  */
 void __napi_schedule_irqoff(struct napi_struct *n)
 {
-	____napi_schedule(this_cpu_ptr(&softnet_data), n);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		____napi_schedule(this_cpu_ptr(&softnet_data), n);
+	else
+		__napi_schedule(n);
 }
 EXPORT_SYMBOL(__napi_schedule_irqoff);
 
-- 
2.30.2



