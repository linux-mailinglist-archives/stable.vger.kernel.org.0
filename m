Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEAC318725
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 10:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhBKJbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 04:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhBKJ3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 04:29:00 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF6EC06178C
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 01:27:43 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m1so4930436wml.2
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 01:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mfHbazlOCX/UlXyuDmE+5dGDxJaOZ2y4lG5YFAFcBjU=;
        b=y8mTOVEkO/To5S7VtQcSqAXJCP374GI9JpGeBTUHMva/ovyzkwuK1s3bE9lNqkdSO5
         S5gbnCbsuQftPnedu528OJ/9MtkV+c3OVSlTP7Jv16Mv4TeZJ7RRieB0RhY01vV5Pm+z
         7BhW9Nz/yeIC+Lyj8crI04EsugQljn2sAaymCGqwFSjyhNORRrdXmx2NslpDW2t5lc1i
         MmmMAv9PhZLyGp6Pbo9xG06Oc9/9moaYiFRh02gH9mBx4tZZTrJQ75VdTo+OzjdkctK8
         xSto6sy8u+ZLdHV508c9pViOAg5lDLz3h1WmV/SYq9HOW0YWY+58yAUlQsc6xqm77LT2
         kvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mfHbazlOCX/UlXyuDmE+5dGDxJaOZ2y4lG5YFAFcBjU=;
        b=PfSKfHWVf9BfLYEIw+MfbXoNe9GEvffYLwQVMzMSjWddZcZRafHZOXsEpeOIbCC65D
         bYFw6y1cmM2Wzv91OlC9JOBSqChM8GJMdov5rjdoVIGo/J/ijzpxjlK31lScXEj4DA/g
         UK0C18TtthJ5G59JGfNTEKUvYifd4gO5hvafqsw5yGXec+h7bW7qFMQ4Qj2B4/dS8Y9U
         0lzfCCb6tRGKp49aPFTpg7oIjjyl4olMTViYrHOCNgNkvCgJbUgG2sftZtz1nO5ptjMz
         nuzNX88Bl5Q/MpefCpviZwq772xN3mUys4iFqDFWscc+Qr0nh5dFAJnNZT9QWryOsFVB
         J5Vw==
X-Gm-Message-State: AOAM530bACwZgxOwrZfLYyTbvkaeOnH4jeg2GVwjOsHD4ooupKxR+OGo
        GMfqmzte3WxTj4X3fpbLa4wpqDOe6tmutg==
X-Google-Smtp-Source: ABdhPJySFP7LamvCZSO2+cxwrH8ORlkScqfKuyh27H9nZYBBy/MWqpAkqNSQpU1lXGrOzDBcgRP4ZQ==
X-Received: by 2002:a7b:c942:: with SMTP id i2mr4300829wml.187.1613035662379;
        Thu, 11 Feb 2021 01:27:42 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id y5sm8335124wmi.10.2021.02.11.01.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 01:27:31 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     zhengyejian@foxmail.com, Thomas Gleixner <tglx@linutronix.de>,
        Stefan Liebler <stli@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Darren Hart <dvhart@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/3] futex: Cure exit race
Date:   Thu, 11 Feb 2021 09:27:00 +0000
Message-Id: <20210211092700.11772-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211092700.11772-1-lee.jones@linaro.org>
References: <20210211092700.11772-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit da791a667536bf8322042e38ca85d55a78d3c273 upstream.

Stefan reported, that the glibc tst-robustpi4 test case fails
occasionally. That case creates the following race between
sys_exit() and sys_futex_lock_pi():

 CPU0				CPU1

 sys_exit()			sys_futex()
  do_exit()			 futex_lock_pi()
   exit_signals(tsk)		  No waiters:
    tsk->flags |= PF_EXITING;	  *uaddr == 0x00000PID
  mm_release(tsk)		  Set waiter bit
   exit_robust_list(tsk) {	  *uaddr = 0x80000PID;
      Set owner died		  attach_to_pi_owner() {
    *uaddr = 0xC0000000;	   tsk = get_task(PID);
   }				   if (!tsk->flags & PF_EXITING) {
  ...				     attach();
  tsk->flags |= PF_EXITPIDONE;	   } else {
				     if (!(tsk->flags & PF_EXITPIDONE))
				       return -EAGAIN;
				     return -ESRCH; <--- FAIL
				   }

ESRCH is returned all the way to user space, which triggers the glibc test
case assert. Returning ESRCH unconditionally is wrong here because the user
space value has been changed by the exiting task to 0xC0000000, i.e. the
FUTEX_OWNER_DIED bit is set and the futex PID value has been cleared. This
is a valid state and the kernel has to handle it, i.e. taking the futex.

Cure it by rereading the user space value when PF_EXITING and PF_EXITPIDONE
is set in the task which 'owns' the futex. If the value has changed, let
the kernel retry the operation, which includes all regular sanity checks
and correctly handles the FUTEX_OWNER_DIED case.

If it hasn't changed, then return ESRCH as there is no way to distinguish
this case from malfunctioning user space. This happens when the exiting
task did not have a robust list, the robust list was corrupted or the user
space value in the futex was simply bogus.

Reported-by: Stefan Liebler <stli@linux.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=200467
Link: https://lkml.kernel.org/r/20181210152311.986181245@linutronix.de
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Lee: Required to satisfy functional dependency from futex back-port.
 Re-add the missing handle_exit_race() parts from:
 3d4775df0a89 ("futex: Replace PF_EXITPIDONE with a state")]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 71 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 65 insertions(+), 6 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 829e897c8883b..b65dbb5d60bb1 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1201,11 +1201,67 @@ static void wait_for_owner_exiting(int ret, struct task_struct *exiting)
 	put_task_struct(exiting);
 }
 
