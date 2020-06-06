Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989AC1F0AA8
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 11:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgFGJgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 05:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgFGJgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 05:36:06 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137EFC08C5C2;
        Sun,  7 Jun 2020 02:36:06 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jhrih-0000KB-7L; Sun, 07 Jun 2020 11:35:59 +0200
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 6E173FF805;
        Sun,  7 Jun 2020 11:35:58 +0200 (CEST)
Message-Id: <20200606221531.963970768@linutronix.de>
User-Agent: quilt/0.65
Date:   Sat, 06 Jun 2020 23:51:16 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, x86@kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        stable@vger.kernel.org
Subject: [patch 2/3] lib/vdso: Provide sanity check for cycles (again)
References: <20200606215114.380723277@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The original x86 VDSO implementation checked for the validity of the clock
source read by testing whether the returned signed cycles value is less
than zero. This check was also used by the vdso read function to signal
that the current selected clocksource is not VDSO capable.

During the rework of the VDSO code the check was removed and replaced with
a check for the clocksource mode being != NONE.

This turned out to be a mistake because the check is necessary for paravirt
and hyperv clock sources. The reason is that these clock sources have their
own internal sequence counter to validate the clocksource at the point of
reading it. This is necessary because the hypervisor can invalidate the
clocksource asynchronously so a check during the VDSO data update is not
sufficient. Having a separate indicator for the validity is slower than
just validating the cycles value. The check for it being negative turned
out to be the fastest implementation and safe as it would require an uptime
of ~73 years with a 4GHz counter frequency to result in a false positive.

Add an optional function to validate the cycles with a default
implementation which allows the compiler to optimize it out for
architectures which do not require it.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Fixes: 5d51bee725cc ("clocksource: Add common vdso clock mode storage")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 lib/vdso/gettimeofday.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -38,6 +38,13 @@ static inline bool vdso_clocksource_ok(c
 }
 #endif
 
+#ifndef vdso_cycles_ok
+static inline bool vdso_cycles_ok(u64 cycles)
+{
+	return true;
+}
+#endif
+
 #ifdef CONFIG_TIME_NS
 static int do_hres_timens(const struct vdso_data *vdns, clockid_t clk,
 			  struct __kernel_timespec *ts)
@@ -62,6 +69,8 @@ static int do_hres_timens(const struct v
 			return -1;
 
 		cycles = __arch_get_hw_counter(vd->clock_mode);
+		if (unlikely(!vdso_cycles_ok(cycles)))
+			return -1;
 		ns = vdso_ts->nsec;
 		last = vd->cycle_last;
 		ns += vdso_calc_delta(cycles, last, vd->mask, vd->mult);
@@ -130,6 +139,8 @@ static __always_inline int do_hres(const
 			return -1;
 
 		cycles = __arch_get_hw_counter(vd->clock_mode);
+		if (unlikely(!vdso_cycles_ok(cycles)))
+			return -1;
 		ns = vdso_ts->nsec;
 		last = vd->cycle_last;
 		ns += vdso_calc_delta(cycles, last, vd->mask, vd->mult);

