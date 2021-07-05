Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B59C3BBD56
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 15:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhGENLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 09:11:05 -0400
Received: from mail-m118208.qiye.163.com ([115.236.118.208]:25360 "EHLO
        mail-m118208.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhGENLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 09:11:05 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jul 2021 09:11:04 EDT
Received: from localhost.localdomain (unknown [113.118.122.203])
        by mail-m118208.qiye.163.com (Hmail) with ESMTPA id C6A8CE03BD;
        Mon,  5 Jul 2021 21:00:58 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     tony.luck@intel.com, bp@alien8.de, bp@suse.de,
        naoya.horiguchi@nec.com, osalvador@suse.de, peterz@infradead.org
Cc:     linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, youquan.song@intel.com, huangcun@sangfor.com.cn,
        stable@vger.kernel.org, Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH v1] x86/mce: Fix endless loop when run task works after #MC
Date:   Mon,  5 Jul 2021 20:59:21 +0800
Message-Id: <20210705125921.936-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZQxhDT1ZJHUxOHR0eTkJMSk5VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PVE6Sjo6Tz9WTRkWFEMTGU8T
        SRIwCzhVSlVKTUlOT0JLS05CTU5KVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkhVSkpDVUpJSVVJS0hZV1kIAVlBSE9CSTcG
X-HM-Tid: 0a7a76c1f02a2c17kusnc6a8ce03bd
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
has been added to task_works, prevent duplicate addition. When
work function be called, the task_works must has been taken,
so it is safe to be cleared in callback.

Fixed: commit 5567d11c21a1 ("x86/mce: Send #MC singal from task work")
Cc: <stable@vger.kernel.org> #v5.8+
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
---
 arch/x86/kernel/cpu/mce/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 22791aadc085..32fb9ded6b85 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1250,6 +1250,7 @@ static void __mc_scan_banks(struct mce *m, struct pt_regs *regs, struct mce *fin
 
 static void kill_me_now(struct callback_head *ch)
 {
+	WRITE_ONCE(ch->func, NULL);
 	force_sig(SIGBUS);
 }
 
@@ -1259,6 +1260,8 @@ static void kill_me_maybe(struct callback_head *cb)
 	int flags = MF_ACTION_REQUIRED;
 	int ret;
 
+	WRITE_ONCE(cb->func, NULL);
+
 	pr_err("Uncorrected hardware memory error in user-access at %llx", p->mce_addr);
 
 	if (!p->mce_ripv)
@@ -1289,17 +1292,20 @@ static void kill_me_maybe(struct callback_head *cb)
 
 static void queue_task_work(struct mce *m, int kill_current_task)
 {
+	struct callback_head ch;
+
 	current->mce_addr = m->addr;
 	current->mce_kflags = m->kflags;
 	current->mce_ripv = !!(m->mcgstatus & MCG_STATUS_RIPV);
 	current->mce_whole_page = whole_page(m);
 
 	if (kill_current_task)
-		current->mce_kill_me.func = kill_me_now;
+		ch.func = kill_me_now;
 	else
-		current->mce_kill_me.func = kill_me_maybe;
+		ch.func = kill_me_maybe;
 
-	task_work_add(current, &current->mce_kill_me, TWA_RESUME);
+	if (!cmpxchg(&current->mce_kill_me.func, NULL, ch.func))
+		task_work_add(current, &current->mce_kill_me, TWA_RESUME);
 }
 
 /*
-- 
2.17.1

