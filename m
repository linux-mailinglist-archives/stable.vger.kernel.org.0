Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BED70048
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 14:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfGVM4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 08:56:48 -0400
Received: from relay.sw.ru ([185.231.240.75]:43164 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbfGVM4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 08:56:47 -0400
Received: from [172.16.25.12]
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <aryabinin@virtuozzo.com>)
        id 1hpXru-00023q-6u; Mon, 22 Jul 2019 15:56:42 +0300
Subject: Re: [PATCH] [v2] ubsan: build ubsan.c more conservatively
To:     Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20190722125139.1335385-1-arnd@arndb.de>
From:   Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <96d5c129-3b27-5b0f-f34c-e6d89e7467b2@virtuozzo.com>
Date:   Mon, 22 Jul 2019 15:56:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190722125139.1335385-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/22/19 3:50 PM, Arnd Bergmann wrote:
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
> mixed with the gcc specific -fno-conserve-stack option. According
> to Andrey Ryabinin, that option is not even needed, dropping it here
> fixes the stackprotector issue.
> 
> Fixes: d08965a27e84 ("x86/uaccess, ubsan: Fix UBSAN vs. SMAP")
> Link: https://lore.kernel.org/lkml/20190617123109.667090-1-arnd@arndb.de/t/
> Link: https://lore.kernel.org/lkml/20190722091050.2188664-1-arnd@arndb.de/t/
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>


Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
