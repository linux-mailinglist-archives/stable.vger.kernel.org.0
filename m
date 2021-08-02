Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B446F3DE078
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 22:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhHBULJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 16:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhHBULI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 16:11:08 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200A8C061760
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 13:10:59 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id h1so21709711iol.9
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 13:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7JjQd+ZR7FC88NvaO1/ik1OCoriiWj0SLnlnN+EI6+8=;
        b=Ywy6YSPDF52dLo6oCY5yw62rQn3QAGehVNzZ6Dv5DUDeIKKP92UUQMDs8CtPL3DiJE
         1OefmpRqTUy2v0i+OjdR8oZzMg4nynlv5vAj5zU5UTqYK+LOVP879lP4OgXBf1HRHyTb
         wRdcZGFEXh59XgJTvMCpApDLIgiAGWfm6ke6p74FuSBJTpCI3GZILGpVFdH3JYVE85Q5
         ZxXmdpQ+aUkvo7nhN0KIamvaJ88+5VGe1ycZtK0Ryi+litocRaf+THOt43sEpqEh9MHX
         O/azej0FQFGlnTyXYL4bF3WjwHs/L5jx0++1/bn7zm90xoaGqaqgpY8hWouHTvTgbeei
         SOtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7JjQd+ZR7FC88NvaO1/ik1OCoriiWj0SLnlnN+EI6+8=;
        b=ia+DmGKuKSzUBLwG56JUkx8e42wYkx8FTM30LzvNPQWuhHmFtQtL67KhALwkhzegEv
         Be7e2bWYiroIGtQxPCHnelSbFLnQLZtlQO1aZd34hg6T7wHiP5ZstSbOWtTfHWTE1rkC
         MQdAiTJIY/WAnsfcD4/FQf80xwCkr72rC8BuwtqFETgcCTWsrxb/tWB+Ax9N0Rzj2zSZ
         lPuNCgXkzkoMOI9srFilnDXmS6H3yh8JsGR/DE5SdyZ7tF6u061BAn6IPKttXmAZ55q8
         e+GMHcuuCAVc28WxdIyVZvh5a3ROIwKtXrOVIBE1GJ6XToQm2Vw0J0cmLMYP555sn6iL
         NGVw==
X-Gm-Message-State: AOAM533dhNk0G2gga+N0PNPLlEz2JykRdJiEStaOynSrExz9T+l4kWHe
        Y02y/DKL625WOI0NcraNKvphxFQduZsjFcJZnQK/W58aPu/07IhJ
X-Google-Smtp-Source: ABdhPJz9KoWJcLNs4XLiWG7XBcXDfyud1ryml8h+jHng7dNSa3OM43gzesT4vPjQfdkKmf49a+ZVhPYPExOqvjEyZE4=
X-Received: by 2002:a05:6638:35a8:: with SMTP id v40mr16688614jal.126.1627935058394;
 Mon, 02 Aug 2021 13:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210726153846.245305071@linuxfoundation.org> <20210726153852.445207631@linuxfoundation.org>
 <CAMn1gO42sPYDajZN7MuysTeGJmxvby=sFuU1eXt0APo_Y5FFSQ@mail.gmail.com> <YQOCUu0nALesF1HB@kroah.com>
In-Reply-To: <YQOCUu0nALesF1HB@kroah.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Mon, 2 Aug 2021 13:10:47 -0700
Message-ID: <CAMn1gO4TqPccK6GqiB8zzm=CzQd-kqGBh0HrVf_2W_VpaSq_+A@mail.gmail.com>
Subject: Re: [PATCH 5.13 191/223] selftest: use mmap instead of posix_memalign
 to allocate memory
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lokesh Gidra <lokeshgidra@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Alistair Delva <adelva@google.com>,
        William McVicker <willmcvicker@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Mitch Phillips <mitchp@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        donnyxia@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 9:38 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jul 29, 2021 at 10:58:11AM -0700, Peter Collingbourne wrote:
> > On Mon, Jul 26, 2021 at 9:16 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Peter Collingbourne <pcc@google.com>
> > >
> > > commit 0db282ba2c12c1515d490d14a1ff696643ab0f1b upstream.
> > >
> > > This test passes pointers obtained from anon_allocate_area to the
> > > userfaultfd and mremap APIs.  This causes a problem if the system
> > > allocator returns tagged pointers because with the tagged address ABI
> > > the kernel rejects tagged addresses passed to these APIs, which would
> > > end up causing the test to fail.  To make this test compatible with such
> > > system allocators, stop using the system allocator to allocate memory in
> > > anon_allocate_area, and instead just use mmap.
> > >
> > > Link: https://lkml.kernel.org/r/20210714195437.118982-3-pcc@google.com
> > > Link: https://linux-review.googlesource.com/id/Icac91064fcd923f77a83e8e133f8631c5b8fc241
> > > Fixes: c47174fc362a ("userfaultfd: selftest")
> > > Co-developed-by: Lokesh Gidra <lokeshgidra@google.com>
> > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > > Cc: Dave Martin <Dave.Martin@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > > Cc: Alistair Delva <adelva@google.com>
> > > Cc: William McVicker <willmcvicker@google.com>
> > > Cc: Evgenii Stepanov <eugenis@google.com>
> > > Cc: Mitch Phillips <mitchp@google.com>
> > > Cc: Andrey Konovalov <andreyknvl@gmail.com>
> > > Cc: <stable@vger.kernel.org>    [5.4]
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  tools/testing/selftests/vm/userfaultfd.c |    6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > --- a/tools/testing/selftests/vm/userfaultfd.c
> > > +++ b/tools/testing/selftests/vm/userfaultfd.c
> > > @@ -197,8 +197,10 @@ static int anon_release_pages(char *rel_
> > >
> > >  static void anon_allocate_area(void **alloc_area)
> > >  {
> > > -       if (posix_memalign(alloc_area, page_size, nr_pages * page_size)) {
> > > -               fprintf(stderr, "out of memory\n");
> > > +       *alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
> > > +                          MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> > > +       if (*alloc_area == MAP_FAILED)
> >
> > Hi Greg,
> >
> > It looks like your backport of this patch (and the backports to stable
> > kernels) are missing a left brace here.
>
> Already fixed up in the latest -rc releases, right?

It looks like you fixed it on linux-4.19.y and linux-5.4.y, but not
linux-4.14.y, linux-5.10.y or linux-5.13.y.

Peter
