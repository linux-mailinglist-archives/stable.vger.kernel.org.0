Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A58D30DBAE
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhBCNrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbhBCNrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:47:19 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C1FC06178C
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:45:55 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id u14so5276028wmq.4
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3a5y1/WHdcXkbOPADuocB1pmZN0ZLdkklQNTVAL0OLE=;
        b=Bq1gJ9maLxf7KN7ZzMhJa34j/cJeCeZ/7HQZ/2lHf6gW0OzmQUYItx1zCaF5q1ION4
         A3Ug1eKzXwyxwWvIhlMLmgAtBFZ8AE9fSVQ60SL3NsmUmYA4yZoFBPqBLBiCZVThTjva
         Ldzk4U5l1KWQPKDgvkCBgnUYDDcVc2yNyPnB1evGUYWaPIvccfUdJFe90wAJ9dv/B4hZ
         JS13ZJS0Vai9msnTRQM9877+8a1aOYrDjLVtbsF4DqcKYPLNl8E1KiOQcc46PA1e9BtA
         dbkPGVUkyIx1fTwcKGc6k8e7Ti1EiV2/5BrYqc0EGi8r5s03H7shHr1ASrYaK0F4Q/bm
         0ybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3a5y1/WHdcXkbOPADuocB1pmZN0ZLdkklQNTVAL0OLE=;
        b=ZzQmU52LG+F9OGSz9Oj5JW/mrxu17hECupL/igQNzJF1HNR8hj26H5MKkCNwhFwMPf
         /eA8lwlAsYhV2SUhvl2gvVKDyP2/rBBKOc3mUvzfTSS+H57puHLOSTn6QRHgM4HOYe15
         6ld4OYGg2Os8KLO7SCNj2hrCkDbX7bCBb9WfAvRWF6BSj3kU2kjUDX7BWIP9anV94SVq
         6tZUnHoxZo6fFJC+ZLm98pHxsQe0vDXkGzWhpWf3O+8pO7EwoefE9xq3hlAyhBRxh+o8
         lgYWKSHBUUqOLiTnQr1OzN0KXaSIPFdjJKj2rWguLVHgnMDl13fu2AXOb9rm9A0qIudL
         klgQ==
X-Gm-Message-State: AOAM5300bBD06NPWNoGuABTdXIQfX3TqLQwmirOP8Kl8xK6qHV9YYxMt
        FndKAE3RACyz2M8ucCqksJt4E70LG0AMKg==
X-Google-Smtp-Source: ABdhPJyXa9bGcsqoNHc7IeW/UYxpsMQKDVWLBAzcvkRqyWfz2Ql1DPsqFyOhpG4OPriKOiLzmzS3kA==
X-Received: by 2002:a7b:c3ce:: with SMTP id t14mr2685420wmj.175.1612359954087;
        Wed, 03 Feb 2021 05:45:54 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id r124sm2867900wmr.16.2021.02.03.05.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:45:53 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/10] futex: Provide and use pi_state_update_owner()
Date:   Wed,  3 Feb 2021 13:45:35 +0000
Message-Id: <20210203134539.2583943-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203134539.2583943-1-lee.jones@linaro.org>
References: <20210203134539.2583943-1-lee.jones@linaro.org>
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
index e44203956d54c..391a85dcd46c2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -837,6 +837,29 @@ static struct futex_pi_state * alloc_pi_state(void)
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
  * Drops a reference to the pi_state object and frees or caches it
  * when the last reference is gone.
@@ -1432,26 +1455,16 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
 		else
 			ret = -EINVAL;
 	}
-	if (ret) {
-		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
-		return ret;
-	}
-
-	raw_spin_lock(&pi_state->owner->pi_lock);
-	WARN_ON(list_empty(&pi_state->list));
-	list_del_init(&pi_state->list);
-	raw_spin_unlock(&pi_state->owner->pi_lock);
 
-	raw_spin_lock(&new_owner->pi_lock);
-	WARN_ON(!list_empty(&pi_state->list));
-	list_add(&pi_state->list, &new_owner->pi_state_list);
-	pi_state->owner = new_owner;
-	raw_spin_unlock(&new_owner->pi_lock);
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
@@ -2353,19 +2366,8 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
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

