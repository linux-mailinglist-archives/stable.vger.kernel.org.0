Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31265EEDD2
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbfKDWKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:10:21 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39015 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390504AbfKDWKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 17:10:20 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iRkY0-0007oR-Jh; Mon, 04 Nov 2019 23:10:04 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id DEDDE1C0017;
        Mon,  4 Nov 2019 23:10:03 +0100 (CET)
Date:   Mon, 04 Nov 2019 22:10:03 -0000
From:   "tip-bot2 for Huacai Chen" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] timekeeping/vsyscall: Update VDSO data unconditionally
Cc:     Huacai Chen <chenhc@lemote.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1571887709-11447-1-git-send-email-chenhc@lemote.com>
References: <1571887709-11447-1-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Message-ID: <157290540350.29376.5969235863179895531.tip-bot2@tip-bot2>
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

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     52338415cf4d4064ae6b8dd972dadbda841da4fa
Gitweb:        https://git.kernel.org/tip/52338415cf4d4064ae6b8dd972dadbda841da4fa
Author:        Huacai Chen <chenhc@lemote.com>
AuthorDate:    Thu, 24 Oct 2019 11:28:29 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 04 Nov 2019 23:02:53 +01:00

timekeeping/vsyscall: Update VDSO data unconditionally

The update of the VDSO data is depending on __arch_use_vsyscall() returning
True. This is a leftover from the attempt to map the features of various
architectures 1:1 into generic code.

The usage of __arch_use_vsyscall() in the actual vsyscall implementations
got dropped and replaced by the requirement for the architecture code to
return U64_MAX if the global clocksource is not usable in the VDSO.

But the __arch_use_vsyscall() check in the update code stayed which causes
the VDSO data to be stale or invalid when an architecture actually
implements that function and returns False when the current clocksource is
not usable in the VDSO.

As a consequence the VDSO implementations of clock_getres(), time(),
clock_gettime(CLOCK_.*_COARSE) operate on invalid data and return bogus
information.

Remove the __arch_use_vsyscall() check from the VDSO update function and
update the VDSO data unconditionally.

[ tglx: Massaged changelog and removed the now useless implementations in
  	asm-generic/ARM64/MIPS ]

Fixes: 44f57d788e7deecb50 ("timekeeping: Provide a generic update_vsyscall() implementation")
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1571887709-11447-1-git-send-email-chenhc@lemote.com
---
 arch/arm64/include/asm/vdso/vsyscall.h |  7 -------
 arch/mips/include/asm/vdso/vsyscall.h  |  7 -------
 include/asm-generic/vdso/vsyscall.h    |  7 -------
 kernel/time/vsyscall.c                 |  9 +++------
 4 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/vdso/vsyscall.h b/arch/arm64/include/asm/vdso/vsyscall.h
index 0c731bf..0c20a7c 100644
--- a/arch/arm64/include/asm/vdso/vsyscall.h
+++ b/arch/arm64/include/asm/vdso/vsyscall.h
@@ -31,13 +31,6 @@ int __arm64_get_clock_mode(struct timekeeper *tk)
 #define __arch_get_clock_mode __arm64_get_clock_mode
 
 static __always_inline
-int __arm64_use_vsyscall(struct vdso_data *vdata)
-{
-	return !vdata[CS_HRES_COARSE].clock_mode;
-}
-#define __arch_use_vsyscall __arm64_use_vsyscall
-
-static __always_inline
 void __arm64_update_vsyscall(struct vdso_data *vdata, struct timekeeper *tk)
 {
 	vdata[CS_HRES_COARSE].mask	= VDSO_PRECISION_MASK;
diff --git a/arch/mips/include/asm/vdso/vsyscall.h b/arch/mips/include/asm/vdso/vsyscall.h
index 1953147..00d41b9 100644
--- a/arch/mips/include/asm/vdso/vsyscall.h
+++ b/arch/mips/include/asm/vdso/vsyscall.h
@@ -28,13 +28,6 @@ int __mips_get_clock_mode(struct timekeeper *tk)
 }
 #define __arch_get_clock_mode __mips_get_clock_mode
 
-static __always_inline
-int __mips_use_vsyscall(struct vdso_data *vdata)
-{
-	return (vdata[CS_HRES_COARSE].clock_mode != VDSO_CLOCK_NONE);
-}
-#define __arch_use_vsyscall __mips_use_vsyscall
-
 /* The asm-generic header needs to be included after the definitions above */
 #include <asm-generic/vdso/vsyscall.h>
 
diff --git a/include/asm-generic/vdso/vsyscall.h b/include/asm-generic/vdso/vsyscall.h
index e94b197..ce41032 100644
--- a/include/asm-generic/vdso/vsyscall.h
+++ b/include/asm-generic/vdso/vsyscall.h
@@ -25,13 +25,6 @@ static __always_inline int __arch_get_clock_mode(struct timekeeper *tk)
 }
 #endif /* __arch_get_clock_mode */
 
-#ifndef __arch_use_vsyscall
-static __always_inline int __arch_use_vsyscall(struct vdso_data *vdata)
-{
-	return 1;
-}
-#endif /* __arch_use_vsyscall */
-
 #ifndef __arch_update_vsyscall
 static __always_inline void __arch_update_vsyscall(struct vdso_data *vdata,
 						   struct timekeeper *tk)
diff --git a/kernel/time/vsyscall.c b/kernel/time/vsyscall.c
index 4bc37ac..5ee0f77 100644
--- a/kernel/time/vsyscall.c
+++ b/kernel/time/vsyscall.c
@@ -110,8 +110,7 @@ void update_vsyscall(struct timekeeper *tk)
 	nsec		= nsec + tk->wall_to_monotonic.tv_nsec;
 	vdso_ts->sec	+= __iter_div_u64_rem(nsec, NSEC_PER_SEC, &vdso_ts->nsec);
 
-	if (__arch_use_vsyscall(vdata))
-		update_vdso_data(vdata, tk);
+	update_vdso_data(vdata, tk);
 
 	__arch_update_vsyscall(vdata, tk);
 
@@ -124,10 +123,8 @@ void update_vsyscall_tz(void)
 {
 	struct vdso_data *vdata = __arch_get_k_vdso_data();
 
-	if (__arch_use_vsyscall(vdata)) {
-		vdata[CS_HRES_COARSE].tz_minuteswest = sys_tz.tz_minuteswest;
-		vdata[CS_HRES_COARSE].tz_dsttime = sys_tz.tz_dsttime;
-	}
+	vdata[CS_HRES_COARSE].tz_minuteswest = sys_tz.tz_minuteswest;
+	vdata[CS_HRES_COARSE].tz_dsttime = sys_tz.tz_dsttime;
 
 	__arch_sync_vdso_data(vdata);
 }
