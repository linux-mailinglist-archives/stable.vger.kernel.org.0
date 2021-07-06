Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E623C3BD69C
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhGFMlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:41:24 -0400
Received: from mail-m118208.qiye.163.com ([115.236.118.208]:26410 "EHLO
        mail-m118208.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbhGFMTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 08:19:08 -0400
Received: from localhost.localdomain (unknown [113.118.122.203])
        by mail-m118208.qiye.163.com (Hmail) with ESMTPA id AE4C5E041C;
        Tue,  6 Jul 2021 20:16:24 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     tony.luck@intel.com, bp@alien8.de, bp@suse.de,
        naoya.horiguchi@nec.com, osalvador@suse.de, peterz@infradead.org
Cc:     linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, youquan.song@intel.com, huangcun@sangfor.com.cn,
        Ding Hui <dinghui@sangfor.com.cn>, stable@vger.kernel.org
Subject: [PATCH v2] x86/mce: Fix endless loop when run task works after #MC
Date:   Tue,  6 Jul 2021 20:16:06 +0800
Message-Id: <20210706121606.15864-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGU5DT1YeHUpDH09JTR4aH0JVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBg6MAw5Oj9MOh8NLC8MIjZI
        AShPFAlVSlVKTUlOTkxITENOTk5OVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkhVSkpDVUpJSVVJS0hZV1kIAVlBT0NISDcG
X-HM-Tid: 0a7a7bbf7e6f2c17kusnae4c5e041c
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recently we encounter multi #MC on the same task when it's
task_work_run() has not been called, current->mce_kill_me was
added to task_works list more than once, that make a circular
linked task_works, so task_work_run() will do a endless loop.

More seriously, the SIGBUS signal can not be delivered to the
userspace task which tigger the #MC and I met #MC flood.

I borrowed mce_kill_me.func to check whether current->mce_kill_me
has been added to task_works, prevent duplicate addition and override
current->mce_xxx. When work function be called, the task_works
must has been taken, so it is safe to be cleared in callback.

Fixes: commit 5567d11c21a1 ("x86/mce: Send #MC singal from task work")
Cc: <stable@vger.kernel.org> #v5.8+
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>

---
v1->v2:
do not call kill_me_now in kill_me_maybe, to avoid mce_kill_me.func
race condition
do not override current->mce_xxx before callback

 arch/x86/kernel/cpu/mce/core.c | 38 ++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 22791aadc085..95d244a95486 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1250,6 +1250,7 @@ static void __mc_scan_banks(struct mce *m, struct pt_regs *regs, struct mce *fin
 
 static void kill_me_now(struct callback_head *ch)
 {
+	WRITE_ONCE(ch->func, NULL);
 	force_sig(SIGBUS);
 }
 
@@ -1258,15 +1259,22 @@ static void kill_me_maybe(struct callback_head *cb)
 	struct task_struct *p = container_of(cb, struct task_struct, mce_kill_me);
 	int flags = MF_ACTION_REQUIRED;
 	int ret;
+	u64 mce_addr = p->mce_addr;
+	__u64 mce_kflags = p->mce_kflags;
+	bool mce_ripv = p->mce_ripv;
+	bool mce_whole_page = p->mce_whole_page;
 
-	pr_err("Uncorrected hardware memory error in user-access at %llx", p->mce_addr);
+	/* reset func after save p->mce_xxx */
+	WRITE_ONCE(cb->func, NULL);
 
-	if (!p->mce_ripv)
+	pr_err("Uncorrected hardware memory error in user-access at %llx", mce_addr);
+
+	if (!mce_ripv)
 		flags |= MF_MUST_KILL;
 
-	ret = memory_failure(p->mce_addr >> PAGE_SHIFT, flags);
-	if (!ret && !(p->mce_kflags & MCE_IN_KERNEL_COPYIN)) {
-		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
+	ret = memory_failure(mce_addr >> PAGE_SHIFT, flags);
+	if (!ret && !(mce_kflags & MCE_IN_KERNEL_COPYIN)) {
+		set_mce_nospec(mce_addr >> PAGE_SHIFT, mce_whole_page);
 		sync_core();
 		return;
 	}
@@ -1283,23 +1291,27 @@ static void kill_me_maybe(struct callback_head *cb)
 		force_sig_mceerr(BUS_MCEERR_AR, p->mce_vaddr, PAGE_SHIFT);
 	} else {
 		pr_err("Memory error not recovered");
-		kill_me_now(cb);
+		force_sig(SIGBUS);
 	}
 }
 
 static void queue_task_work(struct mce *m, int kill_current_task)
 {
-	current->mce_addr = m->addr;
-	current->mce_kflags = m->kflags;
-	current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
-	current->mce_whole_page = whole_page(m);
+	struct callback_head ch;
 
 	if (kill_current_task)
-		current->mce_kill_me.func = kill_me_now;
+		ch.func = kill_me_now;
 	else
-		current->mce_kill_me.func = kill_me_maybe;
+		ch.func = kill_me_maybe;
+
+	if (!cmpxchg(&current->mce_kill_me.func, NULL, ch.func)) {
+		current->mce_addr = m->addr;
+		current->mce_kflags = m->kflags;
+		current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
+		current->mce_whole_page = whole_page(m);
 
-	task_work_add(current, &current->mce_kill_me, TWA_RESUME);
+		task_work_add(current, &current->mce_kill_me, TWA_RESUME);
+	}
 }
 
 /*
-- 
2.17.1

