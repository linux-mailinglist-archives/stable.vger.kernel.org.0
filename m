Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2952D3556FB
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 16:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239332AbhDFOtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 10:49:42 -0400
Received: from out28-123.mail.aliyun.com ([115.124.28.123]:34194 "EHLO
        out28-123.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239002AbhDFOtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 10:49:40 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07439038|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0487646-0.00075957-0.950476;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=zhouyu@wanyeetech.com;NM=1;PH=DS;RN=8;RT=8;SR=0;TI=SMTPD_---.JvtGAVq_1617720563;
Received: from 192.168.88.133(mailfrom:zhouyu@wanyeetech.com fp:SMTPD_---.JvtGAVq_1617720563)
          by smtp.aliyun-inc.com(10.147.43.95);
          Tue, 06 Apr 2021 22:49:24 +0800
Subject: Re: [PATCH] MIPS: Fix a longstanding error in div64.h
To:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
References: <20210406112404.2671507-1-chenhuacai@loongson.cn>
 <0338A250-3BF9-4B96-B9DE-61BE573CBB4C@goldelico.com>
From:   Zhou Yanjie <zhouyu@wanyeetech.com>
Message-ID: <3e27d0e0-4494-7a94-e0d7-046fb8898603@wanyeetech.com>
Date:   Tue, 6 Apr 2021 22:49:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0338A250-3BF9-4B96-B9DE-61BE573CBB4C@goldelico.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nikolaus,

On 2021/4/6 下午8:42, H. Nikolaus Schaller wrote:
>> Am 06.04.2021 um 13:24 schrieb Huacai Chen <chenhuacai@kernel.org>:
>>
>> Only 32bit kernel need __div64_32(), but commit c21004cd5b4cb7d479514d4
>> ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.") makes it depend
>> on 64bit kernel by mistake. This patch fix this longstanding error.
>>
>> Fixes: c21004cd5b4cb7d479514d4 ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
>> ---
>> arch/mips/include/asm/div64.h | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/mips/include/asm/div64.h b/arch/mips/include/asm/div64.h
>> index dc5ea5736440..d199fe36eb46 100644
>> --- a/arch/mips/include/asm/div64.h
>> +++ b/arch/mips/include/asm/div64.h
>> @@ -11,7 +11,7 @@
>>
>> #include <asm-generic/div64.h>
>>
>> -#if BITS_PER_LONG == 64
>> +#if BITS_PER_LONG == 32
>>
>> #include <linux/types.h>
> Hm.
>
> Ingenic jz4780/CI20 build attempt on top ov v5.12-rc6:
>
> In file included from ./include/linux/math64.h:7:0,
>                   from ./include/linux/time.h:6,
>                   from ./include/linux/compat.h:10,
>                   from arch/mips/kernel/asm-offsets.c:12:
> ./include/linux/math64.h: In function 'div_u64_rem':
> ./arch/mips/include/asm/div64.h:29:11: error: invalid type argument of unary '*' (have 'long long unsigned int')
>    __high = *__n >> 32;      \
>             ^
> ./include/asm-generic/div64.h:243:11: note: in expansion of macro '__div64_32'
>     __rem = __div64_32(&(n), __base); \
>             ^
> ./include/linux/math64.h:91:15: note: in expansion of macro 'do_div'
>    *remainder = do_div(dividend, divisor);
>                 ^
>
> Or does it just reveal an unknown bug in my compiler?


I also get these:


In file included from ./include/linux/math64.h:7:0,
                  from ./include/linux/time.h:6,
                  from ./include/linux/compat.h:10,
                  from arch/mips/kernel/asm-offsets.c:12:
./include/linux/math64.h: In function 'div_u64_rem':
./arch/mips/include/asm/div64.h:29:11: error: invalid type argument of 
unary '*' (have 'long long unsigned int')
   __high = *__n >> 32;      \
            ^
./include/asm-generic/div64.h:243:11: note: in expansion of macro 
'__div64_32'
    __rem = __div64_32(&(n), __base); \
            ^
./include/linux/math64.h:91:15: note: in expansion of macro 'do_div'
   *remainder = do_div(dividend, divisor);
                ^
./include/linux/math64.h: In function 'mul_u64_u32_div':
./arch/mips/include/asm/div64.h:29:11: error: invalid type argument of 
unary '*' (have 'long long unsigned int')
   __high = *__n >> 32;      \
            ^
./include/asm-generic/div64.h:243:11: note: in expansion of macro 
'__div64_32'
    __rem = __div64_32(&(n), __base); \
            ^
./include/linux/math64.h:256:14: note: in expansion of macro 'do_div'
   rl.l.high = do_div(rh.ll, divisor);
               ^
./arch/mips/include/asm/div64.h:29:11: error: invalid type argument of 
unary '*' (have 'long long unsigned int')
   __high = *__n >> 32;      \

...


So it seems not a compiler problem.

