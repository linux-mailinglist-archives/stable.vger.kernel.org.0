Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E744D1F3E71
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 16:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgFIOka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 10:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgFIOk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 10:40:29 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DE3C03E97C;
        Tue,  9 Jun 2020 07:40:28 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jifQO-0002o7-Q2; Tue, 09 Jun 2020 16:40:24 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 566CA1C0475;
        Tue,  9 Jun 2020 16:40:24 +0200 (CEST)
Date:   Tue, 09 Jun 2020 14:40:24 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] lib/vdso: Provide sanity check for cycles (again)
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200606221531.963970768@linutronix.de>
References: <20200606221531.963970768@linutronix.de>
MIME-Version: 1.0
Message-ID: <159171362421.17951.3918218703556245648.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     72ce778007e57e8996b4bebdec738fc5e1145fd2
Gitweb:        https://git.kernel.org/tip/72ce778007e57e8996b4bebdec738fc5e1145fd2
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Sat, 06 Jun 2020 23:51:16 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 Jun 2020 16:36:48 +02:00

lib/vdso: Provide sanity check for cycles (again)

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

Fixes: 5d51bee725cc ("clocksource: Add common vdso clock mode storage")
Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200606221531.963970768@linutronix.de

---
 lib/vdso/gettimeofday.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/vdso/gettimeofday.c b/lib/vdso/gettimeofday.c
index a2909af..3bb82a6 100644
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -38,6 +38,13 @@ static inline bool vdso_clocksource_ok(const struct vdso_data *vd)
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
@@ -62,6 +69,8 @@ static int do_hres_timens(const struct vdso_data *vdns, clockid_t clk,
 			return -1;
 
 		cycles = __arch_get_hw_counter(vd->clock_mode);
+		if (unlikely(!vdso_cycles_ok(cycles)))
+			return -1;
 		ns = vdso_ts->nsec;
 		last = vd->cycle_last;
 		ns += vdso_calc_delta(cycles, last, vd->mask, vd->mult);
@@ -130,6 +139,8 @@ static __always_inline int do_hres(const struct vdso_data *vd, clockid_t clk,
 			return -1;
 
 		cycles = __arch_get_hw_counter(vd->clock_mode);
+		if (unlikely(!vdso_cycles_ok(cycles)))
+			return -1;
 		ns = vdso_ts->nsec;
 		last = vd->cycle_last;
 		ns += vdso_calc_delta(cycles, last, vd->mask, vd->mult);
