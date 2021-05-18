Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A3C387402
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 10:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347438AbhERIaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 04:30:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:12722 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239229AbhERIaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 04:30:10 -0400
IronPort-SDR: RPrxie+ysdzzfZQdWcJPutXvJ1ldKoQ8+gBh2Lp1fj2Ot6rJXjucoeNXKr1+fftNJBPWWyjjK/
 2gm4tWvtUDng==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="200352322"
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="200352322"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 01:28:52 -0700
IronPort-SDR: Ha8IYiF0XGp/PBrW7dHSByfYEHsheNtP8u8snDDO95yZ726cg+7ukqTm5ch6zsNpjJo87yPc6/
 NiPJ9EOmDApQ==
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="473352254"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 01:28:50 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1liv5r-00Cu5x-2q; Tue, 18 May 2021 11:28:47 +0300
Date:   Tue, 18 May 2021 11:28:47 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
Message-ID: <YKN6vwGE2XAg3kY7@smile.fi.intel.com>
References: <87a6otfblh.ffs@nanos.tec.linutronix.de>
 <b509418f-9fff-ab27-b460-ecbe6fdea09a@gmail.com>
 <87lf8ddjqx.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lf8ddjqx.ffs@nanos.tec.linutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 01:27:02AM +0200, Thomas Gleixner wrote:
> On Mon, May 17 2021 at 21:25, Maximilian Luz wrote:
> > On 5/17/21 8:40 PM, Thomas Gleixner wrote:
> >> Can you please add "apic=verbose" to the kernel command line and provide
> >> full dmesg output for a kernel w/o your patch and one with your patch
> >> applied?
> >
> > I don't actually own an affected device, but I'm sure Sachi can provide
> > you with that.
> 
> Ok.
> 
> > As far as we can tell, due to the NULL PIC being chosen nr_legacy_irqs()
> > returns 0. That in turn causes mp_check_pin_attr() to return false
> > because is_level and active_low don't seem to match the expected
> > values.
> 
> Ok.
> 
> > That check is essentially ignored if nr_legacy_irqs() returns a high
> > enough value.
> 
> Close enough.
> 
> > I guess that might also be a firmware bug here? Not sure where the
> > expected values come from.
> 
> They come from the interrupt override ACPI table and if not supplied
> then irq 0-15 is preset with default values, which are type=edge and
> polarity=high, i.e.  the opposite of what the failing driver wants.
> 
> The ACPI table lacks an override entry for IRQ7. I looked at one of the
> dmesg files in that github thread and that has overrides:
> 
> [    0.111674] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.111681] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.111688] ACPI: IRQ0 used by override.
> [    0.111692] ACPI: IRQ9 used by override.
> 
> IRQ7 should have a corresponding entry as IRQ9 has:
> 
> https://github.com/linux-surface/acpidumps/blob/4da0148744164cea0c924dab92f45842fde03177/surface_laptop_4_amd/apic.dsl#L178
> 
>           Subtable Type : 02 [Interrupt Source Override]
>                  Length : 0A
>                     Bus : 00
>                  Source : 07
>               Interrupt : 00000007
>   Flags (decoded below) : 000F
>                Polarity : 3
>            Trigger Mode : 3
> 
> > Sachi can probably walk you through this a bit better as she's the one
> > who tracked this down. See also [1, 2] and following comments.
> 
> Impressive detective work!
> 
> Sachi, can you please try the hack below to confirm the above?
> 
> It's not meant to be a solution, but it's the most trivial way to
> validate this.
> 
> I'm pretty sure that Windows on Surface does not care about the PIC at
> all. Whether that's on purpose to safe power or just because Windows
> ignores the PIC completely by now does not matter at all. No idea how
> that repeated poking on the PIC makes it come alive either and TBH, I
> don't care too much about it simply because Linux is able to cope with a
> missing PIC as long as the ACPI tables are correct.
> 
> I'm way too tired to think about a proper solution for that problem and
> I noticed another related issue in that dmesg output:
> 
> [    0.272448] Failed to register legacy timer interrupt
> 
> It's not a problem which causes failures, but it's related to the
> missing PIC.

But ACPI has a pretty nice means about missing legacy hardware, it's called
Hardware Reduced mode. It excludes automatically the (legacy) PIC, PIT, etc.

OTOH it excludes ACPI power chip as well. I haven't looked into this, just
share my thoughts what else can be checked. (On Intel the MID devices use
that approach)

> Needs some more thoughts with brain awake...

-- 
With Best Regards,
Andy Shevchenko


