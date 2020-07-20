Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154D022657D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbgGTPyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731560AbgGTPyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:54:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41067206E9;
        Mon, 20 Jul 2020 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260460;
        bh=Mk9BPFQSsYlWObJZHiGbURYRJrba9Qp7WU4zXP8MO70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFpaZGMsZSKuTbk6F70bEuyMFJVNMaoooMST4ux95+IaZM0h/bm6sGIXvPBscztd0
         VfKq5Qv7kR/1aK9ozso+SRGsgateZPJzi75vuGBCQY+qpaMnqqXh0miv6kkXy8L5wE
         /95T5FycsP3AS1TJHuzFPuDVUJg93tOGHGwdpX2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH 4.19 111/133] timer: Prevent base->clk from moving backward
Date:   Mon, 20 Jul 2020 17:37:38 +0200
Message-Id: <20200720152809.105593165@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit 30c66fc30ee7a98c4f3adf5fb7e213b61884474f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timer.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -580,7 +580,15 @@ trigger_dyntick_cpu(struct timer_base *b
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
 
@@ -899,10 +907,13 @@ static inline void forward_timer_base(st
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
 


