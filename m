Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60CA145813
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 15:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgAVOpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 09:45:32 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:38054 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVOpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 09:45:31 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iuHFy-0007Es-Ar; Wed, 22 Jan 2020 15:45:22 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 05AB3101F92; Wed, 22 Jan 2020 15:45:21 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     vipul kumar <vipulk0511@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Bin Gao <bin.gao@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC
In-Reply-To: <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com> <87eevs7lfd.fsf@nanos.tec.linutronix.de> <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com>
Date:   Wed, 22 Jan 2020 15:45:21 +0100
Message-ID: <878slzeeim.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vipul,

vipul kumar <vipulk0511@gmail.com> writes:
> On Tue, Jan 21, 2020 at 11:15 PM Thomas Gleixner <tglx@linutronix.de> wrote:

>    Measurement with the existing code:
>    $ echo -n "SystemTime: " ; TZ=UTC date -Iseconds ; echo -n "RTC Time:
> " ; TZ=UTC hwclock -r ; echo -n "Uptime: " ; uptime -p
>    SystemTime: 2019-12-05T17:18:37+00:00
>    RTC Time:   2019-12-05 17:18:07.255341+0000
>    Uptime: up 1 day, 7 minutes
>
>    This sample shows a difference of 30 seconds after 1 day.
>
>    Measurement with this patch:
>    SystemTime: 2019-12-11T12:06:19+00:00
>    RTC Time:   2019-12-11 12:06:19.083127+0000
>    Uptime: up 1 day, 3 minutes
>
>    With this patch, no time drift issue is observed. and tsc clocksource
> get calibration (tsc: Refined TSC clocksource calibration: 1833.333 MHz)
> which is missing
>    with the existing implementation.

What's the frequency which is determined from the MSR? Something like
this in dmesg:

       tsc: Detected NNN MHz processor
or
       tsc: Detected NNN MHz TSC

Also please apply the debug patch below and provide a _full_ dmesg after
boot.

>> > +config X86_FEATURE_TSC_UNKNOWN_FREQ
>> > +     bool "Support to skip tsc known frequency flag"
>> > +     help
>> > +       Include support to skip X86_FEATURE_TSC_KNOWN_FREQ flag
>> > +
>> > +       X86_FEATURE_TSC_KNOWN_FREQ flag is causing time-drift on
>> Valleyview/
>> > +       Baytrail SoC.
>> > +       By selecting this option, user can skip
>> X86_FEATURE_TSC_KNOWN_FREQ
>> > +       flag to use refine tsc freq calibration.
>>
>> This is exactly the same problem as before. How does anyone aside of you
>> know whether to enable this or not?
>>
>     Go through the Documentation/kbuild/kconfig-language.rst but didn't
> find related to make
>     config known to everyone. Could you please point to documentation?

Right. And there is no proper answer to this, which makes it clear that
a config option is not the right tool to use.

>> And if someone enables this option then _ALL_ platforms which utilize
>> cpu_khz_from_msr() are affected. How is that any different from your
>> previous approach? This works on local kernels where you build for a
>> specific platform and you know exactly what you're doing, but not for
>> general consumption. What should a distro do with this option?
>>
>>
>     TSC frequency is already calculated in cpu_khz_from_msr() function
> before setting these flags.

Your mail client does some horrible formatting this zig-zag is
unreadable. I'm reformatting the paragraphs below.

> This patch return the same calculated TSC frequency but skipping
> those two flags. On the basis of these flags, we decide whether we
> skip the refined calibration and directly register it as a clocksource
> or use refine tsc freq calibration in init_tsc_clocksource()
> function. By default this config is disabled and if user wants to use
> refine tsc freq calibration() then only user will enable it otherwise
> it will go with existing implementations. So, I don't think so it will
> break for other ATOM SoC.

It does. I explained most of the following to you in an earlier mail
already. Let me try again.

If X86_FEATURE_TSC_RELIABLE is not set, then the TSC requires a watchdog
clocksource. But some of those SoCs do not have anything else than TSC,
so there is no watchdog available. As a consequence the TSC is not
usable for high resolution timers and NOHZ. That breaks existing systems
whether you like it or not.

If X86_FEATURE_TSC_KNOWN_FREQUENCY is not set, then this delays the
usability of the TSC for high res and NOHZ until the refined calibration
figured out that it can't calibrate. And no, we can't know that it does
not work upfront when the early TSC init happens. Clearing this flag
will not break functionality, but it changes the behaviour on boot-time
optimized systems which can obviously be considered breakage.

So no, having a config knob which might be turned on and turning working
systems into trainwrecks is simply not the way to go.

What can be done is to have a command line option which enforces refined
calibration and that option can turn off X86_FEATURE_TSC_KNOWN_FREQUENCY,
but nothing else.

> Check the cpu_khz_from_msr() function.

I know that code.

> In cpu_khz_from_msr() function we are setting
> X86_FEATURE_TSC_KNOWN_FREQ and X86_FEATURE_TSC_RELIABLE for all the
> SoC's but in native_calibrate_tsc(), we check for vendor == INTEL and
> CPUID > 0x15 and then at the end of function, will enable
> X86_FEATURE_TSC_RELIABLE for INTEL_FAM6_ATOM_GOLDMONT SoC.
>
> Do we need to set the same flag in two different functions as it will be
> set in cpu_khz_from_msr() for all SoCs ?

cpu_khz_from_msr() does not handle INTEL_FAM6_ATOM_GOLDMONT or can you
find that in tsc_msr_cpu_ids[]? Making half informed claims is not
solving anything.

Thanks,

        tglx

8<------------------

--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -94,16 +94,20 @@ unsigned long cpu_khz_from_msr(void)
 	if (freq_desc->msr_plat) {
 		rdmsr(MSR_PLATFORM_INFO, lo, hi);
 		ratio = (lo >> 8) & 0xff;
+		pr_info("MSR_PINFO: %08x%08x -> %u\n", hi, lo, ratio);
 	} else {
 		rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
 		ratio = (hi >> 8) & 0x1f;
+		pr_info("MSR_PSTAT: %08x%08x -> %u\n", hi, lo, ratio);
 	}
 
 	/* Get FSB FREQ ID */
 	rdmsr(MSR_FSB_FREQ, lo, hi);
+	pr_info("MSR_FSBF: %08x%08x\n", hi, lo);
 
 	/* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz) */
 	freq = freq_desc->freqs[lo & 0x7];
+	pr_info("REF_CLOCK: %08x\n", freq);
 
 	/* TSC frequency = maximum resolved freq * maximum resolved bus ratio */
 	res = freq * ratio;
