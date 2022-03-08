Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0D14D1985
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 14:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbiCHNqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 08:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347210AbiCHNqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 08:46:04 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E66F49CB5;
        Tue,  8 Mar 2022 05:45:03 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id d3so14011182ilr.10;
        Tue, 08 Mar 2022 05:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wOTmPPxRGAGavYaBI0ES2ExVC8hASPRKrb33K4sd3F0=;
        b=o/y1YVgRc/BZ1Kcpk1jcTq2voS7O1/6r1s2Z6KL502LEhpbntxn+cjae/n0SAu6PZY
         MC+8wt8XEGph8g6nVD1yhCCGQ8Va/KsRGXIIzaOslzHA3TUg5TCMKLT0STlIibjmB0VC
         Rfp21k5c+W5iq2sgwCkigX3ZoBpk+UW3LUi7SGT1bfj+e+c2pYV0Va/bmjqDg5sW5HnS
         Sj4vbjxbLjxSLqDs0Rb9IZ8coLDsmULfrJ7d+hkck3qHVF1XpGuA6ojgbcuVD7jSvO3n
         TzjdgW3666r+USIXS5TzmSrATVTK5DRV6jaF0zZjfPhYz1m8/5KO1pYTp5x27UGjLDE0
         oUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wOTmPPxRGAGavYaBI0ES2ExVC8hASPRKrb33K4sd3F0=;
        b=VdTHspteFhJXRG43aVB6F0XKcP10SlT8xWn1PQE5BCtlN8tFpeUXDqRTtlqpGBLNu1
         c6vBldxPQhlJbRE1mPZ0q/ZrbJ/GFXlFKvDY9cMefv5xqNpyr6RrZ00mDuiL1bTBHTBB
         HzWu5QIaJgRk2erDIW5Dysfao8OH9u9D2sk4OMlKyL7+fakwwV08MbgKgL4aTj/DrzHm
         Wmvf+JMLThS4XFDKFqhc/+cO0szmcQO5HY24WEryCgILinVVAU/Nze9JF9rZ3uC9U3u6
         U8xkFtV3asyIsmm9d9z8ugwVtmKz9rQKi6wwOFv27dhTRc3NtsLfZuPW/dESzMfuLeGj
         9TCA==
X-Gm-Message-State: AOAM532baY0VKWda6WRps1rtt4tABJv1r/k1mu0HgfVIvz0lSGkDcnhB
        Ynao1VGpN3kUTvzFMS1gkakKBSk6sqDVlJAExn4=
X-Google-Smtp-Source: ABdhPJyIaOHh+Namhz4keN1arUSR5eOEgGqBGGQoZ4gvNnQuzkyJ84/tGbSube1SlNQ4UMNFrI1XCx63fJySASq6w48=
X-Received: by 2002:a05:6e02:164e:b0:2c6:59b4:9f60 with SMTP id
 v14-20020a056e02164e00b002c659b49f60mr3053300ilu.235.1646747102985; Tue, 08
 Mar 2022 05:45:02 -0800 (PST)
MIME-Version: 1.0
References: <20220224002024.429707-1-pcc@google.com>
In-Reply-To: <20220224002024.429707-1-pcc@google.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Tue, 8 Mar 2022 14:44:52 +0100
Message-ID: <CA+fCnZfeUnCk1zLAjaoWdChyUqaRNLsbdbwJXF-bQEzWSyN6XA@mail.gmail.com>
Subject: Re: [PATCH v2] kasan: fix more unit tests with CONFIG_UBSAN_LOCAL_BOUNDS
 enabled
To:     Peter Collingbourne <pcc@google.com>
Cc:     Marco Elver <elver@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 1:20 AM Peter Collingbourne <pcc@google.com> wrote:
>
> This is a followup to commit f649dc0e0d7b ("kasan: fix unit tests
> with CONFIG_UBSAN_LOCAL_BOUNDS enabled") that fixes tests that fail
> as a result of __alloc_size annotations being added to the kernel
> allocator functions.
>
> Link: https://linux-review.googlesource.com/id/I4334cafc5db600fda5cebb851b2ee9fd09fb46cc
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Cc: <stable@vger.kernel.org> # 5.16.x
> Fixes: c37495d6254c ("slab: add __alloc_size attributes for better bounds checking")
> ---
> v2:
> - use OPTIMIZER_HIDE_VAR instead of volatile
>
>  lib/test_kasan.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/lib/test_kasan.c b/lib/test_kasan.c
> index 26a5c9007653..7c3dfb569445 100644
> --- a/lib/test_kasan.c
> +++ b/lib/test_kasan.c
> @@ -185,6 +185,7 @@ static void kmalloc_pagealloc_oob_right(struct kunit *test)
>         ptr = kmalloc(size, GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
> +       OPTIMIZER_HIDE_VAR(ptr);
>         KUNIT_EXPECT_KASAN_FAIL(test, ptr[size + OOB_TAG_OFF] = 0);
>
>         kfree(ptr);
> @@ -295,6 +296,7 @@ static void krealloc_more_oob_helper(struct kunit *test,
>                 KUNIT_EXPECT_KASAN_FAIL(test, ptr2[size2] = 'x');
>
>         /* For all modes first aligned offset after size2 must be inaccessible. */
> +       OPTIMIZER_HIDE_VAR(ptr2);
>         KUNIT_EXPECT_KASAN_FAIL(test,
>                 ptr2[round_up(size2, KASAN_GRANULE_SIZE)] = 'x');
>
> @@ -319,6 +321,8 @@ static void krealloc_less_oob_helper(struct kunit *test,
>         /* Must be accessible for all modes. */
>         ptr2[size2 - 1] = 'x';
>
> +       OPTIMIZER_HIDE_VAR(ptr2);
> +
>         /* Generic mode is precise, so unaligned size2 must be inaccessible. */
>         if (IS_ENABLED(CONFIG_KASAN_GENERIC))
>                 KUNIT_EXPECT_KASAN_FAIL(test, ptr2[size2] = 'x');
> --
> 2.35.1.473.g83b2b277ed-goog
>

Acked-by: Andrey Konovalov <andreyknvl@gmail.com>

This patch seems to be in partial conflict with the "kasan: test:
Silence allocation warnings from GCC 12" patch by Kees, which is
already in mm.

Thanks!
