Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94679375DAD
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 01:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhEFXsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 19:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbhEFXsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 19:48:17 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA64C061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 16:47:18 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id h202so9634443ybg.11
        for <stable@vger.kernel.org>; Thu, 06 May 2021 16:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VrYk6rK4qAMSWl4b3WT+Zawp/taVXn+29RbPDW3crfA=;
        b=OBbIGA1B+Wfnspr+21R8l0QW+JbPYM3kzvXGIQ1MCRQDC7gJ6gnhM0YSpUPeQ81fwx
         hvSUuEWNQlvSd7GmuymhSaRDWhjKCHhs1ct0PJguqBjIfzDBxOMR0ULDlT4zrfEaIDvv
         v0favtC2idEj8uAmYr5X+Bkpbl7fbHCBgrOALthuaUyw/TfFrLK8biCpeNiUTVAdU2ZQ
         96UOpW2rr52lXs/oUMTonQVrG/pwoKvY6qFe7RMqpsCni3EKIspjfW8EuaBqNfkQrpcL
         AjUTbSC9w0SxDd1AWH7dbnQ0fMmUUl7CDKD0vCJePU1PXsfUsSeByihUGsoROHoGMgM2
         hA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VrYk6rK4qAMSWl4b3WT+Zawp/taVXn+29RbPDW3crfA=;
        b=VT+dul2Qfy8jpEkVUD9TbE0gxCeFmrbN5z5WZrvcu6RWZyzuMwLdrbpsdkP93oSLm0
         +ZaYHRhfJlB5Z/rbcOwjTm3c8u6N2A4OMjXIv1wIBHT4s7q+4MR9N2YiG9RDp+t/HbzH
         doGdPFlBJctoLsT6HPmXtiGE/gyxhXxn6o0hC3aD+ZtPx8Pryjgx3jUY9U95XAbFyWuS
         +DF3vOm3gnatie30ZQDO7EjK5C2r9F6IHODSTYOvOuRVYEyGM2BUPtvlYgBApURpxHBE
         QeEpqQZKHNhziK2Wceni8cut02JfBX8ZUKJjoQQQ1jW2jbnyhIg9olP+MHL/FWxiosdK
         GeZw==
X-Gm-Message-State: AOAM531YWz+PJY9LFvjZ2YraDGR/n694CxdNkBJqeSK9nIrLHhE3kSE4
        K7bKkUeiB201yV3W1aHdx+V5hKWN3o5L4AQNYJJDhQ==
X-Google-Smtp-Source: ABdhPJwXaOsYBHETHFNI5QAD9BI62aHyeFKeRfKB2S0TG9XZ8294bWhQHvq7ecMTeQQ6A8Dwc6bEnHMf+vR7gGngF4Q=
X-Received: by 2002:a25:5743:: with SMTP id l64mr9276769ybb.314.1620344837199;
 Thu, 06 May 2021 16:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210506212025.815380-1-pcc@google.com> <CA+fCnZfTvOsFfwLfpHZKsDJSMDa6NpJu6NVfq4LREjPWg6Yw2w@mail.gmail.com>
In-Reply-To: <CA+fCnZfTvOsFfwLfpHZKsDJSMDa6NpJu6NVfq4LREjPWg6Yw2w@mail.gmail.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 6 May 2021 16:47:06 -0700
Message-ID: <CAMn1gO7xjd07LH0Vm1bbSRub+PY0KP=jFTpRn=4ob4yYg7gAJQ@mail.gmail.com>
Subject: Re: [PATCH] kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
To:     Andrey Konovalov <andreyknvl@gmail.com>
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

On Thu, May 6, 2021 at 3:12 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
>
> On Thu, May 6, 2021 at 11:20 PM Peter Collingbourne <pcc@google.com> wrote:
> >
> > These tests deliberately access these arrays out of bounds,
> > which will cause the dynamic local bounds checks inserted by
> > CONFIG_UBSAN_LOCAL_BOUNDS to fail and panic the kernel. To avoid this
> > problem, access the arrays via volatile pointers, which will prevent
> > the compiler from being able to determine the array bounds.
> >
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Cc: stable@vger.kernel.org
> > Link: https://linux-review.googlesource.com/id/I90b1713fbfa1bf68ff895aef099ea77b98a7c3b9
> > ---
> >  lib/test_kasan.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> >
> > diff --git a/lib/test_kasan.c b/lib/test_kasan.c
> > index dc05cfc2d12f..2a078e8e7b8e 100644
> > --- a/lib/test_kasan.c
> > +++ b/lib/test_kasan.c
> > @@ -654,8 +654,8 @@ static char global_array[10];
> >
> >  static void kasan_global_oob(struct kunit *test)
> >  {
> > -       volatile int i = 3;
> > -       char *p = &global_array[ARRAY_SIZE(global_array) + i];
> > +       char *volatile array = global_array;
> > +       char *p = &array[ARRAY_SIZE(global_array) + 3];
>
> Nit: in the kernel, "volatile" usually comes before the pointer type.

That would refer to a different type. "volatile char *" is a pointer
to volatile char, while "char *volatile" is a volatile pointer to
char. The latter is what we want here, because we want to prevent the
compiler from inferring things about the pointer itself (i.e. its
array bounds), not the data that it refers to.

Peter
