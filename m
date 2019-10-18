Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2C3DBC15
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 06:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404301AbfJREz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 00:55:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32939 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfJREz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 00:55:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so3088576pfl.0;
        Thu, 17 Oct 2019 21:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=ucTp4pYNsoXIVC4j9OusGhsOmcXWf7rr6MoAdvFKtu4=;
        b=CfRbqYmycchsM1bJlVBRGEXaNsWo9LlbTr2NcLF7r1E4npsvAZAH5jd4uh3EpePLd5
         ufr+cUV7VAX39CfjOthSGrd8LF6VP60ThHzbx7hhKguPAUPX3VFIQ5DSNZjjGtsX8Az9
         fyL5HFvwPvE4/BpTzU/czRQaKcUE5AZPsxtj5m6ILQftjNw5CmEbccaSjS4jVzmEtuJS
         Di6XKPjFXwR4+vVOK5SO4TzIQ/ANsljiFWP8dsFftOju0dwfTqqn18Ivjcq5QCsittKl
         +OW7o1R7IXY7w2qGgF5hzwCF4gCWh5CxiIRIQWu3jt3XR3GRw7xlxvRbun6FKx6qwgof
         zSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=ucTp4pYNsoXIVC4j9OusGhsOmcXWf7rr6MoAdvFKtu4=;
        b=PD5OLkAOB64o/kBfg44Zlsz9+TtqBM3IlhP5mPNzVJgIOxIuVMqaqjnB+m79JYIJ8U
         Stng45FZfa8wFObE6C71f/NxmhNSCPG7GAyoLzX1uVFJrugrNQivFlEqxwht8s2dvOo2
         psDrt47Kl2mThmjqJ/AWruUgMg3fnGq4cZxRy2dsE4iwTSD2l7lwdaFK7QSS3IFHdZhG
         RaqLfWRk53Kc+s+DwcWNFPrmMdR0jSYqPfOR1rjxrMQdYgpvls+EBXIIueFr93fzUYuI
         dtINcsW+vBu7GbBw741rSUxn9KH31IRF821G2nqpV58E8dZctABnyIQjd6NlDb3WqYFh
         eAAw==
X-Gm-Message-State: APjAAAXv+zRIGGoSr22PX6zHzgPQ8LIxfA9GKMkSHgSfvY2aeIb7qsWb
        t+KnuoWSBPb3ekPoLPoW0xtnrn8h+vg=
X-Google-Smtp-Source: APXvYqy96D31GFo6gGMu/neDxNH+1DxPMLtYZjXD3nhnD1h0yzdmy0NM2aKr4ORijlMkp8mxDhk3lA==
X-Received: by 2002:a17:90a:80c2:: with SMTP id k2mr8322228pjw.92.1571367467557;
        Thu, 17 Oct 2019 19:57:47 -0700 (PDT)
Received: from software.domain.org ([66.42.68.162])
        by smtp.gmail.com with ESMTPSA id a7sm3451692pjv.0.2019.10.17.19.57.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 17 Oct 2019 19:57:46 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        chenhuacai@gmail.com, linux-kernel@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] lib/vdso: Use __arch_use_vsyscall() to indicate fallback
Date:   Fri, 18 Oct 2019 11:00:19 +0800
Message-Id: <1571367619-13573-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In do_hres(), we currently use whether the return value of __arch_get_
hw_counter() is negtive to indicate fallback, but this is not a good
idea. Because:

1, ARM64 returns ULL_MAX but MIPS returns 0 when clock_mode is invalid;
2, For a 64bit counter, a "negtive" value of counter is actually valid.

To solve this problem, we use U64_MAX as the only "invalid" return
value -- this is still not fully correct, but has no problem in most
cases. Moreover, all vdso time-related functions should rely on the
return value of __arch_use_vsyscall(), because update_vdso_data() and
update_vsyscall_tz() also rely on it. So, in the core functions of
__cvdso_gettimeofday(), __cvdso_clock_gettime() and __cvdso_clock_
getres(), if __arch_use_vsyscall() returns false, we use the fallback
functions directly.

Fixes: 00b26474c2f1613d7ab894c5 ("lib/vdso: Provide generic VDSO implementation")
Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/arm64/include/asm/vdso/vsyscall.h |  2 +-
 arch/mips/include/asm/vdso/vsyscall.h  |  2 +-
 include/asm-generic/vdso/vsyscall.h    |  2 +-
 lib/vdso/gettimeofday.c                | 12 +++++++++++-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/vdso/vsyscall.h b/arch/arm64/include/asm/vdso/vsyscall.h