+static int handle_exit_race(u32 __user *uaddr, u32 uval,
+			    struct task_struct *tsk)
+{
+	u32 uval2;
+
+	/*
+	 * If the futex exit state is not yet FUTEX_STATE_DEAD, wait
+	 * for it to finish.
+	 */
+	if (tsk && tsk->futex_state != FUTEX_STATE_DEAD)
+		return -EAGAIN;
+
+	/*
+	 * Reread the user space value to handle the following situation:
+	 *
+	 * CPU0				CPU1
+	 *
+	 * sys_exit()			sys_futex()
+	 *  do_exit()			 futex_lock_pi()
+	 *                                futex_lock_pi_atomic()
+	 *   exit_signals(tsk)		    No waiters:
+	 *    tsk->flags |= PF_EXITING;	    *uaddr == 0x00000PID
+	 *  mm_release(tsk)		    Set waiter bit
+	 *   exit_robust_list(tsk) {	    *uaddr = 0x80000PID;
+	 *      Set owner died		    attach_to_pi_owner() {
+	 *    *uaddr = 0xC0000000;	     tsk = get_task(PID);
+	 *   }				     if (!tsk->flags & PF_EXITING) {
+	 *  ...				       attach();
+	 *  tsk->futex_state =               } else {
+	 *	FUTEX_STATE_DEAD;              if (tsk->futex_state !=
+	 *					  FUTEX_STATE_DEAD)
+	 *				         return -EAGAIN;
+	 *				       return -ESRCH; <--- FAIL
+	 *				     }
+	 *
+	 * Returning ESRCH unconditionally is wrong here because the
+	 * user space value has been changed by the exiting task.
+	 *
+	 * The same logic applies to the case where the exiting task is
+	 * already gone.
+	 */
+	if (get_futex_value_locked(&uval2, uaddr))
+		return -EFAULT;
+
+	/* If the user space value has changed, try again. */
+	if (uval2 != uval)
+		return -EAGAIN;
+
+	/*
+	 * The exiting task did not have a robust list, the robust list was
+	 * corrupted or the user space value in *uaddr is simply bogus.
+	 * Give up and tell user space.
+	 */
+	return -ESRCH;
+}
+
 /*
  * Lookup the task for the TID provided from user space and attach to
  * it after doing proper sanity checks.
  */
-static int attach_to_pi_owner(u32 uval, union futex_key *key,
+static int attach_to_pi_owner(u32 __user *uaddr, u32 uval, union futex_key *key,
 			      struct futex_pi_state **ps,
 			      struct task_struct **exiting)
 {
@@ -1216,12 +1272,15 @@ static int attach_to_pi_owner(u32 uval, union futex_key *key,
 	/*
 	 * We are the first waiter - try to look up the real owner and attach
 	 * the new pi_state to it, but bail out when TID = 0 [1]
+	 *
+	 * The !pid check is paranoid. None of the call sites should end up
+	 * with pid == 0, but better safe than sorry. Let the caller retry
 	 */
 	if (!pid)
-		return -ESRCH;
+		return -EAGAIN;
 	p = futex_find_get_task(pid);
 	if (!p)
-		return -ESRCH;
+		return handle_exit_race(uaddr, uval, NULL);
 
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		put_task_struct(p);
@@ -1240,7 +1299,7 @@ static int attach_to_pi_owner(u32 uval, union futex_key *key,
 		 * FUTEX_STATE_DEAD, we know that the task has finished
 		 * the cleanup:
 		 */
-		int ret = (p->futex_state = FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;
+		int ret = handle_exit_race(uaddr, uval, p);
 
 		raw_spin_unlock_irq(&p->pi_lock);
 		/*
@@ -1306,7 +1365,7 @@ static int lookup_pi_state(u32 __user *uaddr, u32 uval,
 	 * We are the first waiter - try to look up the owner based on
 	 * @uval and attach to it.
 	 */
-	return attach_to_pi_owner(uval, key, ps, exiting);
+	return attach_to_pi_owner(uaddr, uval, key, ps, exiting);
 }
 
 static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
@@ -1422,7 +1481,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 	 * attach to the owner. If that fails, no harm done, we only
 	 * set the FUTEX_WAITERS bit in the user space variable.
 	 */
-	return attach_to_pi_owner(uval, key, ps, exiting);
+	return attach_to_pi_owner(uaddr, newval, key, ps, exiting);
 }
 
 /**
-- 
2.25.1

