Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFF4163B37
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 04:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgBSD2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 22:28:52 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39622 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgBSD2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 22:28:51 -0500
Received: by mail-wm1-f67.google.com with SMTP id c84so5130603wme.4
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 19:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PFrPzzwmpyAD/udwXE359rvjJD5ZEgk+K9aOBrdRGe4=;
        b=ZTcpg9Zvzm2Ac6+wAF372I1lGI//y+yRBrSU5kW2wA6VNPv3yptFR4gnP4NusurYX5
         E0Cyoe8S7d6FO50mtLaC/cDuQY9YtxgAglsLaKO+DuxNfOuBfuWUTfpxOFZn4Cnc39dk
         zlwhIpXITMnDYQuHmMuU5piaWl2f36nsUSq5cl6kr72sVhr4RZLDzsrHXidZCV9UrBYq
         seqSSXu1TEksjZLUk2AKA6e7vl7vJL8cfJGP3xLCpsEg+hVjCS0RQczc3Yfot+LKTh96
         p7p6ePUP+BwF2yl4uIDAY1g9zyOq1kn9ib/TbSTt1qSMHIgoqNWwT+93OKlkbsyKyqoq
         WDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PFrPzzwmpyAD/udwXE359rvjJD5ZEgk+K9aOBrdRGe4=;
        b=b0qxSZTh6FdjBgAt40OJkCxXxvEc+3Y9ZuQmm97tFxaely+BcWsABWTYTfiaYQMpYa
         MPGSw/Sry/Wb/OvPzotCAT2kUMWSbthJQskmJ/bKsQoG2umshYy18wJZpCn4yG31Sa2g
         vbP6J6CkoqOJzX1QYW1hSBMBAcw/TvF2RO1L1CsTxouK7Vk0ygvRlHfxSrXmm9POqjP/
         hx8sKxyUPNyrWABsM55E48MIKJVtasNZs6nDFFbdfmtSl9GSmOvtQiEPJh/qOm5KTvOj
         S0zss/Yd5BRYd29cN3Wgrp/CCdQBTS0IkK9Fy14VblTMKwyIV3NEhYWHm2QECNySALqv
         G1ZQ==
X-Gm-Message-State: APjAAAXegRr9Uxubp8UO25u4XK4yl5dluH7+3Jvc+FllrFDZu86fHz1C
        /7BJixgDFv64O4HCpXhQyZXiSbbyVMEgsNckj4T/0Q==
X-Google-Smtp-Source: APXvYqxSVPM8kfU6Iae8q2VWGU/sIXjjlqOBO7h73TYwMqPDl2u3Q1WJfEz4BPOyClmmzeP2Q3AidC1kme6QlYOAk0c=
X-Received: by 2002:a05:600c:285:: with SMTP id 5mr6773557wmk.120.1582082929545;
 Tue, 18 Feb 2020 19:28:49 -0800 (PST)
MIME-Version: 1.0
References: <CAOnJCU+_CnH6XcXbVrf4LCg3s830n6x6OyWckzoBC-kG2yFpwQ@mail.gmail.com>
 <mhng-afe8915b-f34a-49e5-86fd-92f5de4100ed@palmerdabbelt-glaptop1>
In-Reply-To: <mhng-afe8915b-f34a-49e5-86fd-92f5de4100ed@palmerdabbelt-glaptop1>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 19 Feb 2020 08:58:38 +0530
Message-ID: <CAAhSdy15mLGz3Xtu_Q7vOCP5Y2hQjWEosU1v8o8FxKfiLDx4qQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: Don't enable all interrupts in trap_init()
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Atish Patra <atishp@atishpatra.org>,
        Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 19, 2020 at 12:06 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Sun, 02 Feb 2020 03:48:18 PST (-0800), atishp@atishpatra.org wrote:
> > On Sun, Feb 2, 2020 at 3:06 AM Anup Patel <anup.patel@wdc.com> wrote:
> >>
> >> Historically, we have been enabling all interrupts for each
> >> HART in trap_init(). Ideally, we should only enable M-mode
> >> interrupts for M-mode kernel and S-mode interrupts for S-mode
> >> kernel in trap_init().
> >>
> >> Currently, we get suprious S-mode interrupts on Kendryte K210
> >> board running M-mode NO-MMU kernel because we are enabling all
> >> interrupts in trap_init(). To fix this, we only enable software
> >> and external interrupt in trap_init(). In future, trap_init()
> >> will only enable software interrupt and PLIC driver will enable
> >> external interrupt using CPU notifiers.
>
> I think we should add a proper interrupt controller driver for the per-hart
> interrupt controllers, as doing this within the other drivers is ugly -- for
> example, there's no reason an MMIO timer or interrupt controller driver should
> be toggling these bits.

I have always been in support of having per-hart interrupt controller driver.

I will rebase my RISC-V INTC driver upon latest kernel and send it again.
Of course, now the situation has changed the RISC-V INTC driver will
have to consider NOMMU kernel as well.

The last version of RISC-V INTC driver can be found in riscv_intc_v2
branch of https://github.com/avpatel/linux.git

>
> >> Cc: stable@vger.kernel.org
> >> Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code)
>
> I'd argue this actually fixes the M-mode stuff, since that's the first place
> this issue shows up.  I've queued this with
>
> Fixes: a4c3733d32a7 ("riscv: abstract out CSR names for supervisor vs machine mode")
>
> instead, as that's the first commit that will actually write to MIE and
> therefor the first commit that will actually exhibit bad behavior.  It also has
> the advantage of making the patch apply on older trees, which should make life
> easier for the stable folks.

Sure, no problem.

>
> >> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> >> ---
> >>  arch/riscv/kernel/traps.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
> >> index f4cad5163bf2..ffb3d94bf0cc 100644
> >> --- a/arch/riscv/kernel/traps.c
> >> +++ b/arch/riscv/kernel/traps.c
> >> @@ -156,6 +156,6 @@ void __init trap_init(void)
> >>         csr_write(CSR_SCRATCH, 0);
> >>         /* Set the exception vector address */
> >>         csr_write(CSR_TVEC, &handle_exception);
> >> -       /* Enable all interrupts */
> >> -       csr_write(CSR_IE, -1);
> >> +       /* Enable interrupts */
> >> +       csr_write(CSR_IE, IE_SIE | IE_EIE);
> >>  }
> >> --
> >> 2.17.1
> >>
> >>
> >
> > Looks good.
> > Reviewed-by: Atish Patra <atish.patra@wdc.com>
>
> Tested-by: Palmer Dabbelt <palmerdabbelt@google.com> [QMEU virt machine with SMP]
> Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
>
> I consider this a bugfix, so I'm targeting it for RCs.  It's on fixes and
> should go up this week.
>
> Thanks!

Thanks,
Anup