index 0c731bf..406e6de 100644
--- a/arch/arm64/include/asm/vdso/vsyscall.h
+++ b/arch/arm64/include/asm/vdso/vsyscall.h
@@ -31,7 +31,7 @@ int __arm64_get_clock_mode(struct timekeeper *tk)
 #define __arch_get_clock_mode __arm64_get_clock_mode
 
 static __always_inline
-int __arm64_use_vsyscall(struct vdso_data *vdata)
+int __arm64_use_vsyscall(const struct vdso_data *vdata)
 {
 	return !vdata[CS_HRES_COARSE].clock_mode;
 }
diff --git a/arch/mips/include/asm/vdso/vsyscall.h b/arch/mips/include/asm/vdso/vsyscall.h
index 1953147..8b10dd7 100644
--- a/arch/mips/include/asm/vdso/vsyscall.h
+++ b/arch/mips/include/asm/vdso/vsyscall.h
@@ -29,7 +29,7 @@ int __mips_get_clock_mode(struct timekeeper *tk)
 #define __arch_get_clock_mode __mips_get_clock_mode
 
 static __always_inline
-int __mips_use_vsyscall(struct vdso_data *vdata)
+int __mips_use_vsyscall(const struct vdso_data *vdata)
 {
 	return (vdata[CS_HRES_COARSE].clock_mode != VDSO_CLOCK_NONE);
 }
diff --git a/include/asm-generic/vdso/vsyscall.h b/include/asm-generic/vdso/vsyscall.h
index e94b1978..ac05a625 100644
--- a/include/asm-generic/vdso/vsyscall.h
+++ b/include/asm-generic/vdso/vsyscall.h
@@ -26,7 +26,7 @@ static __always_inline int __arch_get_clock_mode(struct timekeeper *tk)
 #endif /* __arch_get_clock_mode */
 
 #ifndef __arch_use_vsyscall
-static __always_inline int __arch_use_vsyscall(struct vdso_data *vdata)
+static __always_inline int __arch_use_vsyscall(const struct vdso_data *vdata)
 {
 	return 1;
 }
diff --git a/lib/vdso/gettimeofday.c b/lib/vdso/gettimeofday.c
index e630e7f..4ad062e 100644
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -9,6 +9,7 @@
 #include <linux/hrtimer_defs.h>
 #include <vdso/datapage.h>
 #include <vdso/helpers.h>
+#include <vdso/vsyscall.h>
 
 /*
  * The generic vDSO implementation requires that gettimeofday.h
@@ -50,7 +51,7 @@ static int do_hres(const struct vdso_data *vd, clockid_t clk,
 		cycles = __arch_get_hw_counter(vd->clock_mode);
 		ns = vdso_ts->nsec;
 		last = vd->cycle_last;
-		if (unlikely((s64)cycles < 0))
+		if (unlikely(cycles == U64_MAX))
 			return -1;
 
 		ns += vdso_calc_delta(cycles, last, vd->mask, vd->mult);
@@ -91,6 +92,9 @@ __cvdso_clock_gettime_common(clockid_t clock, struct __kernel_timespec *ts)
 	if (unlikely((u32) clock >= MAX_CLOCKS))
 		return -1;
 
+	if (!__arch_use_vsyscall(vd))
+		return -1;
+
 	/*
 	 * Convert the clockid to a bitmask and use it to check which
 	 * clocks are handled in the VDSO directly.
@@ -145,6 +149,9 @@ __cvdso_gettimeofday(struct __kernel_old_timeval *tv, struct timezone *tz)
 {
 	const struct vdso_data *vd = __arch_get_vdso_data();
 
+	if (!__arch_use_vsyscall(vd))
+		return gettimeofday_fallback(tv, tz);
+
 	if (likely(tv != NULL)) {
 		struct __kernel_timespec ts;
 
@@ -189,6 +196,9 @@ int __cvdso_clock_getres_common(clockid_t clock, struct __kernel_timespec *res)
 	if (unlikely((u32) clock >= MAX_CLOCKS))
 		return -1;
 
+	if (!__arch_use_vsyscall(vd))
+		return -1;
+
 	hrtimer_res = READ_ONCE(vd[CS_HRES_COARSE].hrtimer_res);
 	/*
 	 * Convert the clockid to a bitmask and use it to check which
-- 
2.7.0

