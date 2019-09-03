Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76AF7A701D
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbfICQ0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730177AbfICQ0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29A0E238C5;
        Tue,  3 Sep 2019 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528004;
        bh=VhYDu8fEbK18fdi3qDlTweaEVg3p6CaSTXf/vybgIME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PjVdcUApmjeGC0xzLSCpOM5LuD+iHYAaxoMhQyXlvZ0JcHTfxjxlDBQvnMDFpL7TZ
         Q7Dv5Ioko/MkcttnY3MgdVvqdR8AYpM0VSyAvlQlcKgr3H55AYy9OtIQ9JZNtkVBp0
         VlQdmaByo0yMRvAFFhT9eWJNRiMBisKI20AMyXkc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 049/167] ARC: show_regs: lockdep: re-enable preemption
Date:   Tue,  3 Sep 2019 12:23:21 -0400
Message-Id: <20190903162519.7136-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

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

