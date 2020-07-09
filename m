Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D99219CF0
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 12:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgGIKEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 06:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgGIKEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 06:04:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C16BC061A0B;
        Thu,  9 Jul 2020 03:04:50 -0700 (PDT)
Date:   Thu, 09 Jul 2020 10:04:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594289087;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXH1fpBV4Oym4GLTgCmE/nJ8fXIAKGGs5Wg9KfiTMVk=;
        b=lc+omKDZ4zjK5eskqG6yJ7++eY6og70sCWynTb2dploUg1L2EU2aV6jDRFyXNO4zxuoHbT
        Szz0rze4DsLEEwdAVfDc8gJGUbECLo/XKIHYrWzkt/84sggzncVRqXWLJf1J+9NTicKIVK
        WbJYxzDJApGmVe9uE7QPmeBZ1rp/rsZjzbWHnQL7TrY+o8C+ynCC+pw6s7ga4nikf/RUCn
        mJtQW4KYPaoH5pUNa4YKh+VPeVLqNVnyjwdUOrDOpGjjNJOaJHCQf8z04fMvxw4rfwoP1Y
        KrCm+yQiKsub3lacJelNtwYLVeec3nDPAVpGYb1gWhz0oXdwRkWZbXUIEfRLnQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594289087;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXH1fpBV4Oym4GLTgCmE/nJ8fXIAKGGs5Wg9KfiTMVk=;
        b=HSlub6Mu1R87O+XAiuX7CRftkum5LYWi0UVO/uVAWEYCN0A4+eH8BZIrUZxwY7JLYM7iRd
        tClPfZ7NpEt8n/Ag==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] timer: Prevent base->clk from moving backward
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Anna-Maria Behnsen" <anna-maria@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200703010657.2302-1-frederic@kernel.org>
References: <20200703010657.2302-1-frederic@kernel.org>
MIME-Version: 1.0
Message-ID: <159428908623.4006.8962643860352985536.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     30c66fc30ee7a98c4f3adf5fb7e213b61884474f
Gitweb:        https://git.kernel.org/tip/30c66fc30ee7a98c4f3adf5fb7e213b61884474f
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Fri, 03 Jul 2020 03:06:57 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 09 Jul 2020 11:56:57 +02:00

timer: Prevent base->clk from moving backward

When a timer is enqueued with a negative delta (ie: expiry is below
base->clk), it gets added to the wheel as expiring now (base->clk).

Yet the value that gets stored in base->next_expiry, while calling
trigger_dyntick_cpu(), is the initial timer->expires value. The
resulting state becomes:

	base->next_expiry < base->clk

On the next timer enqueue, forward_timer_base() may accidentally
rewind base->clk. As a possible outcome, timers may expire way too
early, the worst case being that the highest wheel levels get spuriously
processed again.

To prevent from that, make sure that base->next_expiry doesn't get below
base->clk.

Fixes: a683f390b93f ("timers: Forward the wheel clock whenever possible")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Tested-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200703010657.2302-1-frederic@kernel.org
---
 kernel/time/timer.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 398e6ea..9a838d3 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -584,7 +584,15 @@ trigger_dyntick_cpu(struct timer_base *base, struct timer_list *timer)
 	 * Set the next expiry time and kick the CPU so it can reevaluate the
 	 * wheel:
 	 */
-	base->next_expiry = timer->expires;
+	if (time_before(timer->expires, base->clk)) {
+		/*
+		 * Prevent from forward_timer_base() moving the base->clk
+		 * backward
+		 */
+		base->next_expiry = base->clk;
+	} else {
+		base->next_expiry = timer->expires;
+	}
 	wake_up_nohz_cpu(base->cpu);
 }
 
@@ -896,10 +904,13 @@ static inline void forward_timer_base(struct timer_base *base)
 	 * If the next expiry value is > jiffies, then we fast forward to
 	 * jiffies otherwise we forward to the next expiry value.
 	 */
-	if (time_after(base->next_expiry, jnow))
+	if (time_after(base->next_expiry, jnow)) {
 		base->clk = jnow;
-	else
+	} else {
+		if (WARN_ON_ONCE(time_before(base->next_expiry, base->clk)))
+			return;
 		base->clk = base->next_expiry;
+	}
 #endif
 }
 
