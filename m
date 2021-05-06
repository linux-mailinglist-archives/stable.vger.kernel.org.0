Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912AA375DB7
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 01:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbhEFX7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 19:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbhEFX7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 19:59:02 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC29C061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 16:58:03 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id s20so5346554ejr.9
        for <stable@vger.kernel.org>; Thu, 06 May 2021 16:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rhzQtgGkk8sv3F0qr+scsNAZtqe/fprkS77yEKXnN3w=;
        b=VHNvekirgQ0xBt5Pfhp9vtNrHQVgIDv6MyNboCSCKMhdAcFJXAO21LppYgg+5N8y22
         qAV/byl6Ze79ZsQsvr3uXOTJeQNLnSL7qojlOxWLt/WsJrHszcBja841gT6VvUF3tNIa
         X3weXeBRcbA2XrpbSwXi6BmJk38ldfVNf78yF9ji16fASC6/Ks2yomGuicKS+XNqRo7Z
         QIM+lt5xhjm9bBVdn8sz97gqHUtgSh2Ld0wluTWG/DHQmtphwAxTM3lx76gzGrVacT9v
         jPnozSElj+8nAeW1Wm0RGEpH0tiDgG8VBNR2woyT6gKvCXSyHTHtAjrryxkh7/HV9Nh1
         pXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rhzQtgGkk8sv3F0qr+scsNAZtqe/fprkS77yEKXnN3w=;
        b=Odl+0PvERKM0zopa7oeVOS6uU+vGpYkOIT7oJODluZGkUYuTSJZfriUgMs/mtgVRrM
         DYGQyQUlVRLISxozPEqskJAaCH0Qn6ANHRNvL5KYvb83z96Edj3I/I1+ZnJnrie0a36o
         53XSvMouY1cRLQy4AkBrj4WTYF0SQE9tas9iROTwZ11ajvcJEqpp6P8zOHeTAOohQPhY
         Lts5MEUhKG6gPUVq7y3bfsfb28E6lwAqdY2kLXqfUutw7OBKyIWgT7bNL123iq++kL8l
         STMu6tsJ+RnksB0/YQ08OhYOpgQfwL1JLJ/di8v64Wa/4j1aD7JziLtO7GvQNrrPwi7J
         kTRA==
X-Gm-Message-State: AOAM532o76GDQIA1DUGeeMkQnbuWHRJFRmPOXFcXDqPDnpSspOY9F5UC
        m50znd7FXugOjJKKqich9Dkmob0W7u7gbmYV1xY=
X-Google-Smtp-Source: ABdhPJz+nfN98RMK/BtpdjPP6TOqq/+qqWYJJvo0fepYtYioUQoH6SDSMtjp4Atw7vVilRf4m34R6YzsJ4x4Z/L0OmI=
X-Received: by 2002:a17:906:2616:: with SMTP id h22mr7262378ejc.126.1620345481891;
 Thu, 06 May 2021 16:58:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210506212025.815380-1-pcc@google.com> <CA+fCnZfTvOsFfwLfpHZKsDJSMDa6NpJu6NVfq4LREjPWg6Yw2w@mail.gmail.com>
 <CAMn1gO7xjd07LH0Vm1bbSRub+PY0KP=jFTpRn=4ob4yYg7gAJQ@mail.gmail.com>
In-Reply-To: <CAMn1gO7xjd07LH0Vm1bbSRub+PY0KP=jFTpRn=4ob4yYg7gAJQ@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Fri, 7 May 2021 01:57:51 +0200
Message-ID: <CA+fCnZcEQBLRQhSkJc_FRdkvYabihY8aho3QHE4jjw10WuuoyQ@mail.gmail.com>
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

On Fri, May 7, 2021 at 1:47 AM Peter Collingbourne <pcc@google.com> wrote:
>
> On Thu, May 6, 2021 at 3:12 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
> >
> > On Thu, May 6, 2021 at 11:20 PM Peter Collingbourne <pcc@google.com> wrote:
> > >
> > > These tests deliberately access these arrays out of bounds,
> > > which will cause the dynamic local bounds checks inserted by
> > > CONFIG_UBSAN_LOCAL_BOUNDS to fail and panic the kernel. To avoid this
> > > problem, access the arrays via volatile pointers, which will prevent
> > > the compiler from being able to determine the array bounds.
> > >
> > > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > > Cc: stable@vger.kernel.org
> > > Link: https://linux-review.googlesource.com/id/I90b1713fbfa1bf68ff895aef099ea77b98a7c3b9
> > > ---
> > >  lib/test_kasan.c | 14 ++++++++------
> > >  1 file changed, 8 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/lib/test_kasan.c b/lib/test_kasan.c
> > > index dc05cfc2d12f..2a078e8e7b8e 100644
> > > --- a/lib/test_kasan.c
> > > +++ b/lib/test_kasan.c
> > > @@ -654,8 +654,8 @@ static char global_array[10];
> > >
> > >  static void kasan_global_oob(struct kunit *test)
> > >  {
> > > -       volatile int i = 3;
> > > -       char *p = &global_array[ARRAY_SIZE(global_array) + i];
> > > +       char *volatile array = global_array;
> > > +       char *p = &array[ARRAY_SIZE(global_array) + 3];
> >
> > Nit: in the kernel, "volatile" usually comes before the pointer type.
>
> That would refer to a different type. "volatile char *" is a pointer
> to volatile char, while "char *volatile" is a volatile pointer to
> char. The latter is what we want here, because we want to prevent the
> compiler from inferring things about the pointer itself (i.e. its
> array bounds), not the data that it refers to.

I see. This is unusual. I'd say this needs to be explicitly explained
in the commit message, as well as in a comment in the code.
