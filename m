Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E6D592E68
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiHOLr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiHOLr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:47:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6D8BF5C
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:47:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35998B80E23
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A86C433D6;
        Mon, 15 Aug 2022 11:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660564045;
        bh=MieFFeDIo3SmRcRyFpA4uIwYEp3CItY6L3h/jT1RlPQ=;
        h=Subject:To:Cc:From:Date:From;
        b=c8pY00C47sjzTjnil6Lz9wQYcryC7oclsqUkJcTIuKZ4f5+geBk4q06GKhoF9lTCP
         gdtUAX08ZHqFxcePlaBK+k60HpRAbediF3HNZ9mUHJk9nI2h8TepGZiQM5i+3Sr42E
         8DlaC80HhC54v58ipCAamYj1pI5iDgYw8x9lwFwo=
Subject: FAILED: patch "[PATCH] timekeeping: contribute wall clock to rng on time change" failed to apply to 4.9-stable tree
To:     Jason@zx2c4.com, ebiggers@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:47:13 +0200
Message-ID: <16605640331186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b8ac29b40183a6038919768b5d189c9bd91ce9b4 Mon Sep 17 00:00:00 2001
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sun, 17 Jul 2022 23:53:34 +0200
Subject: [PATCH] timekeeping: contribute wall clock to rng on time change

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

