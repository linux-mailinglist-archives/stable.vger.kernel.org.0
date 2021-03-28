Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F02434BEF6
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhC1UnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:43:14 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37190 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhC1UnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:43:01 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcFQ-0001yN-4R; Sun, 28 Mar 2021 22:43:00 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcFO-003Gip-Q6; Sun, 28 Mar 2021 22:42:58 +0200
Date:   Sun, 28 Mar 2021 22:42:58 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 11/13] futex: Prevent robust futex exit race
Message-ID: <YGDqUkDvp7aAhzSQ@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FMcXBUZT+ktvsr9v"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FMcXBUZT+ktvsr9v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Yang Tao <yang.tao172@zte.com.cn>

commit ca16d5bee59807bf04deaab0a8eccecd5061528c upstream.

Robust futexes utilize the robust_list mechanism to allow the kernel to
release futexes which are held when a task exits. The exit can be voluntary
or caused by a signal or fault. This prevents that waiters block forever.

The futex operations in user space store a pointer to the futex they are
either locking or unlocking in the op_pending member of the per task robust
list.

After a lock operation has succeeded the futex is queued in the robust list
linked list and the op_pending pointer is cleared.

After an unlock operation has succeeded the futex is removed from the
robust list linked list and the op_pending pointer is cleared.

The robust list exit code checks for the pending operation and any futex
which is queued in the linked list. It carefully checks whether the futex
value is the TID of the exiting task. If so, it sets the OWNER_DIED bit and
tries to wake up a potential waiter.

This is race free for the lock operation but unlock has two race scenarios
where waiters might not be woken up. These issues can be observed with
regular robust pthread mutexes. PI aware pthread mutexes are not affected.

(1) Unlocking task is killed after unlocking the futex value in user space
    before being able to wake a waiter.

        pthread_mutex_unlock()
                |
                V
        atomic_exchange_rel (&mutex->__data.__lock, 0)
                        <------------------------killed
            lll_futex_wake ()                   |
                                                |
                                                |(__lock =3D 0)
                                                |(enter kernel)
                                                |
                                                V
                                            do_exit()
                                            exit_mm()
                                          mm_release()
                                        exit_robust_list()
                                        handle_futex_death()
                                                |
                                                |(__lock =3D 0)
                                                |(uval =3D 0)
                                                |
                                                V
        if ((uval & FUTEX_TID_MASK) !=3D task_pid_vnr(curr))
                return 0;

    The sanity check which ensures that the user space futex is owned by
    the exiting task prevents the wakeup of waiters which in consequence
    block infinitely.

(2) Waiting task is killed after a wakeup and before it can acquire the
    futex in user space.

        OWNER                         WAITER
				futex_wait()
   pthread_mutex_unlock()               |
                |                       |
                |(__lock =3D 0)           |
                |                       |
                V                       |
         futex_wake() ------------>  wakeup()
                                        |
                                        |(return to userspace)
                                        |(__lock =3D 0)
                                        |
                                        V
                        oldval =3D mutex->__data.__lock
                                          <-----------------killed
    atomic_compare_and_exchange_val_acq (&mutex->__data.__lock,  |
                        id | assume_other_futex_waiters, 0)      |
                                                                 |
                                                                 |
                                                   (enter kernel)|
                                                                 |
                                                                 V
                                                         do_exit()
                                                        |
                                                        |
                                                        V
                                        handle_futex_death()
                                        |
                                        |(__lock =3D 0)
                                        |(uval =3D 0)
                                        |
                                        V
        if ((uval & FUTEX_TID_MASK) !=3D task_pid_vnr(curr))
                return 0;

    The sanity check which ensures that the user space futex is owned
    by the exiting task prevents the wakeup of waiters, which seems to
    be correct as the exiting task does not own the futex value, but
    the consequence is that other waiters wont be woken up and block
    infinitely.

In both scenarios the following conditions are true:

   - task->robust_list->list_op_pending !=3D NULL
   - user space futex value =3D=3D 0
   - Regular futex (not PI)

If these conditions are met then it is reasonably safe to wake up a
potential waiter in order to prevent the above problems.

As this might be a false positive it can cause spurious wakeups, but the
waiter side has to handle other types of unrelated wakeups, e.g. signals
gracefully anyway. So such a spurious wakeup will not affect the
correctness of these operations.

This workaround must not touch the user space futex value and cannot set
the OWNER_DIED bit because the lock value is 0, i.e. uncontended. Setting
OWNER_DIED in this case would result in inconsistent state and subsequently
in malfunction of the owner died handling in user space.

The rest of the user space state is still consistent as no other task can
observe the list_op_pending entry in the exiting tasks robust list.

The eventually woken up waiter will observe the uncontended lock value and
take it over.

[ tglx: Massaged changelog and comment. Made the return explicit and not
  	depend on the subsequent check and added constants to hand into
  	handle_futex_death() instead of plain numbers. Fixed a few coding
	style issues. ]

Fixes: 0771dfefc9e5 ("[PATCH] lightweight robust futexes: core")
Signed-off-by: Yang Tao <yang.tao172@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1573010582-35297-1-git-send-email-wang.yi59=
@zte.com.cn
Link: https://lkml.kernel.org/r/20191106224555.943191378@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 58 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c3c7f5494bfd..c55bf3511203 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3526,11 +3526,16 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 	return ret;
 }
=20
+/* Constants for the pending_op argument of handle_futex_death */
+#define HANDLE_DEATH_PENDING	true
+#define HANDLE_DEATH_LIST	false
+
 /*
  * Process a futex-list entry, check whether it's owned by the
  * dying task, and do notification if so:
  */
