Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91C0376656
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 15:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhEGNn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 09:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbhEGNn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 09:43:57 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C3EC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 06:42:56 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l4so13658674ejc.10
        for <stable@vger.kernel.org>; Fri, 07 May 2021 06:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wA8Er9sN+NdBzsS6Ly08TOHkeRbO4N8ntYcG2R5kBMM=;
        b=bXYd3GPOrAvlHEHHQi0+BCw+f7lSDIYnV7sTDWVDLT2U/rr8zyEIPZAOpoLuobJhNp
         hivXBE5qLzjZ0fKRBFHRpgvHK3PiGD/bkfMip1f6TbwI0XZqhLVu3hSODEqjUT+WKTFS
         9y243K6c27ikzYhiwqCkKo7cCatexlfZc+3d2EOnbIUEnd3Tt0NajCe7kfbcD+oeGT7L
         N01Ri5wJDavVdZnV+opNvvZqx0XcTsEpxOuZw6tgG7uYLxNqd1193RtwI+dBDA5JPh1F
         e4N3fYNBbu4GD8mXh8OCV5Ytl8sEU59iBuUyq8d5qex0jSQ2WHrLwBLNddgrtW4U+ep9
         HycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wA8Er9sN+NdBzsS6Ly08TOHkeRbO4N8ntYcG2R5kBMM=;
        b=qmAM8804D+ZKsp+FgBuohkQ+8Fn099p0AJ6BNx5dJ3lQ9VR8pPFwyNDi469+ADqmid
         /7RwWt9vqZkiyvq/v6njx4oojfSTNDQYAnOeqgfMMbyFwUSDPjeUgePStgzWtE2BxiRA
         5gJFyPGByLkyjPFsohNmu7B05TCHJlpYpx0/KfqmWnQexhi+zw8MFDkcJhVUuUtdcqzu
         GaIR7WqHhlbYN7CJWczkyoMIIiLVLP/uDYD+/J1bpWwfpM9VYe9j9jbpv9xTLWPpTZKt
         jmERdH5PqE9Kp/w4r8Qv16X7bz9ZnXfx8rlLLhRJTdcW2PvB9mMSYXpVNP2JDKUtxHy7
         c51g==
X-Gm-Message-State: AOAM530tB0gzTEL+oyO7CskAvG0E9OT51iBvhV6lYI9IjpoBDm1HhIG6
        MnURWLolxhf2k+amBprQffiUIRIg0fntKjLOFZxk1AAeAnQ=
X-Google-Smtp-Source: ABdhPJy061vDpchVVDzyyXQONE66x6tLkFrD9OFILubzrSMdTqWpm1vc9fFBBk3sTL6SpxdTS9MNXtSNoHX7vP2xWQM=
X-Received: by 2002:a17:906:14c1:: with SMTP id y1mr10382710ejc.481.1620394975101;
 Fri, 07 May 2021 06:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210507025915.1464056-1-pcc@google.com>
In-Reply-To: <20210507025915.1464056-1-pcc@google.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Fri, 7 May 2021 15:42:44 +0200
Message-ID: <CA+fCnZd7qPTJq4vmQTASntATBUo-AD6YHbt3UxaGYB2bHNZ3-w@mail.gmail.com>
Subject: Re: [PATCH v2] kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
To:     Peter Collingbourne <pcc@google.com>
Cc:     Alexander Potapenko <glider@google.com>,
        George Popescu <georgepope@android.com>,
        Elena Petrova <lenaptr@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 7, 2021 at 4:59 AM Peter Collingbourne <pcc@google.com> wrote:
>
> These tests deliberately access these arrays out of bounds,
> which will cause the dynamic local bounds checks inserted by
> CONFIG_UBSAN_LOCAL_BOUNDS to fail and panic the kernel. To avoid this
> problem, access the arrays via volatile pointers, which will prevent
> the compiler from being able to determine the array bounds.
>
> These accesses use volatile pointers to char (char *volatile) rather
> than the more conventional pointers to volatile char (volatile char *)
> because we want to prevent the compiler from making inferences about
> the pointer itself (i.e. its array bounds), not the data that it
> refers to.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Cc: stable@vger.kernel.org
> Link: https://linux-review.googlesource.com/id/I90b1713fbfa1bf68ff895aef099ea77b98a7c3b9
> ---
>  lib/test_kasan.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/lib/test_kasan.c b/lib/test_kasan.c
> index dc05cfc2d12f..cacbbbdef768 100644
> --- a/lib/test_kasan.c
> +++ b/lib/test_kasan.c
> @@ -654,8 +654,20 @@ static char global_array[10];
>
>  static void kasan_global_oob(struct kunit *test)
>  {
> -       volatile int i = 3;
> -       char *p = &global_array[ARRAY_SIZE(global_array) + i];
> +       /*
> +        * Deliberate out-of-bounds access. To prevent CONFIG_UBSAN_LOCAL_BOUNDS
> +        * from failing here and panicing the kernel, access the array via a
> +        * volatile pointer, which will prevent the compiler from being able to
> +        * determine the array bounds.
> +        *
> +        * This access uses a volatile pointer to char (char *volatile) rather
> +        * than the more conventional pointer to volatile char (volatile char *)
> +        * because we want to prevent the compiler from making inferences about
> +        * the pointer itself (i.e. its array bounds), not the data that it
> +        * refers to.
> +        */
> +       char *volatile array = global_array;
> +       char *p = &array[ARRAY_SIZE(global_array) + 3];
>
>         /* Only generic mode instruments globals. */
>         KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> @@ -703,8 +715,9 @@ static void ksize_uaf(struct kunit *test)
>  static void kasan_stack_oob(struct kunit *test)
>  {
>         char stack_array[10];
> -       volatile int i = OOB_TAG_OFF;
> -       char *p = &stack_array[ARRAY_SIZE(stack_array) + i];
> +       /* See comment in kasan_global_oob. */
> +       char *volatile array = stack_array;
> +       char *p = &array[ARRAY_SIZE(stack_array) + OOB_TAG_OFF];
>
>         KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_STACK);
>
> @@ -715,7 +728,9 @@ static void kasan_alloca_oob_left(struct kunit *test)
>  {
>         volatile int i = 10;
>         char alloca_array[i];
> -       char *p = alloca_array - 1;
> +       /* See comment in kasan_global_oob. */
> +       char *volatile array = alloca_array;
> +       char *p = array - 1;
>
>         /* Only generic mode instruments dynamic allocas. */
>         KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> @@ -728,7 +743,9 @@ static void kasan_alloca_oob_right(struct kunit *test)
>  {
>         volatile int i = 10;
>         char alloca_array[i];
> -       char *p = alloca_array + i;
> +       /* See comment in kasan_global_oob. */
> +       char *volatile array = alloca_array;
> +       char *p = array + i;
>
>         /* Only generic mode instruments dynamic allocas. */
>         KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> --
> 2.31.1.607.g51e8a6a459-goog
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thanks!
