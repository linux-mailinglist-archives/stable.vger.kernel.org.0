Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989D931871F
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 10:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhBKJaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 04:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhBKJ2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 04:28:07 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338FBC06178A
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 01:27:27 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o24so4923979wmh.5
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 01:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zT+iHjphKsz597MUGj9bT/k1CO7ELZX3vL6R9H/hLig=;
        b=oKugZmpmDl9cZwSHBc8RVeKi3ctio/G8zbXcQ4lticc87CjidNgPGN8QvGRNCcvAh1
         D3p+kTfKYjbcN0W8ps1pAHIWVUikHI3/WLZbUUBfjGl+AwGNjQT6LqlXhPCEHpP8O3lK
         JeMdNrClt9lKbTmvbgBNhb4wgb7XzjAd8Y4aG+qhhjj6KNZjpcCRbfBArGM1IUW2m40y
         hFYYWYgRi0gYf2KgZST7rDVeefHr4Atc0JAZIghXjlCg3cl+phSekj9A6UTwihiA3lb1
         1cJFVn7829RPzDT4ESBcJJQBCUxsy32dGJ5/5hI/1vW3zqs3uJPKwj+x8QmYkMdudhKV
         sEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zT+iHjphKsz597MUGj9bT/k1CO7ELZX3vL6R9H/hLig=;
        b=RNlgakDFvpvM93FCP1GKTf8XUtIPry9t7jB7NUJIfJgdSl6zSgC1g7LhpuMhDjH0ND
         tyFg1D6YI9Vtqjsqx6ZB1FQKsCwoflhIgLVXP8BgRgFsZ3YOMgXgWl6SNS7YRqhPxgFy
         7PYs8qbZnJsRKyMLA1aG6cigvKPBZVXE20qOKHxbfuwN3EzhIccVW/wSvxUEM90VH2ud
         jtR700YEpcXvbSQ6EEfQMmU+4Jl8Vu6XCS0NO9GJx8PfvDt1KKO3hN9vHWF/fAupq+ZM
         aEyTI95CDt87mEUFtGk8OAJbyqlWdoXaPMB+yvhXSgprnGXtndfsNlGTLHmLbZ3u/rNj
         VaFg==
X-Gm-Message-State: AOAM532wmJ4gspctqiMpkIgAScrzefDIZbwt2NdbynMslPp/ADwBNvVB
        jKnZJpQLcpnFkE/CmC9sdeDW3/cbyyOwXA==
X-Google-Smtp-Source: ABdhPJwtfTu/wmETYHu3sFdV9lKg0z30mJSH6c3wFq91M2T+fjyp2h3pFf6TWrMNCg8xsQ3g9trqFQ==
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr4279066wmg.12.1613035645562;
        Thu, 11 Feb 2021 01:27:25 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id y5sm8335124wmi.10.2021.02.11.01.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 01:27:14 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     zhengyejian@foxmail.com, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/3] futex: Ensure the correct return value from futex_lock_pi()
Date:   Thu, 11 Feb 2021 09:26:58 +0000
Message-Id: <20210211092700.11772-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211092700.11772-1-lee.jones@linaro.org>
References: <20210211092700.11772-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 12bb3f7f1b03d5913b3f9d4236a488aa7774dfe9 upstream

In case that futex_lock_pi() was aborted by a signal or a timeout and the
task returned without acquiring the rtmutex, but is the designated owner of
the futex due to a concurrent futex_unlock_pi() fixup_owner() is invoked to
establish consistent state. In that case it invokes fixup_pi_state_owner()
which in turn tries to acquire the rtmutex again. If that succeeds then it
does not propagate this success to fixup_owner() and futex_lock_pi()
returns -EINTR or -ETIMEOUT despite having the futex locked.

Return success from fixup_pi_state_owner() in all cases where the current
task owns the rtmutex and therefore the futex and propagate it correctly
through fixup_owner(). Fixup the other callsite which does not expect a
positive return value.

Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Lee: Back-ported in support of a previous futex attempt]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 83db5787c67ef..a43cf67c2fe91 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2322,7 +2322,7 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 		}
 
 		if (__rt_mutex_futex_trylock(&pi_state->pi_mutex)) {
-			/* We got the lock after all, nothing to fix. */
+			/* We got the lock. pi_state is correct. Tell caller. */
 			return 1;
 		}
 
@@ -2364,7 +2364,7 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	 */
 	pi_state_update_owner(pi_state, newowner);
 
-	return 0;
+	return argowner == current;
 
 	/*
 	 * To handle the page fault we need to drop the hash bucket
@@ -2447,8 +2447,6 @@ static long futex_wait_restart(struct restart_block *restart);
  */
 static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 {
-	int ret = 0;
-
 	if (locked) {
 		/*
 		 * Got the lock. We might not be the anticipated owner if we
@@ -2459,8 +2457,8 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 		 * stable state, anything else needs more attention.
 		 */
 		if (q->pi_state->owner != current)
-			ret = fixup_pi_state_owner(uaddr, q, current);
-		goto out;
+			return fixup_pi_state_owner(uaddr, q, current);
+		return 1;
 	}
 
 	/*
@@ -2471,10 +2469,8 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 	 * Another speculative read; pi_state->owner == current is unstable
 	 * but needs our attention.
 	 */
-	if (q->pi_state->owner == current) {
-		ret = fixup_pi_state_owner(uaddr, q, NULL);
-		goto out;
-	}
+	if (q->pi_state->owner == current)
+		return fixup_pi_state_owner(uaddr, q, NULL);
 
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
@@ -2483,8 +2479,7 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 	if (WARN_ON_ONCE(rt_mutex_owner(&q->pi_state->pi_mutex) == current))
 		return fixup_pi_state_owner(uaddr, q, current);
 
-out:
-	return ret ? ret : locked;
+	return 0;
 }
 
 /**
@@ -3106,6 +3101,11 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 			 */
 			put_pi_state(q.pi_state);
 			spin_unlock(q.lock_ptr);
+			/*
+			 * Adjust the return value. It's either -EFAULT or
+			 * success (1) but the caller expects 0 for success.
+			 */
+			ret = ret < 0 ? ret : 0;
 		}
 	} else {
 		struct rt_mutex *pi_mutex;
-- 
2.25.1

