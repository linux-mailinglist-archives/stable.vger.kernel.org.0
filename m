Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B150215610A
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 23:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgBGWLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 17:11:47 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41509 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgBGWLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 17:11:47 -0500
Received: by mail-pf1-f195.google.com with SMTP id j9so461327pfa.8;
        Fri, 07 Feb 2020 14:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7P/U6HZAjWu6p04qNYo876LE15VgVDEKsC4BF07QYgA=;
        b=Ov1OzCf4XM5HbpNu0KOsV01jip1NCZlK6yacs2PhA/P8Ib4d0qvaP1lVfBLYJ9ZIyx
         cqXpEYXMRT4DcBEpig8chVk//qN7of/wgY/QGzASxYo0i2uHW4ffhcWm05AuLLa9ef+W
         48wck5oUzNr8rhXOfiXvTLlHzgzE20/dtJrIfdPgexL3cHJrEav8uydtnd396fViLI1B
         qznUisCPUs/xYEHpSq7+kjct0fSncN6bMhKUSM9g3Ps8lY86MN1evwcjSKhLbvS5k6mW
         oXqRMbjnXw0fp+x3emB95oFAfJR1k6L0NXCV1lDdeK/koNC2AHKBmQ5wUuB8S2kF2aIP
         hEnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7P/U6HZAjWu6p04qNYo876LE15VgVDEKsC4BF07QYgA=;
        b=mXfteJv6O2PIOTE9kc9rd56UENEtXhefXI0uToLiqhEvDtaxJH2j5mBSydTSAhNcQ5
         rWQSTSztazId2vt+OuY3mNz5p4e6OZFxm4jun+5qXmmvzaNLyJ3PkBygfmlJrna0Il4B
         OlxnbxkjlgKMCL0PaqcHYTWbOAsBR2ZNmt54bcuXd+UuPj3qMLW8Z/NMrXvfuekSJU4F
         NHDlY4/kzqwJQr2RksxciCDbF0SxPeJeDGF4i/toYtZJW8ray6M/l2SdXXRQ+Z4fnY5P
         X9PK/+5VZfwdRSO7a0+UUG13/+YB+p/LPoppFMXKkqNW2ueFhsijvQBpCSM2VAN8hxXC
         yZaQ==
X-Gm-Message-State: APjAAAX7Ud0rm/Rtso0lmsWOrdysGvC4y6WeR5Rpi/mNSwZMx3qbZBs2
        1/apoY7aHhpup8lm0J0KLfrNpx3BkrcKyBuW4VM=
X-Google-Smtp-Source: APXvYqyz2HVfYX7Rb1FnU73yT8RBGg8g3y6ZBvIRRkaYlXI5NPK4Rlq0V5QzS3iBjuC9KvarEM4FdE8T94fHuEsT+0s=
X-Received: by 2002:a65:4685:: with SMTP id h5mr1403414pgr.203.1581113504981;
 Fri, 07 Feb 2020 14:11:44 -0800 (PST)
MIME-Version: 1.0
References: <20200207205456.113758-1-hdegoede@redhat.com> <20200207205456.113758-3-hdegoede@redhat.com>
In-Reply-To: <20200207205456.113758-3-hdegoede@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 8 Feb 2020 00:11:33 +0200
Message-ID: <CAHp75VcEKS_XkdfqnydF3KgeH=Fk_9GyQfcmrs6D9rJbTuKstw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] x86/tsc_msr: Make MSR derived TSC frequency more accurate
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
        Rahul Tanwar <rahul.tanwar@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 7, 2020 at 10:55 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> The "Intel 64 and IA-32 Architectures Software Developer=E2=80=99s Manual
> Volume 4: Model-Specific Registers" has the following table for the
> values from freq_desc_byt:

For the LGM people in Cc list. Hans included you in order to confirm
what's going on with TSC on LGM SoC.
Can you do it in a way that we certainly know clocks with good
precision (and if Spread Spectrum is in use what should we put here)?

