Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2D2CD2F2
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 17:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfJFPfE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 6 Oct 2019 11:35:04 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37052 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfJFPfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 11:35:04 -0400
Received: by mail-oi1-f193.google.com with SMTP id i16so9641897oie.4;
        Sun, 06 Oct 2019 08:35:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vJ/fN1Td6yKGxz4rSrSmUvRGVTLM8nHHs5htnjPWdus=;
        b=U8vUSZ8AHnwmo0wbddLUYzZzGp3f1sIWCM591LQM5tvFAY7kfGDCapugDUWJ3xddXb
         b02itqtrqAf0ddxRE3z9pVlW2zpmvHRTlhOuuKzQG0lKvxwSE/AlVah4HfVX29CAk7+X
         JvQJ4ukD7mVdrYhkAtQQCHs3c0Nxf5KaNE8fxtJjL9mwK9gGMLduUxcWH1OL0rKV8B6c
         VMWp4ZtDYU+1rpTSim6ksxlwfbUkHc61X4Uc+d88BNEHoa4Vy7WRtNtvZfa4U+KW3exL
         ejCXKNqhgIhpVwlvN5HEg1pxwxDJ/zG/iKp9zItmTaxuMtFpspcfkD0gc7KX3vW3w8ID
         ueQg==
X-Gm-Message-State: APjAAAUSGr+einD1Pnfkta4OIYD2x9HzKT1C55HeTWlnqS0Ka23LGcVV
        LRrttxqovGh7o/BTGFJEdsrdKiaJrDctw+yEUXo=
X-Google-Smtp-Source: APXvYqwYT9OUUNLx0nEf+PiDEhafjGnfYuD/XrtvHL6roRxoSb0ZP2ty4iqUH8Km5t2frUwDctDFJ2muIxViqyBBbWo=
X-Received: by 2002:aca:4890:: with SMTP id v138mr15295460oia.57.1570376103413;
 Sun, 06 Oct 2019 08:35:03 -0700 (PDT)
MIME-Version: 1.0
References: <20191003140828.14801-1-ville.syrjala@linux.intel.com>
 <2393023.mJgu6cDs6C@kreacher> <20191004123026.GU1208@intel.com>
In-Reply-To: <20191004123026.GU1208@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Sun, 6 Oct 2019 17:34:52 +0200
Message-ID: <CAJZ5v0hsiyKfVcDFbnJKqDkCKWhbSfNrmm7yVhudONuS0SWALw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix RCU reboot regression on x86 PIC machines
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 4, 2019 at 2:30 PM Ville Syrjälä
<ville.syrjala@linux.intel.com> wrote:
>
> On Thu, Oct 03, 2019 at 05:05:28PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, October 3, 2019 4:08:28 PM CEST Ville Syrjala wrote:
> > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > >
> > > Since 4.20-rc1 my PIC machines no longer reboot/shutdown.
> > > I bisected this down to commit 45975c7d21a1 ("rcu: Define RCU-sched
> > > API in terms of RCU for Tree RCU PREEMPT builds").
> > >
> > > I traced the hang into
> > > -> cpufreq_suspend()
> > >  -> cpufreq_stop_governor()
> > >   -> cpufreq_dbs_governor_stop()
> > >    -> gov_clear_update_util()
> > >     -> synchronize_sched()
> > >      -> synchronize_rcu()
> > >
> > > Only PREEMPT=y is affected for obvious reasons. The problem
> > > is limited to PIC machines since they mask off interrupts
> > > in i8259A_shutdown() (syscore_ops.shutdown() registered
> > > from device_initcall()).
> >
> > Let me treat this as a fresh bug report. :-)
> >
> > > I reported this long ago but no better fix has surfaced,
> >
> > So I don't recall seeing the original report or if I did, I had not understood
> > the problem then.
> >
> > > hence sending out my initial workaround which I've been
> > > carrying around ever since. I just move cpufreq_core_init()
> > > to late_initcall() so the syscore_ops get registered in the
> > > oppsite order and thus the .shutdown() hooks get executed
> > > in the opposite order as well. Not 100% convinced this is
> > > safe (especially moving the cpufreq_global_kobject creation
> > > to late_initcall()) but I've not had any problems with it
> > > at least.
> >
> > The problem is a bug in cpufreq that shouldn't point its syscore shutdown
> > callback pointer to cpufreq_suspend(), because the syscore stage is generally
> > too lat to call that function and I'm not sure why this has not been causing
> > any other issues to trigger (or maybe it did, but they were not reported).
> >
> > Does the patch below work for you?
>
> It does. Thanks.
>
> Feel free to slap on
> Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> if you want to go with that.

I will, thank you!
