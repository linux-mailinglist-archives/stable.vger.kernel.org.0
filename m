Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24AEF1A5D88
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 10:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgDLIoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 04:44:15 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45958 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgDLIoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 04:44:15 -0400
Received: by mail-oi1-f196.google.com with SMTP id k133so4407121oih.12;
        Sun, 12 Apr 2020 01:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1nytNGtuyh7aPHGCTZBNdWfHVT4mdjiF/o3w2hwxlkw=;
        b=n1iRatd+/D82s1VDGqN+JXB5oX9H/Ojv/SZ6QXJBUVW7R1iyMgStg++c0oUrtcaNPY
         sVwQPidz07mcO2WcMO44tPsGkkgNdZnPq1LhPVpvXiDtbzuw9xLexHyEW9P8k7YX85cY
         +obnujwUdQDhwCNIR1Pj2aB8to9PPW3zG6oXF/W/VxeLqS1x9aTFq8PsatbSp4qamtuW
         Ii1noMkTGxXCQlv71A7UTvqXA4yn5OtnwaffzCaxoDhCMqyRGqmOwjAdwK4iAn6uniNM
         Rw4vMs1xVN8aYQrjohyqZ7bLcJiJDhnE5O4yniy8AP3G5BcxRBDPD0sG8F1bz1SBnXtW
         N03g==
X-Gm-Message-State: AGi0PuZrxqPUONKgOokNT/luUjH3NQW1XKYj1pbaWdG/8Nu4fdUOJ0oj
        GiU05XLP44b0Gg94q+MerIiNH3xyTFgdEmG50IxCqVE4
X-Google-Smtp-Source: APiQypJmkPLTUaltcHqyClglyUvfg37fQ/CnHIR+vVpQZ5Yhaj8io+VwjGAN/TNE4a+YjxsSky6Xgvw1nnHGssq9k6g=
X-Received: by 2002:aca:cdd1:: with SMTP id d200mr8124950oig.153.1586681052851;
 Sun, 12 Apr 2020 01:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200411230943.24951-1-sashal@kernel.org> <20200411230943.24951-95-sashal@kernel.org>
In-Reply-To: <20200411230943.24951-95-sashal@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 12 Apr 2020 10:44:01 +0200
Message-ID: <CAMuHMdVrp25m_SDKSC=ntNWxsumcw4JKvHNDeFZT_JnpfQmCxg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 095/108] ARM: shmobile: Enable
 ARM_GLOBAL_TIMER on Cortex-A9 MPCore SoCs
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Sun, Apr 12, 2020 at 1:11 AM Sasha Levin <sashal@kernel.org> wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
>
> [ Upstream commit 408324a3c5383716939eea8096a0f999a0665f7e ]
>
> SH-Mobile AG5 and R-Car H1 SoCs are based on the Cortex-A9 MPCore, which
> includes a global timer.
>
> Enable the ARM global timer on these SoCs, which will be used for:
>   - the scheduler clock, improving scheduler accuracy from 10 ms to 3 or
>     4 ns,
>   - delay loops, allowing removal of calls to shmobile_init_delay() from
>     the corresponding machine vectors.
>
> Note that when using an old DTB lacking the global timer, the kernel
> will still work.  However, loops-per-jiffies will no longer be preset,
> and the delay loop will need to be calibrated during boot.

I.e. to avoid this delay, this patch is best backported after backporting
8443ffd1bbd5be74 ("ARM: dts: r8a7779: Add device node for ARM global timer"),
df1a0aac0a533e6f ("ARM: dts: sh73a0: Add device node for ARM global timer").

While the former has been backported to v5.[45]-stable, the latter hasn't,
probably because it depends on
61b58e3f6e518c51 ("ARM: dts: sh73a0: Rename twd clock to periph clock")

So please backport the last two commits first.
Thanks!

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Link: https://lore.kernel.org/r/20191211135222.26770-5-geert+renesas@glider.be
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