-static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,=
 int pi)
+static int handle_futex_death(u32 __user *uaddr, struct task_struct *curr,
+			      bool pi, bool pending_op)
 {
 	u32 uval, uninitialized_var(nval), mval;
 	int err;
@@ -3543,6 +3548,42 @@ static int handle_futex_death(u32 __user *uaddr, str=
uct task_struct *curr, int p
 	if (get_user(uval, uaddr))
 		return -1;
=20
+	/*
+	 * Special case for regular (non PI) futexes. The unlock path in
+	 * user space has two race scenarios:
+	 *
+	 * 1. The unlock path releases the user space futex value and
+	 *    before it can execute the futex() syscall to wake up
+	 *    waiters it is killed.
+	 *
+	 * 2. A woken up waiter is killed before it can acquire the
+	 *    futex in user space.
+	 *
+	 * In both cases the TID validation below prevents a wakeup of
+	 * potential waiters which can cause these waiters to block
+	 * forever.
+	 *
+	 * In both cases the following conditions are met:
+	 *
+	 *	1) task->robust_list->list_op_pending !=3D NULL
+	 *	   @pending_op =3D=3D true
+	 *	2) User space futex value =3D=3D 0
+	 *	3) Regular futex: @pi =3D=3D false
+	 *
+	 * If these conditions are met, it is safe to attempt waking up a
+	 * potential waiter without touching the user space futex value and
+	 * trying to set the OWNER_DIED bit. The user space futex value is
+	 * uncontended and the rest of the user space mutex state is
+	 * consistent, so a woken waiter will just take over the
+	 * uncontended futex. Setting the OWNER_DIED bit would create
+	 * inconsistent state and malfunction of the user space owner died
+	 * handling.
+	 */
+	if (pending_op && !pi && !uval) {
+		futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
+		return 0;
+	}
+
 	if ((uval & FUTEX_TID_MASK) !=3D task_pid_vnr(curr))
 		return 0;
=20
@@ -3662,10 +3703,11 @@ static void exit_robust_list(struct task_struct *cu=
rr)
 		 * A pending lock might already be on the list, so
 		 * don't process it twice:
 		 */
-		if (entry !=3D pending)
+		if (entry !=3D pending) {
 			if (handle_futex_death((void __user *)entry + futex_offset,
-						curr, pi))
+						curr, pi, HANDLE_DEATH_LIST))
 				return;
+		}
 		if (rc)
 			return;
 		entry =3D next_entry;
@@ -3679,9 +3721,10 @@ static void exit_robust_list(struct task_struct *cur=
r)
 		cond_resched();
 	}
=20
-	if (pending)
+	if (pending) {
 		handle_futex_death((void __user *)pending + futex_offset,
-				   curr, pip);
+				   curr, pip, HANDLE_DEATH_PENDING);
+	}
 }
=20
 static void futex_cleanup(struct task_struct *tsk)
@@ -3964,7 +4007,8 @@ void compat_exit_robust_list(struct task_struct *curr)
 		if (entry !=3D pending) {
 			void __user *uaddr =3D futex_uaddr(entry, futex_offset);
=20
-			if (handle_futex_death(uaddr, curr, pi))
+			if (handle_futex_death(uaddr, curr, pi,
+					       HANDLE_DEATH_LIST))
 				return;
 		}
 		if (rc)
@@ -3983,7 +4027,7 @@ void compat_exit_robust_list(struct task_struct *curr)
 	if (pending) {
 		void __user *uaddr =3D futex_uaddr(pending, futex_offset);
=20
-		handle_futex_death(uaddr, curr, pip);
+		handle_futex_death(uaddr, curr, pip, HANDLE_DEATH_PENDING);
 	}
 }
=20


--FMcXBUZT+ktvsr9v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6lIACgkQ57/I7JWG
EQky/BAArp3eKgrxIFG6xLs10x3ZnWlXFgc1ElHvRQg+TJ3C5lZyhdAR6t+7/Et/
q2SSd1Nr80iIHADbjli+ipr6mEiYIZS1l5yZ06wi0wkZCKjCHkM7C1r2hWW87eaU
M+ylpoyHi/hBwKCvUOYVG2xD6W7MIMFooAblPqJ0WQu0gWbQnjuJaGaSVJI00LM1
d91nlkhwXms/dIkU3M2E3ctoc3fHof1hnDT2OvgM7LC1FEk4ImeK5D2lvWBQRZ60
qwLbu0m1EynJ38tDY6BYvsUilazFdFIQnb9/LTjUAxmSlifmIGqn/Qu6s0FtJXok
fvYJt0OS/4vSi9bF5D9I1b8s0A9k5lXaoovQvNuSfJ2v4iuXXuWJ6jdUAeEV1sSO
sp02i/R5yp85qxWJnc022/C8uAxErwU/YDaHj5UElmNUou/qCsVlMRRxcSPF2GYa
9Wcgq43XB9ERoTAtQoIHy1n777Yvm5lepajwMxsWA7RYZW4mYpwyZZluEphN9DKA
d1H4lEQogIykytXUZjbQuXq2jVfu238cMH+3KKnNYDvHboAdJBcxOSef3WW7ZOR8
mLfB8EQnvPvhEq//w1ijI0ajvYmw1/EcnfdT9s29yqtCjp78vEVTapwLMIR7hIZ8
KfRotf3bzR9st/AFdF8IH+jUNqj+t2+g9PtjgbBhYh5JRBIM+AE=
=OOal
-----END PGP SIGNATURE-----

--FMcXBUZT+ktvsr9v--
