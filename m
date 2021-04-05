Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4448735404D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbhDEJRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240776AbhDEJQ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 771E4611C1;
        Mon,  5 Apr 2021 09:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614213;
        bh=I8DTmaBacYcNpmF2i7l+wFyI9X1qJ9nJlMup7acN7hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6SmoQrGVofd2EOXUxI4SEUhd8uXjoWNSEwXabwE3qSP/7wDx1/4/zmjpfEDSxZvS
         Xs7J0UWb0AiWXkOOm/4sisXtYBX0RfJUkKeeBFc7b59OwmW8vfRSSWXdZaBDKcqlKl
         aPkFRUOoptLDHitzcCBmw2rTuvnHf1eBKbekFYkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 125/152] powerpc/pseries/mobility: handle premature return from H_JOIN
Date:   Mon,  5 Apr 2021 10:54:34 +0200
Message-Id: <20210405085038.294163417@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 274cb1ca2e7ce02cab56f5f4c61a74aeb566f931 ]

The pseries join/suspend sequence in its current form was written with
the assumption that it was the only user of H_PROD and that it needn't
handle spurious successful returns from H_JOIN. That's wrong;
powerpc's paravirt spinlock code uses H_PROD, and CPUs entering
do_join() can be woken prematurely from H_JOIN with a status of
H_SUCCESS as a result. This causes all CPUs to exit the sequence
early, preventing suspend from occurring at all.

Add a 'done' boolean flag to the pseries_suspend_info struct, and have
the waking thread set it before waking the other threads. Threads
which receive H_SUCCESS from H_JOIN retry if the 'done' flag is still
unset.

Fixes: 9327dc0aeef3 ("powerpc/pseries/mobility: use stop_machine for join/suspend")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210315080045.460331-3-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/mobility.c | 26 ++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index a6739ce9feac..e83e0891272d 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -458,9 +458,12 @@ static int do_suspend(void)
  *           or if an error is received from H_JOIN. The thread which performs
  *           the first increment (i.e. sets it to 1) is responsible for
  *           waking the other threads.
+ * @done: False if join/suspend is in progress. True if the operation is
+ *        complete (successful or not).
  */
 struct pseries_suspend_info {
 	atomic_t counter;
+	bool done;
 };
 
 static int do_join(void *arg)
@@ -470,6 +473,7 @@ static int do_join(void *arg)
 	long hvrc;
 	int ret;
 
+retry:
 	/* Must ensure MSR.EE off for H_JOIN. */
 	hard_irq_disable();
 	hvrc = plpar_hcall_norets(H_JOIN);
@@ -485,8 +489,20 @@ static int do_join(void *arg)
 	case H_SUCCESS:
 		/*
 		 * The suspend is complete and this cpu has received a
-		 * prod.
+		 * prod, or we've received a stray prod from unrelated
+		 * code (e.g. paravirt spinlocks) and we need to join
+		 * again.
+		 *
+		 * This barrier orders the return from H_JOIN above vs
+		 * the load of info->done. It pairs with the barrier
+		 * in the wakeup/prod path below.
 		 */
+		smp_mb();
+		if (READ_ONCE(info->done) == false) {
+			pr_info_ratelimited("premature return from H_JOIN on CPU %i, retrying",
+					    smp_processor_id());
+			goto retry;
+		}
 		ret = 0;
 		break;
 	case H_BAD_MODE:
@@ -500,6 +516,13 @@ static int do_join(void *arg)
 
 	if (atomic_inc_return(counter) == 1) {
 		pr_info("CPU %u waking all threads\n", smp_processor_id());
+		WRITE_ONCE(info->done, true);
+		/*
+		 * This barrier orders the store to info->done vs subsequent
+		 * H_PRODs to wake the other CPUs. It pairs with the barrier
+		 * in the H_SUCCESS case above.
+		 */
+		smp_mb();
 		prod_others();
 	}
 	/*
@@ -553,6 +576,7 @@ static int pseries_suspend(u64 handle)
 
 		info = (struct pseries_suspend_info) {
 			.counter = ATOMIC_INIT(0),
+			.done = false,
 		};
 
 		ret = stop_machine(do_join, &info, cpu_online_mask);
-- 
2.30.2



