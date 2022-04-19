Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A1550776F
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239228AbiDSSRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356389AbiDSSQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:16:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D787D3E5D3;
        Tue, 19 Apr 2022 11:12:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 586CA60AC0;
        Tue, 19 Apr 2022 18:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5511DC385A7;
        Tue, 19 Apr 2022 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391961;
        bh=9Vd9VfQI/r2lx1eeK2qA6QkTXF4Wdp/LKCeS7dSW+2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsjY8cREktoVTVqzqVwHOG6BTqbPRlIb9O4VpBt0EsukFwAtrxhB3db+WhkzJjVWL
         FikOa31FnDXFJfuKvdTItgrh8KBT94ccLLND0gQ1BpBLp5gwOQP/zkRdjB2JGUY6WN
         Z1OU6xvB8PXLjv489Aj3TecZFW4NSGIQtesnpcWdAz+/zNJ0ISuK5KFNFRLRxE/hv5
         hLt1pTw/wK/NsNWUbxcWnkYXtiUWdefW++klBA0JFt3rlA6mBHpFQTUzQCOFKVVo/g
         nrLMI+a36owQkKJzlC6H+Z8O6xbAzqCSrF4lYPIHaX8ByZJUxuCDR4riNC1D1+mGzU
         zzq2oVYm3zC4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang1.zhang@intel.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        bigeasy@linutronix.de
Subject: [PATCH AUTOSEL 5.17 34/34] irq_work: use kasan_record_aux_stack_noalloc() record callstack
Date:   Tue, 19 Apr 2022 14:11:01 -0400
Message-Id: <20220419181104.484667-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181104.484667-1-sashal@kernel.org>
References: <20220419181104.484667-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang1.zhang@intel.com>

[ Upstream commit 25934fcfb93c4687ad32fd3d062bcf03457129d4 ]

On PREEMPT_RT kernel and KASAN is enabled.  the kasan_record_aux_stack()
may call alloc_pages(), and the rt-spinlock will be acquired, if currently
in atomic context, will trigger warning:

  BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 239, name: bootlogd
  Preemption disabled at:
  [<ffffffffbab1a531>] rt_mutex_slowunlock+0xa1/0x4e0
  CPU: 3 PID: 239 Comm: bootlogd Tainted: G        W 5.17.1-rt17-yocto-preempt-rt+ #105
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
  Call Trace:
     __might_resched.cold+0x13b/0x173
     rt_spin_lock+0x5b/0xf0
     get_page_from_freelist+0x20c/0x1610
     __alloc_pages+0x25e/0x5e0
     __stack_depot_save+0x3c0/0x4a0
     kasan_save_stack+0x3a/0x50
     __kasan_record_aux_stack+0xb6/0xc0
     kasan_record_aux_stack+0xe/0x10
     irq_work_queue_on+0x6a/0x1c0
     pull_rt_task+0x631/0x6b0
     do_balance_callbacks+0x56/0x80
     __balance_callbacks+0x63/0x90
     rt_mutex_setprio+0x349/0x880
     rt_mutex_slowunlock+0x22a/0x4e0
     rt_spin_unlock+0x49/0x80
     uart_write+0x186/0x2b0
     do_output_char+0x2e9/0x3a0
     n_tty_write+0x306/0x800
     file_tty_write.isra.0+0x2af/0x450
     tty_write+0x22/0x30
     new_sync_write+0x27c/0x3a0
     vfs_write+0x3f7/0x5d0
     ksys_write+0xd9/0x180
     __x64_sys_write+0x43/0x50
     do_syscall_64+0x44/0x90
     entry_SYSCALL_64_after_hwframe+0x44/0xae

Fix it by using kasan_record_aux_stack_noalloc() to avoid the call to
alloc_pages().

Link: https://lkml.kernel.org/r/20220402142555.2699582-1-qiang1.zhang@intel.com
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq_work.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index f7df715ec28e..7afa40fe5cc4 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -137,7 +137,7 @@ bool irq_work_queue_on(struct irq_work *work, int cpu)
 	if (!irq_work_claim(work))
 		return false;
 
-	kasan_record_aux_stack(work);
+	kasan_record_aux_stack_noalloc(work);
 
 	preempt_disable();
 	if (cpu != smp_processor_id()) {
-- 
2.35.1

