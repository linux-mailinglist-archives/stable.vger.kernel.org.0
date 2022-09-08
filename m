Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1290E5B1462
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 08:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiIHGF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 02:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiIHGFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 02:05:55 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EB97333F
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 23:05:54 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-346cd4c3d7aso61938027b3.8
        for <stable@vger.kernel.org>; Wed, 07 Sep 2022 23:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=lJYRFzwH4JLePemhbCSx0zq48/URDmByv8p7ogaW1eM=;
        b=dxgOW659IivH6ld+oycZtkdr3gYSMaf5uDZRsDYUvQ185actGdsTWmmMsrrWLgybri
         AkY83nwjwwlVNWRdb6P3iQ1jcISGCuuCYVVz8tORRQuLq3P7H30d8+3dUx8chekDvaUX
         1q/Lv+J0p7TDE5qNJqtLPLTyPlKRaaQ2XoOkT0bbM1dsym6ePdy8yT6jrpVR/ad6kBJI
         lQIwyjMS1rQb8G2PPW+xSuI8oH532YZCPnArrFpBAV8ZBgin2MSD2kyMxHGMUd9c/+vt
         iUraNSxXT2Mckc/uF3lJbsywOxUJB3MFM2DelphAU4bEt9wrs7twwgyEglRDr4Be+N4K
         bAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=lJYRFzwH4JLePemhbCSx0zq48/URDmByv8p7ogaW1eM=;
        b=dx6HZDbZi+wwSlmBiCphli4K3lw+EA2WOf2PG7Z99CPjn/rQAR1e/q7fvmCt/7LFKd
         YaMRX7nF45+k82WnSN4ZGKXFIICRVSyXY177HEI/NAjk+5JVEHwYNERU8KhJBn8T484L
         kNxZOEQ3H26orixrS8yP2fE2QA/IUvoI8h70PDAA7FcXtim+/Auylbu/KJEZX77PumaM
         T7FErLJ1lHsrQ1frUwWv6ZP4nsmR1lrJPuPlcC5ZHOk0BMmsQwXUk+RjMoieWG0mh9Qt
         oACrF366n7jKTJJxnlpXrybzWBnbxbj5JV+K3ohWTZD+KlMrmZKhz8fE7mJqADKNkgIx
         fB/g==
X-Gm-Message-State: ACgBeo3GvniDN3dj/9h5YhWR56AsF5DtLzBH1hZEEvPr9YkVC530WVDh
        ASd/YJtrVmk9CqhR5Nwc3vkZooKKjVKesECFFBpDRg==
X-Google-Smtp-Source: AA6agR7fk9QsTUWXLvr/tdr0+4a/qUd4BukcHMTp6u6ZV71YqzuR6ZHkzBSwnnqHEGFvGdP6PzzI7Orsef6bMbxf/8M=
X-Received: by 2002:a81:bb41:0:b0:328:fd1b:5713 with SMTP id
 a1-20020a81bb41000000b00328fd1b5713mr6423586ywl.238.1662617153642; Wed, 07
 Sep 2022 23:05:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220907173903.2268161-1-elver@google.com>
In-Reply-To: <20220907173903.2268161-1-elver@google.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 8 Sep 2022 08:05:17 +0200
Message-ID: <CANpmjNMH4_H75Z_aQ63C52TDma7PnjWWjmyv+MtXt2W522UAQQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] kcsan: Instrument memcpy/memset/memmove with newer Clang
To:     elver@google.com, "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Boqun Feng <boqun.feng@gmail.com>, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 7 Sept 2022 at 19:39, Marco Elver <elver@google.com> wrote:
>
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
> ---
>  kernel/kcsan/core.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
> index fe12dfe254ec..66ef48aa86e0 100644
> --- a/kernel/kcsan/core.c
> +++ b/kernel/kcsan/core.c
> @@ -18,6 +18,7 @@
>  #include <linux/percpu.h>
>  #include <linux/preempt.h>
>  #include <linux/sched.h>
> +#include <linux/string.h>
>  #include <linux/uaccess.h>
>
>  #include "encoding.h"
> @@ -1308,3 +1309,29 @@ noinline void __tsan_atomic_signal_fence(int memorder)
>         }
>  }
>  EXPORT_SYMBOL(__tsan_atomic_signal_fence);
> +
> +void *__tsan_memset(void *s, int c, size_t count);
> +noinline void *__tsan_memset(void *s, int c, size_t count)
> +{
> +       check_access(s, count, KCSAN_ACCESS_WRITE, _RET_IP_);
> +       return __memset(s, c, count);
> +}
> +EXPORT_SYMBOL(__tsan_memset);
> +
> +void *__tsan_memmove(void *dst, const void *src, size_t len);
> +noinline void *__tsan_memmove(void *dst, const void *src, size_t len)
> +{
> +       check_access(dst, len, KCSAN_ACCESS_WRITE, _RET_IP_);
> +       check_access(src, len, 0, _RET_IP_);
> +       return __memmove(dst, src, len);
> +}
> +EXPORT_SYMBOL(__tsan_memmove);
> +
> +void *__tsan_memcpy(void *dst, const void *src, size_t len);
> +noinline void *__tsan_memcpy(void *dst, const void *src, size_t len)
> +{
> +       check_access(dst, len, KCSAN_ACCESS_WRITE, _RET_IP_);
> +       check_access(src, len, 0, _RET_IP_);
> +       return __memcpy(dst, src, len);
> +}
> +EXPORT_SYMBOL(__tsan_memcpy);

I missed that s390 doesn't have arch memcpy variants, so this fails:

>> kernel/kcsan/core.c:1316:16: error: implicit declaration of function '__memset'; did you mean '__memset64'? [-Werror=implicit-function-declaration]

I'll send a v2 where __tsan_mem* is aliased to generic versions if the
arch doesn't have mem*() functions.




> --
> 2.37.2.789.g6183377224-goog
>
