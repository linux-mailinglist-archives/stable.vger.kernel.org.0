Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08017171BA7
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbgB0OEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387567AbgB0OEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBD2020801;
        Thu, 27 Feb 2020 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812258;
        bh=ep/R6/bCPKBeHBroTETaokEleV9E49zDrDWvWc6h8Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A61KqJJdQDJTLFX6ffzgLw3BdQCyCcY9uIO3l6JcaM8Zcio9HyE4sE349asOHWwr+
         uAE3Kw2A8Sj8r39VIOZ3RDVRtjPpy8uC60n7mkimAHt1GTcad2giP8B+WaVumqW1Xj
         C5edlkb8BtC3jEH18D9oQWcmc4xI32AEzSMxUBxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        "Herton R. Krzesinski" <herton@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>, malat@debian.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 45/97] Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()"
Date:   Thu, 27 Feb 2020 14:36:53 +0100
Message-Id: <20200227132221.919471596@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>

commit edf28f4061afe4c2d9eb1c3323d90e882c1d6800 upstream.

This reverts commit a97955844807e327df11aa33869009d14d6b7de0.

Commit a97955844807 ("ipc,sem: remove uneeded sem_undo_list lock usage
in exit_sem()") removes a lock that is needed.  This leads to a process
looping infinitely in exit_sem() and can also lead to a crash.  There is
a reproducer available in [1] and with the commit reverted the issue
does not reproduce anymore.

Using the reproducer found in [1] is fairly easy to reach a point where
one of the child processes is looping infinitely in exit_sem between
for(;;) and if (semid == -1) block, while it's trying to free its last
sem_undo structure which has already been freed by freeary().

Each sem_undo struct is on two lists: one per semaphore set (list_id)
and one per process (list_proc).  The list_id list tracks undos by
semaphore set, and the list_proc by process.

Undo structures are removed either by freeary() or by exit_sem().  The
freeary function is invoked when the user invokes a syscall to remove a
semaphore set.  During this operation freeary() traverses the list_id
associated with the semaphore set and removes the undo structures from
both the list_id and list_proc lists.

For this case, exit_sem() is called at process exit.  Each process
contains a struct sem_undo_list (referred to as "ulp") which contains
the head for the list_proc list.  When the process exits, exit_sem()
traverses this list to remove each sem_undo struct.  As in freeary(),
whenever a sem_undo struct is removed from list_proc, it is also removed
from the list_id list.

Removing elements from list_id is safe for both exit_sem() and freeary()
due to sem_lock().  Removing elements from list_proc is not safe;
freeary() locks &un->ulp->lock when it performs
list_del_rcu(&un->list_proc) but exit_sem() does not (locking was
removed by commit a97955844807 ("ipc,sem: remove uneeded sem_undo_list
lock usage in exit_sem()").

This can result in the following situation while executing the
reproducer [1] : Consider a child process in exit_sem() and the parent
in freeary() (because of semctl(sid[i], NSEM, IPC_RMID)).

 - The list_proc for the child contains the last two undo structs A and
   B (the rest have been removed either by exit_sem() or freeary()).

 - The semid for A is 1 and semid for B is 2.

 - exit_sem() removes A and at the same time freeary() removes B.

 - Since A and B have different semid sem_lock() will acquire different
   locks for each process and both can proceed.

The bug is that they remove A and B from the same list_proc at the same
time because only freeary() acquires the ulp lock. When exit_sem()
removes A it makes ulp->list_proc.next to point at B and at the same
time freeary() removes B setting B->semid=-1.

At the next iteration of for(;;) loop exit_sem() will try to remove B.

The only way to break from for(;;) is for (&un->list_proc ==
&ulp->list_proc) to be true which is not. Then exit_sem() will check if
B->semid=-1 which is and will continue looping in for(;;) until the
memory for B is reallocated and the value at B->semid is changed.

At that point, exit_sem() will crash attempting to unlink B from the
lists (this can be easily triggered by running the reproducer [1] a
second time).

To prove this scenario instrumentation was added to keep information
about each sem_undo (un) struct that is removed per process and per
semaphore set (sma).

          CPU0                                CPU1
  [caller holds sem_lock(sma for A)]      ...
  freeary()                               exit_sem()
  ...                                     ...
  ...                                     sem_lock(sma for B)
  spin_lock(A->ulp->lock)                 ...
  list_del_rcu(un_A->list_proc)           list_del_rcu(un_B->list_proc)

Undo structures A and B have different semid and sem_lock() operations
proceed.  However they belong to the same list_proc list and they are
removed at the same time.  This results into ulp->list_proc.next
pointing to the address of B which is already removed.

After reverting commit a97955844807 ("ipc,sem: remove uneeded
sem_undo_list lock usage in exit_sem()") the issue was no longer
reproducible.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1694779

Link: http://lkml.kernel.org/r/20191211191318.11860-1-ioanna-maria.alifieraki@canonical.com
Fixes: a97955844807 ("ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()")
Signed-off-by: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Herton R. Krzesinski <herton@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: <malat@debian.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/sem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2345,11 +2345,9 @@ void exit_sem(struct task_struct *tsk)
 		ipc_assert_locked_object(&sma->sem_perm);
 		list_del(&un->list_id);
 
-		/* we are the last process using this ulp, acquiring ulp->lock
-		 * isn't required. Besides that, we are also protected against
-		 * IPC_RMID as we hold sma->sem_perm lock now
-		 */
+		spin_lock(&ulp->lock);
 		list_del_rcu(&un->list_proc);
+		spin_unlock(&ulp->lock);
 
 		/* perform adjustments registered in un */
 		for (i = 0; i < sma->sem_nsems; i++) {


