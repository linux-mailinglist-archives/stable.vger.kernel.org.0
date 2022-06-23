Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D61558826
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiFWTBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiFWTBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:01:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363B410E660;
        Thu, 23 Jun 2022 11:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D302AB824B8;
        Thu, 23 Jun 2022 18:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D9DC3411B;
        Thu, 23 Jun 2022 18:06:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="i8VacFgO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656007579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBPyGuTe86mnhxG9zwBBx0uOGbFIgl4RlsUraYH1wUM=;
        b=i8VacFgOFGPItHWqD0uM/IkBt4nJuvU/5PQHEGRL1DfzbJTY2Te5yXtRTGlL+II8KpTNq9
        vINjqRZsbU7QI1zdLuR2GVXD43wn/Jn1yOqhAUxw1UEIFFf4NO82MCdb3H5PsNiJoDpDZn
        PiTYNUv3hmMjuDL3buGsYoEBhPbs0xc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f9fc6760 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 23 Jun 2022 18:06:18 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH v2] timekeeping: contribute wall clock to rng on time change
Date:   Thu, 23 Jun 2022 20:05:55 +0200
Message-Id: <20220623180555.1345684-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9qy0N3BvDo-0jkS+om0N3Yk--ZAyKvSKshzDBzvuoP+UA@mail.gmail.com>
References: <CAHmME9qy0N3BvDo-0jkS+om0N3Yk--ZAyKvSKshzDBzvuoP+UA@mail.gmail.com>
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
 kernel/time/timekeeping.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8e4b3c32fcf9..89b894b3ede8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -23,6 +23,7 @@
 #include <linux/pvclock_gtod.h>
 #include <linux/compiler.h>
 #include <linux/audit.h>
+#include <linux/random.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
@@ -1331,6 +1332,8 @@ int do_settimeofday64(const struct timespec64 *ts)
 		goto out;
 	}
 
+	add_device_randomness(&ts, sizeof(ts));
+
 	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts_delta));
 
 	tk_set_xtime(tk, ts);
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

