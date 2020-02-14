Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155A615D33C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 08:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgBNH4A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 14 Feb 2020 02:56:00 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46912 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgBNH4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 02:56:00 -0500
Received: by mail-ot1-f67.google.com with SMTP id g64so8278372otb.13;
        Thu, 13 Feb 2020 23:56:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7oQONjLNlEZepD8Y2r5t+j56WISZpm8LS3SWu/bbMS8=;
        b=LoWNVwZvw6Cxhw9xOidUFGWhRw7qFg/2ErZzhsi7hkw3Loqj1xPPN/hw5Cp6gvBach
         51Vrl1CkZlH5lZQfcRyI8fk2N7pjsp1NiEcNlJys1x4vI+3rzxN6UNEopj30SYEWPDD1
         63ZCyxD5M8a1w2mRy0WVacYr4NfmCNB54t6iYTOOg699BOAuKwh1B368+a2Mpb2TtyXD
         iDMVhzbh8OwECqqVR1cNbUhHWsuIU8N2fJULko1VUNac6BJOIppl5cxbm2w4RyVBiILa
         9QLUzR3cxHvY/jPvfgiaf4qmUk1gOSUv0epMKhvkdHYRZiyJUjjDxtPndk4xNPtxCp6/
         X8Hw==
X-Gm-Message-State: APjAAAWM8sJLFnuoClL3vVJZeWnNJN0i+rqdgNdqbsmn/b63DIEPcRTc
        6u9FpKkbh1/KIrqYu9SFKCGk/5kRMv6FTzw0oLQ=
X-Google-Smtp-Source: APXvYqxDeWmOc69NHWSa6PwqqMjpTxI+i2WBomfCoxkfPUQbLE6azVsZ1oV9DuLc2U8uR66fSJB33go/01gP97cCVJ4=
X-Received: by 2002:a05:6830:1d55:: with SMTP id p21mr1223936oth.145.1581666959566;
 Thu, 13 Feb 2020 23:55:59 -0800 (PST)
MIME-Version: 1.0
References: <20200213151839.156309910@linuxfoundation.org> <20200213222732.GA20637@roeck-us.net>
In-Reply-To: <20200213222732.GA20637@roeck-us.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 14 Feb 2020 08:55:48 +0100
Message-ID: <CAMuHMdV0nRPVjRpvVuZBMpaTfQGeMQN-2xrSehDwXOoG=4iATw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/96] 5.4.20-stable review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Günter,

On Thu, Feb 13, 2020 at 11:28 PM Guenter Roeck <linux@roeck-us.net> wrote:
> On Thu, Feb 13, 2020 at 07:20:07AM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.20 release.
> > There are 96 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> > Anything received after that time might be too late.
> >
>
> Build reference: v5.4.19-98-gdfae536f94c2
> gcc version: powerpc64-linux-gcc (GCC) 9.2.0
>
> Building powerpc:defconfig ... failed
> --------------
> Error log:
> drivers/rtc/rtc-ds1307.c:1570:21: error: variable 'regmap_config' has initializer but incomplete type
>  1570 | static const struct regmap_config regmap_config = {
>
> Bisect log below. Looks like the the definition of "not needed"
> needs an update.

"not needed" goes together with (or after) "when necessary":
578c2b661e2b1b47 ("rtc: Kconfig: select REGMAP_I2C when necessary")

> v5.5.y has the same problem.
>
> Guenter
>
> ---
> # bad: [dfae536f94c22d5fd109d5db73cd5ed7245a764c] Linux 5.4.20-rc1
> # good: [d6591ea2dd1a44b1c72c5a3e3b6555d7585acdae] Linux 5.4.19
> git bisect start 'HEAD' 'v5.4.19'
> # bad: [f52a8d450b1431b775d993cd8586f0cfd5fe25e1] ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
> git bisect bad f52a8d450b1431b775d993cd8586f0cfd5fe25e1
> # good: [99323d91be3464a8ff87c7b16c72e7134b7b5075] selftests/bpf: Test freeing sockmap/sockhash with a socket in it
> git bisect good 99323d91be3464a8ff87c7b16c72e7134b7b5075
> # bad: [4ece240000532dbe0628f28f3f5466ed4091613b] rtc: i2c/spi: Avoid inclusion of REGMAP support when not needed
> git bisect bad 4ece240000532dbe0628f28f3f5466ed4091613b
> # good: [3a0805bedf5a29ff659d82b34ccf8f393820a5f1] NFS: Fix fix of show_nfs_errors
> git bisect good 3a0805bedf5a29ff659d82b34ccf8f393820a5f1
> # good: [bd35cae202fa94fe8349ea63ea082f190b31692c] NFSv4.0: nfs4_do_fsinfo() should not do implicit lease renewals
> git bisect good bd35cae202fa94fe8349ea63ea082f190b31692c
> # good: [d052da5a3c584de39b4b74176b37925d58ab4239] rtc: hym8563: Return -EINVAL if the time is known to be invalid
> git bisect good d052da5a3c584de39b4b74176b37925d58ab4239
> # first bad commit: [4ece240000532dbe0628f28f3f5466ed4091613b] rtc: i2c/spi: Avoid inclusion of REGMAP support when not needed

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
