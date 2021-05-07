Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A56D375EF1
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 04:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhEGDAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 23:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhEGDAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 23:00:53 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB22C061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 19:59:54 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id e190so10100769ybb.10
        for <stable@vger.kernel.org>; Thu, 06 May 2021 19:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jyeEVDWCsJDK9WjnevEylhhMkY8rdV3C9LFNvXcKQQ=;
        b=XLGMlOmKZQf1wdAkiQjry4+JmGH0YYfwJibp+VuCfiEWY7dTIrkPxC0EL1+ViNqZEk
         jeVbG4Qs94DhxV/3JA5z0jfEZUYOhBENqMRZiHoJNy0jZVub8SHsHsnFIKMQusAxsIOj
         xywuMIOAnLVk5iILaYjg50+DD1gXZujVgKqUzpJgY37rG+DLBsM5cJr+ILXlfV6iNQbo
         PeNW4j/N0XE2a8mGlJBH4/b+WaZNmb8EqxG/SzA/L+i1kSobJQnJOIPcJsI/+8w6OZYb
         8NRKdcty3iw6OnbeYRUp/jCEigwCYwOZu+9ZkIrL2Wgo5zk7LDxA2BaFszYGAT6I5ke0
         5HIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jyeEVDWCsJDK9WjnevEylhhMkY8rdV3C9LFNvXcKQQ=;
        b=Furg82+6oPru+ioQshSoHFPn2zyRbKiC6uxQ2IW17DZGOJdvRW+4CWuumXJtoot0x4
         U7wGODbQ1TlFdJ57744kAyy12ukEGvRSyV2u/XXCsoOiBDuk56bzou7DY4DxitaJubu6
         56xzip34KuZxepaPWnW/GVwZlcZJUdz5zcHIIVLtBW83ulnRyJZ4x6IwTX1P9NumKskN
         JX+HE1Y6UD9gdkJVGc8DYJdEL275cTHwqQvnTc6HsSR3f4+iWSPmZ04nzfz0sYT2DfKc
         NaqA+MQOwlhSdn++nKQ5C/skgMTrnO5D417stPXuGUo4QtsvLmwNADsaPNHkmg+Dg95S
         1fbA==
X-Gm-Message-State: AOAM533vE+Hic/WIRAHqhV/bipcL3QRorta6Cyxia0RfM2colhdAAVa9
        BwHo8/s2TFNy8CTuTaQqQG3xWN6bRHbNJ+qstd6uUm/v4x8=
X-Google-Smtp-Source: ABdhPJzAU9HJOs0EbYseAm14OduSCR8BddYeCmVyRUFDX63L8L7sDVv3sqA4oLGOsl8ttMGrqoxFeamcoPgu0wKi8Lc=
X-Received: by 2002:a25:cccd:: with SMTP id l196mr10927574ybf.26.1620356394027;
 Thu, 06 May 2021 19:59:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210506212025.815380-1-pcc@google.com> <CA+fCnZfTvOsFfwLfpHZKsDJSMDa6NpJu6NVfq4LREjPWg6Yw2w@mail.gmail.com>
 <CAMn1gO7xjd07LH0Vm1bbSRub+PY0KP=jFTpRn=4ob4yYg7gAJQ@mail.gmail.com> <CA+fCnZcEQBLRQhSkJc_FRdkvYabihY8aho3QHE4jjw10WuuoyQ@mail.gmail.com>
In-Reply-To: <CA+fCnZcEQBLRQhSkJc_FRdkvYabihY8aho3QHE4jjw10WuuoyQ@mail.gmail.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 6 May 2021 19:59:28 -0700
Message-ID: <CAMn1gO6zUSN+-BSmKN=WuTJ=oabu1iUBJ1HhrJELPO_HzR8v4Q@mail.gmail.com>
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

On Thu, May 6, 2021 at 4:58 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
>
> On Fri, May 7, 2021 at 1:47 AM Peter Collingbourne <pcc@google.com> wrote:
> >
> > On Thu, May 6, 2021 at 3:12 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
> > >
> > > On Thu, May 6, 2021 at 11:20 PM Peter Collingbourne <pcc@google.com> wrote:
> > > >
> > > > These tests deliberately access these arrays out of bounds,
> > > > which will cause the dynamic local bounds checks inserted by
> > > > CONFIG_UBSAN_LOCAL_BOUNDS to fail and panic the kernel. To avoid this
> > > > problem, access the arrays via volatile pointers, which will prevent
> > > > the compiler from being able to determine the array bounds.
> > > >
> > > > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > > > Cc: stable@vger.kernel.org
> > > > Link: https://linux-review.googlesource.com/id/I90b1713fbfa1bf68ff895aef099ea77b98a7c3b9
> > > > ---
> > > >  lib/test_kasan.c | 14 ++++++++------
> > > >  1 file changed, 8 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/lib/test_kasan.c b/lib/test_kasan.c
> > > > index dc05cfc2d12f..2a078e8e7b8e 100644
> > > > --- a/lib/test_kasan.c
> > > > +++ b/lib/test_kasan.c
> > > > @@ -654,8 +654,8 @@ static char global_array[10];
> > > >
> > > >  static void kasan_global_oob(struct kunit *test)
> > > >  {
> > > > -       volatile int i = 3;
> > > > -       char *p = &global_array[ARRAY_SIZE(global_array) + i];
> > > > +       char *volatile array = global_array;
> > > > +       char *p = &array[ARRAY_SIZE(global_array) + 3];
> > >
> > > Nit: in the kernel, "volatile" usually comes before the pointer type.
> >
> > That would refer to a different type. "volatile char *" is a pointer
> > to volatile char, while "char *volatile" is a volatile pointer to
> > char. The latter is what we want here, because we want to prevent the
> > compiler from inferring things about the pointer itself (i.e. its
> > array bounds), not the data that it refers to.
>
> I see. This is unusual. I'd say this needs to be explicitly explained
> in the commit message, as well as in a comment in the code.

Done in v2.

Peter
