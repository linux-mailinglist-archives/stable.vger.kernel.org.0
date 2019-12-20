Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 925C01278D7
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 11:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfLTKIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 05:08:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45656 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTKIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 05:08:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nw+qOmMQ3X+HAx4+dv6Gw33Ycg+rRda7KQnG1oQs3r0=; b=f7WU/lmahCdhnIsmd43rYnwNh
        pgu/3iKZHl2XsgSwkdsPsaqcy8/WUxBa/yVgQPHbULVKD75mAEKIPX4Ja5LmZsrapWrMyYVHCB7jK
        DsLfg3MDu2WinXrQKgrQI1RVb5vjh+mNeiCH638/NszGn/KfgzqtE19C2UB8P3Kb9QKcQWcJL0VcP
        29G3BaYwPgDuAnqlwRrZOqTtuXk8oyKLJKXZpC2qp/TlZX9pmGRekjJAKVSa4BS9sCq7jhVxQqXvS
        nbUB22vtFuSzIkDiYiTx04D8HbvpIhlmHNAaFyxIyCwmu3y5lh9VsWqzWxPqu3z5oCEapcpR9CQJg
        IOADSBosQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iiFCR-0007FE-13; Fri, 20 Dec 2019 10:07:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1303830411B;
        Fri, 20 Dec 2019 11:06:33 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F125C203A8990; Fri, 20 Dec 2019 11:07:56 +0100 (CET)
Date:   Fri, 20 Dec 2019 11:07:56 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     X86 ML <x86@kernel.org>, Feng Tang <feng.tang@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/quirks: disable HPET on Intel Coffee Lake Refresh
 platforms
Message-ID: <20191220100756.GF2844@hirez.programming.kicks-ass.net>
References: <20191203205716.1228-1-Jason@zx2c4.com>
 <20191209154505.6183-1-Jason@zx2c4.com>
 <CAHmME9q3mcE+Am5e=R=z=kJrkjwmz_tWqt7jc1b-7DiPt0vWNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9q3mcE+Am5e=R=z=kJrkjwmz_tWqt7jc1b-7DiPt0vWNw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 20, 2019 at 02:42:59AM +0100, Jason A. Donenfeld wrote:
> Hi,
> 
> Thought I should give a poke here so that this doesn't slip through
> the cracks again. Could we get this in for rc3?

I think another version of this patch made it in recently, see commit:

  f8edbde885bb ("x86/intel: Disable HPET on Intel Coffee Lake H platforms")

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
