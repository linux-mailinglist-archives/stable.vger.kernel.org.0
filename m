Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C024A4AD1F9
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 08:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347523AbiBHHNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 02:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239883AbiBHHNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 02:13:12 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A83C0401EF
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 23:13:10 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id c15so23064361ljf.11
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 23:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=telus.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PQx9yycvGYpKyCgAvuWDdcBVWCJa3H3NyEWfCx/k5WA=;
        b=Z1F1U/gLvw9+Pjeh8lx2oVNfB+J6yVYOIyCF5PrMw+5bbMyzJ+fN/M7DbYMn2ZppLm
         FaqudwX4iNBFIUFSbqo2zJ73BLMnXOZjT2IxbkHMbtnaSmtkLVVuUnd5Ap8Y8O/NuOEZ
         lvQJ5yBTrq/SpUFAxfkIrZMjq3ZTYXuh6nfmAh2oHh69BegqZZqvUZa5KrGrr9S3KcVZ
         h0RyB1JD1IFXKLQvYKCzGRHKnR1cqVag+KCA0msIViVkrFjSHufPgJ+J00O3D+3betSe
         zW83+LOF1S3CNznfPbLEBbgeKeT+LfKODvG4W7BASDOWcEkTpQB+oDYsQ+q0hCBdZMBk
         XCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PQx9yycvGYpKyCgAvuWDdcBVWCJa3H3NyEWfCx/k5WA=;
        b=phtfiqnJVP9sH5ZgiS/1zwaF/XnyxuJjjMc7koNeFwUk5/0iUNNW/PSLCv5imEM9mQ
         SWQHclxCTjDLgTp0tishFhgArDehjnK195fjzZYkV3b2r6HThuyjC0Iz3I2lgPAlwp0u
         N4iZW3vowSH2FPEtIDMKP9IT2HsdPsLYWRZQpQiaw2aGt/YcdIO3WlTOss/uU+0uLriG
         ebSw8uE446vqYbFTWVwPDomqpoqPgmPVCWpxS2VsG92CrmMZGhYZQh3gLT+/nq3paurz
         Z1UJHeuRVaeedjONM9YYOSe+78Hqfg91O4Ear/jT4n5pZxB0ZhvmSOv6dN4yAD19sKUk
         JqWw==
X-Gm-Message-State: AOAM5327hMP/TB4fKa1ODHkHEdBsSPXBZQM00FYfqin/MjT74fTe3CnZ
        OvKG7rcxQ9lednO6hc2ckncpCXNA9tVpvokt6MQYZQ==
X-Google-Smtp-Source: ABdhPJzZQfS4PljZUn4lT5y7d+EOf/OQIM/Gy2WW8iCoWGE07Fi7riic9d6TzE4atFMHt1kJWN1hoMNLNUQHntOAUHM=
X-Received: by 2002:a2e:7319:: with SMTP id o25mr2078468ljc.34.1644304388966;
 Mon, 07 Feb 2022 23:13:08 -0800 (PST)
MIME-Version: 1.0
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net> <20220208023940.GA5558@shbuild999.sh.intel.com>
In-Reply-To: <20220208023940.GA5558@shbuild999.sh.intel.com>
From:   Doug Smythies <dsmythies@telus.net>
Date:   Mon, 7 Feb 2022 23:13:00 -0800
Message-ID: <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Feng,

Thank you for your reply.

On Mon, Feb 7, 2022 at 6:39 PM Feng Tang <feng.tang@intel.com> wrote:
>
> Hi Doug,
>
> Thanks for the report.
>
> On Tue, Feb 08, 2022 at 09:40:14AM +0800, Doug Smythies wrote:
> > Hi All,
> >
> > Note before: I do not know If I have the e-mail address list correct,
> > nor am I actually a member of the x86 distribution list. I am on
> > the linux-pm email list.
> >
> > When using the intel_pstate CPU frequency scaling driver with HWP disabled,
> > active mode, powersave scaling governor, the times between calls to the driver
> > have never exceeded 10 seconds.
> >
> > Since kernel 5.16-rc4 and commit: b50db7095fe002fa3e16605546cba66bf1b68a3e
> > " x86/tsc: Disable clocksource watchdog for TSC on qualified platorms"
> >
> > There are now occasions where times between calls to the driver can be
> > over 100's of seconds and can result in the CPU frequency being left
> > unnecessarily high for extended periods.
> >
> > From the number of clock cycles executed between these long
> > durations one can tell that the CPU has been running code, but
> > the driver never got called.
> >
> > Attached are some graphs from some trace data acquired using
> > intel_pstate_tracer.py where one can observe an idle system between
> > about 42 and well over 200 seconds elapsed time, yet CPU10 never gets
> > called, which would have resulted in reducing it's pstate request, until
> > an elapsed time of 167.616 seconds, 126 seconds since the last call. The
> > CPU frequency never does go to minimum.
> >
> > For reference, a similar CPU frequency graph is also attached, with
> > the commit reverted. The CPU frequency drops to minimum,
> > over about 10 or 15 seconds.,
>
> commit b50db7095fe0 essentially disables the clocksource watchdog,
> which literally doesn't have much to do with cpufreq code.
>
> One thing I can think of is, without the patch, there is a periodic
> clocksource timer running every 500 ms, and it loops to run on
> all CPUs in turn. For your HW, it has 12 CPUs (from the graph),
> so each CPU will get a timer (HW timer interrupt backed) every 6
> seconds. Could this affect the cpufreq governor's work flow (I just
> quickly read some cpufreq code, and seem there is irq_work/workqueue
> involved).

6 Seconds is the longest duration I have ever seen on this
processor before commit b50db7095fe0.

I said "the times between calls to the driver have never
exceeded 10 seconds" originally, but that involved other processors.

I also did longer, 9000 second tests:

For a reverted kernel the driver was called 131,743,
and 0 times the duration was longer than 6.1 seconds.

For a non-reverted kernel the driver was called 110,241 times,
and 1397 times the duration was longer than 6.1 seconds,
and the maximum duration was 303.6 seconds

> Can you try one test that keep all the current setting and change
> the irq affinity of disk/network-card to 0xfff to let interrupts
> from them be distributed to all CPUs?

I am willing to do the test, but I do not know how to change the
irq affinity.

> Thanks,
> Feng
>
>
> > Processor: Intel(R) Core(TM) i5-10600K CPU @ 4.10GHz
> >
> > Why this particular configuration, i.e. no-hwp, active, powersave?
> > Because it is, by far, the easiest to observe what is going on.
> >
> > ... Doug
> >
>
>
>
>
>
