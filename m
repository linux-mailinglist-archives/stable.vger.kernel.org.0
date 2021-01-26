Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5ADC304C1A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbhAZWAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392078AbhAZUFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 15:05:44 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B105EC0613D6;
        Tue, 26 Jan 2021 12:05:03 -0800 (PST)
Date:   Tue, 26 Jan 2021 20:04:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611691502;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=WTrRZwsMcoVms/EV04Vpw9qhwafIHEu5jI8j2cg/5sI=;
        b=BNN/kLH25Qws44cTFAeZFZKNuu0jQuUACykUF1iue4nl+tQm72eQeqNcuplqNZdy5UFG/Y
        EWzX20QwfJNSidEMknX3/fkHe57QfT0NXlh5rrEQAgPkeQhGKsDcj3DEVp9mTLE/qUISw5
        pPuefahCFqvrctu6lk9ZN/pGfTLvxdicsatx4WmZcEKEmN7253TitjpucgZQ1pyz3ydX0S
        lgjo1YWzfT9rHRJ0kB8LDl05EZf0rKxIPBp4u2n6ZlKZoTkI40QvB4OqcttRc6HgLHUmC4
        1s3KvMXkpwyYSgmCc1zheqK0lJIK+yTnfznILoXFD0TqQgid+2/l9MKRInQqTg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611691502;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=WTrRZwsMcoVms/EV04Vpw9qhwafIHEu5jI8j2cg/5sI=;
        b=BIBeeGqpBT1zhgKtHPmCgIBHQWUFiA+SE6O29CA86UHvqfZ+J76BOGO6dR0FaGCOKRopLv
        kfin7RLqRhbvpMBg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] futex: Replace pointless printk in fixup_owner()
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161169149970.414.17718525075409786900.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     04b79c55201f02ffd675e1231d731365e335c307
Gitweb:        https://git.kernel.org/tip/04b79c55201f02ffd675e1231d731365e335c307
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Tue, 19 Jan 2021 16:06:10 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 26 Jan 2021 15:10:58 +01:00

futex: Replace pointless printk in fixup_owner()

If that unexpected case of inconsistent arguments ever happens then the
futex state is left completely inconsistent and the printk is not really
helpful. Replace it with a warning and make the state consistent.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
---
 kernel/futex.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index d5e61c2..5dc8f89 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2550,14 +2550,10 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
-	 * the owner of the rt_mutex.
+	 * the owner of the rt_mutex. Warn and establish consistent state.
 	 */
-	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current) {
-		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "
-				"pi-state %p\n", ret,
-				q->pi_state->pi_mutex.owner,
-				q->pi_state->owner);
-	}
+	if (WARN_ON_ONCE(rt_mutex_owner(&q->pi_state->pi_mutex) == current))
+		return fixup_pi_state_owner(uaddr, q, current);
 
 	return 0;
 }
