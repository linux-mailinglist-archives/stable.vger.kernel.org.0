Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937B0593D65
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbiHOTyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241858AbiHOTxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7023AE3A;
        Mon, 15 Aug 2022 11:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84D16B810A0;
        Mon, 15 Aug 2022 18:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49BBC433D6;
        Mon, 15 Aug 2022 18:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589455;
        bh=PjvIlGHNLRN6F/T3nDYHHiN9EJ37PSPnqadsUE8gwZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmEh6MvrhqmWHwp9dPhNc00L1+oWLTWAiYHrysx1cXWbrEpdtpwGaUyZP1KyvcgVW
         H+5EIJlbl/16jjLO+2QfCHPWuy5z2W4sBZkc4sIw8YoNVd8XRx5V8/P+tYqNkkQ/QU
         AVZzbDypRBaiZIoJ7rh4VeuxDx/3bs2hn+DdW1KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 723/779] timekeeping: contribute wall clock to rng on time change
Date:   Mon, 15 Aug 2022 20:06:07 +0200
Message-Id: <20220815180408.368575578@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit b8ac29b40183a6038919768b5d189c9bd91ce9b4 ]

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
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 871c912860ed..d6a0ff68df41 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -23,6 +23,7 @@
 #include <linux/pvclock_gtod.h>
 #include <linux/compiler.h>
 #include <linux/audit.h>
+#include <linux/random.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
@@ -1326,8 +1327,10 @@ int do_settimeofday64(const struct timespec64 *ts)
 	/* Signal hrtimers about time change */
 	clock_was_set(CLOCK_SET_WALL);
 
-	if (!ret)
+	if (!ret) {
 		audit_tk_injoffset(ts_delta);
+		add_device_randomness(ts, sizeof(*ts));
+	}
 
 	return ret;
 }
@@ -2413,6 +2416,7 @@ int do_adjtimex(struct __kernel_timex *txc)
 	ret = timekeeping_validate_timex(txc);
 	if (ret)
 		return ret;
+	add_device_randomness(txc, sizeof(*txc));
 
 	if (txc->modes & ADJ_SETOFFSET) {
 		struct timespec64 delta;
@@ -2430,6 +2434,7 @@ int do_adjtimex(struct __kernel_timex *txc)
 	audit_ntp_init(&ad);
 
 	ktime_get_real_ts64(&ts);
+	add_device_randomness(&ts, sizeof(ts));
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&tk_core.seq);
-- 
2.35.1



