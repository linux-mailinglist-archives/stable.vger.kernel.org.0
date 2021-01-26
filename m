Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F836304C15
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbhAZWAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405255AbhAZUFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 15:05:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA68C061574;
        Tue, 26 Jan 2021 12:05:00 -0800 (PST)
Date:   Tue, 26 Jan 2021 20:04:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611691498;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=WYYOiLy89E5Uca5A9MncZaRPPY1qBs3u+pf7CaKg9Xc=;
        b=oa66NSEcPCglQa3LW+Qz/3tgJAtTIuBXzOwYBG21hDk07oSuyyWPhtS8g5uqhoORkij2IN
        cRLexje4tO/Dof3lYQSEw/DK6ELnJ7RYOmzEG1IE56KJIHDjvKPoouTEo/4KIuEkeOjZko
        IULkzM0+xpEyIWFS4diegbsuD+BRAb4Jlq+KfpWQZPtPn4cdgdS0MgCf7XapUIca9uix4t
        UUNWeIYiPUbpIBzAcQMLwRPKxMSfmwqtwqj7Nz0zuc/qhk09Xi2qlQjOh9JMjxJ7t5AWgp
        zRfvCPAQ7zt/2QSiyCmWr6X/s7fg0gHayUH6QDk5ctqk/X9eJzprCW65Gh0/eg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611691498;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=WYYOiLy89E5Uca5A9MncZaRPPY1qBs3u+pf7CaKg9Xc=;
        b=2SFz4tHtAlyqazqwJvjyEcwnnA0zIi+Bm51eRjIC04qxUYq6hya1O5EbZuWmG3psdjswGt
        ghqchA5K5FqCEyAQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] futex: Use pi_state_update_owner() in put_pi_state()
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161169149587.414.5977354859259738218.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     6ccc84f917d33312eb2846bd7b567639f585ad6d
Gitweb:        https://git.kernel.org/tip/6ccc84f917d33312eb2846bd7b567639f585ad6d
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 20 Jan 2021 11:35:19 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 26 Jan 2021 15:10:59 +01:00

futex: Use pi_state_update_owner() in put_pi_state()

No point in open coding it. This way it gains the extra sanity checks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
---
 kernel/futex.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index cfca221..a0fe63c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -808,16 +808,10 @@ static void put_pi_state(struct futex_pi_state *pi_state)
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
-		struct task_struct *owner;
 		unsigned long flags;
 
 		raw_spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
-		owner = pi_state->owner;
-		if (owner) {
-			raw_spin_lock(&owner->pi_lock);
-			list_del_init(&pi_state->list);
-			raw_spin_unlock(&owner->pi_lock);
-		}
+		pi_state_update_owner(pi_state, NULL);
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
 		raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
 	}
