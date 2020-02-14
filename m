Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A940A15F166
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgBNSCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731807AbgBNPz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFDC32467C;
        Fri, 14 Feb 2020 15:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695757;
        bh=P1plHYGMYC1qyi04bgC3z1Yfbf1bTSu9ZEsG1MsEc/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yo367vd2HnMb2Rpht2sMFdrpuuaw52ZQDe1kKyvvs2lMeOKXBlWIJGQAvJZ471PH+
         aO1zrN4uNnGyZw6aPaTD92SxeRb3CIC8La7+SucW/QUEdPyyyFx1/zoVxknbmpvhe1
         sI4kmM9RLapsb3nlMB8ek7pzSLpObLuz2VH0djNY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changbin Du <changbin.du@gmail.com>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 326/542] x86/nmi: Remove irq_work from the long duration NMI handler
Date:   Fri, 14 Feb 2020 10:45:18 -0500
Message-Id: <20200214154854.6746-326-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

[ Upstream commit 248ed51048c40d36728e70914e38bffd7821da57 ]

First, printk() is NMI-context safe now since the safe printk() has been
implemented and it already has an irq_work to make NMI-context safe.

Second, this NMI irq_work actually does not work if a NMI handler causes
panic by watchdog timeout. It has no chance to run in such case, while
the safe printk() will flush its per-cpu buffers before panicking.

While at it, repurpose the irq_work callback into a function which
concentrates the NMI duration checking and makes the code easier to
follow.

 [ bp: Massage. ]

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20200111125427.15662-1-changbin.du@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/nmi.h |  1 -
 arch/x86/kernel/nmi.c      | 20 +++++++++-----------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 75ded1d13d98d..9d5d949e662e1 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -41,7 +41,6 @@ struct nmiaction {
 	struct list_head	list;
 	nmi_handler_t		handler;
 	u64			max_duration;
-	struct irq_work		irq_work;
 	unsigned long		flags;
 	const char		*name;
 };
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index e676a9916c498..54c21d6abd5ac 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -104,18 +104,22 @@ static int __init nmi_warning_debugfs(void)
 }
 fs_initcall(nmi_warning_debugfs);
 
-static void nmi_max_handler(struct irq_work *w)
+static void nmi_check_duration(struct nmiaction *action, u64 duration)
 {
-	struct nmiaction *a = container_of(w, struct nmiaction, irq_work);
+	u64 whole_msecs = READ_ONCE(action->max_duration);
 	int remainder_ns, decimal_msecs;
-	u64 whole_msecs = READ_ONCE(a->max_duration);
+
+	if (duration < nmi_longest_ns || duration < action->max_duration)
+		return;
+
+	action->max_duration = duration;
 
 	remainder_ns = do_div(whole_msecs, (1000 * 1000));
 	decimal_msecs = remainder_ns / 1000;
 
 	printk_ratelimited(KERN_INFO
 		"INFO: NMI handler (%ps) took too long to run: %lld.%03d msecs\n",
-		a->handler, whole_msecs, decimal_msecs);
+		action->handler, whole_msecs, decimal_msecs);
 }
 
 static int nmi_handle(unsigned int type, struct pt_regs *regs)
@@ -142,11 +146,7 @@ static int nmi_handle(unsigned int type, struct pt_regs *regs)
 		delta = sched_clock() - delta;
 		trace_nmi_handler(a->handler, (int)delta, thishandled);
 
-		if (delta < nmi_longest_ns || delta < a->max_duration)
-			continue;
-
-		a->max_duration = delta;
-		irq_work_queue(&a->irq_work);
+		nmi_check_duration(a, delta);
 	}
 
 	rcu_read_unlock();
@@ -164,8 +164,6 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 	if (!action->handler)
 		return -EINVAL;
 
-	init_irq_work(&action->irq_work, nmi_max_handler);
-
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/*
-- 
2.20.1

