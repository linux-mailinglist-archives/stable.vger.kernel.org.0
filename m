Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE3DA90A2
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389846AbfIDSKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390170AbfIDSKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DF1B206B8;
        Wed,  4 Sep 2019 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620651;
        bh=An5nCkic9DIMAchQA8nBNy2dnhyUW1x9ls9wee2wjeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNcy2Du8an8wu4lCnBTePdGlrkedudBFwBMsgc61bJ4bv9sWVTRVbKXfzbOc4eMNM
         3Q4nX/22mwllEjODo3oY1WRDzrRyqytds3gnuQw1NEYdxGBxdHnNaD9t7fSp61YSaQ
         PdoZ3ksT+y8iUk9/yf8LYmz2wvKAYAKIo4QtKcnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, dbueso@suse.de,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 043/143] locking/rwsem: Add missing ACQUIRE to read_slowpath exit when queue is empty
Date:   Wed,  4 Sep 2019 19:53:06 +0200
Message-Id: <20190904175315.753872440@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e1b98fa316648420d0434d9ff5b92ad6609ba6c3 ]

LTP mtest06 has been observed to occasionally hit "still mapped when
deleted" and following BUG_ON on arm64.

The extra mapcount originated from pagefault handler, which handled
pagefault for vma that has already been detached. vma is detached
under mmap_sem write lock by detach_vmas_to_be_unmapped(), which
also invalidates vmacache.

When the pagefault handler (under mmap_sem read lock) calls
find_vma(), vmacache_valid() wrongly reports vmacache as valid.

After rwsem down_read() returns via 'queue empty' path (as of v5.2),
it does so without an ACQUIRE on sem->count:

  down_read()
    __down_read()
      rwsem_down_read_failed()
        __rwsem_down_read_failed_common()
          raw_spin_lock_irq(&sem->wait_lock);
          if (list_empty(&sem->wait_list)) {
            if (atomic_long_read(&sem->count) >= 0) {
              raw_spin_unlock_irq(&sem->wait_lock);
              return sem;

The problem can be reproduced by running LTP mtest06 in a loop and
building the kernel (-j $NCPUS) in parallel. It does reproduces since
v4.20 on arm64 HPE Apollo 70 (224 CPUs, 256GB RAM, 2 nodes). It
triggers reliably in about an hour.

The patched kernel ran fine for 10+ hours.

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Will Deacon <will@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: dbueso@suse.de
Fixes: 4b486b535c33 ("locking/rwsem: Exit read lock slowpath if queue empty & no writer")
Link: https://lkml.kernel.org/r/50b8914e20d1d62bb2dee42d342836c2c16ebee7.1563438048.git.jstancek@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/rwsem-xadd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 0b1f779572402..397dedc58432d 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -454,6 +454,8 @@ __rwsem_down_read_failed_common(struct rw_semaphore *sem, int state)
 		 * been set in the count.
 		 */
 		if (atomic_long_read(&sem->count) >= 0) {
+			/* Provide lock ACQUIRE */
+			smp_acquire__after_ctrl_dep();
 			raw_spin_unlock_irq(&sem->wait_lock);
 			rwsem_set_reader_owned(sem);
 			lockevent_inc(rwsem_rlock_fast);
-- 
2.20.1



