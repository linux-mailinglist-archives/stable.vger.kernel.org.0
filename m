Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132DFB1F12
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389709AbfIMNPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbfIMNPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:31 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96B50208C2;
        Fri, 13 Sep 2019 13:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380531;
        bh=8Ox/twdNfWzBqCkBllPrnqUO/zXdBQaBeO8Y1SruOrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETjCqoimZmYlhnkrmu8Qgrnc1zjq0QOpzyqHf4uz/rIEa9jzDCu0I5jRFdJAlqvCX
         k+hO2I8/iiu78J3GtESbWt/C+b2iepw28dQAdT6GmUBMY23SEkDrDx+epybBPgSaQ8
         A3BL6BgbKCplGNil8DvBAalk/gM1jdQf9fXJT/qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/190] ARC: show_regs: lockdep: re-enable preemption
Date:   Fri, 13 Sep 2019 14:05:31 +0100
Message-Id: <20190913130605.618520939@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f731a8e89f8c78985707c626680f3e24c7a60772 ]

signal handling core calls show_regs() with preemption disabled which
on ARC takes mmap_sem for mm/vma access, causing lockdep splat.

| [ARCLinux]# ./segv-null-ptr
| potentially unexpected fatal signal 11.
| BUG: sleeping function called from invalid context at kernel/fork.c:1011
| in_atomic(): 1, irqs_disabled(): 0, pid: 70, name: segv-null-ptr
| no locks held by segv-null-ptr/70.
| CPU: 0 PID: 70 Comm: segv-null-ptr Not tainted 4.18.0+ #69
|
| Stack Trace:
|  arc_unwind_core+0xcc/0x100
|  ___might_sleep+0x17a/0x190
|  mmput+0x16/0xb8
|  show_regs+0x52/0x310
|  get_signal+0x5ee/0x610
|  do_signal+0x2c/0x218
|  resume_user_mode_begin+0x90/0xd8

Workaround by re-enabling preemption temporarily.

Note that the preemption disabling in core code around show_regs()
was introduced by commit 3a9f84d354ce ("signals, debug: fix BUG: using
smp_processor_id() in preemptible code in print_fatal_signal()")

to silence a differnt lockdep seen on x86 bakc in 2009.

Cc: <stable@vger.kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/kernel/troubleshoot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
index 5c6663321e873..215f515442e03 100644
--- a/arch/arc/kernel/troubleshoot.c
+++ b/arch/arc/kernel/troubleshoot.c
@@ -179,6 +179,12 @@ void show_regs(struct pt_regs *regs)
 	struct task_struct *tsk = current;
 	struct callee_regs *cregs;
 
+	/*
+	 * generic code calls us with preemption disabled, but some calls
+	 * here could sleep, so re-enable to avoid lockdep splat
+	 */
+	preempt_enable();
+
 	print_task_path_n_nm(tsk);
 	show_regs_print_info(KERN_INFO);
 
@@ -221,6 +227,8 @@ void show_regs(struct pt_regs *regs)
 	cregs = (struct callee_regs *)current->thread.callee_reg;
 	if (cregs)
 		show_callee_regs(cregs);
+
+	preempt_disable();
 }
 
 void show_kernel_fault_diag(const char *str, struct pt_regs *regs,
-- 
2.20.1