Tony, by the way, do you have any information about the rest?

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
>
> Cc: stable@vger.kernel.org
> Reported-by: Vipul Kumar <vipulk0511@gmail.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -s/DSM/SDM/
> -Do not refer to Merrifield / Moorefield as BYT / CHT, they only share th=
e
>  CPU core design and otherwise are significantly different
>
> Changes in v3:
> -Some code style tweaks and variable renames suggested by Andy Shevchenko
> ---
>  arch/x86/kernel/tsc_msr.c | 92 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 82 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
> index 95030895fffa..fbd8afe0ab56 100644
> --- a/arch/x86/kernel/tsc_msr.c
> +++ b/arch/x86/kernel/tsc_msr.c
> @@ -17,6 +17,23 @@
>
>  #define MAX_NUM_FREQS  16 /* 4 bits to select the frequency */
>
> +/*
> + * The frequency numbers in the SDM are e.g. 83.3 MHz, which does not co=
ntain a
> + * lot of accuracy which leads to clock drift. As far as we know Bay Tra=
il SoCs
> + * use a 25 MHz crystal and Cherry Trail uses a 19.2 MHz crystal, the cr=
ystal
> + * is the source clk for a root PLL which outputs 1600 and 100 MHz. It i=
s
> + * unclear if the root PLL outputs are used directly by the CPU clock PL=
L or
> + * if there is another PLL in between.
> + * This does not matter though, we can model the chain of PLLs as a sing=
le PLL
> + * with a quotient equal to the quotients of all PLLs in the chain multi=
plied.
> + * So we can create a simplified model of the CPU clock setup using a re=
ference
> + * clock of 100 MHz plus a quotient which gets us as close to the freque=
ncy
> + * from the SDM as possible.
> + * For the 83.3 MHz example from above this would give us 100 MHz * 5 / =
6 =3D
> + * 83 and 1/3 MHz, which matches exactly what has been measured on actua=
l hw.
> + */
> +#define TSC_REFERENCE_KHZ 100000
> +
>  /*
>   * If MSR_PERF_STAT[31] is set, the maximum resolved bus ratio can be
>   * read in MSR_PLATFORM_ID[12:8], otherwise in MSR_PERF_STAT[44:40].
> @@ -26,6 +43,14 @@
>   */
>  struct freq_desc {
>         bool use_msr_plat;
> +       struct {
> +               u32 multiplier;
> +               u32 divider;
> +       } muldiv[MAX_NUM_FREQS];
> +       /*
> +        * Some CPU frequencies in the SDM do not map to known PLL freqs,=
 in
> +        * that case the muldiv arrays is empty and the freqs array is us=
ed.
> +        */
>         u32 freqs[MAX_NUM_FREQS];
>         u32 mask;
>  };
> @@ -47,31 +72,66 @@ static const struct freq_desc freq_desc_clv =3D {
>         .mask =3D 0x07,
>  };
>
> +/*
> + * Bay Trail SDM MSR_FSB_FREQ frequencies simplified PLL model:
> + *  000:   100 *  5 /  6  =3D  83.3333 MHz
> + *  001:   100 *  1 /  1  =3D 100.0000 MHz
> + *  010:   100 *  4 /  3  =3D 133.3333 MHz
> + *  011:   100 *  7 /  6  =3D 116.6667 MHz
> + *  100:   100 *  4 /  5  =3D  80.0000 MHz
> + */
>  static const struct freq_desc freq_desc_byt =3D {
>         .use_msr_plat =3D true,
> -       .freqs =3D { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 },
> +       .muldiv =3D { { 5, 6 }, { 1, 1 }, { 4, 3 }, { 7, 6 },
> +                   { 4, 5 } },
>         .mask =3D 0x07,
>  };
>
> +/*
> + * Cherry Trail SDM MSR_FSB_FREQ frequencies simplified PLL model:
> + * 0000:   100 *  5 /  6  =3D  83.3333 MHz
> + * 0001:   100 *  1 /  1  =3D 100.0000 MHz
> + * 0010:   100 *  4 /  3  =3D 133.3333 MHz
> + * 0011:   100 *  7 /  6  =3D 116.6667 MHz
> + * 0100:   100 *  4 /  5  =3D  80.0000 MHz
> + * 0101:   100 * 14 / 15  =3D  93.3333 MHz
> + * 0110:   100 *  9 / 10  =3D  90.0000 MHz
> + * 0111:   100 *  8 /  9  =3D  88.8889 MHz
> + * 1000:   100 *  7 /  8  =3D  87.5000 MHz
> + */
>  static const struct freq_desc freq_desc_cht =3D {
>         .use_msr_plat =3D true,
> -       .freqs =3D { 83300, 100000, 133300, 116700, 80000, 93300, 90000,
> -                  88900, 87500 },
> +       .muldiv =3D { { 5, 6 }, {  1,  1 }, { 4,  3 }, { 7, 6 },
> +                   { 4, 5 }, { 14, 15 }, { 9, 10 }, { 8, 9 },
> +                   { 7, 8 } },
>         .mask =3D 0x0f,
>  };
>
> +/*
> + * Merriefield SDM MSR_FSB_FREQ frequencies simplified PLL model:
> + * 0001:   100 *  1 /  1  =3D 100.0000 MHz
> + * 0010:   100 *  4 /  3  =3D 133.3333 MHz
> + */
>  static const struct freq_desc freq_desc_tng =3D {
>         .use_msr_plat =3D true,
> -       .freqs =3D { 0, 100000, 133300, 0, 0, 0, 0, 0 },
> +       .muldiv =3D { { 0, 0 }, { 1, 1 }, { 4, 3 } },
>         .mask =3D 0x07,
>  };
>
> +/*
> + * Moorefield SDM MSR_FSB_FREQ frequencies simplified PLL model:
> + * 0000:   100 *  5 /  6  =3D  83.3333 MHz
> + * 0001:   100 *  1 /  1  =3D 100.0000 MHz
> + * 0010:   100 *  4 /  3  =3D 133.3333 MHz
> + * 0011:   100 *  1 /  1  =3D 100.0000 MHz
> + */
>  static const struct freq_desc freq_desc_ann =3D {
>         .use_msr_plat =3D true,
> -       .freqs =3D { 83300, 100000, 133300, 100000, 0, 0, 0, 0 },
> +       .muldiv =3D { { 5, 6 }, { 1, 1 }, { 4, 3 }, { 1, 1 } },
>         .mask =3D 0x0f,
>  };
>
> +/* 24 MHz crystal? : 24 * 13 / 4 =3D 78 MHz */
>  static const struct freq_desc freq_desc_lgm =3D {
>         .use_msr_plat =3D true,
>         .freqs =3D { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 780=
00 },
> @@ -120,11 +180,23 @@ unsigned long cpu_khz_from_msr(void)
>         rdmsr(MSR_FSB_FREQ, lo, hi);
>         index =3D lo & freq_desc->mask;
>
> -       /* Map CPU reference clock freq ID(0-7) to CPU reference clock fr=
eq(KHz) */
> -       freq =3D freq_desc->freqs[index];
> -
> -       /* TSC frequency =3D maximum resolved freq * maximum resolved bus=
 ratio */
> -       res =3D freq * ratio;
> +       /*
> +        * Note this also catches cases where the index points to an unpo=
pulated
> +        * part of muldiv, in that case the else will set freq and res to=
 0.
> +        */
> +       if (freq_desc->muldiv[index].divider) {
> +               freq =3D DIV_ROUND_CLOSEST(TSC_REFERENCE_KHZ *
> +                                          freq_desc->muldiv[index].multi=
plier,
> +                                        freq_desc->muldiv[index].divider=
);
> +               /* Multiply by ratio before the divide for better accurac=
y */
> +               res =3D DIV_ROUND_CLOSEST(TSC_REFERENCE_KHZ *
> +                                          freq_desc->muldiv[index].multi=
plier *
> +                                          ratio,
> +                                       freq_desc->muldiv[index].divider)=
;
> +       } else {
> +               freq =3D freq_desc->freqs[index];
> +               res =3D freq * ratio;
> +       }
>
>         if (freq =3D=3D 0)
>                 pr_err("Error MSR_FSB_FREQ index %d is unknown\n", index)=
;
> --
> 2.25.0
>


--=20
With Best Regards,
Andy Shevchenko
