Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3E614C314
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 23:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgA1Wjr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 28 Jan 2020 17:39:47 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50122 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgA1Wjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 17:39:47 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iwZW5-0006jc-Dm; Tue, 28 Jan 2020 23:39:29 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 919CB101227; Tue, 28 Jan 2020 23:39:28 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Hans de Goede <hdegoede@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        vipul kumar <vipulk0511@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC
In-Reply-To: <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com> <87eevs7lfd.fsf@nanos.tec.linutronix.de> <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com> <878slzeeim.fsf@nanos.tec.linutronix.de> <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com> <20200123144108.GU32742@smile.fi.intel.com> <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com> <87iml11ccf.fsf@nanos.tec.linutronix.de> <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com> <87ftg5131x.fsf@nanos.tec.linutronix.de> <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com>
Date:   Tue, 28 Jan 2020 23:39:28 +0100
Message-ID: <87sgjz434v.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hans,

Hans de Goede <hdegoede@redhat.com> writes:
> Ok, I have been testing this on various devices and I'm pretty sure now
> that my initial hunch is correct. The problem is that the accuracy of
> the FSB frequency as listed in the Intel docs is not so great:

Thanks for doing that.

> The "Intel 64 and IA-32 Architectures Software Developer’s Manual Volume 4:
> Model-Specific Registers" has the following table for the values from
> freq_desc_byt:
>
>     000B: 083.3 MHz
>     001B: 100.0 MHz
>     010B: 133.3 MHz
>     011B: 116.7 MHz
>     100B: 080.0 MHz
>
> Notice how for e.g the 83.3 MHz value there are 3 significant digits,
> which translates to an accuracy of a 1000 ppm, where as your typical
> crystal oscillator is 20 - 100 ppm, so the accuracy of the frequency
> format used in the Software Developer’s Manual is not really helpful.

The SDM is not always helpful :)

> So the 00 part of 83300 which I'm suggesting to replace with 33 in
> essence is not specified and when the tsc_msr.c code was written /
> Bay Trail support was added the value from the datasheet was simply
> padded with zeros.
>
> There is already a hint that that likely is not correct in the values
> from the Software Developer’s Manual, we have values ending at 3.3,
> but also at 6.7, which to me feels like it is 6.66666666666667 rounded
> up and thus the 3.3 likely is 3.33333333333333.
>
> Test 1: Intel(R) Celeron(R) CPU  N2840  @ 2.16GHz"
> --------------------------------------------------
>
> As said I've also ran some tests. The first device I have tested is
> a HP stream 11 x360 with an "Intel(R) Celeron(R) CPU  N2840  @ 2.16GHz"
> (from /proc/cpuinfo) this is the "laptop' version of Bay Trail rather
> then the tablet version, so like Vipul's case I can comment out the 2
> lines setting the TSC_KNOWN_FREQ and TSC_RELIABLE flags and get
> "Refined TSC clocksource calibration". I've also added the changes with
> the extra pr_info calls which you requested. Here is the relevant output
> from a kernel with the 2 flags commented out + your pr_info changes,
> note I changed the REF_CLOCK format from %x to %d as that seems easier
> to interpret to me.
>
> [    0.000000] MSR_PINFO: 0000060000001a00 -> 26
> [    0.000000] MSR_FSBF: 0000000000000000
> [    0.000000] REF_CLOCK: 83000
> [    0.000000] tsc: Detected 2165.800 MHz processor
> [    3.586805] tsc: Refined TSC clocksource calibration: 2166.666 MHz
>
> And with my suggested change:
>
> [    0.000000] MSR_PINFO: 0000060000001a00 -> 26
> [    0.000000] MSR_FSBF: 0000000000000000
> [    0.000000] REF_CLOCK: 83333
> [    0.000000] tsc: Detected 2166.658 MHz processor
> [    3.587326] tsc: Refined TSC clocksource calibration: 2166.667 MHz
>
> Note we are still 0.009 MHz of from the refined calibration, so my
> suggestion to really fix this would be to change the freqs part
> of struct freq_desc to be in Hz rather then KHz and then calculate
> res as:
>
> res = DIV_ROUND_CLOSEST(freq * ratio, 1000); /* res is in KHz */

That makes a log of sense.

> Which would give us:
>
> [    0.000000] tsc: Detected 2166.667 MHz processor
>
>
> Test 2: "Intel(R) Atom(TM) CPU  Z3736F @ 1.33GHz"
> -------------------------------------------------
>
> Second device tested: HP Pavilion x2 Detachable 10" version
> with Bay Trail SoC: "Intel(R) Atom(TM) CPU  Z3736F @ 1.33GHz".
>
> Relevant log messages, unpatched:
> [    0.000000] MSR_PINFO: 0000060000001000 -> 16
> [    0.000000] MSR_FSBF: 0000000000000000
> [    0.000000] REF_CLOCK: 83000
> [    0.000000] tsc: Detected 1332.800 MHz processor
>
> Patched:
> [    0.000000] MSR_PINFO: 0000060000001000 -> 16
> [    0.000000] MSR_FSBF: 0000000000000000
> [    0.000000] REF_CLOCK: 83333
> [    0.000000] tsc: Detected 1333.328 MHz processor
>
> Now since we do not have another clock source, we do not
> know for sure that the 1333.328 MHz is better then the
> original 1332.800, but it does seem to be a more logical
> value; and from the N2840 @ 2.16GHz string, which runs
> at 2166.667 MHz we have learned that the number in the
> string is rounded down (at least for Bay Trail devices),
> so if the 1332.800 MHz where correct then we would
> expect the string to contain 1.32GHz, but it says 1.33GHz
>
>
> Test 3: "Intel(R) Atom(TM) CPU  Z3775  @ 1.46GHz"
> -------------------------------------------------
>
> Third device tested: Asus T200TA" with:
> "Intel(R) Atom(TM) CPU  Z3775  @ 1.46GHz"
> again this is the tablet version, so only one clocksource
> and thus no "Refined TSC clocksource calibration"
>
> [    0.000000] MSR_PINFO: 0000040000000b00 -> 11
> [    0.000000] MSR_FSBF: 0000000000000002
> [    0.000000] REF_CLOCK: 133300
> [    0.000000] tsc: Detected 1466.300 MHz processor
>
> Since we have no other clocksource, we cannot be
> sure that this is wrong, unless we compare to say
> the RTC using using the commands Vipul used to
> test. So I'm leaving this device running for say
> 12 hours and then I'll check.
>
> I have a hunch that in this case too we need to replace the
> 00 with 33, so use 133333 as ref-clock, but we will see.

Looking at the table again:

>     000B: 083.3 MHz
>     001B: 100.0 MHz
>     010B: 133.3 MHz
>     011B: 116.7 MHz
>     100B: 080.0 MHz

I don't know what the crystal frequency of this CPU is, but usually the
frequencies are the same accross a SoC family. The E3800 baytrail
definitely runs with a 25Mhz crystal.

So using 25MHz as crystal frequency;

000:   25 * 20 / 6  =  83.3333
001:   25 *  4 / 1  = 100.0000
010:   25 * 16 / 3  = 133.3333
011:   25 * 28 / 6  = 116.6666
100:   25 * 16 / 5  =  80.0000

So the tables for the various SoCs should have the crystal frequency and
the multiplier / divider pairs for each step. That makes the math simple
and accurate.

Typical crystal frequencies are 19.2, 24 and 25Mhz.

And if you look at CPUID 15H, it provides the crystal frequency and the
crystal to TSC ratio with a nominator / denominator pair. IOW a proper
description of the PLL.

Thanks,

        tglx

