Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830AB4796ED
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 23:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhLQWQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 17:16:04 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36080 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhLQWQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 17:16:03 -0500
Date:   Fri, 17 Dec 2021 22:16:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639779362;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwucGkdHW2AGD5uQLtH16eVlF+0ZkoFxd0RELR7jY/I=;
        b=MifcnrkXm5YazgnCPBRrhPTdyg9bAS+7ugyOdEnpExMzkF8Nc1hI7KL4jCNg45btFEjIfN
        NorCPG9F0lMAejAOBrecNV4irPZekRTHO0siDJ+H2ppRbjOWUqbDgdPC4pDYK7pjV0Bw7o
        dQyBU0j6TmMP4ISwtFoFJYgQ7X2PZdNCVF5YADLK3Dfb2KnkiNgIb111wrovGLHzRMT3/X
        YgNOFjNFXKoUv46eY3M+Vu+ie7aQpGqIuV7KRmWDJtMVk+ExgyFZr/UJmDk9EeLZ0t3zLj
        UoKWdsZgXPgydQBQTatVpQqPEoj8UTXt9MDKmr6iLjGCHIv9saERP6hLBZKN3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639779362;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwucGkdHW2AGD5uQLtH16eVlF+0ZkoFxd0RELR7jY/I=;
        b=hhLZ01sTJSEwovB8cwxoBtu5RKqqNpI0zyrf3G4KR8mmHuviWzOY8pQMGEP6t+C7WD3efP
        MbOz5rjjM7yK3ZCA==
From:   "tip-bot2 for Yu Liao" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] timekeeping: Really make sure wall_to_monotonic
 isn't positive
Cc:     Yu Liao <liaoyu15@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211213135727.1656662-1-liaoyu15@huawei.com>
References: <20211213135727.1656662-1-liaoyu15@huawei.com>
MIME-Version: 1.0
Message-ID: <163977936091.23020.4635277365571231741.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     4e8c11b6b3f0b6a283e898344f154641eda94266
Gitweb:        https://git.kernel.org/tip/4e8c11b6b3f0b6a283e898344f154641eda94266
Author:        Yu Liao <liaoyu15@huawei.com>
AuthorDate:    Mon, 13 Dec 2021 21:57:27 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 17 Dec 2021 23:06:22 +01:00

timekeeping: Really make sure wall_to_monotonic isn't positive

Even after commit e1d7ba873555 ("time: Always make sure wall_to_monotonic
isn't positive") it is still possible to make wall_to_monotonic positive
by running the following code:

    int main(void)
    {
        struct timespec time;

        clock_gettime(CLOCK_MONOTONIC, &time);
        time.tv_nsec = 0;
        clock_settime(CLOCK_REALTIME, &time);
        return 0;
    }

The reason is that the second parameter of timespec64_compare(), ts_delta,
may be unnormalized because the delta is calculated with an open coded
substraction which causes the comparison of tv_sec to yield the wrong
result:

  wall_to_monotonic = { .tv_sec = -10, .tv_nsec =  900000000 }
  ts_delta 	    = { .tv_sec =  -9, .tv_nsec = -900000000 }

That makes timespec64_compare() claim that wall_to_monotonic < ts_delta,
but actually the result should be wall_to_monotonic > ts_delta.

After normalization, the result of timespec64_compare() is correct because
the tv_sec comparison is not longer misleading:

  wall_to_monotonic = { .tv_sec = -10, .tv_nsec =  900000000 }
  ts_delta 	    = { .tv_sec = -10, .tv_nsec =  100000000 }

Use timespec64_sub() to ensure that ts_delta is normalized, which fixes the
issue.

Fixes: e1d7ba873555 ("time: Always make sure wall_to_monotonic isn't positive")
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211213135727.1656662-1-liaoyu15@huawei.com
---
 kernel/time/timekeeping.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b348749..dcdcb85 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1306,8 +1306,7 @@ int do_settimeofday64(const struct timespec64 *ts)
 	timekeeping_forward_now(tk);
 
 	xt = tk_xtime(tk);
-	ts_delta.tv_sec = ts->tv_sec - xt.tv_sec;
-	ts_delta.tv_nsec = ts->tv_nsec - xt.tv_nsec;
+	ts_delta = timespec64_sub(*ts, xt);
 
 	if (timespec64_compare(&tk->wall_to_monotonic, &ts_delta) > 0) {
 		ret = -EINVAL;
