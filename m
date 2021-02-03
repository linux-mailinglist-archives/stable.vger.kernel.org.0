Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B01F30DBAC
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhBCNrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbhBCNrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:47:21 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD490C061797
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:45:58 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id l12so4506554wmq.2
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SH5Nj25x7+v0gQvzlOdJud0ErPOJ5XP3gEjc5bfgYKY=;
        b=XfT445G4wZ4PKUnsgeT4VrLtHzCml1M0Oj6q+Hn/HN1tEDGfkWHIIPD0WvgsvcVOfp
         +pBW47XxIPkCRm/di75xUdPTOj/yGLjKCrcqLhYTBSaxqgTkpSOkNkctl/zE2gWhsHIH
         80j9GQXlDSkOLtPt+Hl6uFrtnCDgsvjFBMDWLgncFPnBv7ciIu7fBdO1CXeAHDKoQ3/g
         zT89cFJjdtZikZ8g8MiOsJF/mqSq/JwZBeWw5EXoz3OiTylhVIi/HS6xV/hg9H1IAIlC
         xqVXwoh3ngTPuFMqIl8Uhs/TCtuiiTazF6GhjqW7mA8XIQFoiLinLwmEmfn+1Hz9OLeb
         Di3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SH5Nj25x7+v0gQvzlOdJud0ErPOJ5XP3gEjc5bfgYKY=;
        b=LPDugSbxsEASrNrmav5GuHy9JcOH++AdkGqsV26JhJLYfZYsdnHgJ9mLtvGk+c6e3O
         gDNfaSK8/VqBMQsfvDV6cM95gJCKgUe4yEIapqyuZud0Fnt9nPWAWBLPcPTgMTdBBi2a
         Is9jN4bL0ZcE6LrXru6q7Vfxno3mB7cDOK61UWoYzSfUIGvFpe5ZNMpqlMzjVxm9e83A
         oHKcYIreeF94ruplTyQ6/SdZNOyPK2+niKdZCvSiQL90D2f2ZgDmdtayQRZSrcCnFhq3
         l+O7ymqv5crMNozUk4ZDWvDP5rQmycyC24YG3BUIU48GzwEaqndJL4JhUPVm9kuUyzvi
         LYNw==
X-Gm-Message-State: AOAM530bikAtwDhL9HOSeS3UuEs9slA5IBxMw+GGmFk4+9/but6RILRf
        WjO32g1ZiQJBvEMM5lR+WrERsj5A81JKHA==
X-Google-Smtp-Source: ABdhPJw7fL9kGMGN/1+TuqA9IK/4IQIl6fz4O4NqP+n1zIeh2vnIJaogHVdN/cYPuX2C4+1EUzVODQ==
X-Received: by 2002:a1c:21c6:: with SMTP id h189mr2774643wmh.173.1612359957109;
        Wed, 03 Feb 2021 05:45:57 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id r124sm2867900wmr.16.2021.02.03.05.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:45:56 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/10] futex: Simplify fixup_pi_state_owner()
Date:   Wed,  3 Feb 2021 13:45:38 +0000
Message-Id: <20210203134539.2583943-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203134539.2583943-1-lee.jones@linaro.org>
References: <20210203134539.2583943-1-lee.jones@linaro.org>
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
index be5e3e927bffa..c163f5d6efab3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2272,18 +2272,16 @@ static void unqueue_me_pi(struct futex_q *q)
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
@@ -2324,7 +2322,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 
 		if (__rt_mutex_futex_trylock(&pi_state->pi_mutex)) {
 			/* We got the lock after all, nothing to fix. */
-			return 0;
+			return 1;
 		}
 
 		/*
@@ -2339,7 +2337,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 			 * We raced against a concurrent self; things are
 			 * already fixed up. Nothing to do.
 			 */
-			return 0;
+			return 1;
 		}
 		newowner = argowner;
 	}
@@ -2380,7 +2378,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 handle_fault:
 	spin_unlock(q->lock_ptr);
 
-	ret = fault_in_user_writeable(uaddr);
+	err = fault_in_user_writeable(uaddr);
 
 	spin_lock(q->lock_ptr);
 
@@ -2388,12 +2386,27 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
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

