Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CED4108F5
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 02:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240794AbhISAQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 20:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239491AbhISAQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Sep 2021 20:16:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46648C061574;
        Sat, 18 Sep 2021 17:14:56 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632010491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=agX9fVOcY0lG1flSHKbwyj/DdeEVh6/WedQOjxUd1Ck=;
        b=VCuRJgyqXh+zScHFAb7YBIbcEBrWLNk4crQhUjRy8gIxtRho2wEv4FmVHh02ZrdegVG66T
        cjssrwCvQMLFv6GAEXdlpv9YLu7zOoKMlsw6mMF6JyMhorXrNGwNfsp3kmqPrz2rODZosI
        pP4H1GIajNfhwxvYDJXBoYycSS0XDDUIOkcxY26HuX3O0+AQjxgoBSWT6+4aPKEnrVqQ/+
        3Mlgv/8jnPpeXHYmSKwMuwtQGBtgJMSAG3NlKVykjTNoQABjPl8YHxt08f0jZ3qyz0WlNI
        qdLkM120eIZ4jP+6+JPZKfP+GAgB5AhnlxflVtVRkaJl4SrvGjLk4ixGKG4aIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632010491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=agX9fVOcY0lG1flSHKbwyj/DdeEVh6/WedQOjxUd1Ck=;
        b=gTr9cY6KWw0VQsnHU1YUE/U5q/bWlkdmWL4HIp2GwrhsyDBMdQLHkoA7JyfBchRWaf0Rzp
        rcJBRjEDa84M6/Cw==
To:     Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, x86@kernel.org,
        jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, kai.heng.feng@canonical.com, bhelgaas@google.com,
        linux-pci@vger.kernel.org, rudolph@fb.com, xapienz@fb.com,
        bmilton@fb.com, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
In-Reply-To: <YURhL33YyXRMkdC6@hirez.programming.kicks-ass.net>
References: <20210916131739.1260552-1-kuba@kernel.org>
 <20210916150707.GA1611532@bjorn-Precision-5520>
 <YURb1bzc3L4gNI9Q@hirez.programming.kicks-ass.net>
 <YURhL33YyXRMkdC6@hirez.programming.kicks-ass.net>
Date:   Sun, 19 Sep 2021 02:14:50 +0200
Message-ID: <87v92x775x.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17 2021 at 11:34, Peter Zijlstra wrote:
> On Fri, Sep 17, 2021 at 11:11:49AM +0200, Peter Zijlstra wrote:
>> On Thu, Sep 16, 2021 at 10:07:07AM -0500, Bjorn Helgaas wrote:
>> > This seems to be an ongoing issue, not just a point defect in a single
>> > product, and I really hate the onesy-twosy nature of this.  Is there
>> > really no way to detect this issue automatically or fix whatever Linux
>> > bug makes us trip over this?  I am no clock expert, so I have
>> > absolutely no idea whether this is possible.

Right, we need to have all these quirks because we can't define a
generation cutoff based on family/model because X86 model is simply a
random number. There might be some scheme behind it, but it's neither
obvious nor documented.

But the HPET on the affected machines goes south when the system enters
PC10. So the right thing to do is to check whether PC10 is supported and
force disable HPET if that's the case. That disablement is required
independent of the clocksource watchdog problem because HPET is exposed
in other ways as well.

Questions for Rafael:

What's the proper way to figure out whether PC10 is supported? I got
lost in the maze of intel_idle and ACPI muck and several other places
which check that. Just grep for CPUID_MWAIT_LEAF and see how consistent
all of that is.

Why the heck can't we have _ONE_ authoritive implementation of that?
Just because, right?

Of course all of this is well documented as usual....

>> X86 is gifted with the grant total of _0_ reliable clocks. Given no
>> accurate time, it is impossible to tell which one of them is broken
>> worst. Although I suppose we could attempt to synchronize against the
>> PMU or MPERF..
>> 
>> We could possibly disable the tsc watchdog for
>> X86_FEATURE_TSC_KNOWN_FREQ && X86_FEATURE_TSC_ADJUST I suppose.
>> 
>> And then have people with 'creative' BIOS get to keep the pieces.
>
> Alternatively, we can change what the TSC watchdog does for
> X86_FEATURE_TSC_ADJUST machines. Instead of checking time against HPET
> it can check if TSC_ADJUST changes. That should make it more resillient
> vs HPET time itself being off.

I tried that and I hated the mess it created. Abusing the clocksource
watchdog machinery for that is a nightmare. Don't even think about it.

When TSC_ADJUST is available then we check the MSR when a CPU goes idle,
but not more often than once per second. My concern is that we can't
check TSC_ADJUST for modifications on fully loaded CPUs, but why do I
still care?

The requirements for ditching the watchdog should be:

    X86_FEATURE_TSC_KNOWN_FREQ &&
    X86_FEATURE_TSC_ADJUST &&
    X86_FEATURE_NONSTOP_TSC &&
    X86_FEATURE_ARAT

But expecting X86_FEATURE_TSC_KNOWN_FREQ to be set on these HPET
trainwreck equipped machines is wishful thinking:

# cpuid -1 -l 0x15
CPU:
   Time Stamp Counter/Core Crystal Clock Information (0x15):
      TSC/clock ratio = 176/2
      nominal core crystal clock = 0 Hz

We calculate that missing frequency then from leaf 0x16:

# cpuid -1 -l 0x16
CPU:
   Processor Frequency Information (0x16):
      Core Base Frequency (MHz) = 0x834 (2100)
      Core Maximum Frequency (MHz) = 0x1068 (4200)
      Bus (Reference) Frequency (MHz) = 0x64 (100)

But we don't set the TSC_KNOWN_FREQ feature bit in the case that crystal
clock is 0 and we need to use leaf 16. Which is entirely correct because
the Core Base Frequency CPUID info is a joke:

[    3.045828] tsc: Refined TSC clocksource calibration: 2111.993 MHz

The refined calibration is pretty accurate according to NTP and if you
take the CPUID 15/16 numbers into account even obvious with pure math:

  TSC/clock ratio = 176/2
  Core Base Frequency (MHz) = 0x834 (2100)

  2100 / (176 / 2) = 23.8636 (MHz)

which would be a very unusual crystal frequency. The refined calibration
makes a lot more sense:

  2112 / (176 / 2) = 24 (MHz)

which is one of the very well known crystal frequencies of these
machines.

It's 2021 now and we are still not able to get reasonable information
from hardware/firmware about this?

Can the hardware and firmware people finaly get their act together?

Here is the simple list of things we are asking for:

 - Reliable TSC which cannot be tinkered with even by "value add" BIOSes

 - Reliable information from hardware/firmware about the TSC frequency

 - Hardware enforced (or firmware assisted) guarantees of TSC being
   synchronized accross sockets

We are asking for that for more than _twenty_ years now. All what we get
are useless new features and as demonstrated in the case at hand new
types of wreckage instead of a proper solution to the underlying
problems.

I'm personally dealing with the x86 timer hardware trainwrecks for more
than 20 years now. TBH, I'm tired of this idiocy and very close to the
point where I stop caring.

Thanks,

        tglx
