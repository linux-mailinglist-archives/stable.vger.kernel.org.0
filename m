Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973B34510C5
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243008AbhKOSzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242965AbhKOSwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:52:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DBDF63466;
        Mon, 15 Nov 2021 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999800;
        bh=cYrOYS1+KIfaOEpww6W/hCePkj8cZjnxveBQ64QIXSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNk19wkFWiYyrrhiFC88AJWoGDVYOlzig+1+lwZYLqEwpwsY1nyYMmksJVB/CYQh0
         RpaI99a7hQ27zlUeA9vDS0GU5TW9kD05kXLQ+RSTVhy48Pjd/QGRINBFOvxxxhv3uN
         a30tVR9YERLzoZ59yV7QfE2aqsecde2K9YDVK5ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuan-Ying Lee <kuan-ying.lee@mediatek.com>,
        Will Deacon <will@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Yee Lee <yee.lee@mediatek.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 396/849] scs: Release kasan vmalloc poison in scs_free process
Date:   Mon, 15 Nov 2021 17:57:59 +0100
Message-Id: <20211115165433.646650439@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yee Lee <yee.lee@mediatek.com>

[ Upstream commit 528a4ab45300fa6283556d9b48e26b45a8aa15c4 ]

Since scs allocation is moved to vmalloc region, the
shadow stack is protected by kasan_posion_vmalloc.
However, the vfree_atomic operation needs to access
its context for scs_free process and causes kasan error
as the dump info below.

This patch Adds kasan_unpoison_vmalloc() before vfree_atomic,
which aligns to the prior flow as using kmem_cache.
The vmalloc region will go back posioned in the following
vumap() operations.

 ==================================================================
 BUG: KASAN: vmalloc-out-of-bounds in llist_add_batch+0x60/0xd4
 Write of size 8 at addr ffff8000100b9000 by task kthreadd/2

 CPU: 0 PID: 2 Comm: kthreadd Not tainted 5.15.0-rc2-11681-g92477dd1faa6-dirty #1
 Hardware name: linux,dummy-virt (DT)
 Call trace:
  dump_backtrace+0x0/0x43c
  show_stack+0x1c/0x2c
  dump_stack_lvl+0x68/0x84
  print_address_description+0x80/0x394
  kasan_report+0x180/0x1dc
  __asan_report_store8_noabort+0x48/0x58
  llist_add_batch+0x60/0xd4
  vfree_atomic+0x60/0xe0
  scs_free+0x1dc/0x1fc
  scs_release+0xa4/0xd4
  free_task+0x30/0xe4
  __put_task_struct+0x1ec/0x2e0
  delayed_put_task_struct+0x5c/0xa0
  rcu_do_batch+0x62c/0x8a0
  rcu_core+0x60c/0xc14
  rcu_core_si+0x14/0x24
  __do_softirq+0x19c/0x68c
  irq_exit+0x118/0x2dc
  handle_domain_irq+0xcc/0x134
  gic_handle_irq+0x7c/0x1bc
  call_on_irq_stack+0x40/0x70
  do_interrupt_handler+0x78/0x9c
  el1_interrupt+0x34/0x60
  el1h_64_irq_handler+0x1c/0x2c
  el1h_64_irq+0x78/0x7c
  _raw_spin_unlock_irqrestore+0x40/0xcc
  sched_fork+0x4f0/0xb00
  copy_process+0xacc/0x3648
  kernel_clone+0x168/0x534
  kernel_thread+0x13c/0x1b0
  kthreadd+0x2bc/0x400
  ret_from_fork+0x10/0x20

 Memory state around the buggy address:
  ffff8000100b8f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
  ffff8000100b8f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 >ffff8000100b9000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                    ^
  ffff8000100b9080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
  ffff8000100b9100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ==================================================================

Suggested-by: Kuan-Ying Lee <kuan-ying.lee@mediatek.com>
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Will Deacon <will@kernel.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Yee Lee <yee.lee@mediatek.com>
Fixes: a2abe7cbd8fe ("scs: switch to vmapped shadow stacks")
Link: https://lore.kernel.org/r/20210930081619.30091-1-yee.lee@mediatek.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/scs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/scs.c b/kernel/scs.c
index e2a71fc82fa06..579841be88646 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -78,6 +78,7 @@ void scs_free(void *s)
 		if (this_cpu_cmpxchg(scs_cache[i], 0, s) == NULL)
 			return;
 
+	kasan_unpoison_vmalloc(s, SCS_SIZE);
 	vfree_atomic(s);
 }
 
-- 
2.33.0



