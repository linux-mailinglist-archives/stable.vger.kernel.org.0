Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC61375D1A
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 00:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhEFWNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 18:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbhEFWNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 18:13:52 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735ABC061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 15:12:53 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gx5so10532936ejb.11
        for <stable@vger.kernel.org>; Thu, 06 May 2021 15:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g4k85sNna4acWN9ZC6UqwVS/egVVT59K9tfgh5ipaL0=;
        b=OeVrGpI2jXAJIL35oXmZsoEVD6ZtLijoYlhbF7/+AxfnOwk1Kn9GM42xPX34HpTT1e
         VIB4WmdjVvGw5/ORihmdcIMpOFKsvbBkEDGRJmNNOpic9tb11BUnMUtiaohv8uLvUZqo
         PkoGgbZ34boY2cb/YV66fQ07QP1D064BHvfe01bsuIQDSMBGDDhdJH9pyZtWZeo12dU2
         OJ10s44qQUR95JWko5VWCSzHJEnIXcx74ldRzn0X9IvXf6LGzvoA0ExpHPmsgnhLKGKU
         RcT/1Ganva7DAs+LpEIeZBC4WrNHGt5z2ixlCZJF7XcozrLm+paiJ/3h77GzbrY6Nj1Q
         dfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g4k85sNna4acWN9ZC6UqwVS/egVVT59K9tfgh5ipaL0=;
        b=DecEVQPkzM5bzQzgIl73im3sg+42rlFPbZhsH6yprKdzBj+F5oWpI9tN9KBtjk8s9+
         aTkANFvzGIelGlyKOYZVn23CUil1hoBqmBJvFS+MpJqRIxjEbU49eiaeVFaYrJAoARMZ
         viQN1x5g+5PwYwfxtvzWJEKPTWIsskR8xCY2BCbNBUYtBLwageuq4MoQzOwgD5AjKbgi
         cIYdXoVDAenhYiGMcPzw6uyoK3Gs17TVoMFWjGMeDoztGWrYW2+fqSbHqv0QLoCMyAD3
         vj8/NfSW1s22KhzzvMl8kiOD3d12fRfeACYXt+zrThqyBnkU9H6tev23TeS8IEmchySt
         7RSw==
X-Gm-Message-State: AOAM533dZ/xROod8Bf24WRCGWerqgjTAPjCA6j15ZJeb2qZ1jmW4aU/s
        Ugy92x+lvxk03GDgAk5BJjaKgj8S08aBjG6D9oo=
X-Google-Smtp-Source: ABdhPJwaTRG1B8nTf5RhEh+PJTM99galXlQ0+1oFt+ozQCQX0tlFkxNgdyaZ9rH2/J3ZHEvRwvsG1XST6exVC7yPMQ0=
X-Received: by 2002:a17:906:14c1:: with SMTP id y1mr6878062ejc.481.1620339172238;
 Thu, 06 May 2021 15:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210506212025.815380-1-pcc@google.com>
In-Reply-To: <20210506212025.815380-1-pcc@google.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Fri, 7 May 2021 00:12:41 +0200
Message-ID: <CA+fCnZfTvOsFfwLfpHZKsDJSMDa6NpJu6NVfq4LREjPWg6Yw2w@mail.gmail.com>
Subject: Re: [PATCH] kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
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

On Thu, May 6, 2021 at 11:20 PM Peter Collingbourne <pcc@google.com> wrote:
>
> These tests deliberately access these arrays out of bounds,
> which will cause the dynamic local bounds checks inserted by
> CONFIG_UBSAN_LOCAL_BOUNDS to fail and panic the kernel. To avoid this
> problem, access the arrays via volatile pointers, which will prevent
> the compiler from being able to determine the array bounds.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Cc: stable@vger.kernel.org
> Link: https://linux-review.googlesource.com/id/I90b1713fbfa1bf68ff895aef099ea77b98a7c3b9
> ---
>  lib/test_kasan.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/lib/test_kasan.c b/lib/test_kasan.c
> index dc05cfc2d12f..2a078e8e7b8e 100644
> --- a/lib/test_kasan.c
> +++ b/lib/test_kasan.c
> @@ -654,8 +654,8 @@ static char global_array[10];
>
>  static void kasan_global_oob(struct kunit *test)
>  {
> -       volatile int i = 3;
> -       char *p = &global_array[ARRAY_SIZE(global_array) + i];
> +       char *volatile array = global_array;
> +       char *p = &array[ARRAY_SIZE(global_array) + 3];

Nit: in the kernel, "volatile" usually comes before the pointer type.

>
>         /* Only generic mode instruments globals. */
>         KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> @@ -703,8 +703,8 @@ static void ksize_uaf(struct kunit *test)
>  static void kasan_stack_oob(struct kunit *test)
>  {
>         char stack_array[10];
> -       volatile int i = OOB_TAG_OFF;
> -       char *p = &stack_array[ARRAY_SIZE(stack_array) + i];
> +       char *volatile array = stack_array;
> +       char *p = &array[ARRAY_SIZE(stack_array) + OOB_TAG_OFF];
>
>         KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_STACK);
>
> @@ -715,7 +715,8 @@ static void kasan_alloca_oob_left(struct kunit *test)
>  {
>         volatile int i = 10;
>         char alloca_array[i];
> -       char *p = alloca_array - 1;
> +       char *volatile array = alloca_array;
> +       char *p = array - 1;
>
>         /* Only generic mode instruments dynamic allocas. */
>         KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> @@ -728,7 +729,8 @@ static void kasan_alloca_oob_right(struct kunit *test)
>  {
>         volatile int i = 10;
>         char alloca_array[i];
> -       char *p = alloca_array + i;
> +       char *volatile array = alloca_array;
> +       char *p = array + i;
>
>         /* Only generic mode instruments dynamic allocas. */
>         KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> --
> 2.31.1.607.g51e8a6a459-goog
>

Acked-by: Andrey Konovalov <andreyknvl@gmail.com>

Thanks, Peter!
