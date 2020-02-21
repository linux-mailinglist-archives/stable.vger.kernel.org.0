Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5CD16766C
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbgBUId5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:33:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732248AbgBUIKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:10:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2D9A20578;
        Fri, 21 Feb 2020 08:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272601;
        bh=P1plHYGMYC1qyi04bgC3z1Yfbf1bTSu9ZEsG1MsEc/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZPEVVC1andCgEH0lKq7PVXP9M0Sxd55WZwoJpzJJPnloLljSxYlHrwo+c1d3wlz0
         KjFwmuCViOm7lHgOoYrsXXNOMuBzUSMPjNry1G/4KhztOSAkX9L6dZQcetrTUjxQO+
         ZkNoxay2ShEg1lSjpIax7ZPViOIy+7h8UQVM2bNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 204/344] x86/nmi: Remove irq_work from the long duration NMI handler
Date:   Fri, 21 Feb 2020 08:40:03 +0100
Message-Id: <20200221072407.639683769@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



