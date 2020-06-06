Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5081F0AAC
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 11:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgFGJgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 05:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgFGJgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 05:36:07 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA65FC08C5C2;
        Sun,  7 Jun 2020 02:36:06 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jhrii-0000LD-62; Sun, 07 Jun 2020 11:36:00 +0200
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id A89A110108F;
        Sun,  7 Jun 2020 11:35:59 +0200 (CEST)
Message-Id: <20200606221532.080560273@linutronix.de>
User-Agent: quilt/0.65
Date:   Sat, 06 Jun 2020 23:51:17 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, x86@kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        stable@vger.kernel.org
Subject: [patch 3/3] x86/vdso: Unbreak paravirt VDSO clocks
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

The conversion of x86 VDSO to the generic clock mode storage broke the
paravirt and hyperv clocksource logic. These clock sources have their own
internal sequence counter to validate the clocksource at the point of
reading it. This is necessary because the hypervisor can invalidate the
clocksource asynchronously so a check during the VDSO data update is not
sufficient. If the internal check during read invalidates the clocksource
the read return U64_MAX. The original code checked this efficiently by
testing whether the result (casted to signed) is negative, i.e. bit 63 is
set. This was done that way because an extra indicator for the validity had
more overhead.

The conversion broke this check because the check was replaced by a check
for a valid VDSO clock mode.

The wreckage manifests itself when the paravirt clock is installed as a
valid VDSO clock and during runtime invalidated by the hypervisor,
e.g. after a host suspend/resume cycle. After the invalidation the read
function returns U64_MAX which is used as cycles and makes the clock jump
by ~2200 seconds, and become stale until the 2200 seconds have elapsed
where it starts to jump again. The period of this effect depends on the
shift/mult pair of the clocksource and the jumps and staleness are an
artifact of undefined but reproducible behaviour of math overflow.

Implement an x86 version of the new vdso_cycles_ok() inline which adds this
check back and a variant of vdso_clocksource_ok() which lets the compiler
optimize it out to avoid the extra conditional. That's suboptimal when the
system does not have a VDSO capable clocksource, but that's not the case
which is optimized for.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Fixes: 5d51bee725cc ("clocksource: Add common vdso clock mode storage")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 arch/x86/include/asm/vdso/gettimeofday.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/arch/x86/include/asm/vdso/gettimeofday.h
+++ b/arch/x86/include/asm/vdso/gettimeofday.h
@@ -271,6 +271,24 @@ static __always_inline const struct vdso
 	return __vdso_data;
 }
 
+static inline bool arch_vdso_clocksource_ok(const struct vdso_data *vd)
+{
+	return true;
+}
+#define vdso_clocksource_ok arch_vdso_clocksource_ok
+
+/*
+ * Clocksource read value validation to handle PV and HyperV clocksources
+ * which can be invalidated asynchronously and indicate invalidation by
+ * returning U64_MAX, which can be effectively tested by checking for a
+ * negative value after casting it to s64.
+ */
+static inline bool arch_vdso_cycles_ok(u64 cycles)
+{
+	return (s64)cycles >= 0;
+}
+#define vdso_cycles_ok arch_vdso_cycles_ok
+
 /*
  * x86 specific delta calculation.
  *

