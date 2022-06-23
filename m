Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9C05583DC
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiFWRg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiFWRgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:36:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE03517DB;
        Thu, 23 Jun 2022 10:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8130C61408;
        Thu, 23 Jun 2022 17:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C65C3411B;
        Thu, 23 Jun 2022 17:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003988;
        bh=EDaFSoEVfixfh5sPbNxskDPOh1gkpNtxrkKnRYcrl/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNGMRNN/WrYAdW39A96bD7XHe+MDTQdq7oYuU9ugp5UPHhDGFAmKVi0D82tiyz7QD
         7/Z9G/X+xlMBZclIJ5vwIbgUzhqtAb9O5BlnxuXkfC8UCb1TA6Z2JaLvg+MeaUom2d
         CfRVhF7/CgvNlIoq3jgsCojOa7rNYr6dGsdc6+J8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 153/237] timekeeping: Add raw clock fallback for random_get_entropy()
Date:   Thu, 23 Jun 2022 18:43:07 +0200
Message-Id: <20220623164347.557675518@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 1366992e16bddd5e2d9a561687f367f9f802e2e4 upstream.

The addition of random_get_entropy_fallback() provides access to
whichever time source has the highest frequency, which is useful for
gathering entropy on platforms without available cycle counters. It's
not necessarily as good as being able to quickly access a cycle counter
that the CPU has, but it's still something, even when it falls back to
being jiffies-based.

In the event that a given arch does not define get_cycles(), falling
back to the get_cycles() default implementation that returns 0 is really
not the best we can do. Instead, at least calling
random_get_entropy_fallback() would be preferable, because that always
needs to return _something_, even falling back to jiffies eventually.
It's not as though random_get_entropy_fallback() is super high precision
or guaranteed to be entropic, but basically anything that's not zero all
the time is better than returning zero all the time.

Finally, since random_get_entropy_fallback() is used during extremely
early boot when randomizing freelists in mm_init(), it can be called
before timekeeping has been initialized. In that case there really is
nothing we can do; jiffies hasn't even started ticking yet. So just give
up and return 0.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/timex.h     |    8 ++++++++
 kernel/time/timekeeping.c |   16 ++++++++++++++++
 2 files changed, 24 insertions(+)

--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -62,6 +62,8 @@
 #include <linux/types.h>
 #include <linux/param.h>
 
+unsigned long random_get_entropy_fallback(void);
+
 #include <asm/timex.h>
 
 #ifndef random_get_entropy
@@ -74,8 +76,14 @@
  *
  * By default we use get_cycles() for this purpose, but individual
  * architectures may override this in their asm/timex.h header file.
+ * If a given arch does not have get_cycles(), then we fallback to
+ * using random_get_entropy_fallback().
  */
+#ifdef get_cycles
 #define random_get_entropy()	((unsigned long)get_cycles())
+#else
+#define random_get_entropy()	random_get_entropy_fallback()
+#endif
 #endif
 
 /*
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -21,6 +21,7 @@
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
+#include <linux/timex.h>
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 #include <linux/pvclock_gtod.h>
@@ -2248,6 +2249,21 @@ ktime_t ktime_get_update_offsets_now(uns
 }
 
 /**
+ * random_get_entropy_fallback - Returns the raw clock source value,
+ * used by random.c for platforms with no valid random_get_entropy().
+ */
+unsigned long random_get_entropy_fallback(void)
+{
+	struct tk_read_base *tkr = &tk_core.timekeeper.tkr_mono;
+	struct clocksource *clock = READ_ONCE(tkr->clock);
+
+	if (unlikely(timekeeping_suspended || !clock))
+		return 0;
+	return clock->read(clock);
+}
+EXPORT_SYMBOL_GPL(random_get_entropy_fallback);
+
+/**
  * do_adjtimex() - Accessor function to NTP __do_adjtimex function
  */
 int do_adjtimex(struct timex *txc)


