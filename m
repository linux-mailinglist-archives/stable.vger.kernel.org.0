Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11944C26E2
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 10:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiBXIzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 03:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiBXIzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 03:55:05 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59013163073
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 00:54:36 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id p19so2446173ybc.6
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 00:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6LyzN4y/7LbQq4KLs8Ged395bQeALH2HjEMTuIFD+Xs=;
        b=tAwCy0Juzg1LJ8ESx7tnClUCfRh342K9ktgq/9ycOepQOkGF9CWrlSBJzukQ7mqmFV
         Pt7AAanY+jPfQzWR95zmKaW/I95lS5ogeAsxuA/jdj1yNBtVm7NVk2aD++jKbzR2jb6k
         UoXDGlePz1zXsUNVO9Q3MxNgEJ8YkcrWpqBSKSt1++biYEMjuCiPtpV1jbcfEzMYQ01V
         zUK3+uxr58G8KS4PEDGYWZ8C2a92mLQ75XrdJ6FN1bic/huriP+ZZ8+eFPJAcFxwj4Is
         wnJ0LX7cL0xg6oLjxVZCyq9nggeCGg0QAXBJNFa2dKkmYKWi6pFR1Loyk7GAu8lL+zpS
         YweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6LyzN4y/7LbQq4KLs8Ged395bQeALH2HjEMTuIFD+Xs=;
        b=cDZw9azznHfBlMZtZNfcqoH2KxvB3M54lEHg7my6czBw1MsRrVxPc6ZZXuzsozVz8g
         b2PbPrvrcMXcWN+W78+4Wb88pk8QjKqeSswvxCrYvkVzYZDU4jqDO5r1P2pm2sFKakan
         Jj7rk4hx1joFGgkEosEx+ggCTNG/NW1BZVbjgrc3ONYNwzzsGi0jKhBYfPtnyevWICmL
         jAgSGdlp9Vo5yPhRa5MHj8u4cevqv0c9Jnsuq5w2QXRdnFMBfAY1u8NZAV2AJN0lYbYy
         Jj+lii+xs/Y/e0X14H9WG9XpeTZL+K84BRe8sZvsAjuzYpSjaQZtEjobzkOxGwICUOB4
         Szfw==
X-Gm-Message-State: AOAM530m1lojtodlPxR6zHjulqfsxAXRhhA4sW0+R3WZYEhn+yeM6xwq
        i81dGgEfMfO2zEyH+wmo5RvOKuSAlsIqlTyHWCJm/Q==
X-Google-Smtp-Source: ABdhPJzgM45SQS4CBJEv1rTkvY1iH0epa4IjtQbO2nqN04jCGY6MooN2Q2hDh8eRIbMCjtwSTvwYaLV/TkLEvPgMQws=
X-Received: by 2002:a25:a4e8:0:b0:61e:1eb6:19bd with SMTP id
 g95-20020a25a4e8000000b0061e1eb619bdmr1613695ybi.168.1645692875363; Thu, 24
 Feb 2022 00:54:35 -0800 (PST)
MIME-Version: 1.0
References: <20220224002024.429707-1-pcc@google.com>
In-Reply-To: <20220224002024.429707-1-pcc@google.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 24 Feb 2022 09:54:23 +0100
Message-ID: <CANpmjNOaZNtsJ+5pgJrpHb5VZtXjFs1i1L2S6Q_oqFo3hFt4Tg@mail.gmail.com>
Subject: Re: [PATCH v2] kasan: fix more unit tests with CONFIG_UBSAN_LOCAL_BOUNDS
 enabled
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
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

On Thu, 24 Feb 2022 at 01:20, Peter Collingbourne <pcc@google.com> wrote:
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

Reviewed-by: Marco Elver <elver@google.com>

Thanks!

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
