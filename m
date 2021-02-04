Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683D230FA05
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhBDRnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238586AbhBDRbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:31:15 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEFFC0617AA
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:19 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c12so4466684wrc.7
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kpLUGBUL3ePc9LcRSMK136epmeMCkjKyot5g5+ExSZs=;
        b=lrkDfKrmqKhCtD/jgvCllWo5ju50m/wkQJTuvx7E0r9oQ6VMUclDsay9h080wssrrX
         CBmHhQyOiLZlowk/io5iyiBY5KK1VsIDm53Mrq0QvlydCrC6sQW/uhEIT0PltlQ6W+iL
         tozxel+p89Lo6FQ11NuWWTqFJ9k/rSQy5i9S0vixQQwE7M+yS17hKgJwC01LZteMFVJ2
         yELnfvwNpwxmwmvMvMRFIoRTAhgXSV1srXz/EjC098m7FFrSWt7Q4CQXBde5R/uhsrz1
         rxK1MZwNPUhKyWe6MtUsJIDReMLNZRBeRXb91Kqum2LaGJJFJ5fY0okjnprC7vygahs6
         gWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kpLUGBUL3ePc9LcRSMK136epmeMCkjKyot5g5+ExSZs=;
        b=qw+koHEQvOJ/5/N7d/6W37USPGKXj3fwwcxKuTk21wror6/App5LHF46JSiD4rewk2
         +kKulR7J3gl0w5GIY+OWsVbHmBPi17oTVnRdzDql93GPkngR9OwXhDbl0/5Kl4mNN+42
         UTvHYxjTE9jntKAT1lYyntzIv8yORLY84lRHSScsImbiNVPN4nZkn9AwwXdLGQOFf3eA
         8oS/TbQD4hIEaDtJHfrIr1aRG7MvjhTq+pQL6CtFO2jFfxA1ZUHLuTw9xm2wLScKY96e
         8e8j4bISRkgc9SBaYDgmnauup2HEy4xK8EkQ+PFY+StPiTa0+JmH62uZe8DdMSolOITu
         m1zg==
X-Gm-Message-State: AOAM5302FJX6HVPXAgFpVm/0otPjqQgnWLilfRkDIUhlzAMmGzIDnhlX
        ifF0Tjylhh8J0+vvlzm23OC8d/QBrVdeBA==
X-Google-Smtp-Source: ABdhPJyPAdW2Z1+uye1ZxnbU4g4Pa7RoPzR6N3wnR5VxNAVOS7Iiy9ggVJhQd95fOv41cHff/Xq8Vw==
X-Received: by 2002:adf:e50e:: with SMTP id j14mr488496wrm.162.1612459758389;
        Thu, 04 Feb 2021 09:29:18 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:17 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/10] futex: Simplify fixup_pi_state_owner()
Date:   Thu,  4 Feb 2021 17:29:02 +0000
Message-Id: <20210204172903.2860981-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit f2dac39d93987f7de1e20b3988c8685523247ae2 ]

Too many gotos already and an upcoming fix would make it even more
unreadable.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index d9bec8eb60969..8300870666638 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2237,18 +2237,16 @@ static void unqueue_me_pi(struct futex_q *q)
 	spin_unlock(q->lock_ptr);
 }
 
-static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
-				struct task_struct *argowner)
+static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
+				  struct task_struct *argowner)
 {
 	struct futex_pi_state *pi_state = q->pi_state;
-	u32 uval, uninitialized_var(curval), newval;
 	struct task_struct *oldowner, *newowner;
-	u32 newtid;
-	int ret;
-
-	lockdep_assert_held(q->lock_ptr);
+	u32 uval, curval, newval, newtid;
+	int err = 0;
 
 	oldowner = pi_state->owner;
+
 	/* Owner died? */
 	if (!pi_state->owner)
 		newtid |= FUTEX_OWNER_DIED;
@@ -2289,7 +2287,7 @@ retry:
 
 		if (__rt_mutex_futex_trylock(&pi_state->pi_mutex)) {
 			/* We got the lock after all, nothing to fix. */
-			return 0;
+			return 1;
 		}
 
 		/*
@@ -2304,7 +2302,7 @@ retry:
 			 * We raced against a concurrent self; things are
 			 * already fixed up. Nothing to do.
 			 */
-			return 0;
+			return 1;
 		}
 		newowner = argowner;
 	}
@@ -2345,7 +2343,7 @@ retry:
 handle_fault:
 	spin_unlock(q->lock_ptr);
 
-	ret = fault_in_user_writeable(uaddr);
+	err = fault_in_user_writeable(uaddr);
 
 	spin_lock(q->lock_ptr);
 
@@ -2353,12 +2351,27 @@ handle_fault:
 	 * Check if someone else fixed it for us:
 	 */
 	if (pi_state->owner != oldowner)
-		return 0;
+		return argowner == current;
 
-	if (ret)
-		return ret;
+	/* Retry if err was -EAGAIN or the fault in succeeded */
+	if (!err)
+		goto retry;
 
-	goto retry;
+	return err;
+}
+
+static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
+				struct task_struct *argowner)
+{
+	struct futex_pi_state *pi_state = q->pi_state;
+	int ret;
+
+	lockdep_assert_held(q->lock_ptr);
+
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+	ret = __fixup_pi_state_owner(uaddr, q, argowner);
+	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+	return ret;
 }
 
 static long futex_wait_restart(struct restart_block *restart);
-- 
2.25.1

