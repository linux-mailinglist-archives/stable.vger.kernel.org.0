Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9954137D00
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAKJwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:52:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbgAKJwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:52:20 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCCAF20842;
        Sat, 11 Jan 2020 09:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736340;
        bh=MJ/M7tLrt8Znxce3AiWWY84baZvo6f9mbQS4jWLxiYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVirj2LgAnHhS0uenw3eN2k6mEXV8QmWKDfbCa5IUs7O/uDLxEMh+Fwp8io7TIvvn
         ZhR4aj0bqpOWJdVMPanHVax1vjYBoPmfDsEsXKzdMVosprHgrt0YUf1PMUfQ0p1z1r
         VR8u7Zz9pl0L/KmX25uTgUzkOIALyUfZzsQdkEiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Marco Elver <elver@google.com>, Will Deacon <will@kernel.org>,
        Andrea Parri <parri.andrea@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/59] taskstats: fix data-race
Date:   Sat, 11 Jan 2020 10:49:22 +0100
Message-Id: <20200111094840.703775554@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

[ Upstream commit 0b8d616fb5a8ffa307b1d3af37f55c15dae14f28 ]

When assiging and testing taskstats in taskstats_exit() there's a race
when setting up and reading sig->stats when a thread-group with more
than one thread exits:

write to 0xffff8881157bbe10 of 8 bytes by task 7951 on cpu 0:
 taskstats_tgid_alloc kernel/taskstats.c:567 [inline]
 taskstats_exit+0x6b7/0x717 kernel/taskstats.c:596
 do_exit+0x2c2/0x18e0 kernel/exit.c:864
 do_group_exit+0xb4/0x1c0 kernel/exit.c:983
 get_signal+0x2a2/0x1320 kernel/signal.c:2734
 do_signal+0x3b/0xc00 arch/x86/kernel/signal.c:815
 exit_to_usermode_loop+0x250/0x2c0 arch/x86/entry/common.c:159
 prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
 do_syscall_64+0x2d7/0x2f0 arch/x86/entry/common.c:299
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

read to 0xffff8881157bbe10 of 8 bytes by task 7949 on cpu 1:
 taskstats_tgid_alloc kernel/taskstats.c:559 [inline]
 taskstats_exit+0xb2/0x717 kernel/taskstats.c:596
 do_exit+0x2c2/0x18e0 kernel/exit.c:864
 do_group_exit+0xb4/0x1c0 kernel/exit.c:983
 __do_sys_exit_group kernel/exit.c:994 [inline]
 __se_sys_exit_group kernel/exit.c:992 [inline]
 __x64_sys_exit_group+0x2e/0x30 kernel/exit.c:992
 do_syscall_64+0xcf/0x2f0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by using smp_load_acquire() and smp_store_release().

Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Will Deacon <will@kernel.org>
Reviewed-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://lore.kernel.org/r/20191009114809.8643-1-christian.brauner@ubuntu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/taskstats.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 21f82c29c914..0737a50380d7 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -582,25 +582,33 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
-	struct taskstats *stats;
+	struct taskstats *stats_new, *stats;
 
-	if (sig->stats || thread_group_empty(tsk))
-		goto ret;
+	/* Pairs with smp_store_release() below. */
+	stats = smp_load_acquire(&sig->stats);
+	if (stats || thread_group_empty(tsk))
+		return stats;
 
 	/* No problem if kmem_cache_zalloc() fails */
-	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
+	stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
 
 	spin_lock_irq(&tsk->sighand->siglock);
-	if (!sig->stats) {
-		sig->stats = stats;
-		stats = NULL;
+	stats = sig->stats;
+	if (!stats) {
+		/*
+		 * Pairs with smp_store_release() above and order the
+		 * kmem_cache_zalloc().
+		 */
+		smp_store_release(&sig->stats, stats_new);
+		stats = stats_new;
+		stats_new = NULL;
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
 
-	if (stats)
-		kmem_cache_free(taskstats_cache, stats);
-ret:
-	return sig->stats;
+	if (stats_new)
+		kmem_cache_free(taskstats_cache, stats_new);
+
+	return stats;
 }
 
 /* Send pid data out on exit */
-- 
2.20.1



