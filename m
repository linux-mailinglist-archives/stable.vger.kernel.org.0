Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8938A9F8
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbhETLIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239140AbhETLGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:06:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE33E60FDB;
        Thu, 20 May 2021 10:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505130;
        bh=bxQYnJV0rEBNwhtbGDeP8nQut7nB2UF5lBADMfe58Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJP+wGChkL5N8+j96JTVna8DbBPfDr1NZ2qrgrBZV0SOK3Yu/qwvz4btQLIo8Fn4r
         0GNOSn2s4fvOCYHelpQ4VlpaALCI2QAfB74C3RfKvCvxuF7xujRQ6gmGCYryUjjywX
         ERA0NDkNm3uolFxUl08lv+t0W8khM4tcNbdSHFDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang.zhang@windriver.com>,
        Andrew Halaney <ahalaney@redhat.com>,
        Alexander Potapenko <glider@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Vijayanand Jitta <vjitta@codeaurora.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Yogesh Lal <ylal@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 236/240] lib: stackdepot: turn depot_lock spinlock to raw_spinlock
Date:   Thu, 20 May 2021 11:23:48 +0200
Message-Id: <20210520092116.613782743@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 lib/stackdepot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -78,7 +78,7 @@ static void *stack_slabs[STACK_ALLOC_MAX
 static int depot_index;
 static int next_slab_inited;
 static size_t depot_offset;
-static DEFINE_SPINLOCK(depot_lock);
+static DEFINE_RAW_SPINLOCK(depot_lock);
 
 static bool init_stack_slab(void **prealloc)
 {
@@ -253,7 +253,7 @@ depot_stack_handle_t depot_save_stack(st
 			prealloc = page_address(page);
 	}
 
-	spin_lock_irqsave(&depot_lock, flags);
+	raw_spin_lock_irqsave(&depot_lock, flags);
 
 	found = find_stack(*bucket, trace->entries, trace->nr_entries, hash);
 	if (!found) {
@@ -277,7 +277,7 @@ depot_stack_handle_t depot_save_stack(st
 		WARN_ON(!init_stack_slab(&prealloc));
 	}
 
-	spin_unlock_irqrestore(&depot_lock, flags);
+	raw_spin_unlock_irqrestore(&depot_lock, flags);
 exit:
 	if (prealloc) {
 		/* Nobody used this memory, ok to free it. */


