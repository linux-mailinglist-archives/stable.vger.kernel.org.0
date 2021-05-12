Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B693A37D2F9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351686AbhELSPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353206AbhELSK4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:10:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82D8B61942;
        Wed, 12 May 2021 18:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842744;
        bh=HoXhbdPkempNh0y+GrVdzvcto/dJ8wWErjeD512HHMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/Qf/00L0tmitPjYxmwQ0f8kpRyGCRTyhZbB3PtCSpFDuLcvDmqG5fEiggW6VBfw4
         gi5rviYba5Czv+UIUFG8fIwtvUgNTbd7HHcCyb+jYB002YhCWBT4yjnv3DjcwteveS
         Ymgj+FX23/FeeNwLhNm/OBLN5QH1FqFuwHheAwLtFtpkuSPFJIv/7raHmKjrSRL1rC
         i0Za91Z1TEUswlOm7hUXs57k8e2/GCgAAYKNQuuA9eXfVAcACDMEb+qp3tZ33/ktEg
         mZG69i1YZqNz92JLWKBc8VNZIVOt3PoS4Vl4SuFCrYUwt1zFy+t7kUY2ZeTxCdWV8/
         LghT76nrbstyQ==
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
Subject: [PATCH AUTOSEL 4.14 12/12] lib: stackdepot: turn depot_lock spinlock to raw_spinlock
Date:   Wed, 12 May 2021 14:05:22 -0400
Message-Id: <20210512180522.665788-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180522.665788-1-sashal@kernel.org>
References: <20210512180522.665788-1-sashal@kernel.org>
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
index 759ff419fe61..c519aa07d2e9 100644
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
@@ -253,7 +253,7 @@ depot_stack_handle_t depot_save_stack(struct stack_trace *trace,
 			prealloc = page_address(page);
 	}
 
-	spin_lock_irqsave(&depot_lock, flags);
+	raw_spin_lock_irqsave(&depot_lock, flags);
 
 	found = find_stack(*bucket, trace->entries, trace->nr_entries, hash);
 	if (!found) {
@@ -277,7 +277,7 @@ depot_stack_handle_t depot_save_stack(struct stack_trace *trace,
 		WARN_ON(!init_stack_slab(&prealloc));
 	}
 
-	spin_unlock_irqrestore(&depot_lock, flags);
+	raw_spin_unlock_irqrestore(&depot_lock, flags);
 exit:
 	if (prealloc) {
 		/* Nobody used this memory, ok to free it. */
-- 
2.30.2

