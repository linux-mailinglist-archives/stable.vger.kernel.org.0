Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A29B2E6BB3
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgL1Wzv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 28 Dec 2020 17:55:51 -0500
Received: from aposti.net ([89.234.176.197]:37250 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729641AbgL1Wb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 17:31:29 -0500
Date:   Mon, 28 Dec 2020 22:30:36 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] MIPS: boot: Fix unaligned access =?UTF-8?Q?with=0D=0A?=
 CONFIG_MIPS_RAW_APPENDED_DTB
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Message-Id: <0JM2MQ.PMKIEAOX7SCZ@crapouillou.net>
In-Reply-To: <20201228222532.GA24926@alpha.franken.de>
References: <20201216233956.280068-1-paul@crapouillou.net>
        <20201228222532.GA24926@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

Le lun. 28 déc. 2020 à 23:25, Thomas Bogendoerfer 
<tsbogend@alpha.franken.de> a écrit :
> On Wed, Dec 16, 2020 at 11:39:56PM +0000, Paul Cercueil wrote:
>>  The compressed payload is not necesarily 4-byte aligned, at least 
>> when
>>  compiling with Clang. In that case, the 4-byte value appended to the
>>  compressed payload that corresponds to the uncompressed kernel image
>>  size must be read using get_unaligned_le().
>> 
>>  This fixes Clang-built kernels not booting on MIPS (tested on a 
>> Ingenic
>>  JZ4770 board).
>> 
>>  Fixes: b8f54f2cde78 ("MIPS: ZBOOT: copy appended dtb to the end of 
>> the kernel")
>>  Cc: <stable@vger.kernel.org> # v4.7
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
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
>>   		dtb_size = fdt_totalsize((void *)&__appended_dtb);
>> 
>>   		/* last four bytes is always image size in little endian */
>>  -		image_size = le32_to_cpup((void *)&__image_end - 4);
>>  +		image_size = get_unaligned_le32((void *)&__image_end - 4);
> 
> gives me following error
> 
> arch/mips/boot/compressed/decompress.c:120:16: error: implicit 
> declaration of function ‘get_unaligned_le32’ 
> [-Werror=implicit-function-declaration]
>    image_size = get_unaligned_le32((void *)&__image_end - 4);
> 
> I've added
> 
> #include <asm/unaligned.h>
> 
> which fixes the compile error, but I'm wondering why the patch 
> compiled
> for you ?

No idea - but it does compile fine without the include here. Probably a 
defconfig difference.

Cheers,
-Paul


