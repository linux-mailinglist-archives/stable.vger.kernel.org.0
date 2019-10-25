Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA82E5316
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbfJYSHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:07:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47116 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731506AbfJYSFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:54 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xz-0008Ok-AV; Fri, 25 Oct 2019 19:05:39 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xw-0001l7-KJ; Fri, 25 Oct 2019 19:05:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Boqun Feng" <boqun.feng@gmail.com>, linux-crypto@vger.kernel.org,
        "Daniel Jordan" <daniel.m.jordan@oracle.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        "Andrea Parri" <andrea.parri@amarulasolutions.com>,
        linux-arch@vger.kernel.org
Date:   Fri, 25 Oct 2019 19:03:46 +0100
Message-ID: <lsq.1572026582.588282827@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 45/47] padata: use smp_mb in padata_reorder to avoid
 orphaned padata jobs
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit cf144f81a99d1a3928f90b0936accfd3f45c9a0a upstream.

Testing padata with the tcrypt module on a 5.2 kernel...

    # modprobe tcrypt alg="pcrypt(rfc4106(gcm(aes)))" type=3
    # modprobe tcrypt mode=211 sec=1

...produces this splat:

    INFO: task modprobe:10075 blocked for more than 120 seconds.
          Not tainted 5.2.0-base+ #16
    modprobe        D    0 10075  10064 0x80004080
    Call Trace:
     ? __schedule+0x4dd/0x610
     ? ring_buffer_unlock_commit+0x23/0x100
     schedule+0x6c/0x90
     schedule_timeout+0x3b/0x320
     ? trace_buffer_unlock_commit_regs+0x4f/0x1f0
     wait_for_common+0x160/0x1a0
     ? wake_up_q+0x80/0x80
     { crypto_wait_req }             # entries in braces added by hand
     { do_one_aead_op }
     { test_aead_jiffies }
     test_aead_speed.constprop.17+0x681/0xf30 [tcrypt]
     do_test+0x4053/0x6a2b [tcrypt]
     ? 0xffffffffa00f4000
     tcrypt_mod_init+0x50/0x1000 [tcrypt]
     ...

The second modprobe command never finishes because in padata_reorder,
CPU0's load of reorder_objects is executed before the unlocking store in
spin_unlock_bh(pd->lock), causing CPU0 to miss CPU1's increment:

CPU0                                 CPU1

padata_reorder                       padata_do_serial
  LOAD reorder_objects  // 0
                                       INC reorder_objects  // 1
                                       padata_reorder
                                         TRYLOCK pd->lock   // failed
  UNLOCK pd->lock

CPU0 deletes the timer before returning from padata_reorder and since no
other job is submitted to padata, modprobe waits indefinitely.

Add a pair of full barriers to guarantee proper ordering:

CPU0                                 CPU1

padata_reorder                       padata_do_serial
  UNLOCK pd->lock
  smp_mb()
  LOAD reorder_objects
                                       INC reorder_objects
                                       smp_mb__after_atomic()
                                       padata_reorder
                                         TRYLOCK pd->lock

smp_mb__after_atomic is needed so the read part of the trylock operation
comes after the INC, as Andrea points out.   Thanks also to Andrea for
help with writing a litmus test.

Fixes: 16295bec6398 ("padata: Generic parallelization/serialization interface")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-arch@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/padata.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -272,7 +272,12 @@ static void padata_reorder(struct parall
 	 * The next object that needs serialization might have arrived to
 	 * the reorder queues in the meantime, we will be called again
 	 * from the timer function if no one else cares for it.
+	 *
+	 * Ensure reorder_objects is read after pd->lock is dropped so we see
+	 * an increment from another task in padata_do_serial.  Pairs with
+	 * smp_mb__after_atomic in padata_do_serial.
 	 */
+	smp_mb();
 	if (atomic_read(&pd->reorder_objects)
 			&& !(pinst->flags & PADATA_RESET))
 		mod_timer(&pd->timer, jiffies + HZ);
@@ -341,6 +346,13 @@ void padata_do_serial(struct padata_priv
 	list_add_tail(&padata->list, &pqueue->reorder.list);
 	spin_unlock(&pqueue->reorder.lock);
 
+	/*
+	 * Ensure the atomic_inc of reorder_objects above is ordered correctly
+	 * with the trylock of pd->lock in padata_reorder.  Pairs with smp_mb
+	 * in padata_reorder.
+	 */
+	smp_mb__after_atomic();
+
 	put_cpu();
 
 	padata_reorder(pd);

