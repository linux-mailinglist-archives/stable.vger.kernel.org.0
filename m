Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342D34AEA40
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 07:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiBIGXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 01:23:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbiBIGXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 01:23:23 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF28DE01CCA5
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 22:23:23 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id a25so1969451lji.9
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 22:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=telus.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rNHVEGbI4VboLceypPZ+FijAwrzCqKw6joMYkR0IdCY=;
        b=VJoHqBzGs98/ibJkvyb1l8KARFdrOYLZBOzljTQQwNoQCl/hrA4hAZOopSso9gmZrg
         YlMnNakIPfbk7Kejx+BgGInST6sTBlrNc4x+kly5BTRH3BYfHgnLuj1S6le5jesxagPb
         wZZbeIGH9TmlxSy4Ao2CqCKZZC8I51ZHtlUG9zFH5NPZ7+tckIBLOwy5ksSaWYeIC0Zb
         eyUs+uczYI47vfo2qxv6Eb2ruwse7V1sio631FIIr4KBFHUlVgOQJxFD0qgJnB+g1Fqm
         QWK7w+FUHACx3EOET53QILHlSBkheTyrbhJ/HLWp9+xNJvhI44JWe7JVXobPDlp3KxCt
         M+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rNHVEGbI4VboLceypPZ+FijAwrzCqKw6joMYkR0IdCY=;
        b=IJET3M+IDPfmSlD5KkGjzf6n9BifuCNWEubh+nk/Na6OO1sWbgQCgMl3rh6Pel23+V
         wgRRY1uUxjNgn11cPCAYQuskNOCbRxk7Xih0NjFR8zA4j5w+tubMVM5jfZHwsKOffcTs
         GT89ypK+cl8ZUhAOOl+nHcLqZqE7O6xdKqGUlVtHqvJQJ19+jHw8JZxFhKG4TJpcPuoB
         c8xu4AzLJDdTxJRCmvLDDQZBwlG/JbTXou0SJwgQyqwNb4wcD/nv3CPNSNm/1HLQqSys
         OYamsBQ2QtEcbhC9kBUbJjMDNuPURp9gGIko+RvGaTb9WnSl9/LSM2tzMwsjvvw0xc2N
         X93A==
X-Gm-Message-State: AOAM530sZQw2QnrnWegsnL2BwcHwklA+eGZj+7yuBc2b/Mpusz+xZKcK
        ofyWeSBZFzVbk+yuix8Dd95IBJckoDH4S/exf8pA3w==
X-Google-Smtp-Source: ABdhPJwr0uOCfhXxU+M57ngjhJRrmlo7Ph8RI48Kj0jQE4iiLMnXEoViFfqoetLp/+sCaKRCIZnl2+lDffrZ8JGahQk=
X-Received: by 2002:a2e:a54a:: with SMTP id e10mr606431ljn.239.1644387802079;
 Tue, 08 Feb 2022 22:23:22 -0800 (PST)
