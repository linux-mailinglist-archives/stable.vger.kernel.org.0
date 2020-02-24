Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E81169B51
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 01:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgBXAoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 19:44:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgBXAoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 19:44:38 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C809C20880;
        Mon, 24 Feb 2020 00:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582505077;
        bh=4SX0x3+R2axy3XbXdYEFn9TU7Ul2zJ+quEgXLI6COFM=;
        h=Date:From:To:Subject:From;
        b=RnvxN7cttc7zXuGXxsLND+5lVV22R/lVGEK1r7/QhFEFppTrYy5r9l7xdP4sxFmnv
         FFEoRoZgfW+ab3kHJrCvdvzzCruDOEkEF2ljEj7TPDq7t0KHsRxdPa95y1AyVpPANu
         BBaPiaKzUL/JZGnoidG0OCrkZBIUtx0CHoG9nllg=
Date:   Sun, 23 Feb 2020 16:44:36 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, catalin.marinas@arm.com, dave@stgolabs.net,
        herton@redhat.com, ioanna-maria.alifieraki@canonical.com,
        jay.vosburgh@canonical.com, joel@joelfernandes.org,
        malat@debian.org, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 revert-ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem.patch
 removed from -mm tree
Message-ID: <20200224004436.p9bu0Gm7V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()"
has been removed from the -mm tree.  Its filename was
     revert-ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Subject: Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()"

This reverts commit a97955844807e327df11aa33869009d14d6b7de0.

Commit a97955844807 ("ipc,sem: remove uneeded sem_undo_list lock usage in
exit_sem()") removes a lock that is needed.  This leads to a process
looping infinitely in exit_sem() and can also lead to a crash.  There is a
reproducer available in [1] and with the commit reverted the issue does
not reproduce anymore.

Using the reproducer found in [1] is fairly easy to reach a point where
one of the child processes is looping infinitely in exit_sem between
for(;;) and if (semid == -1) block, while it's trying to free its last
sem_undo structure which has already been freed by freeary().

Each sem_undo struct is on two lists: one per semaphore set (list_id) and
one per process (list_proc).  The list_id list tracks undos by semaphore
set, and the list_proc by process.

Undo structures are removed either by freeary() or by exit_sem().  The
freeary function is invoked when the user invokes a syscall to remove a
semaphore set.  During this operation freeary() traverses the list_id
associated with the semaphore set and removes the undo structures from
both the list_id and list_proc lists.

For this case, exit_sem() is called at process exit.  Each process
contains a struct sem_undo_list (referred to as "ulp") which contains the
head for the list_proc list.  When the process exits, exit_sem() traverses
this list to remove each sem_undo struct.  As in freeary(), whenever a
sem_undo struct is removed from list_proc, it is also removed from the
list_id list.

Removing elements from list_id is safe for both exit_sem() and freeary()
due to sem_lock().  Removing elements from list_proc is not safe;
freeary() locks &un->ulp->lock when it performs
list_del_rcu(&un->list_proc) but exit_sem() does not (locking was removed
by commit a97955844807 ("ipc,sem: remove uneeded sem_undo_list lock usage
in exit_sem()").

This can result in the following situation while executing the reproducer
[1] : Consider a child process in exit_sem() and the parent in freeary()
(because of semctl(sid[i], NSEM, IPC_RMID)).  The list_proc for the child
contains the last two undo structs A and B (the rest have been removed
either by exit_sem() or freeary()).  The semid for A is 1 and semid for B
is 2.  exit_sem() removes A and at the same time freeary() removes B. 
Since A and B have different semid sem_lock() will acquire different locks
for each process and both can proceed.  The bug is that they remove A and
B from the same list_proc at the same time because only freeary() acquires
the ulp lock.  When exit_sem() removes A it makes ulp->list_proc.next to
point at B and at the same time freeary() removes B setting B->semid=-1. 
At the next iteration of for(;;) loop exit_sem() will try to remove B. 
The only way to break from for(;;) is for (&un->list_proc ==
&ulp->list_proc) to be true which is not.  Then exit_sem() will check if
B->semid=-1 which is and will continue looping in for(;;) until the memory
for B is reallocated and the value at B->semid is changed.  At that point,
exit_sem() will crash attempting to unlink B from the lists (this can be
easily triggered by running the reproducer [1] a second time).

To prove this scenario instrumentation was added to keep information about
each sem_undo (un) struct that is removed per process and per semaphore
set (sma).

        CPU0                                CPU1
[caller holds sem_lock(sma for A)]      ...
freeary()                               exit_sem()
...                                     ...
...                                     sem_lock(sma for B)
spin_lock(A->ulp->lock)                 ...
list_del_rcu(un_A->list_proc)           list_del_rcu(un_B->list_proc)

Undo structures A and B have different semid and sem_lock() operations
proceed.  However they belong to the same list_proc list and they are
removed at the same time.  This results into ulp->list_proc.next pointing
to the address of B which is already removed.

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
---

 ipc/sem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/ipc/sem.c~revert-ipcsem-remove-uneeded-sem_undo_list-lock-usage-in-exit_sem
+++ a/ipc/sem.c
@@ -2384,11 +2384,9 @@ void exit_sem(struct task_struct *tsk)
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
_

Patches currently in -mm which might be from ioanna-maria.alifieraki@canonical.com are


