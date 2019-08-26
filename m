Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390E79D1AA
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 16:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfHZOb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 10:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfHZOb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 10:31:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F8E02173E;
        Mon, 26 Aug 2019 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566829885;
        bh=S0V5XzeUw6fLtK+Xw7uttsjbYD3Xydm6LhgGRawrGX0=;
        h=From:To:Cc:Subject:Date:From;
        b=HdM+S1qfzWCubuHSz6qprslKCDToWduEWGAZnKuGrZAg3ma0tx7ElLj13ud7eZ+in
         btG6ByNvg67bwAvN/iGinplkOY5WKXOuTXcBA/5EJJ00R7BYBmLOsiaR/m8BlF8ZKb
         /b6XNqIcvqne7TeArj/U9ZqIUZx5dITtt0zKn9jQ=
From:   Sasha Levin <sashal@kernel.org>
To:     peterz@infradead.org, will@kernel.org, jstancek@redhat.com,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Waiman Long <longman@redhat.com>,
        dbueso@suse.de, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH v5.2 1/2] locking/rwsem: Add missing ACQUIRE to read_slowpath exit when queue is empty
Date:   Mon, 26 Aug 2019 10:31:13 -0400
Message-Id: <20190826143114.23471-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Stancek <jstancek@redhat.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

This is a backport for the v5.2 stable tree. There were multiple reports
of this issue being hit.

Given that there were a few changes to the code around this, I'd
appreciate an ack before pulling it in.

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

