Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F23116E2E
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 14:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfLINwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 08:52:45 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:40033 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbfLINwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 08:52:45 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b843a08c;
        Mon, 9 Dec 2019 12:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=RYPNAO8pwh6iCrx5e80LVpnefCE=; b=M3+dta
        J7fmYlPDFrZRk+CrGkxx3YJCFKgETgpVGUG5heIeWum69Y5vuRHU/rnSqQ6A7dLW
        Siq7ElxDAAkxBuL0AimVlIE5BUdRDT760Jab3N6QU9Jf+GH2cepj432920uO0QaM
        MQGuXgi5LiKSDgtS0ynKd5Z5f3Q/5e5ZXcUz4D//NVT5dundtG8QIpowgsaZIc44
        uBib3CadAfB1rIfK04Evhi3GlDVPCXExbuynCGG3VgwGoFzPYuj/JtLKrPw4GzGk
        Nkc9FNPPLG12Z9+9DB93S0YzR4JPvrU2D0o1z2jWdaX5ydcjo2Moh3wwVVL80VDX
        j3b6jvnJQJjQnbEQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e11ee197 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 9 Dec 2019 12:57:18 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id i4so12229795otr.3;
        Mon, 09 Dec 2019 05:52:43 -0800 (PST)
X-Gm-Message-State: APjAAAW0DYnkETybioBkwxN+WqwONLTeaZoBV/Av2lyz4HMcXUGzuqTV
        uOE2iJzIKVXSJe5KZpILiE5vluYnpIDfI2QvnQg=
X-Google-Smtp-Source: APXvYqyVURC5GTgUeS/91sj5vlJHeKhQEPMupfCXUeqGgPXGNQ5muw4Z3JyBpQmGlSHhAbaTSe0vPvDWaGq2pBLboqM=
X-Received: by 2002:a05:6830:1b6a:: with SMTP id d10mr21943419ote.52.1575899562452;
 Mon, 09 Dec 2019 05:52:42 -0800 (PST)
MIME-Version: 1.0
References: <20191203205716.1228-1-Jason@zx2c4.com>
In-Reply-To: <20191203205716.1228-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 9 Dec 2019 14:52:31 +0100
X-Gmail-Original-Message-ID: <CAHmME9qhDwHo8TEYy7TwukyMS2siS7yYP1o8dDBSe0x5BFQDWg@mail.gmail.com>
Message-ID: <CAHmME9qhDwHo8TEYy7TwukyMS2siS7yYP1o8dDBSe0x5BFQDWg@mail.gmail.com>
Subject: Re: [PATCH] x86/quirks: disable HPET on Intel Coffee Lake Refresh platforms
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Feng Tang <feng.tang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Thomas,

Can we perhaps get this into 5.5-rc2?

It'd be nice if Intel could give us a list of SKUs that are affected
(as you asked in another email thread), but barring that, the best we
can do is whack-a-mole like this. I'm typing you this email on the
hardware that this patch addresses.

Jason

On Tue, Dec 3, 2019 at 9:57 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> This is a follow up of fc5db58539b4 ("x86/quirks: Disable HPET on Intel
> Coffe Lake platforms"), which addressed the issue for 8th generation
> Coffee Lake. Intel has released Coffee Lake again for 9th generation,
> apparently still with the same bug:
>
> clocksource: timekeeping watchdog on CPU3: Marking clocksource 'tsc' as unstable because the skew is too large:
> clocksource:                       'hpet' wd_now: 24f422b8 wd_last: 247dea41 mask: ffffffff
> clocksource:                       'tsc' cs_now: 144d927c4e cs_last: 140ba6e2a0 mask: ffffffffffffffff
> tsc: Marking TSC unstable due to clocksource watchdog
> TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
> sched_clock: Marking unstable (26553416234, 4203921)<-(26567277071, -9656937)
> clocksource: Switched to clocksource hpet
>
> So, we add another quirk for the chipset
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/early-quirks.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 4cba91ec8049..a73f88dd7f86 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -712,6 +712,8 @@ static struct chipset early_qrk[] __initdata = {
>                 PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>         { PCI_VENDOR_ID_INTEL, 0x3ec4,
>                 PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> +       { PCI_VENDOR_ID_INTEL, 0x3e20,
> +               PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>         { PCI_VENDOR_ID_BROADCOM, 0x4331,
>           PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
>         {}
> --
> 2.24.0
