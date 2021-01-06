Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913AA2EC48D
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 21:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbhAFUPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 15:15:09 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:48492 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbhAFUPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 15:15:09 -0500
Date:   Wed, 06 Jan 2021 20:14:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1609964066; bh=WJzK6tqy2kudlSwkM4O7gMAIJYEZptuNFADdyTc5dhI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=HwpAema3qYw7H0Uk8Mw4bpCmFURtP/90veXgW/rvDH+kzWJzez0CW6Q+786ZxxOyo
         BvvlWdgX2LfkqmpIXLlZGnXwRx+33dZ9lMdwn7WK1gvuIoF5C5bFi4o9bAvZmir+uF
         iD2zd0xHjq4zInQxaOJtr/3QDoX0OHxq8Aa6Ld5k0lpFfW/m69oDZU7Mbo98dlEDBI
         cWpGNjxFxlMYHasUKvfqillR87YtA4VQ/tpA2jQpjK9uyOCQWzLTFM9cRNiFp9qZif
         bl3GGXkbwyvRMoznX092HfTqPbGau3RgaJHCAmtBS2wMQwAHCa3j6/PD1SUpJWSAL6
         AIS0dkxUi8RGw==
To:     Nathan Chancellor <natechancellor@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alex Smith <alex.smith@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH mips-next 0/4] MIPS: vmlinux.lds.S sections fix & cleanup
Message-ID: <20210106201400.32416-1-alobakin@pm.me>
In-Reply-To: <20210104121729.46981-1-alobakin@pm.me>
References: <20210104121729.46981-1-alobakin@pm.me>
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

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Mon, 4 Jan 2021 17:09:36 -0700

> On Mon, Jan 04, 2021 at 12:18:10PM +0000, Alexander Lobakin wrote:
>> This series hunts the problems discovered after manual enabling of
>> ARCH_WANT_LD_ORPHAN_WARN, notably the missing PAGE_ALIGNED_DATA()
>> section affecting VDSO placement (marked for stable).
>>
>> Compile and runtime tested on MIPS32R2 CPS board with no issues.
>>
>> Alexander Lobakin (4):
>>   MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
>>   MIPS: vmlinux.lds.S: add ".rel.dyn" to DISCARDS
>>   MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
>>   MIPS: select ARCH_WANT_LD_ORPHAN_WARN
>>
>>  arch/mips/Kconfig              | 1 +
>>  arch/mips/kernel/vmlinux.lds.S | 5 ++++-
>>  2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> --
>> 2.30.0
>>
>
> Glad to see ARCH_WANT_LD_ORPHAN_WARN catching on :)
>
> I took this for a spin with clang with malta_kvm_guest_defconfig and I
> only see one section unaccounted for:
>
> $ make -skj"$(nproc)" ARCH=3Dmips CROSS_COMPILE=3Dmipsel-linux-gnu- LLVM=
=3D1 O=3Dout/mips distclean malta_kvm_guest_defconfig all
> ...
> ld.lld: warning: <internal>:(.got) is being placed in '.got'
> ld.lld: warning: <internal>:(.got) is being placed in '.got'
> ld.lld: warning: <internal>:(.got) is being placed in '.got'
>
> Looks like most architectures place it in .got (ia64, nios2, powerpc)
> or .text (arm64).

Addressed in v2, thanks!

> Cheers,
> Nathan

Al

