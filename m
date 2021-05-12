Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7349637D289
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350546AbhELSKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352771AbhELSEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0EAB6143A;
        Wed, 12 May 2021 18:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842583;
        bh=zhyBvzrh9W0IRk2zSFEPYdi9jdcCS/hX+1blNt0b6tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2/Dz1XJa+jN6gFgUltnbdS9zPwbc3ydnVODc5qffGasBMSEG6gDn9PyCp8c/Xdiz
         y/ctplDPN84SXdkQ59x6sWDuA5iJuC8peiEZ3MK7CFDiBOZJSfpCsb2JUKPKcFrj6f
         oVjRTIFtmhkAX1ctlZq81RCiYLHBnNaDWGqZWubkuBEfOUhDkd6Cftt6g3+8vSIqBq
         x9Q4Ol26Qqr1jVIphpxJiUfAXA92QNylTIixFayyS36b7O86xIHn8eVQL6UhqN4oR1
         wo8ifEE31b/SHLBlDZpzUr9au2wn7TbiTxvVqDmS3qVID2Uf3P3giEfQsa8xnhuvpt
         iCALBRZngoCHg==
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
Subject: [PATCH AUTOSEL 5.11 34/35] lib: stackdepot: turn depot_lock spinlock to raw_spinlock
Date:   Wed, 12 May 2021 14:02:04 -0400
Message-Id: <20210512180206.664536-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
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
index 890dcc2e984e..f229c65fd533 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -70,7 +70,7 @@ static void *stack_slabs[STACK_ALLOC_MAX_SLABS];
 static int depot_index;
 static int next_slab_inited;
 static size_t depot_offset;
-static DEFINE_SPINLOCK(depot_lock);
+static DEFINE_RAW_SPINLOCK(depot_lock);
 
 static bool init_stack_slab(void **prealloc)
 {
@@ -280,7 +280,7 @@ depot_stack_handle_t stack_depot_save(unsigned long *entries,
 			prealloc = page_address(page);
 	}
 
-	spin_lock_irqsave(&depot_lock, flags);
+	raw_spin_lock_irqsave(&depot_lock, flags);
 
 	found = find_stack(*bucket, entries, nr_entries, hash);
 	if (!found) {
@@ -304,7 +304,7 @@ depot_stack_handle_t stack_depot_save(unsigned long *entries,
 		WARN_ON(!init_stack_slab(&prealloc));
 	}
 
-	spin_unlock_irqrestore(&depot_lock, flags);
+	raw_spin_unlock_irqrestore(&depot_lock, flags);
 exit:
 	if (prealloc) {
 		/* Nobody used this memory, ok to free it. */
-- 
2.30.2

