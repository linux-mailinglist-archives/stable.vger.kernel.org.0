Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A458F1272F2
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 02:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLTBnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 20:43:13 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:53159 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbfLTBnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 20:43:13 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6083baea
        for <stable@vger.kernel.org>;
        Fri, 20 Dec 2019 00:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=XLwH+H8gpSnvg+OJl0InL3nyUUw=; b=b15s1g
        Bk4EcFfFm0sL/2nn0/7Dzpke74A1+cnATyq/kKAQqjL4991Fs0LkQDTFHap9HGis
        bjtqpC2+Ta2XB0iOwag6201ozF+sjtAY+vWnZ0cnAUXGfNwtxGjMfB2LjMsQIEbz
        CTxvBBbBTbxnkMeUFNmIeIXFwSmEdvmJiCeajbI7eGqTTFU6z2RcdncSY65QmLFN
        6yHWYYBtQYPWFXUvws1hhEKdx/odyiydZhZFBpQAOfjE3d16ANs2dhPSowSafjfs
        lI/zdBClNKAoBsQ64HTm6rHszm3G0R1vxg6QE9Szh519QhHDBUJ90XMHT6Fb8jFG
        zC34dbGB68o1j7rw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 57195056 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Fri, 20 Dec 2019 00:46:25 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id w21so1940387otj.7
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 17:43:11 -0800 (PST)
X-Gm-Message-State: APjAAAXErx2k22lLONTwq6oAotgL7Aqm/EUPd/VFIeq33706dMjIIN2K
        E96qI+IgD2mXZo7BoF2QxmYSlUl8ojQI/MqHdak=
X-Google-Smtp-Source: APXvYqxhW+TFjrTeB0FhBZAxrz01bJ0xO5DD4cJcTb7jXU9+Fh53GCcaMCv3lSNKByJ1HQsqMvEh+QsGp1O6IgDtPlo=
X-Received: by 2002:a05:6830:1141:: with SMTP id x1mr12370602otq.120.1576806190494;
 Thu, 19 Dec 2019 17:43:10 -0800 (PST)
MIME-Version: 1.0
References: <20191203205716.1228-1-Jason@zx2c4.com> <20191209154505.6183-1-Jason@zx2c4.com>
In-Reply-To: <20191209154505.6183-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 20 Dec 2019 02:42:59 +0100
X-Gmail-Original-Message-ID: <CAHmME9q3mcE+Am5e=R=z=kJrkjwmz_tWqt7jc1b-7DiPt0vWNw@mail.gmail.com>
Message-ID: <CAHmME9q3mcE+Am5e=R=z=kJrkjwmz_tWqt7jc1b-7DiPt0vWNw@mail.gmail.com>
Subject: Re: [PATCH] x86/quirks: disable HPET on Intel Coffee Lake Refresh platforms
To:     X86 ML <x86@kernel.org>
Cc:     Feng Tang <feng.tang@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thought I should give a poke here so that this doesn't slip through
the cracks again. Could we get this in for rc3?

Thanks,
Jason

On Mon, Dec 9, 2019 at 4:45 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
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
