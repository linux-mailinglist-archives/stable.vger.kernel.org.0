Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44505588FB
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiFWTdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiFWTcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:32:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DE011801;
        Thu, 23 Jun 2022 12:12:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBED360E9A;
        Thu, 23 Jun 2022 19:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B87CC341C0;
        Thu, 23 Jun 2022 19:12:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nRsLdUeJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656011572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wn91beVIpJqcjS6OkGcXvZ64/XKHTsjaRxnq+PVXs/8=;
        b=nRsLdUeJuSmN2lu7ljc7LjGkyDyMhD94yTRJWdL2fyFvtfxvHNgiAsP/LINeQvHXp+by3B
        dBDNcrzybW4w6BQDyQhVBulH3jPXk+6k2v3TtkfKcqIaNRQxEmyP51EQmtTtPAL7GzmW+u
        qBbRtrJH+AfF87cIQvLhGPacF48mRAg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 67e2eba3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 23 Jun 2022 19:12:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH v4] timekeeping: contribute wall clock to rng on time change
Date:   Thu, 23 Jun 2022 21:12:49 +0200
Message-Id: <20220623191249.1357363-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9qGQrgCEGgQpomq6W2EMUy_D5AxqgYHykmmgND+PPVjjw@mail.gmail.com>
References: <CAHmME9qGQrgCEGgQpomq6W2EMUy_D5AxqgYHykmmgND+PPVjjw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The rng's random_init() function contributes the real time to the rng at
boot time, so that events can at least start in relation to something
particular in the real world. But this clock might not yet be set that
point in boot, so nothing is contributed. In addition, the relation
between minor clock changes from, say, NTP, and the cycle counter is
potentially useful entropic data.

This commit addresses this by mixing in a time stamp on calls to
settimeofday and adjtimex. No entropy is credited in doing so, so it
doesn't make initialization faster, but it is still useful input to
have.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 kernel/time/timekeeping.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8e4b3c32fcf9..f72b9f1de178 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -23,6 +23,7 @@
 #include <linux/pvclock_gtod.h>
 #include <linux/compiler.h>
 #include <linux/audit.h>
+#include <linux/random.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
@@ -1343,8 +1344,10 @@ int do_settimeofday64(const struct timespec64 *ts)
 	/* Signal hrtimers about time change */
 	clock_was_set(CLOCK_SET_WALL);
 
-	if (!ret)
+	if (!ret) {
 		audit_tk_injoffset(ts_delta);
+		add_device_randomness(ts, sizeof(*ts));
+	}
 
 	return ret;
 }
@@ -2430,6 +2433,7 @@ int do_adjtimex(struct __kernel_timex *txc)
 	ret = timekeeping_validate_timex(txc);
 	if (ret)
 		return ret;
+	add_device_randomness(txc, sizeof(*txc));
 
 	if (txc->modes & ADJ_SETOFFSET) {
 		struct timespec64 delta;
@@ -2447,6 +2451,7 @@ int do_adjtimex(struct __kernel_timex *txc)
 	audit_ntp_init(&ad);
 
 	ktime_get_real_ts64(&ts);
+	add_device_randomness(&ts, sizeof(ts));
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&tk_core.seq);
-- 
2.35.1

