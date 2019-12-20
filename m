Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C15701272F7
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 02:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLTBoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 20:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbfLTBoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 20:44:10 -0500
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C76624689
        for <stable@vger.kernel.org>; Fri, 20 Dec 2019 01:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576806249;
        bh=7Cih23Cwjps0fHiwT5pfwZhbRXsTuF8ylaqJmIWg1EM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zG6k3JseLbGsOvNaFmRmkIDqfS68H269BY2OQUoc+Qy7/88a1gvwznjJlTlLBSFEr
         dVqsyI2WsG4DejE6mzLC9HADpbQUBysFDT69QOfx2W5XjAQsD7l79YEORFZfBAaD6w
         HmQEwPszcHdrZ2tHloxr6VkCTNUzvGHxfX6CIvUg=
Received: by mail-wm1-f42.google.com with SMTP id u2so7584268wmc.3
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 17:44:09 -0800 (PST)
X-Gm-Message-State: APjAAAWSf6yZmJxwgRE8DjDeL526f1YHdv5dBerJW/H4oS65A2VbQJLY
        1LRHKPiaZtRpOt6y2IZ8ljFM3zGl1LVkCiYjXlIpPQ==
X-Google-Smtp-Source: APXvYqweUeUxuTYW5VPVDKeujQNK0kTO4GLH5byvbvxy4PJe0muLBwvRVX7sKZaxYC39H7l9uH2uzWC61tUNHV4L0Ew=
X-Received: by 2002:a7b:cbc9:: with SMTP id n9mr13296136wmi.89.1576806248079;
 Thu, 19 Dec 2019 17:44:08 -0800 (PST)
MIME-Version: 1.0
References: <20191203205716.1228-1-Jason@zx2c4.com> <20191209154505.6183-1-Jason@zx2c4.com>
 <CAHmME9q3mcE+Am5e=R=z=kJrkjwmz_tWqt7jc1b-7DiPt0vWNw@mail.gmail.com>
In-Reply-To: <CAHmME9q3mcE+Am5e=R=z=kJrkjwmz_tWqt7jc1b-7DiPt0vWNw@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 19 Dec 2019 17:43:56 -0800
X-Gmail-Original-Message-ID: <CALCETrVcJbhV9P+cSNhgzmLzbLFUCDvERN+SRJ+0YA0=MSnaQQ@mail.gmail.com>
Message-ID: <CALCETrVcJbhV9P+cSNhgzmLzbLFUCDvERN+SRJ+0YA0=MSnaQQ@mail.gmail.com>
Subject: Re: [PATCH] x86/quirks: disable HPET on Intel Coffee Lake Refresh platforms
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     X86 ML <x86@kernel.org>, Feng Tang <feng.tang@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 5:43 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi,
>
> Thought I should give a poke here so that this doesn't slip through
> the cracks again. Could we get this in for rc3?

Thomas?

BTW, you forgot LKML.

>
> Thanks,
> Jason
>
> On Mon, Dec 9, 2019 at 4:45 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > This is a follow up of fc5db58539b4 ("x86/quirks: Disable HPET on Intel
> > Coffe Lake platforms"), which addressed the issue for 8th generation
> > Coffee Lake. Intel has released Coffee Lake again for 9th generation,
> > apparently still with the same bug:
> >
> > clocksource: timekeeping watchdog on CPU3: Marking clocksource 'tsc' as unstable because the skew is too large:
> > clocksource:                       'hpet' wd_now: 24f422b8 wd_last: 247dea41 mask: ffffffff
> > clocksource:                       'tsc' cs_now: 144d927c4e cs_last: 140ba6e2a0 mask: ffffffffffffffff
> > tsc: Marking TSC unstable due to clocksource watchdog
> > TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
> > sched_clock: Marking unstable (26553416234, 4203921)<-(26567277071, -9656937)
> > clocksource: Switched to clocksource hpet
> >
> > So, we add another quirk for the chipset
> >
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > Cc: Feng Tang <feng.tang@intel.com>
> > Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/x86/kernel/early-quirks.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> > index 4cba91ec8049..a73f88dd7f86 100644
> > --- a/arch/x86/kernel/early-quirks.c
> > +++ b/arch/x86/kernel/early-quirks.c
> > @@ -712,6 +712,8 @@ static struct chipset early_qrk[] __initdata = {
> >                 PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> >         { PCI_VENDOR_ID_INTEL, 0x3ec4,
> >                 PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> > +       { PCI_VENDOR_ID_INTEL, 0x3e20,
> > +               PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> >         { PCI_VENDOR_ID_BROADCOM, 0x4331,
> >           PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
> >         {}
> > --
> > 2.24.0
