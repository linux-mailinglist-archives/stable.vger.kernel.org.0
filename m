Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919E414CB11
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 14:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgA2NDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 08:03:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:56434 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgA2NDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 08:03:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 05:03:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="217941078"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga007.jf.intel.com with ESMTP; 29 Jan 2020 05:03:49 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iwn0Z-0002G6-0R; Wed, 29 Jan 2020 15:03:51 +0200
Date:   Wed, 29 Jan 2020 15:03:50 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        vipul kumar <vipulk0511@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
Message-ID: <20200129130350.GD32742@smile.fi.intel.com>
References: <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com>
 <878slzeeim.fsf@nanos.tec.linutronix.de>
 <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com>
 <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
 <87iml11ccf.fsf@nanos.tec.linutronix.de>
 <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
 <87ftg5131x.fsf@nanos.tec.linutronix.de>
 <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com>
 <87sgjz434v.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sgjz434v.fsf@nanos.tec.linutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 11:39:28PM +0100, Thomas Gleixner wrote:
> Hans de Goede <hdegoede@redhat.com> writes:
> > Ok, I have been testing this on various devices and I'm pretty sure now
> > that my initial hunch is correct. The problem is that the accuracy of
> > the FSB frequency as listed in the Intel docs is not so great:
> 
> Thanks for doing that.

+1!

> > The "Intel 64 and IA-32 Architectures Software Developer’s Manual Volume 4:
> > Model-Specific Registers" has the following table for the values from
> > freq_desc_byt:
> >
> >     000B: 083.3 MHz
> >     001B: 100.0 MHz
> >     010B: 133.3 MHz
> >     011B: 116.7 MHz
> >     100B: 080.0 MHz
> >
> > Notice how for e.g the 83.3 MHz value there are 3 significant digits,
> > which translates to an accuracy of a 1000 ppm, where as your typical
> > crystal oscillator is 20 - 100 ppm, so the accuracy of the frequency
> > format used in the Software Developer’s Manual is not really helpful.
> 
> The SDM is not always helpful :)
> 
> > So the 00 part of 83300 which I'm suggesting to replace with 33 in
> > essence is not specified and when the tsc_msr.c code was written /
> > Bay Trail support was added the value from the datasheet was simply
> > padded with zeros.
> >
> > There is already a hint that that likely is not correct in the values
> > from the Software Developer’s Manual, we have values ending at 3.3,
> > but also at 6.7, which to me feels like it is 6.66666666666667 rounded
> > up and thus the 3.3 likely is 3.33333333333333.
> >
> > Test 1: Intel(R) Celeron(R) CPU  N2840  @ 2.16GHz"
> > --------------------------------------------------
> >
> > As said I've also ran some tests. The first device I have tested is
> > a HP stream 11 x360 with an "Intel(R) Celeron(R) CPU  N2840  @ 2.16GHz"
> > (from /proc/cpuinfo) this is the "laptop' version of Bay Trail rather
> > then the tablet version, so like Vipul's case I can comment out the 2
> > lines setting the TSC_KNOWN_FREQ and TSC_RELIABLE flags and get
> > "Refined TSC clocksource calibration". I've also added the changes with
> > the extra pr_info calls which you requested. Here is the relevant output
> > from a kernel with the 2 flags commented out + your pr_info changes,
> > note I changed the REF_CLOCK format from %x to %d as that seems easier
> > to interpret to me.
> >
> > [    0.000000] MSR_PINFO: 0000060000001a00 -> 26
> > [    0.000000] MSR_FSBF: 0000000000000000
> > [    0.000000] REF_CLOCK: 83000
> > [    0.000000] tsc: Detected 2165.800 MHz processor
> > [    3.586805] tsc: Refined TSC clocksource calibration: 2166.666 MHz
> >
> > And with my suggested change:
> >
> > [    0.000000] MSR_PINFO: 0000060000001a00 -> 26
> > [    0.000000] MSR_FSBF: 0000000000000000
> > [    0.000000] REF_CLOCK: 83333
> > [    0.000000] tsc: Detected 2166.658 MHz processor
> > [    3.587326] tsc: Refined TSC clocksource calibration: 2166.667 MHz
> >
> > Note we are still 0.009 MHz of from the refined calibration, so my
> > suggestion to really fix this would be to change the freqs part
> > of struct freq_desc to be in Hz rather then KHz and then calculate
> > res as:
> >
> > res = DIV_ROUND_CLOSEST(freq * ratio, 1000); /* res is in KHz */
> 
> That makes a log of sense.

...

> Looking at the table again:
> 
> >     000B: 083.3 MHz
> >     001B: 100.0 MHz
> >     010B: 133.3 MHz
> >     011B: 116.7 MHz
> >     100B: 080.0 MHz
> 
> I don't know what the crystal frequency of this CPU is, but usually the
> frequencies are the same accross a SoC family. The E3800 baytrail
> definitely runs with a 25Mhz crystal.
> 
> So using 25MHz as crystal frequency;
> 
> 000:   25 * 20 / 6  =  83.3333
> 001:   25 *  4 / 1  = 100.0000
> 010:   25 * 16 / 3  = 133.3333
> 011:   25 * 28 / 6  = 116.6666
> 100:   25 * 16 / 5  =  80.0000
> 
> So the tables for the various SoCs should have the crystal frequency and
> the multiplier / divider pairs for each step. That makes the math simple
> and accurate.

Completely agree here. I used to fix magic tables [1] when product engineers
considers data in the documentation like carved in stone. So, I'm not surprised
we have one here.

> Typical crystal frequencies are 19.2, 24 and 25Mhz.

Hans, I think Cherrytrail may be affected by this as the others.
CHT AFAIK uses 19.2MHz xtal.

> And if you look at CPUID 15H, it provides the crystal frequency and the
> crystal to TSC ratio with a nominator / denominator pair. IOW a proper
> description of the PLL.

[1]: 9df461eca18f ("spi: pxa2xx: replace ugly table by approximation")


-- 
With Best Regards,
Andy Shevchenko


