Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF55333E76
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhCJN0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233413AbhCJNZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78DD964FF6;
        Wed, 10 Mar 2021 13:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382728;
        bh=wyeoJoAKw4M6OkASOevUT5ZrvINGIUsKtdswAl21VUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3X1AtnwWb1AAQy8KT/yu/xC5L/W5qNLyxL7w0GYsLrQdTV8hFQPOHaOrJK4eUool
         hnP9e6fl+tMyUw6EkEXrRLHYawVUBvcWrIuE3q1/qxnZZYxYmLC1ViIuFA8oCZ/CkL
         V8sIwLqPmuSA/ZjBf6A14zNlziZXGlI90PoiT9fs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Schoebel-Theuer <tst@1und1.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 2/7] futex: fix spin_lock() / spin_unlock_irq() imbalance
Date:   Wed, 10 Mar 2021 14:25:15 +0100
Message-Id: <20210310132319.239999799@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.155338551@linuxfoundation.org>
References: <20210310132319.155338551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Thomas Schoebel-Theuer <tst@1und1.de>

This patch and problem analysis is specific for 4.4 LTS, due to incomplete
backporting of other fixes. Later LTS series have different backports.

The following is obviously incorrect:

static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
             struct futex_hash_bucket *hb)
{
[...]
	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
[...]
	raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
[...]
}

The 4.4-specific fix should probably go in the direction of
b4abf91047c,
making everything irq-safe.

Probably, backporting of b4abf91047c
to 4.4 LTS could thus be another good idea.

However, this might involve some more 4.4-specific work and
require thorough testing:

> git log --oneline v4.4..b4abf91047c -- kernel/futex.c kernel/locking/rtmutex.c | wc -l
10

So this patch is just an obvious quickfix for now.

Hint: the lock order is documented in 4.9.y and later. A similar
documenting is missing in 4.4.y. Please somebody either backport also,
or write a new description, if there would be some differences I cannot
easily see at the moment. Without reliable docs,
inspection of the locking correctness may become a pain.
 
Signed-off-by: Thomas Schoebel-Theuer <tst@1und1.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>
Fixes: 394fc4981426 ("futex: Rework inconsistent rt_mutex/futex_q state")
Fixes: 6510e4a2d04f ("futex,rt_mutex: Provide futex specific rt_mutex API")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1408,7 +1408,7 @@ static int wake_futex_pi(u32 __user *uad
 	if (pi_state->owner != current)
 		return -EINVAL;
 
-	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*


