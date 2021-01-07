Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE352ECF4B
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 13:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbhAGMAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 07:00:04 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:22404 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbhAGMAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 07:00:04 -0500
Date:   Thu, 07 Jan 2021 11:59:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610020761; bh=/QpZtUfW8sCY4JlyQE+cRg/152g/kjH3nLFh80d0Hbk=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Ngatwy647URiYFOHt2f6ts1sFxqi75bAxDr7xnIcvZPgZuOkMvFjU0eJYV52wuChA
         46KkuGuhpJOWdXPO24qMOoClJI5Gldx28BrcUawpgP5aN/uHvVjChV+R8GoATIQ584
         035sbeP9/VlhUJ+cnJ7r+EXdoXtMwkh3nofFve85s0zp5hi6p+4UBsAEj/hMzPl664
         Gv1W9LSRdIKlsOYoqp9xWCZ5LSOcABn1CbRqRSUzqZxHBZEirihfdEpOoTqKk9DvRc
         wUjnpKugp5AAOqgYJ2hFfcOxfqbIZg7GxMrimwapaM+EN0NnWY9FkPxdj29nCS28Ha
         DgXM++POOkCSQ==
To:     Kees Cook <keescook@chromium.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alex Smith <alex.smith@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 mips-next 2/4] MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
Message-ID: <20210107115855.281681-1-alobakin@pm.me>
In-Reply-To: <202101061518.67B9E0205@keescook>
References: <20210106200713.31840-1-alobakin@pm.me> <20210106200801.31993-1-alobakin@pm.me> <20210106200801.31993-2-alobakin@pm.me> <202101061400.8F83981AE@keescook> <20210106223606.267756-1-alobakin@pm.me> <202101061518.67B9E0205@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Wed, 6 Jan 2021 15:26:18 -0800

> On Wed, Jan 06, 2021 at 10:36:38PM +0000, Alexander Lobakin wrote:
>> From: Kees Cook <keescook@chromium.org>
>> Date: Wed, 6 Jan 2021 14:07:07 -0800
>>
>>> On Wed, Jan 06, 2021 at 08:08:19PM +0000, Alexander Lobakin wrote:
>>>> Discard GNU attributes at link time as kernel doesn't use it at all.
>>>> Solves a dozen of the following ld warnings (one per every file):
>>>>
>>>> mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
>>>> from `arch/mips/kernel/head.o' being placed in section
>>>> `.gnu.attributes'
>>>> mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
>>>> from `init/main.o' being placed in section `.gnu.attributes'
>>>>
>>>> Misc: sort DISCARDS section entries alphabetically.
>>>
>>> Hmm, I wonder what is causing the appearance of .eh_frame? With help I
>>> tracked down all the causes of this on x86, arm, and arm64, so that's
>>> why it's not in the asm-generic DISCARDS section. I suspect this could
>>> be cleaned up for mips too?
>>
>> I could take a look and hunt it down. Could you please give some refs on
>> what were the causes and solutions for the mentioned architectures?
>
> Sure! Here are the ones I could find again:
>
> 34b4a5c54c42 ("arm64/kernel: Remove needless Call Frame Information annot=
ations")
> 6e0a66d10c5b ("arm64/build: Remove .eh_frame* sections due to unwind tabl=
es")
> d1c0272bc1c0 ("x86/boot/compressed: Remove, discard, or assert for unwant=
ed sections")
>
>>> Similarly for .gnu.attributes. What is generating that? (Or, more
>>> specifically, why is it both being generated AND discarded?)
>>
>> On my setup, GNU Attributes consist of MIPS FP type (soft) and
>> (if I'm correct) MIPS GNU Hash tables.
>
> Ah, right, the soft-float markings sound correct to discard, IIUC.
>
>> By the way. I've built the kernel with LLVM stack (and found several
>> subjects for more patches) and, besides '.got', also got a fistful
>> of '.data..compoundliteral*' symbols (drivers/mtd/nand/spi/,
>> net/ipv6/ etc). Where should they be placed (rodata, rwdata, ...)
>> or they are anomalies of some kind and should be fixed somehow?
>
> Ah yeah, I've seen this before:
> https://lore.kernel.org/lkml/202010051345.2Q0cvqdM-lkp@intel.com/
> https://lore.kernel.org/lkml/CAKwvOd=3Ds53vUELe311VSjxt2_eQd+RGNCf__n+cV+=
R=3DPQ_CdXQ@mail.gmail.com/
>
> And it looks like LTO trips over it too:
> https://lore.kernel.org/lkml/20201211184633.3213045-3-samitolvanen@google=
.com/
>
> So I think the correct solution is to follow Sami's patch and add it to
> vmlinux.lds.h:
>
> -#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX*
> +#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..L* .data..compoundlit=
eral*
> ...
> -#define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]*
> -#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]*
> +#define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]* .rodata..L*
> +#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..compoundliteral*
>
> Can you include a patch for this in your series?
>
> Thanks!

Thanks for the help!
Hope now I caught them all properly in v3.

> --
> Kees Cook

Al

