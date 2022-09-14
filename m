Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EDB5B87EC
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 14:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiINMM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 08:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiINMMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 08:12:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5391D30F72;
        Wed, 14 Sep 2022 05:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11A1AB81AA1;
        Wed, 14 Sep 2022 12:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A239AC433C1;
        Wed, 14 Sep 2022 12:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663157541;
        bh=hjuXbnWXJ+x/tKRxSvQIiKmnjkb9e4J1VOi2HUS1+aU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Qy/Fb2wvXLrIG4vNfFCGHghjwjqoe2bQVHqlEMR/Rv1lTN+/aoF2CSko0EGDPJm9u
         AC25Xz6PAc5EzVJq6EDSAUuIFQ3yJUurSarFqalRcpe3PoPZWKKZB3uTu0NfM3wUo6
         dqz3+sP8iTHeO3mmepNP9HhV3HH/zZLunM6r4rbrZxwZ8Jyg0LZT/qGOv7pq0E277F
         eSwiSeaBktCR+khewocGLN/8285R1c6kciZMYOT1LV2FNMPglxafQFwcPYwq4knxf1
         a1MPwdd7WWxnjnVd8RDVUqvSdBMd2ro6an6pCM7RnQPutGEiJ2SvUhQ+A44GArwSz7
         1MX20d/uDKeFg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 1A4025C06AB; Wed, 14 Sep 2022 05:12:19 -0700 (PDT)
Date:   Wed, 14 Sep 2022 05:12:19 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Marco Elver <elver@google.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Boqun Feng <boqun.feng@gmail.com>, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        llvm@lists.linux.dev, Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kcsan: Instrument memcpy/memset/memmove with
 newer Clang
Message-ID: <20220914121219.GA360920@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220912094541.929856-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912094541.929856-1-elver@google.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 12, 2022 at 11:45:40AM +0200, Marco Elver wrote:
> With Clang version 16+, -fsanitize=thread will turn
> memcpy/memset/memmove calls in instrumented functions into
> __tsan_memcpy/__tsan_memset/__tsan_memmove calls respectively.
> 
> Add these functions to the core KCSAN runtime, so that we (a) catch data
> races with mem* functions, and (b) won't run into linker errors with
> such newer compilers.
> 
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Marco Elver <elver@google.com>

Queued and pushed, thank you!

							Thanx, Paul

> ---
> v3:
> * Truncate sizes larger than MAX_ENCODABLE_SIZE, so we still set up
>   watchpoints on them. Iterating through MAX_ENCODABLE_SIZE blocks may
>   result in pathological cases where performance would seriously suffer.
>   So let's avoid that for now.
> * Just use memcpy/memset/memmove instead of __mem*() functions. Many
>   architectures that already support KCSAN don't define them (mips,
>   s390), and having both __mem* and mem versions of the functions
>   provides little benefit elsewhere; and backporting would become more
>   difficult, too. The compiler should not inline them given all
>   parameters are non-constants here.
> 
> v2:
> * Fix for architectures which do not provide their own
>   memcpy/memset/memmove and instead use the generic versions in
>   lib/string. In this case we'll just alias the __tsan_ variants.
> ---
>  kernel/kcsan/core.c | 50 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
> index fe12dfe254ec..54d077e1a2dc 100644
> --- a/kernel/kcsan/core.c
> +++ b/kernel/kcsan/core.c
> @@ -14,10 +14,12 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/list.h>
> +#include <linux/minmax.h>
>  #include <linux/moduleparam.h>
>  #include <linux/percpu.h>
>  #include <linux/preempt.h>
>  #include <linux/sched.h>
> +#include <linux/string.h>
>  #include <linux/uaccess.h>
>  
>  #include "encoding.h"
> @@ -1308,3 +1310,51 @@ noinline void __tsan_atomic_signal_fence(int memorder)
>  	}
>  }
>  EXPORT_SYMBOL(__tsan_atomic_signal_fence);
> +
> +#ifdef __HAVE_ARCH_MEMSET
> +void *__tsan_memset(void *s, int c, size_t count);
> +noinline void *__tsan_memset(void *s, int c, size_t count)
> +{
> +	/*
> +	 * Instead of not setting up watchpoints where accessed size is greater
> +	 * than MAX_ENCODABLE_SIZE, truncate checked size to MAX_ENCODABLE_SIZE.
> +	 */
> +	size_t check_len = min_t(size_t, count, MAX_ENCODABLE_SIZE);
> +
> +	check_access(s, check_len, KCSAN_ACCESS_WRITE, _RET_IP_);
> +	return memset(s, c, count);
> +}
> +#else
> +void *__tsan_memset(void *s, int c, size_t count) __alias(memset);
> +#endif
> +EXPORT_SYMBOL(__tsan_memset);
> +
> +#ifdef __HAVE_ARCH_MEMMOVE
> +void *__tsan_memmove(void *dst, const void *src, size_t len);
> +noinline void *__tsan_memmove(void *dst, const void *src, size_t len)
> +{
> +	size_t check_len = min_t(size_t, len, MAX_ENCODABLE_SIZE);
> +
> +	check_access(dst, check_len, KCSAN_ACCESS_WRITE, _RET_IP_);
> +	check_access(src, check_len, 0, _RET_IP_);
> +	return memmove(dst, src, len);
> +}
> +#else
> +void *__tsan_memmove(void *dst, const void *src, size_t len) __alias(memmove);
> +#endif
> +EXPORT_SYMBOL(__tsan_memmove);
> +
> +#ifdef __HAVE_ARCH_MEMCPY
> +void *__tsan_memcpy(void *dst, const void *src, size_t len);
> +noinline void *__tsan_memcpy(void *dst, const void *src, size_t len)
> +{
> +	size_t check_len = min_t(size_t, len, MAX_ENCODABLE_SIZE);
> +
> +	check_access(dst, check_len, KCSAN_ACCESS_WRITE, _RET_IP_);
> +	check_access(src, check_len, 0, _RET_IP_);
> +	return memcpy(dst, src, len);
> +}
> +#else
> +void *__tsan_memcpy(void *dst, const void *src, size_t len) __alias(memcpy);
> +#endif
> +EXPORT_SYMBOL(__tsan_memcpy);
> -- 
> 2.37.2.789.g6183377224-goog
> 
