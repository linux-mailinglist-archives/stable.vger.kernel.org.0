Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0D930FA1A
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbhBDRqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238530AbhBDRaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:30:15 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E48C061797
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:16 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id 7so4551333wrz.0
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L9WDlXzldPwLcNIVpjw64K4i0YIfrHdhJn+ngLH0dQE=;
        b=NTLTlxqXUs9SwMrPjNG0ZyDO1lAKLCgMYooX9qcFgzVmPo3prVb0uDJfMjfEPYaDKf
         eICcyeIfhn1SxbnsPc1KoqwxPsJ7LtyDgF/CXrcobUa7U48X/CA+c6ztlB30K/95J/aF
         FIzbfbLlRlV5sBJtt+M/KHkhPm3LWeGSm9ibbFnPIWvNcO3hqGAfMj96/ddmWtyz+wmi
         6gClkTxXEdLakFp8MoKH4rHXNB39SCj0BPgO7OfoQZlh+T7oo3bZa10H+1Ya7zFEAiOG
         0Qs/outahWmrt6sW48Gg/9lehbF3NbsHfNUC2MVmG7yuflHTvPlwJthaIp+Y9wicMBfT
         iD2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L9WDlXzldPwLcNIVpjw64K4i0YIfrHdhJn+ngLH0dQE=;
        b=KB76HkRCIke0xA9oR4bfPlLnzI5lBGKlt9dJkutYSrSj08527Ksr7hMrSR4B6lxAbs
         yTwExnNBbcSxBltPVUfURYeaTif0wIdwvyrPPIAk+O8DdQ5L4/4STnfXt6myJohZ2w9c
         hm2gHM8njPmWitPqSEaFlUqo/2Wkp3WfIM5K4pzpG+n/zZBNGFf9dqCbjHPt1Dq2Bhur
         3F0nCZqbDAN8K8Py1TwNI/jN0KisuB3cI++kRwbRosAskRo6szEDEpSc3BDHm+A347YS
         TA2xr1DtnaQzxotSlPowEZ6d4sS1NzAPguOaRSxIlh5rC36yQOnklUplSPjxb+/INPh6
         /gCg==
X-Gm-Message-State: AOAM532KTMB2lI4wLId29ACaLHD7rtwgWoiGNqnuXCVbhMYUeQEKY8jN
        +HWDRJXXHZy84u94zEcActX78XBJiy+F1Q==
X-Google-Smtp-Source: ABdhPJx5QREjE6McECjkPpuDF5f973rNzG6beOHZbOiU689lBLVidLnuGm++jZx09Gz7RFFaAIloHw==
X-Received: by 2002:adf:a2ca:: with SMTP id t10mr454572wra.370.1612459754633;
        Thu, 04 Feb 2021 09:29:14 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:14 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/10] futex: Provide and use pi_state_update_owner()
Date:   Thu,  4 Feb 2021 17:28:59 +0000
Message-Id: <20210204172903.2860981-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit c5cade200ab9a2a3be9e7f32a752c8d86b502ec7 ]

Updating pi_state::owner is done at several places with the same
code. Provide a function for it and use that at the obvious places.

This is also a preparation for a bug fix to avoid yet another copy of the
same code or alternatively introducing a completely unpenetratable mess of
gotos.

Originally-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 64 ++++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a247942d69799..1390ffa874a6b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -835,6 +835,29 @@ static struct futex_pi_state * alloc_pi_state(void)
 	return pi_state;
 }
 
+static void pi_state_update_owner(struct futex_pi_state *pi_state,
+				  struct task_struct *new_owner)
+{
+	struct task_struct *old_owner = pi_state->owner;
+
+	lockdep_assert_held(&pi_state->pi_mutex.wait_lock);
+
+	if (old_owner) {
+		raw_spin_lock(&old_owner->pi_lock);
+		WARN_ON(list_empty(&pi_state->list));
+		list_del_init(&pi_state->list);
+		raw_spin_unlock(&old_owner->pi_lock);
+	}
+
+	if (new_owner) {
+		raw_spin_lock(&new_owner->pi_lock);
+		WARN_ON(!list_empty(&pi_state->list));
+		list_add(&pi_state->list, &new_owner->pi_state_list);
+		pi_state->owner = new_owner;
+		raw_spin_unlock(&new_owner->pi_lock);
+	}
+}
+
 /*
  * Must be called with the hb lock held.
  */
@@ -1427,26 +1450,16 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
 		else
 			ret = -EINVAL;
 	}
-	if (ret) {
-		raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
-		return ret;
-	}
-
-	raw_spin_lock_irq(&pi_state->owner->pi_lock);
-	WARN_ON(list_empty(&pi_state->list));
-	list_del_init(&pi_state->list);
-	raw_spin_unlock_irq(&pi_state->owner->pi_lock);
 
-	raw_spin_lock_irq(&new_owner->pi_lock);
-	WARN_ON(!list_empty(&pi_state->list));
-	list_add(&pi_state->list, &new_owner->pi_state_list);
-	pi_state->owner = new_owner;
-	raw_spin_unlock_irq(&new_owner->pi_lock);
-
-	/*
-	 * We've updated the uservalue, this unlock cannot fail.
-	 */
-	deboost = __rt_mutex_futex_unlock(&pi_state->pi_mutex, &wake_q);
+	if (!ret) {
+		/*
+		 * This is a point of no return; once we modified the uval
+		 * there is no going back and subsequent operations must
+		 * not fail.
+		 */
+		pi_state_update_owner(pi_state, new_owner);
+		deboost = __rt_mutex_futex_unlock(&pi_state->pi_mutex, &wake_q);
+	}
 
 	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 	spin_unlock(&hb->lock);
@@ -2318,19 +2331,8 @@ retry:
 	 * We fixed up user space. Now we need to fix the pi_state
 	 * itself.
 	 */
-	if (pi_state->owner != NULL) {
-		raw_spin_lock_irq(&pi_state->owner->pi_lock);
-		WARN_ON(list_empty(&pi_state->list));
-		list_del_init(&pi_state->list);
-		raw_spin_unlock_irq(&pi_state->owner->pi_lock);
-	}
-
-	pi_state->owner = newowner;
+	pi_state_update_owner(pi_state, newowner);
 
-	raw_spin_lock_irq(&newowner->pi_lock);
-	WARN_ON(!list_empty(&pi_state->list));
-	list_add(&pi_state->list, &newowner->pi_state_list);
-	raw_spin_unlock_irq(&newowner->pi_lock);
 	return 0;
 
 	/*
-- 
2.25.1

