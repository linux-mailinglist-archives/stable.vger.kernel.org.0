Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895AA6FF8C
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 14:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfGVMZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 08:25:19 -0400
Received: from relay.sw.ru ([185.231.240.75]:41606 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbfGVMZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 08:25:19 -0400
Received: from [172.16.25.12]
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <aryabinin@virtuozzo.com>)
        id 1hpXNO-0001ko-UQ; Mon, 22 Jul 2019 15:25:11 +0300
Subject: Re: [PATCH] ubsan: build ubsan.c more conservatively
To:     Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Sodagudi Prasad <psodagud@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20190722091050.2188664-1-arnd@arndb.de>
From:   Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <c7da8503-93bc-c130-2e50-918996abe6c7@virtuozzo.com>
Date:   Mon, 22 Jul 2019 15:25:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190722091050.2188664-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/22/19 12:10 PM, Arnd Bergmann wrote:
> objtool points out several conditions that it does not like, depending
> on the combination with other configuration options and compiler
> variants:
> 
> stack protector:
> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0xbf: call to __stack_chk_fail() with UACCESS enabled
> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0xbe: call to __stack_chk_fail() with UACCESS enabled
> 
> stackleak plugin:
> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x4a: call to stackleak_track_stack() with UACCESS enabled
> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x4a: call to stackleak_track_stack() with UACCESS enabled
> 
> kasan:
> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x25: call to memcpy() with UACCESS enabled
> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x25: call to memcpy() with UACCESS enabled
> 
> The stackleak and kasan options just need to be disabled for this file
> as we do for other files already. For the stack protector, we already
> attempt to disable it, but this fails on clang because the check is
> mixed with the gcc specific -fno-conserve-stack option, so we need to
> test them separately.
> 
> Fixes: 42440c1f9911 ("lib/ubsan: add type mismatch handler for new GCC/Clang")

There was no uaccess validataion at that time, so the right fixes line is probably this:

Fixes: d08965a27e84 ("x86/uaccess, ubsan: Fix UBSAN vs. SMAP")

> Link: https://lore.kernel.org/lkml/20190617123109.667090-1-arnd@arndb.de/t/
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  lib/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/Makefile b/lib/Makefile
> index 095601ce371d..320e3b632dd3 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -279,7 +279,8 @@ obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
>  obj-$(CONFIG_UBSAN) += ubsan.o
>  
>  UBSAN_SANITIZE_ubsan.o := n
> -CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
> +KASAN_SANITIZE_ubsan.o := n
> +CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack) $(call cc-option, -fno-stack-protector) $(DISABLE_STACKLEAK_PLUGIN)

$(call cc-option, -fno-conserve-stack) can be removed entirely. It's just copy paste from kasan Makefile.
It was added in kasan purely for performance reasons.

Not sure that it's needed even in kasan Makefile, the code which was
the reason for adding fno-conserve-stack might not get into the final version of KASAN patches.
