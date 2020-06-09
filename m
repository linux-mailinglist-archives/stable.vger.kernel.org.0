Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0CA1F3E77
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 16:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgFIOkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 10:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730569AbgFIOke (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 10:40:34 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414B0C05BD1E;
        Tue,  9 Jun 2020 07:40:31 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jifQO-0002o6-Dq; Tue, 09 Jun 2020 16:40:24 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id D80CD1C007F;
        Tue,  9 Jun 2020 16:40:23 +0200 (CEST)
Date:   Tue, 09 Jun 2020 14:40:23 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/vdso: Unbreak paravirt VDSO clocks
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200606221532.080560273@linutronix.de>
References: <20200606221532.080560273@linutronix.de>
MIME-Version: 1.0
Message-ID: <159171362368.17951.5578339673051850079.tip-bot2@tip-bot2>
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

Commit-ID:     7778d8417b74aded842eeb372961cfc460417fa0
Gitweb:        https://git.kernel.org/tip/7778d8417b74aded842eeb372961cfc460417fa0
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Sat, 06 Jun 2020 23:51:17 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 Jun 2020 16:36:49 +02:00

x86/vdso: Unbreak paravirt VDSO clocks

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

Fixes: 5d51bee725cc ("clocksource: Add common vdso clock mode storage")
Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200606221532.080560273@linutronix.de

---
 arch/x86/include/asm/vdso/gettimeofday.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/vdso/gettimeofday.h b/arch/x86/include/asm/vdso/gettimeofday.h
index 9a6dc9b..fb81fea 100644
--- a/arch/x86/include/asm/vdso/gettimeofday.h
+++ b/arch/x86/include/asm/vdso/gettimeofday.h
@@ -271,6 +271,24 @@ static __always_inline const struct vdso_data *__arch_get_vdso_data(void)
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
