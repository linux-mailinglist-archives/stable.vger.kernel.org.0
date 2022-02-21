Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466634BE77E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356183AbiBULZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 06:25:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356405AbiBULYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 06:24:51 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDD3134
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 03:20:34 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id p19so33550558ybc.6
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 03:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NjKrfGzLGlEon1RMte/jjmVRaWvN7F73qDlwuyQ/zYs=;
        b=KVnvCl9SXCIAFVXXcrWnELc0cbmTmjsCJFTP40Wnwx3bappQWSCGC0co2cN21AFisu
         zFGQutfRR4Y8cw6T1m4WpD8Qg6RJH06P6j3XcRYINj1Nh7AdctBuHylH6+n2z4IOexZ1
         ulRlDRzSqrJoOjoNIlAcyaDs40H16vzvdNfLeW50Zz5yEdnWIgwNudBQDDfNuRrJUYre
         u+X+150q1gG3VgHLY3ndJ+YXLDDYAk/3wnDZf4UlO9qK617hT/H5HMx0z6jUCtxp7d2I
         0Hw4a2nJDDOUH6gL3eFbPKCUX0aVDLCi+7JkSnaOO+Owk+Bvr+hDPnjzLdbrHRO45wmh
         euEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NjKrfGzLGlEon1RMte/jjmVRaWvN7F73qDlwuyQ/zYs=;
        b=sGWkFobMEJAo2wSL6GHvIb/1pZ4Dzy3HaHGYdbXcFiX1QqMg8OonJhcpkLYVE9EwYO
         rveXJokWHtptxbHxDRJI7+EwVN31lP9lXyyOJnjzWxZ7Wp1BCwZShgWXkPHdOf71xext
         1c4iiTBUILz46VSJFM8vWuLCPSlN2ZQhJXV3zES/grh08WeH7Q+KzI/AFEglj8zFZxrS
         NiflTxg4NPCtdlz3Ka4ORLdXa/N8AUNz+IJYnRC7KFSvFWdX20SWcDuH4xIcm4OiJgqR
         O0aEfvzNtek6xzeHho73RxNbLDa+DKJBhA93E8wkkMgQ3WJO2QENsy9Y3Ut+JQaVelDG
         7XkA==
X-Gm-Message-State: AOAM5302V9nCbn3kF+k357jFXXEMWSDbl1Q6c0NIlFU2IOodb9H5wCCG
        i5KRNRr16JS2R0vRa94NdQdP1Yh8dNW++5/0cCz9/A==
X-Google-Smtp-Source: ABdhPJykNMsrySTFXO/n9IosEJ7fJiemNoCPy7o5SFUUFfp950VVTfS0ryvWrIgF0b87z65j4cwVD6Lpqb/+Iv5G48s=
X-Received: by 2002:a25:bb8d:0:b0:61d:aca6:8aa0 with SMTP id
 y13-20020a25bb8d000000b0061daca68aa0mr17780158ybg.609.1645442433890; Mon, 21
 Feb 2022 03:20:33 -0800 (PST)
MIME-Version: 1.0
References: <20220219012643.892158-1-pcc@google.com>
In-Reply-To: <20220219012643.892158-1-pcc@google.com>
From:   Marco Elver <elver@google.com>
Date:   Mon, 21 Feb 2022 12:20:22 +0100
Message-ID: <CANpmjNMfemciY2Qn7aZ1Z0EvTA21CqZ6zei+dncGMedWr0-6cQ@mail.gmail.com>
Subject: Re: [PATCH] kasan: fix more unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 19 Feb 2022 at 02:26, Peter Collingbourne <pcc@google.com> wrote:
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
>  lib/test_kasan.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/lib/test_kasan.c b/lib/test_kasan.c
> index 26a5c9007653..3bf8801d0e66 100644
> --- a/lib/test_kasan.c
> +++ b/lib/test_kasan.c
> @@ -177,7 +177,8 @@ static void kmalloc_node_oob_right(struct kunit *test)
>   */
>  static void kmalloc_pagealloc_oob_right(struct kunit *test)
>  {
> -       char *ptr;
> +       /* See comment in kasan_global_oob_right. */
> +       char *volatile ptr;
>         size_t size = KMALLOC_MAX_CACHE_SIZE + 10;

I think more recently we've been using OPTIMIZER_HIDE_VAR() to hide
things from the compiler. Does OPTIMIZER_HIDE_VAR(ptr) right before
the access also work in this case?

I leave it to you which you think is cleaner - I'm guessing that we
might want to avoid volatile if we can.

>         KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
> @@ -272,7 +273,8 @@ static void kmalloc_large_oob_right(struct kunit *test)
>  static void krealloc_more_oob_helper(struct kunit *test,
>                                         size_t size1, size_t size2)
>  {
> -       char *ptr1, *ptr2;
> +       /* See comment in kasan_global_oob_right. */
> +       char *ptr1, *volatile ptr2;
>         size_t middle;
>
>         KUNIT_ASSERT_LT(test, size1, size2);
> @@ -304,7 +306,8 @@ static void krealloc_more_oob_helper(struct kunit *test,
>  static void krealloc_less_oob_helper(struct kunit *test,
>                                         size_t size1, size_t size2)
>  {
> -       char *ptr1, *ptr2;
> +       /* See comment in kasan_global_oob_right. */
> +       char *ptr1, *volatile ptr2;
>         size_t middle;
>
>         KUNIT_ASSERT_LT(test, size2, size1);
> --
> 2.35.1.473.g83b2b277ed-goog
>
