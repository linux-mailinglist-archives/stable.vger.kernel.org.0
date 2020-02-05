Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E94C11535BE
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 17:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgBEQ7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 11:59:18 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43968 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBEQ7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 11:59:18 -0500
Received: by mail-pl1-f193.google.com with SMTP id p11so1107071plq.10;
        Wed, 05 Feb 2020 08:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hTvGyzpT8qWgq1PkSuDh1vstP+iebjXcB0FdkwebEs0=;
        b=swaAa7MyjKLSVKQJMu0q4FO6mx8x99K4GDOxgwjBF5Q1gZgW9em3lNEz5+Yz06L6+E
         JuGW2TzZ4kLEHB6lQ/KGbxkW+VdXCGGYxFM1Fctt52U6ixcAmPZvOol2xASHE99p5Pja
         jL8l1sfYQ2OIxomudN4Qu/3dK8+2vrWQi2BFl213BP0s74X5qKAYmWf3qlAOZI+4smlZ
         Onri87648JZcr8O4DJLRWNEhvrIAwtuwkS7aC+VXhw19aAWt17RbeLVt3Sg8w6ExbboP
         9pFQyOWzc+Y+K/5X7hRUSpHBY4Uh7mmVwS534POSUyt/k6zaj42EHbBZFbOK0KrPtZtJ
         8c3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hTvGyzpT8qWgq1PkSuDh1vstP+iebjXcB0FdkwebEs0=;
        b=WL1P518WoFqEqy9of5pfWAdkMMoGJhX5xGopzKVCJfl0putBqr2Jtn0+6EvENHyozH
         Cxd4MHwQ/AaPAhOU+HQcCBjAZp/xN7onuW4HWrVyqhtFeNa185XebU6C5QsEh9e09JUf
         qq++eLiHSY/j3WDzgg+fZAKPDftwWG7NxPXJZBKgIh2H2hnjvom9OmZmMl5n8QWE4e+J
         A66E6aWfhk9lIINt1gj6Uf/W/rYS+2hILQNJtprHAFntZ5viCL+vPK3k+vrIYOU8V9RQ
         db3AZl7gKt6gc0JcbsN9SN8rAzT4uuWU6QgPMfO0x0+LuXj3h2MRAKYIQE8FSXsbTVwb
         l+aw==
X-Gm-Message-State: APjAAAVLTk2LEADE0r/QYzkw3p6URt8osiQ/RFANgb5lVP9EiNOUpHOb
        8U0ZQYyA76wCDktCD5XqFHiXDJdu9i/3r6fWRvQ=
X-Google-Smtp-Source: APXvYqwL7ujGt16LVgoXGks815KdlepogsRexIXgXfzeGByh5N/nkq3IlNhYwf6wESLp8UO4d8ByoGXgo13HJ62pjtQ=
X-Received: by 2002:a17:902:b598:: with SMTP id a24mr35042557pls.262.1580921957186;
 Wed, 05 Feb 2020 08:59:17 -0800 (PST)
MIME-Version: 1.0
References: <20200205153428.437087-1-hdegoede@redhat.com> <20200205153428.437087-4-hdegoede@redhat.com>
In-Reply-To: <20200205153428.437087-4-hdegoede@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 5 Feb 2020 18:59:08 +0200
Message-ID: <CAHp75Vfc=LN+_iDLDZ2s-i-q6tZ-K_FV7hqAcH6fhwBA9-AHUQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] x86/tsc_msr: Make MSR derived TSC frequency more accurate
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 5, 2020 at 5:34 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> The "Intel 64 and IA-32 Architectures Software Developer=E2=80=99s Manual
> Volume 4: Model-Specific Registers" has the following table for the
> values from freq_desc_byt:
>
>    000B: 083.3 MHz
>    001B: 100.0 MHz
>    010B: 133.3 MHz
>    011B: 116.7 MHz
>    100B: 080.0 MHz
>
> Notice how for e.g the 83.3 MHz value there are 3 significant digits,
> which translates to an accuracy of a 1000 ppm, where as your typical
> crystal oscillator is 20 - 100 ppm, so the accuracy of the frequency
> format used in the Software Developer=E2=80=99s Manual is not really help=
ful.
>
> As far as we know Bay Trail SoCs use a 25 MHz crystal and Cherry Trail
> uses a 19.2 MHz crystal, the crystal is the source clk for a root PLL
> which outputs 1600 and 100 MHz. It is unclear if the root PLL outputs are
> used directly by the CPU clock PLL or if there is another PLL in between.
>
> This does not matter though, we can model the chain of PLLs as a single
> PLL with a quotient equal to the quotients of all PLLs in the chain
> multiplied.
>
> So we can create a simplified model of the CPU clock setup using a
> reference clock of 100 MHz plus a quotient which gets us as close to the
> frequency from the SDM as possible.
>
> For the 83.3 MHz example from above this would give us 100 MHz * 5 / 6 =
=3D
> 83 and 1/3 MHz, which matches exactly what has been measured on actual hw=
.
>
> This commit makes the tsc_msr.c code use a simplified PLL model with a
> reference clock of 100 MHz for all Bay and Cherry Trail models.
>
> This has been tested on the following models:
>
>               CPU freq before:        CPU freq after this commit:
> Intel N2840   2165.800 MHz            2166.667 MHz
> Intel Z3736   1332.800 MHz            1333.333 MHz
> Intel Z3775   1466.300 MHz            1466.667 MHz
> Intel Z8350   1440.000 MHz            1440.000 MHz
> Intel Z8750   1600.000 MHz            1600.000 MHz
>
> This fixes the time drifting by about 1 second per hour (20 - 30 seconds
> per day) on (some) devices which rely on the tsc_msr.c code to determine
> the TSC frequency.

Thanks for this effort!

...

> +#define REFERENCE_KHZ 100000

Perhaps TSC_REFERENCE_KHZ ?

...

> +       struct {
> +               u32 multiplier;
> +               u32 divider;
> +       } pairs[MAX_NUM_FREQS];

Perhaps pairs -> muldiv ?

...

> +       .pairs =3D { {  5,  6 }, { 1,  1 }, { 4, 3 }, { 7, 6 }, { 4, 5 },
> +                  { 14, 15 }, { 9, 10 }, { 8, 9 }, { 7, 8 } },

Maybe 4 per line or alike (8 per line) for better understanding which
muldiv maps to which value?

...

> +       .pairs =3D { { 0, 0 }, { 1, 1 }, { 4, 3 } },

And maybe list all of them always? (I'm fine with either approach).

...

> +/* 24 MHz crystal? : 24 * 13 / 4 =3D 78 MHz */

Perhaps Cc to LGM SoC developers team (they did it recently, so, they
have to know).

...

> +       if (freq_desc->pairs[index].divider) {

> +               freq =3D DIV_ROUND_CLOSEST(REFERENCE_KHZ *
> +                                           freq_desc->pairs[index].multi=
plier,
> +                                        freq_desc->pairs[index].divider)=
;

Maybe helper?

> +               /* Multiply by ratio before the divide for better accurac=
y */
> +               res =3D DIV_ROUND_CLOSEST(REFERENCE_KHZ *
> +                                           freq_desc->pairs[index].multi=
plier *
> +                                           ratio,
> +                                       freq_desc->pairs[index].divider);

...which may be used here as well.

> +       } else {
> +               freq =3D freq_desc->freqs[index];
> +               res =3D freq * ratio;
> +       }

--=20
With Best Regards,
Andy Shevchenko
