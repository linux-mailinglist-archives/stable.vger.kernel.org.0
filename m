Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B743152BD
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 16:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhBIPZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 10:25:13 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44914 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbhBIPXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 10:23:06 -0500
Date:   Tue, 09 Feb 2021 15:22:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612884142;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XB03glBY/5tLLvRLJWJe41AKQPCVAeafGDFn/GWB+gk=;
        b=FD7jb+nGF9QH+3aMW0aVJ1nO1YituWa3YaYDJkKstPzdcdI+OH8A2Ia3niVvoYTpyyLWCY
        ejMTXssqP7y/sR6Fwzf5kPtFqUDosg9ADu5KaXeiIZWN2CxJWEwX9tBzTL3nup4h2Ae6PD
        tdZiHX7FkqeeA232fIJWUGDTaWNCL6vBFQWIRGjbNDsjXern0ulIVkhImEer1WngO3ZFOu
        psj3ChQbd3ZA2tujwkUDqZb6IVaU64x9yuV4BojemNfUUO6uHHeWbtR9J/AA5Zob1C4S/t
        VkT1PHuH4pyvkD6nWICif9Ui3Mcf0vttjENtlb3OtKQZ9kkt27wiDURlkCs23A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612884142;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XB03glBY/5tLLvRLJWJe41AKQPCVAeafGDFn/GWB+gk=;
        b=E/IEdE+BlWEwcA7E3mJlQV0pPelYYszaUXVt/bOeH/pe0YIQlFWa1FtUnGrFZ4mUG+ufAu
        nsCOzCxOqR4WVoCA==
From:   "tip-bot2 for Mikael Beckius" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] hrtimer: Update softirq_expires_next correctly
 in hrtimer_force_reprogram()
Cc:     Mikael Beckius <mikael.beckius@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210128140208.30264-1-mikael.beckius@windriver.com>
References: <20210128140208.30264-1-mikael.beckius@windriver.com>
MIME-Version: 1.0
Message-ID: <161288414184.23325.3143319640747364296.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     0fcc7c20d2e2a65fb5b80d42841084e8509d085d
Gitweb:        https://git.kernel.org/tip/0fcc7c20d2e2a65fb5b80d42841084e8509d085d
Author:        Mikael Beckius <mikael.beckius@windriver.com>
AuthorDate:    Thu, 28 Jan 2021 15:02:08 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 Feb 2021 16:18:42 +01:00

hrtimer: Update softirq_expires_next correctly in hrtimer_force_reprogram()

hrtimer_force_reprogram() invokes __hrtimer_get_next_event() to find the
earliest expiry time of all hrtimer bases. __hrtimer_get_next_event() does
not update cpu_base::[softirq_]_expires_next. That needs to be done at the
callsites.

hrtimer_force_reprogram() updates cpu_base::softirq_expires_next only when
the first expiring timer is a softirq timer and the soft interrupt is not
activated. That's wrong because cpu_base::softirq_expires_next is left
stale when the first expiring timer of all bases is a timer which expires
in hard interrupt context.

That becomes a problem when clock_settime() sets CLOCK_REALTIME forward and
the first soft expiring timer is in the CLOCK_REALTIME_SOFT base. Setting
CLOCK_REALTIME forward moves the clock MONOTONIC based expiry time of that
timer before the stale cpu_base::softirq_expires_next.

cpu_base::softirq_expires_next is cached to make the check for raising the
soft interrupt fast. In the above case the soft interrupt won't be raised
until clock monotonic reaches the stale cpu_base::softirq_expires_next
value. That's incorrect, but what's worse it that if the softirq timer
becomes the first expiring timer of all clock bases after the hard expiry
timer has been handled the reprogramming of the clockevent from
hrtimer_interrupt() will result in an interrupt storm. That happens because
the reprogramming does not use cpu_base::softirq_expires_next, it uses
__hrtimer_get_next_event() which returns the actual expiry time. Once clock
MONOTONIC reaches cpu_base::softirq_expires_next the soft interrupt is
raised and the storm subsides.

Change the logic in hrtimer_force_reprogram() to evaluate the soft and hard
bases seperately, update softirq_expires_next and handle the case when a
soft expiring timer is the first of all bases by comparing the expiry times
and updating the required cpu base fields.

[ tglx: Modified it to avoid the double evaluation ]

Fixes:5da70160462e ("hrtimer: Implement support for softirq based hrtimers")
Signed-off-by: Mikael Beckius <mikael.beckius@windriver.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210128140208.30264-1-mikael.beckius@windriver.com

---
 kernel/time/hrtimer.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 743c852..88a0145 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -626,24 +626,30 @@ static inline int hrtimer_hres_active(void)
 static void
 hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 {
-	ktime_t expires_next;
+	ktime_t expires_next, soft = KTIME_MAX;
 
 	/*
-	 * Find the current next expiration time.
+	 * If the soft interrupt has already been activated, ignore the
+	 * soft bases. They will be handled in the already raised soft
+	 * interrupt.
 	 */
-	expires_next = __hrtimer_get_next_event(cpu_base, HRTIMER_ACTIVE_ALL);
-
-	if (cpu_base->next_timer && cpu_base->next_timer->is_soft) {
+	if (!cpu_base->softirq_activated) {
+		soft = __hrtimer_get_next_event(cpu_base, HRTIMER_ACTIVE_SOFT);
 		/*
-		 * When the softirq is activated, hrtimer has to be
-		 * programmed with the first hard hrtimer because soft
-		 * timer interrupt could occur too late.
+		 * Update the soft expiry time. clock_settime() might have
+		 * affected it.
 		 */
-		if (cpu_base->softirq_activated)
-			expires_next = __hrtimer_get_next_event(cpu_base,
-								HRTIMER_ACTIVE_HARD);
-		else
-			cpu_base->softirq_expires_next = expires_next;
+		cpu_base->softirq_expires_next = soft;
+	}
+
+	expires_next = __hrtimer_get_next_event(cpu_base, HRTIMER_ACTIVE_HARD);
+	/*
+	 * If a softirq timer is expiring first, update cpu_base->next_timer
+	 * and program the hardware with the soft expiry time.
+	 */
+	if (expires_next > soft) {
+		cpu_base->next_timer = cpu_base->softirq_next_timer;
+		expires_next = soft;
 	}
 
 	if (skip_equal && expires_next == cpu_base->expires_next)
