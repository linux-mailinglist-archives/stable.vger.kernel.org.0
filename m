Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14B637D2EC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243566AbhELSPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:15:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349403AbhELSKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 225416192B;
        Wed, 12 May 2021 18:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842719;
        bh=tBJpSCR/JXQD4SNlixszfDXQT0C1jlLrFAXRes16CAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kahvgjRmlhpMfnRbm3yYRlYKmKgxVjxhRzjPVfcNadBIzzVoqTh1AcyAVbDLEUZyd
         HieoaCn/bDk0Wi/uXoKj1gYieg5lYLIt/3i+Xf5FMXmmwSw6h54OxyJzmv/kAfumdd
         PtKLZjMqL+7GKE9YHpm2HBwVD9QnONT/H9q7iFFyoq3+HNduohB9WuQkO9+mqhiiuI
         RidUryQjYn+WPMzVNsYshaNFyhp7WvMhYtpHny22eXUplJfDz6RODYeSFD2j64pWuk
         DqjqaH/xY5Zo+tqnhnHv7tD4DDwyEU+9uOQlK+35W4rxuWVdLzqtoGz3iufaEJOcl0
         f+tN32LdxxKWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang.zhang@windriver.com>,
        Andrew Halaney <ahalaney@redhat.com>,
        Alexander Potapenko <glider@google.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vijayanand Jitta <vjitta@codeaurora.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Yogesh Lal <ylal@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 17/18] lib: stackdepot: turn depot_lock spinlock to raw_spinlock
Date:   Wed, 12 May 2021 14:04:48 -0400
Message-Id: <20210512180450.665586-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180450.665586-1-sashal@kernel.org>
References: <20210512180450.665586-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

[ Upstream commit 78564b9434878d686c5f88c4488b20cccbcc42bc ]

In RT system, the spin_lock will be replaced by sleepable rt_mutex lock,
in __call_rcu(), disable interrupts before calling
kasan_record_aux_stack(), will trigger this calltrace:

  BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:951
  in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 19, name: pgdatinit0
  Call Trace:
    ___might_sleep.cold+0x1b2/0x1f1
    rt_spin_lock+0x3b/0xb0
    stack_depot_save+0x1b9/0x440
    kasan_save_stack+0x32/0x40
    kasan_record_aux_stack+0xa5/0xb0
    __call_rcu+0x117/0x880
    __exit_signal+0xafb/0x1180
    release_task+0x1d6/0x480
    exit_notify+0x303/0x750
    do_exit+0x678/0xcf0
    kthread+0x364/0x4f0
    ret_from_fork+0x22/0x30

Replace spinlock with raw_spinlock.

Link: https://lkml.kernel.org/r/20210329084009.27013-1-qiang.zhang@windriver.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Reported-by: Andrew Halaney <ahalaney@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Yogesh Lal <ylal@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/stackdepot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 3376a3291186..d0f1b7d0ce2e 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -78,7 +78,7 @@ static void *stack_slabs[STACK_ALLOC_MAX_SLABS];
 static int depot_index;
 static int next_slab_inited;
 static size_t depot_offset;
-static DEFINE_SPINLOCK(depot_lock);
+static DEFINE_RAW_SPINLOCK(depot_lock);
 
 static bool init_stack_slab(void **prealloc)
 {
@@ -266,7 +266,7 @@ depot_stack_handle_t depot_save_stack(struct stack_trace *trace,
 			prealloc = page_address(page);
 	}
 
-	spin_lock_irqsave(&depot_lock, flags);
+	raw_spin_lock_irqsave(&depot_lock, flags);
 
 	found = find_stack(*bucket, trace->entries, trace->nr_entries, hash);
 	if (!found) {
@@ -290,7 +290,7 @@ depot_stack_handle_t depot_save_stack(struct stack_trace *trace,
 		WARN_ON(!init_stack_slab(&prealloc));
 	}
 
-	spin_unlock_irqrestore(&depot_lock, flags);
+	raw_spin_unlock_irqrestore(&depot_lock, flags);
 exit:
 	if (prealloc) {
 		/* Nobody used this memory, ok to free it. */
-- 
2.30.2