MIME-Version: 1.0
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net> <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com> <20220208091525.GA7898@shbuild999.sh.intel.com>
In-Reply-To: <20220208091525.GA7898@shbuild999.sh.intel.com>
From:   Doug Smythies <dsmythies@telus.net>
Date:   Tue, 8 Feb 2022 22:23:13 -0800
Message-ID: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     Feng Tang <feng.tang@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        dsmythies <dsmythies@telus.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 8, 2022 at 1:15 AM Feng Tang <feng.tang@intel.com> wrote:
> On Mon, Feb 07, 2022 at 11:13:00PM -0800, Doug Smythies wrote:
> > > >
> > > > Since kernel 5.16-rc4 and commit: b50db7095fe002fa3e16605546cba66bf1b68a3e
> > > > " x86/tsc: Disable clocksource watchdog for TSC on qualified platorms"
> > > >
> > > > There are now occasions where times between calls to the driver can be
> > > > over 100's of seconds and can result in the CPU frequency being left
> > > > unnecessarily high for extended periods.
> > > >
> > > > From the number of clock cycles executed between these long
> > > > durations one can tell that the CPU has been running code, but
> > > > the driver never got called.
> > > >
> > > > Attached are some graphs from some trace data acquired using
> > > > intel_pstate_tracer.py where one can observe an idle system between
> > > > about 42 and well over 200 seconds elapsed time, yet CPU10 never gets
> > > > called, which would have resulted in reducing it's pstate request, until
> > > > an elapsed time of 167.616 seconds, 126 seconds since the last call. The
> > > > CPU frequency never does go to minimum.
> > > >
> > > > For reference, a similar CPU frequency graph is also attached, with
> > > > the commit reverted. The CPU frequency drops to minimum,
> > > > over about 10 or 15 seconds.,
> > >
> > > commit b50db7095fe0 essentially disables the clocksource watchdog,
> > > which literally doesn't have much to do with cpufreq code.
> > >
> > > One thing I can think of is, without the patch, there is a periodic
> > > clocksource timer running every 500 ms, and it loops to run on
> > > all CPUs in turn. For your HW, it has 12 CPUs (from the graph),
> > > so each CPU will get a timer (HW timer interrupt backed) every 6
> > > seconds. Could this affect the cpufreq governor's work flow (I just
> > > quickly read some cpufreq code, and seem there is irq_work/workqueue
> > > involved).
> >
> > 6 Seconds is the longest duration I have ever seen on this
> > processor before commit b50db7095fe0.
> >
> > I said "the times between calls to the driver have never
> > exceeded 10 seconds" originally, but that involved other processors.
> >
> > I also did longer, 9000 second tests:
> >
> > For a reverted kernel the driver was called 131,743,
> > and 0 times the duration was longer than 6.1 seconds.
> >
> > For a non-reverted kernel the driver was called 110,241 times,
> > and 1397 times the duration was longer than 6.1 seconds,
> > and the maximum duration was 303.6 seconds
>
> Thanks for the data, which shows it is related to the removal of
> clocksource watchdog timers. And under this specific configurations,
> the cpufreq work flow has some dependence on that watchdog timers.
>
> Also could you share you kernel config, boot message and some
> system settings like for tickless mode, so that other people can
> try to reproduce? thanks

I steal the kernel configuration file from the Ubuntu mainline PPA
[1], what they call "lowlatency", or 1000Hz tick. I make these
changes before compile:

scripts/config --disable DEBUG_INFO
scripts/config --disable SYSTEM_TRUSTED_KEYS
scripts/config --disable SYSTEM_REVOCATION_KEYS

I also send you the config and dmesg files in an off-list email.

This is an idle, and very low periodic loads, system type test.
My test computer has no GUI and very few services running.
Notice that I have not used the word "regression" yet in this thread,
because I don't know for certain that it is. In the end, we don't
care about CPU frequency, we care about wasting energy.
It is definitely a change, and I am able to measure small increases
in energy use, but this is all at the low end of the power curve.
So far I have not found a significant example of increased power
use, but I also have not looked very hard.

During any test, many monitoring tools might shorten durations.
For example if I run turbostat, say:

sudo turbostat --Summary --quiet --show
Busy%,Bzy_MHz,IRQ,PkgWatt,PkgTmp,RAMWatt,GFXWatt,CorWatt --interval
2.5

Well, yes then the maximum duration would be 2.5 seconds,
because turbostat wakes up each CPU to inquire about things
causing a call to the CPU scaling driver. (I tested this, for about
900 seconds.)

For my power tests I use a sample interval of >= 300 seconds.
For duration only tests, turbostat is not run at the same time.

My grub line:

GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 consoleblank=314
intel_pstate=active intel_pstate=no_hwp msr.allow_writes=on
cpuidle.governor=teo"

A typical pstate tracer command (with the script copied to the
directory where I run this stuff:):

sudo ./intel_pstate_tracer.py --interval 600 --name vnew02 --memory 800000

>
> > > Can you try one test that keep all the current setting and change
> > > the irq affinity of disk/network-card to 0xfff to let interrupts
> > > from them be distributed to all CPUs?
> >
> > I am willing to do the test, but I do not know how to change the
> > irq affinity.
>
> I might say that too soon. I used to "echo fff > /proc/irq/xxx/smp_affinity"
> (xx is the irq number of a device) to let interrupts be distributed
> to all CPUs long time ago, but it doesn't work on my 2 desktops at hand.
> Seems it only support one-cpu irq affinity in recent kernel.
>
> You can still try that command, though it may not work.

I did not try this yet.

[1] https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.17-rc3/
