Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862D340CCE9
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 21:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhIOTCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 15:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230454AbhIOTCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 15:02:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E1666103C;
        Wed, 15 Sep 2021 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631732450;
        bh=YkcmojiGY9QQWNOZSXXazF7PH72SyPEf2FF46vMZGi4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OFjb8HjsSmZK+4SVeiFai01070Y1zogb4vqszFPpGhM9vIyDkZs9APM/9Tcs/kDk7
         VF1V3FeNh5MAvGK7lhKuylpqPmESdCbrAnOt5BL8h5OF3F7aLtD5kKuNUC49mjp20r
         QX/1YX9xCbiR+/iE99ZN4NQ3CFJU0fsxBv7GUiE4WAhCUmZblcVcVTDUVTkJlT6+do
         7T1suanyadkwGd3/C9EzqSgt15BoGV4bceSWAG5r8KO+wwIRYzb5QTUFs4kLgrg0nK
         7e4vk3tj9iz1KIrwdewGmCJWliO+VYgKZV4uWILHGv5tk3FPiYg0mHZw2KizlZTdrj
         4yalWMo018cOQ==
Received: by mail-wr1-f53.google.com with SMTP id i23so5501528wrb.2;
        Wed, 15 Sep 2021 12:00:50 -0700 (PDT)
X-Gm-Message-State: AOAM531pic0hhcXxlTjjTm36rCupRNxguLdNwxkyMyekhCfX4xFpb5jc
        1SP0zzEZoMN9seusjQ1z4GL/Sw7BE8KgBTaIXyM=
X-Google-Smtp-Source: ABdhPJx8Nor137Y0AwvNBzqyTieu/xOANX3s9f7G1HqlVUhP8yp1vwLVZbH/Ct+G2pARpk8PDQr+RpjPUVT8GnvVKrE=
X-Received: by 2002:adf:c10b:: with SMTP id r11mr1734773wre.336.1631732448752;
 Wed, 15 Sep 2021 12:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131123.500712780@linuxfoundation.org>
In-Reply-To: <20210913131123.500712780@linuxfoundation.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 15 Sep 2021 21:00:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
Message-ID: <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in timespec64_to_ns()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 1:22 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>  /*
>   * Limits for settimeofday():
> @@ -124,10 +126,13 @@ static inline bool timespec64_valid_sett
>   */
>  static inline s64 timespec64_to_ns(const struct timespec64 *ts)
>  {
> -       /* Prevent multiplication overflow */
> -       if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
> +       /* Prevent multiplication overflow / underflow */
> +       if (ts->tv_sec >= KTIME_SEC_MAX)
>                 return KTIME_MAX;
>
> +       if (ts->tv_sec <= KTIME_SEC_MIN)
> +               return KTIME_MIN;
> +

I just saw this get merged for the stable kernels, and had not seen this when
Thomas originally merged it.

I can see how this helps the ptp_clock_adjtime() users, but I just
double-checked
what other callers exist, and I think it introduces a regression in setitimer(),
which does

        nval = timespec64_to_ns(&value->it_value);
        ninterval = timespec64_to_ns(&value->it_interval);

without any further range checking that I could find. Setting timers
with negative intervals sounds like a bad idea, and interpreting negative
it_value as a past time instead of KTIME_SEC_MAX sounds like an
unintended interface change.

I haven't done any proper analysis of the changes, so maybe it's all
good, but I think we need to double-check this, and possibly revert
it from the stable kernels until a final conclusion.

        Arnd
