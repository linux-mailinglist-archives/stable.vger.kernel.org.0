Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DD52ABC2B
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbgKINfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731145AbgKINfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 08:35:00 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC5BC0613CF;
        Mon,  9 Nov 2020 05:35:00 -0800 (PST)
Date:   Mon, 09 Nov 2020 13:34:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604928898;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xIn34HVKy73OXU3upBn5Sgk+diM0sY3tJJfSyrEjPj0=;
        b=AF0khv9slGbhWJRf3ryTKIq+/ULIqu1fMy6wj8dNBvQoVkO562WRNKfwO5+gWKoclvz23E
        pe2xWdm2Do4ESZCk8ww5BkuZdjdW+0C6CzXEgSADygQk5IAF3XEShZjbFIwQPUg4TkHHjp
        dFmtCIABBJVDH/1ODuyAB31OhV4YrsVEv1GjxL7vIgbrVlF8UGH+c7zmc8kM2/MTGwsQyR
        L0bSKLIv3mTJyq8fTP4nbuQEYQyrNKeEExDWYlOAzxc1sntQnUZfRnM6clLlatXkFPt3y7
        8YqJy2dkGKqq+zTFVaAWsaijcl/2upo1b8nVSavRDORxZfrLyk5snEclRs9WCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604928898;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xIn34HVKy73OXU3upBn5Sgk+diM0sY3tJJfSyrEjPj0=;
        b=AXtBKdDJAxNp2JBm9OXsPiSo1f+0g8UjVkLKN+PCWvchHllPkuAqIq3N3y++1e7yzhP+gZ
        hVl0moKPpsWnxCDA==
From:   "tip-bot2 for Dan Carpenter" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] futex: Don't enable IRQs unconditionally in
 put_pi_state()
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201106085205.GA1159983@mwanda>
References: <20201106085205.GA1159983@mwanda>
MIME-Version: 1.0
Message-ID: <160492889756.11244.1763664400047325043.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     1e106aa3509b86738769775969822ffc1ec21bf4
Gitweb:        https://git.kernel.org/tip/1e106aa3509b86738769775969822ffc1ec21bf4
Author:        Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate:    Fri, 06 Nov 2020 11:52:05 +03:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 09 Nov 2020 14:30:30 +01:00

futex: Don't enable IRQs unconditionally in put_pi_state()

The exit_pi_state_list() function calls put_pi_state() with IRQs disabled
and is not expecting that IRQs will be enabled inside the function.

Use the _irqsave() variant so that IRQs are restored to the original state
instead of being enabled unconditionally.

Fixes: 153fbd1226fb ("futex: Fix more put_pi_state() vs. exit_pi_state_list() races")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201106085205.GA1159983@mwanda
---
 kernel/futex.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index ac32887..00259c7 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -788,8 +788,9 @@ static void put_pi_state(struct futex_pi_state *pi_state)
 	 */
 	if (pi_state->owner) {
 		struct task_struct *owner;
+		unsigned long flags;
 
-		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+		raw_spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
 		owner = pi_state->owner;
 		if (owner) {
 			raw_spin_lock(&owner->pi_lock);
@@ -797,7 +798,7 @@ static void put_pi_state(struct futex_pi_state *pi_state)
 			raw_spin_unlock(&owner->pi_lock);
 		}
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex, owner);
-		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+		raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
 	}
 
 	if (current->pi_state_cache) {
