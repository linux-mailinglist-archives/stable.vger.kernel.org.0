Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDB9DE81B
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 11:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfJUJcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 05:32:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34070 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfJUJcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 05:32:39 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iMU3B-0005rj-Ie; Mon, 21 Oct 2019 11:32:29 +0200
Date:   Mon, 21 Oct 2019 11:32:29 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@kernel.org>
cc:     Huacai Chen <chenhc@lemote.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] lib/vdso: Use __arch_use_vsyscall() to indicate
 fallback
In-Reply-To: <CALCETrXik5bzj-jQyHgqkzXqhYVJzedyD6WqBS+m+zmzKzCcDQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1910211027540.1904@nanos.tec.linutronix.de>
References: <1571367619-13573-1-git-send-email-chenhc@lemote.com> <CALCETrWXRgkQOJGRqa_sOLAG2zhjsEX6b86T2VTsNYN9ECRrtA@mail.gmail.com> <CAAhV-H6VkW5-hMOrzAQeyHT4pYGExZR6eTRbPHSPK50GAkigCw@mail.gmail.com> <alpine.DEB.2.21.1910191156240.2098@nanos.tec.linutronix.de>
 <CALCETrXik5bzj-jQyHgqkzXqhYVJzedyD6WqBS+m+zmzKzCcDQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 20 Oct 2019, Andy Lutomirski wrote:
> On Sat, Oct 19, 2019 at 3:01 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> > __arch_use_vsyscall() is a pointless exercise TBH. The VDSO data should be
> > updated unconditionally so all the trivial interfaces like time() and
> > getres() just work independently of the functions which depend on the
> > underlying clocksource.
> >
> > This functions have a fallback operation already:
> >
> > Let __arch_get_hw_counter() return U64_MAX and the syscall fallback is
> > invoked.
> >
> 
> My thought was that __arch_get_hw_counter() could return last-1 to
> indicate failure, which would allow the two checks to be folded into
> one check.  Or we could continue to use U64_MAX and rely on the fact
> that (s64)U64_MAX < 0, not worry about the cycle counter overflowing,
> and letting cycles < last catch it.

This is not an overflow catch. It's solely to deal with the fact that on
X86 you can observe (cycles < last) on multi socket systems under rare
circumstances. Any other architecture does not have that issue AFAIK.

The wraparound of clocksources with a smaller width than 64bit is handled
by:

    delta = (cycles - last) & mask;

which operates on unsigned values for obvious reasons.

> (And we should change it to return s64 at some point regardless -- all
> the math is signed, so the underlying types should be too IMO.)

See above. delta is guaranteed to be >= 0 and the mult/shift is not signed
either. All the base values which are in the VDSO are unsigned as well.

The weird typecast there:

    if ((s64)cycles < 0)

could as well be

    if (cycles == U64_MAX)

but the typecasted version creates better code.

I tried to fold the two operations (see patch below) and on all machines I
tested on (various generations of Intel and AMD) the result is slower than
what we have now by a couple of cycles, which is a lot for these functions
(i.e. between 3-5%). I'm sure I tried that before and ended up with the
existing code as the fastest variant.

Why? That's subject to speculation :)

Thanks,

	tglx

8<----------
 arch/x86/include/asm/vdso/gettimeofday.h |   39 ++++++-------------------------
 lib/vdso/gettimeofday.c                  |   23 +++---------------
 2 files changed, 13 insertions(+), 49 deletions(-)

--- a/arch/x86/include/asm/vdso/gettimeofday.h
+++ b/arch/x86/include/asm/vdso/gettimeofday.h
@@ -235,10 +235,14 @@ static u64 vread_hvclock(void)
 }
 #endif
 
-static inline u64 __arch_get_hw_counter(s32 clock_mode)
+static inline u64 __arch_get_hw_counter(s32 clock_mode, u64 last, u64 mask)
 {
+	/*
+	 * Mask operation is not required as all VDSO clocksources are
+	 * 64bit wide.
+	 */
 	if (clock_mode == VCLOCK_TSC)
-		return (u64)rdtsc_ordered();
+		return (u64)rdtsc_ordered() - last;
 	/*
 	 * For any memory-mapped vclock type, we need to make sure that gcc
 	 * doesn't cleverly hoist a load before the mode check.  Otherwise we
@@ -248,13 +252,13 @@ static inline u64 __arch_get_hw_counter(
 #ifdef CONFIG_PARAVIRT_CLOCK
 	if (clock_mode == VCLOCK_PVCLOCK) {
 		barrier();
-		return vread_pvclock();
+		return vread_pvclock() - last;
 	}
 #endif
 #ifdef CONFIG_HYPERV_TIMER
 	if (clock_mode == VCLOCK_HVCLOCK) {
 		barrier();
-		return vread_hvclock();
+		return vread_hvclock() - last;
 	}
 #endif
 	return U64_MAX;
@@ -265,33 +269,6 @@ static __always_inline const struct vdso
 	return __vdso_data;
 }
 
-/*
- * x86 specific delta calculation.
- *
- * The regular implementation assumes that clocksource reads are globally
- * monotonic. The TSC can be slightly off across sockets which can cause
- * the regular delta calculation (@cycles - @last) to return a huge time
- * jump.
- *
- * Therefore it needs to be verified that @cycles are greater than
- * @last. If not then use @last, which is the base time of the current
- * conversion period.
- *
- * This variant also removes the masking of the subtraction because the
- * clocksource mask of all VDSO capable clocksources on x86 is U64_MAX
- * which would result in a pointless operation. The compiler cannot
- * optimize it away as the mask comes from the vdso data and is not compile
- * time constant.
- */
-static __always_inline
-u64 vdso_calc_delta(u64 cycles, u64 last, u64 mask, u32 mult)
-{
-	if (cycles > last)
-		return (cycles - last) * mult;
-	return 0;
-}
-#define vdso_calc_delta vdso_calc_delta
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_VDSO_GETTIMEOFDAY_H */
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -26,34 +26,21 @@
 #include <asm/vdso/gettimeofday.h>
 #endif /* ENABLE_COMPAT_VDSO */
 
-#ifndef vdso_calc_delta
-/*
- * Default implementation which works for all sane clocksources. That
- * obviously excludes x86/TSC.
- */
-static __always_inline
-u64 vdso_calc_delta(u64 cycles, u64 last, u64 mask, u32 mult)
-{
-	return ((cycles - last) & mask) * mult;
-}
-#endif
-
 static int do_hres(const struct vdso_data *vd, clockid_t clk,
 		   struct __kernel_timespec *ts)
 {
 	const struct vdso_timestamp *vdso_ts = &vd->basetime[clk];
-	u64 cycles, last, sec, ns;
+	u64 delta, sec, ns;
 	u32 seq;
 
 	do {
 		seq = vdso_read_begin(vd);
-		cycles = __arch_get_hw_counter(vd->clock_mode);
-		ns = vdso_ts->nsec;
-		last = vd->cycle_last;
-		if (unlikely((s64)cycles < 0))
+		delta = __arch_get_hw_counter(vd->clock_mode, vd->cycle_last,
+					      vd->mask);
+		if (unlikely((s64)delta < 0))
 			return -1;
 
-		ns += vdso_calc_delta(cycles, last, vd->mask, vd->mult);
+		ns = vdso_ts->nsec + delta * vd->mult;
 		ns >>= vd->shift;
 		sec = vdso_ts->sec;
 	} while (unlikely(vdso_read_retry(vd, seq)));




