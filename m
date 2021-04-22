Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A258C3687E5
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 22:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbhDVUaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 16:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbhDVUaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 16:30:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E83C06174A;
        Thu, 22 Apr 2021 13:29:37 -0700 (PDT)
Message-Id: <20210422194704.984540159@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619123376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=QEWkB2rFEnM13X0FKJCpTSym3PN7/+G4+71WvlUWCtA=;
        b=uFb7FlfaNL0gOPm575cXhBZ88RrS2C+xAlB8nEeTZuq8E9IL4rD4yeGlSZzxTR6zTWCZfw
        xfYAVsCB4RqqUj9FImlylaujjPfHc52S3euiCBDmMpQzO33hR/xXMri+4NmwWFpFd1LX8Z
        lBAZ2zChAFaUB4qkyOE+UJEZ6cPBpFO9MQgTtz5Z5Qkb9jYwrfkszzO+3szjOKZ23c2sbc
        NWmt/6e0R/GPuSWLM13DpHf1IziEoxFlqRgZFX/KfLTJPc9KBBWuKAHtgVf8TsVDtlofTA
        roWPMHAEK3V/OmVeLBU2Dqbf/PwdRGbyCVoEfw1/+XmTLI5umSDDpUBIhI2yKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619123376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=QEWkB2rFEnM13X0FKJCpTSym3PN7/+G4+71WvlUWCtA=;
        b=4aNt+FsOh9RSDz7T2IdicANpZT/2g1QIy9US8nKK13cGT6fxJ7aDfXGvB7yBNQIBXQ8xzM
        XzF40T5MgbI4A4CQ==
Date:   Thu, 22 Apr 2021 21:44:19 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Adhemerval Zanella <adhemerval.zanella@linaro.org>,
        Lukasz Majewski <lukma@denx.de>,
        Florian Weimer <fweimer@redhat.com>,
        Carlos O'Donell <carlos@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Ingo Molnar <mingo@kernel.org>,
        Andrei Vagin <avagin@gmail.com>, stable@vger.kernel.org,
        Darren Hart <dvhart@infradead.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [patch 2/6] futex: Do not apply time namespace adjustment on FUTEX_LOCK_PI
References: <20210422194417.866740847@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

FUTEX_LOCK_PI does not require to have the FUTEX_CLOCK_REALTIME bit set
because it has been using CLOCK_REALTIME based absolute timeouts
forever. Due to that, the time namespace adjustment which is applied when
FUTEX_CLOCK_REALTIME is not set, will wrongly take place for FUTEX_LOCK_PI
and wreckage the timeout.

Exclude it from that procedure.

Fixes: c2f7d08cccf4 ("futex: Adjust absolute futex timeouts with per time namespace offset")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: stable@vger.kernel.org
---
 kernel/futex.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3781,7 +3781,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
-		else if (!(op & FUTEX_CLOCK_REALTIME))
+		else if (cmd != FUTEX_LOCK_PI && !(op & FUTEX_CLOCK_REALTIME))
 			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
@@ -3975,7 +3975,7 @@ SYSCALL_DEFINE6(futex_time32, u32 __user
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
-		else if (!(op & FUTEX_CLOCK_REALTIME))
+		else if (cmd != FUTEX_LOCK_PI && !(op & FUTEX_CLOCK_REALTIME))
 			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}

