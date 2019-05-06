Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCEA15058
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfEFPgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:36:25 -0400
Received: from relay.sw.ru ([185.231.240.75]:36242 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfEFPgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 11:36:25 -0400
Received: from [172.16.25.12]
        by relay.sw.ru with esmtp (Exim 4.91)
        (envelope-from <aryabinin@virtuozzo.com>)
        id 1hNff9-0004Zp-Q9; Mon, 06 May 2019 18:36:19 +0300
Subject: Re: [PATCH 4.9 09/62] kasan: turn on
 -fsanitize-address-use-after-scope
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
 <20190506143051.888762392@linuxfoundation.org>
 <6636d7cf-03fe-e253-f981-e07d75858b33@virtuozzo.com>
 <20190506151026.GA12193@kroah.com>
From:   Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <e3ea0e86-581e-a0e4-ea3a-c7a9322143b8@virtuozzo.com>
Date:   Mon, 6 May 2019 18:36:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506151026.GA12193@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/6/19 6:10 PM, Greg Kroah-Hartman wrote:
> On Mon, May 06, 2019 at 05:55:54PM +0300, Andrey Ryabinin wrote:
>>
>>
>> On 5/6/19 5:32 PM, Greg Kroah-Hartman wrote:
>>> From: Andrey Ryabinin <aryabinin@virtuozzo.com>
>>>
>>> commit c5caf21ab0cf884ef15b25af234f620e4a233139 upstream.
>>>
>>> In the upcoming gcc7 release, the -fsanitize=kernel-address option at
>>> first implied new -fsanitize-address-use-after-scope option.  This would
>>> cause link errors on older kernels because they don't have two new
>>> functions required for use-after-scope support.  Therefore, gcc7 changed
>>> default to -fno-sanitize-address-use-after-scope.
>>>
>>> Now the kernel has everything required for that feature since commit
>>> 828347f8f9a5 ("kasan: support use-after-scope detection").  So, to make it
>>> work, we just have to enable use-after-scope in CFLAGS.
>>>
>>> Link: http://lkml.kernel.org/r/1481207977-28654-1-git-send-email-aryabinin@virtuozzo.com
>>> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
>>> Acked-by: Dmitry Vyukov <dvyukov@google.com>
>>> Cc: Alexander Potapenko <glider@google.com>
>>> Cc: Andrey Konovalov <andreyknvl@google.com>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> ---
>>>  scripts/Makefile.kasan |    2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> --- a/scripts/Makefile.kasan
>>> +++ b/scripts/Makefile.kasan
>>> @@ -29,6 +29,8 @@ else
>>>      endif
>>>  endif
>>>  
>>> +CFLAGS_KASAN += $(call cc-option, -fsanitize-address-use-after-scope)
>>> +
>>>  CFLAGS_KASAN_NOSANITIZE := -fno-builtin
>>>  
>>>  endif
>>>
>>>
>>
>> This shouldn't be in the -stable.
> 
> Why not?  Does no one use gcc7 with this kernel and kasan?
> 

You don't need this patch to use kasan on this kernel with gcc7.
This patch only enables detection of use-after-scope bugs. This feature appeared to be useless,
hence it disabled recently by commit 7771bdbbfd3d ("kasan: remove use after scope bugs detection.")

The link errors mentioned in changelog was the problem only for some period of time in the development branch of GCC 7.
The released GCC7 version doesn't have this problem.
