Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D33F2162EAA
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgBRSg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:36:29 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37395 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgBRSg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 13:36:29 -0500
Received: by mail-pl1-f195.google.com with SMTP id c23so8421765plz.4
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 10:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=deSq0a14rSLUpPG1ENh74nUw4fh0dIpGPEl5kTUgrmw=;
        b=omEsIjt8aCcWfGTycR646o4RZaZaKMTiWee69L+h8Fll5DulpeCtdxPisOy8v0kvAM
         vu/2SlirKz3PFVgerQ+7mQNQVxEZgmSX+NtbNS8r1crMliYrPxUePrcoxH4zF2g3BuaO
         nefp+B1sAzPMdwKqxU82rlYdguWXyDAiEMndG+3ZRotaL7i8NbwThMLyeQs/ab6AZPXC
         506Ja+fL4Mqd1QNcEv6tcQhkhQ5JPNrVVmaNgG/Y6C6Q8033tQlpfDVvMg7Z9mnJLpgy
         dPMIiQPP6tjBmYU2cZ34bUrQB9figgSStewo8Mg6Cq+4r0QneW73BkVzmlIbsvSffU6W
         hWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=deSq0a14rSLUpPG1ENh74nUw4fh0dIpGPEl5kTUgrmw=;
        b=WwZDfIW+JLZq9OjDu8//NEbB4eFCzbtLSBD2lqBw1HvllvzU9MFKe8QRgforwLFUcm
         L7T0qZ+cSICwmJnnmGBVTdimu78iqOyXoIFMP5GHhQLMXIYwp4CDJjOqbbSmt3XPgIzF
         UwaI88sp68ySwFssbW0Kssajehxg3+L1hZp1RqhMtkyYydzBwDAY729XjXKurvxFc6Lw
         dOFZvKlQ4in5JiLhMpAkUiJi9tuibSOyOhI/zdACh5/CvCVIjLtI7vJ7cT7ZpB7GDDsB
         8S6Vq1g/bWxdj/NP6u1KABlkUngavHySrQZcF4vp4LBu7rWBT0OIL/EZx4eG7zwKjo74
         tyww==
X-Gm-Message-State: APjAAAVgKGjaR5i62ih5RFcZrqBf1WOhp9sIjSuPRftu1aWXFzj0DXfi
        HbfFDBGzj0EmE1//AYrR6klFJA==
X-Google-Smtp-Source: APXvYqwcYKKfwzMe9EN+17kdygLIXGc6z65srtD5bMH+mVuMdxWGlEWgWQagiLvoXlBPO5rzfJPmEA==
X-Received: by 2002:a17:902:426:: with SMTP id 35mr21802232ple.176.1582050988323;
        Tue, 18 Feb 2020 10:36:28 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:23a5:d584:6a92:3e3c])
        by smtp.gmail.com with ESMTPSA id z10sm5664511pgf.35.2020.02.18.10.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 10:36:27 -0800 (PST)
Date:   Tue, 18 Feb 2020 10:36:27 -0800 (PST)
X-Google-Original-Date: Tue, 18 Feb 2020 10:36:25 PST (-0800)
Subject:     Re: [PATCH] RISC-V: Don't enable all interrupts in trap_init()
In-Reply-To: <CAOnJCU+_CnH6XcXbVrf4LCg3s830n6x6OyWckzoBC-kG2yFpwQ@mail.gmail.com>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, anup@brainfault.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        linux-riscv@lists.infradead.org, Christoph Hellwig <hch@lst.de>
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     atishp@atishpatra.org
Message-ID: <mhng-afe8915b-f34a-49e5-86fd-92f5de4100ed@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 02 Feb 2020 03:48:18 PST (-0800), atishp@atishpatra.org wrote:
> On Sun, Feb 2, 2020 at 3:06 AM Anup Patel <anup.patel@wdc.com> wrote:
>>
>> Historically, we have been enabling all interrupts for each
>> HART in trap_init(). Ideally, we should only enable M-mode
>> interrupts for M-mode kernel and S-mode interrupts for S-mode
>> kernel in trap_init().
>>
>> Currently, we get suprious S-mode interrupts on Kendryte K210
>> board running M-mode NO-MMU kernel because we are enabling all
>> interrupts in trap_init(). To fix this, we only enable software
>> and external interrupt in trap_init(). In future, trap_init()
>> will only enable software interrupt and PLIC driver will enable
>> external interrupt using CPU notifiers.

I think we should add a proper interrupt controller driver for the per-hart
interrupt controllers, as doing this within the other drivers is ugly -- for
example, there's no reason an MMIO timer or interrupt controller driver should
be toggling these bits.

>> Cc: stable@vger.kernel.org
>> Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code)

I'd argue this actually fixes the M-mode stuff, since that's the first place
this issue shows up.  I've queued this with

Fixes: a4c3733d32a7 ("riscv: abstract out CSR names for supervisor vs machine mode")

instead, as that's the first commit that will actually write to MIE and
therefor the first commit that will actually exhibit bad behavior.  It also has
the advantage of making the patch apply on older trees, which should make life
easier for the stable folks.

>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
>> ---
>>  arch/riscv/kernel/traps.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
>> index f4cad5163bf2..ffb3d94bf0cc 100644
>> --- a/arch/riscv/kernel/traps.c
>> +++ b/arch/riscv/kernel/traps.c
>> @@ -156,6 +156,6 @@ void __init trap_init(void)
>>         csr_write(CSR_SCRATCH, 0);
>>         /* Set the exception vector address */
>>         csr_write(CSR_TVEC, &handle_exception);
>> -       /* Enable all interrupts */
>> -       csr_write(CSR_IE, -1);
>> +       /* Enable interrupts */
>> +       csr_write(CSR_IE, IE_SIE | IE_EIE);
>>  }
>> --
>> 2.17.1
>>
>>
>
> Looks good.
> Reviewed-by: Atish Patra <atish.patra@wdc.com>

Tested-by: Palmer Dabbelt <palmerdabbelt@google.com> [QMEU virt machine with SMP]
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>

I consider this a bugfix, so I'm targeting it for RCs.  It's on fixes and
should go up this week.

Thanks!
