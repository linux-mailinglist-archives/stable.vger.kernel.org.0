Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A3F3135FC
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhBHPEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232560AbhBHPD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:03:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A302A64E9D;
        Mon,  8 Feb 2021 15:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796541;
        bh=D/cuF8HNNnjapB3LbsVqBvyvmr3HSkTynXjdm9FHBwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKLimW2TRzrKOqx2RAn48qb4TfJ89d3zfMkQbUS/tiWz4i/TX3fb/NA/fCXjW9AqD
         LF+NTX9WiX9nZuwU8ECHjDTiAivxYLMpLRgxM1J9aRorI7IJ2C6IgVP8f+2k1X0WOB
         yzGPIfIzfJKjAm+bEclNVhArOhlmxRZZhi+YFegs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 07/38] futex: Provide and use pi_state_update_owner()
Date:   Mon,  8 Feb 2021 16:00:29 +0100
Message-Id: <20210208145805.576321276@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   64 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -835,6 +835,29 @@ static struct futex_pi_state * alloc_pi_
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
@@ -1427,26 +1450,16 @@ static int wake_futex_pi(u32 __user *uad
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


