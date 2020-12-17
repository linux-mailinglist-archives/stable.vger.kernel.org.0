Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAA12DCB0B
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 03:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgLQCgM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 16 Dec 2020 21:36:12 -0500
Received: from aposti.net ([89.234.176.197]:53254 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbgLQCgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 21:36:10 -0500
Date:   Thu, 17 Dec 2020 02:35:14 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] MIPS: boot: Fix unaligned access with
 CONFIG_MIPS_RAW_APPENDED_DTB
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Nathan Chancellor <natechancellor@gmail.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Message-Id: <QUPGLQ.GMF1AOUMK24W@crapouillou.net>
In-Reply-To: <CAKwvOdnmt7v=+QdZbVYw9fDTeAhhHn0X++aLBa3uQVp7Gp=New@mail.gmail.com>
References: <20201216233956.280068-1-paul@crapouillou.net>
        <CAKwvOdnmt7v=+QdZbVYw9fDTeAhhHn0X++aLBa3uQVp7Gp=New@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nick,

Le mer. 16 déc. 2020 à 18:08, Nick Desaulniers 
<ndesaulniers@google.com> a écrit :
> On Wed, Dec 16, 2020 at 3:40 PM Paul Cercueil <paul@crapouillou.net> 
> wrote:
>> 
>>  The compressed payload is not necesarily 4-byte aligned, at least 
>> when
>>  compiling with Clang. In that case, the 4-byte value appended to the
>>  compressed payload that corresponds to the uncompressed kernel image
>>  size must be read using get_unaligned_le().
> 
> Should it be get_unaligned_le32()?

Indeed.

>> 
>>  This fixes Clang-built kernels not booting on MIPS (tested on a 
>> Ingenic
>>  JZ4770 board).
>> 
>>  Fixes: b8f54f2cde78 ("MIPS: ZBOOT: copy appended dtb to the end of 
>> the kernel")
>>  Cc: <stable@vger.kernel.org> # v4.7
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> 
> Hi Paul, thanks for the patch (and for testing with Clang)!
> Alternatively, we could re-align __image_end to the next 4B multiple
> via:
> 
> diff --git a/arch/mips/boot/compressed/ld.script
> b/arch/mips/boot/compressed/ld.script
> index 0ebb667274d6..349919eff5fb 100644
> --- a/arch/mips/boot/compressed/ld.script
> +++ b/arch/mips/boot/compressed/ld.script
> @@ -27,6 +27,7 @@ SECTIONS
>                 /* Put the compressed image here */
>                 __image_begin = .;
>                 *(.image)
> +               . = ALIGN(4);
>                 __image_end = .;
>                 CONSTRUCTORS
>                 . = ALIGN(16);

Actually that would not work (I did try that), since the 4-byte size 
appended to the compressed payload is inside the *(.image) section. The 
code that appends it (in scripts/Makefile.lib, I think) doesn't seem to 
take care about aligning it to a 4-byte offset. I have no idea why it 
does with GCC and doesn't with Clang, and I have no idea why the 
compressed payload's size isn't aligned either.

> The tradeoff being up to 3 wasted bytes of padding in the compressed
> image, vs fetching one value slower (assuming unaligned loads are
> slower than aligned loads MIPS, IDK).  I doubt decompress_kernel is
> called repeatedly, so let's take the byte saving approach of yours by
> using unaligned loads!
> 
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks.

Cheers,
-Paul

>>  ---
>>   arch/mips/boot/compressed/decompress.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>>  diff --git a/arch/mips/boot/compressed/decompress.c 
>> b/arch/mips/boot/compressed/decompress.c
>>  index c61c641674e6..47c07990432b 100644
>>  --- a/arch/mips/boot/compressed/decompress.c
>>  +++ b/arch/mips/boot/compressed/decompress.c
>>  @@ -117,7 +117,7 @@ void decompress_kernel(unsigned long 
>> boot_heap_start)
>>                  dtb_size = fdt_totalsize((void *)&__appended_dtb);
>> 
>>                  /* last four bytes is always image size in little 
>> endian */
>>  -               image_size = le32_to_cpup((void *)&__image_end - 4);
>>  +               image_size = get_unaligned_le32((void 
>> *)&__image_end - 4);
>> 
>>                  /* copy dtb to where the booted kernel will expect 
>> it */
>>                  memcpy((void *)VMLINUX_LOAD_ADDRESS_ULL + 
>> image_size,
>>  --
>>  2.29.2
>> 
> 
> 
> --
> Thanks,
> ~Nick Desaulniers


