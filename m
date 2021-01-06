Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F292EC644
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 23:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbhAFWhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 17:37:24 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:34697 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbhAFWhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 17:37:24 -0500
X-Greylist: delayed 8894 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2021 17:37:23 EST
Date:   Wed, 06 Jan 2021 22:36:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1609972601; bh=k6M2q3UgsdjUwB9RMkadILtzv8IamufG6KQUruldxKM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=L6maY/yDbZ8Li0Yu7ap8dAql+A6dhNs6Z/myf6kVJ/LEMEKRzBpHeJB3K6Caxqpxw
         7Ix4vt5L6jfkFK6++/PLRVjeBWD0AObdMR3t1vk4ZA7I/8WgkaHP/vk/9XayK3XZXW
         H5r44Sb+JNddFSO3fmmLEtCN4qYiMYaMg/g0O+Ynmt03JLdONAWsVGXE3qwt3n74Z3
         wEmU3UZr5coSYU/YIg1FAszTV5Qt+LwQ6bvuXD0XJpCXNUCQmEoqzMPhkL/6bVDfHv
         1ga1Y22mEmL1T5yHnN+XgV0IGQ4R6l2hLDfOzNPhyHUAwrbE6/PrSOv8BAIGyq9NVU
         syUCww5on34kw==
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
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 mips-next 2/4] MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
Message-ID: <20210106223606.267756-1-alobakin@pm.me>
In-Reply-To: <202101061400.8F83981AE@keescook>
References: <20210106200713.31840-1-alobakin@pm.me> <20210106200801.31993-1-alobakin@pm.me> <20210106200801.31993-2-alobakin@pm.me> <202101061400.8F83981AE@keescook>
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
Date: Wed, 6 Jan 2021 14:07:07 -0800

> On Wed, Jan 06, 2021 at 08:08:19PM +0000, Alexander Lobakin wrote:
>> Discard GNU attributes at link time as kernel doesn't use it at all.
>> Solves a dozen of the following ld warnings (one per every file):
>>
>> mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
>> from `arch/mips/kernel/head.o' being placed in section
>> `.gnu.attributes'
>> mips-alpine-linux-musl-ld: warning: orphan section `.gnu.attributes'
>> from `init/main.o' being placed in section `.gnu.attributes'
>>
>> Misc: sort DISCARDS section entries alphabetically.
>
> Hmm, I wonder what is causing the appearance of .eh_frame? With help I
> tracked down all the causes of this on x86, arm, and arm64, so that's
> why it's not in the asm-generic DISCARDS section. I suspect this could
> be cleaned up for mips too?

I could take a look and hunt it down. Could you please give some refs on
what were the causes and solutions for the mentioned architectures?

> Similarly for .gnu.attributes. What is generating that? (Or, more
> specifically, why is it both being generated AND discarded?)

On my setup, GNU Attributes consist of MIPS FP type (soft) and
(if I'm correct) MIPS GNU Hash tables.

> -Kees

By the way. I've built the kernel with LLVM stack (and found several
subjects for more patches) and, besides '.got', also got a fistful
of '.data..compoundliteral*' symbols (drivers/mtd/nand/spi/,
net/ipv6/ etc). Where should they be placed (rodata, rwdata, ...)
or they are anomalies of some kind and should be fixed somehow?

>>
>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>> ---
>>  arch/mips/kernel/vmlinux.lds.S | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.l=
ds.S
>> index 83e27a181206..5d6563970ab2 100644
>> --- a/arch/mips/kernel/vmlinux.lds.S
>> +++ b/arch/mips/kernel/vmlinux.lds.S
>> @@ -221,9 +221,10 @@ SECTIONS
>>  =09=09/* ABI crap starts here */
>>  =09=09*(.MIPS.abiflags)
>>  =09=09*(.MIPS.options)
>> +=09=09*(.eh_frame)
>> +=09=09*(.gnu.attributes)
>>  =09=09*(.options)
>>  =09=09*(.pdr)
>>  =09=09*(.reginfo)
>> -=09=09*(.eh_frame)
>>  =09}
>>  }
>> --
>> 2.30.0
>>
>>
>
> --
> Kees Cook

Thanks,
Al

