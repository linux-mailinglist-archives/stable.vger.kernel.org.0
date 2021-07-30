Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEDF3DB269
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 06:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhG3Eiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 00:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhG3Eiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 00:38:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC4B46103B;
        Fri, 30 Jul 2021 04:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627619925;
        bh=tD4NnTylNSsCZ9xiCzjSNWEXJJJDNb6Se5lb5F1OcYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=toiNWdL04FsePRojqRJIzvv75RA0Lqux0uewva6xZNg/8+SNhPETyhI9IUaDHc0nP
         dLbX29AD9Ewde6vsYtAWR/NX1gam5MiODiU+gF4sHGp4VMfUMLseThhhhpg13TX6Rl
         RWvDpfkK7vCzJhrQiVSYh84T5CtpQznwl2kwtzPw=
Date:   Fri, 30 Jul 2021 06:38:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Collingbourne <pcc@google.com>
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
Subject: Re: [PATCH 5.13 191/223] selftest: use mmap instead of
 posix_memalign to allocate memory
Message-ID: <YQOCUu0nALesF1HB@kroah.com>
References: <20210726153846.245305071@linuxfoundation.org>
 <20210726153852.445207631@linuxfoundation.org>
 <CAMn1gO42sPYDajZN7MuysTeGJmxvby=sFuU1eXt0APo_Y5FFSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMn1gO42sPYDajZN7MuysTeGJmxvby=sFuU1eXt0APo_Y5FFSQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 10:58:11AM -0700, Peter Collingbourne wrote:
> On Mon, Jul 26, 2021 at 9:16 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Peter Collingbourne <pcc@google.com>
> >
> > commit 0db282ba2c12c1515d490d14a1ff696643ab0f1b upstream.
> >
> > This test passes pointers obtained from anon_allocate_area to the
> > userfaultfd and mremap APIs.  This causes a problem if the system
> > allocator returns tagged pointers because with the tagged address ABI
> > the kernel rejects tagged addresses passed to these APIs, which would
> > end up causing the test to fail.  To make this test compatible with such
> > system allocators, stop using the system allocator to allocate memory in
> > anon_allocate_area, and instead just use mmap.
> >
> > Link: https://lkml.kernel.org/r/20210714195437.118982-3-pcc@google.com
> > Link: https://linux-review.googlesource.com/id/Icac91064fcd923f77a83e8e133f8631c5b8fc241
> > Fixes: c47174fc362a ("userfaultfd: selftest")
> > Co-developed-by: Lokesh Gidra <lokeshgidra@google.com>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > Cc: Dave Martin <Dave.Martin@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Alistair Delva <adelva@google.com>
> > Cc: William McVicker <willmcvicker@google.com>
> > Cc: Evgenii Stepanov <eugenis@google.com>
> > Cc: Mitch Phillips <mitchp@google.com>
> > Cc: Andrey Konovalov <andreyknvl@gmail.com>
> > Cc: <stable@vger.kernel.org>    [5.4]
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  tools/testing/selftests/vm/userfaultfd.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > --- a/tools/testing/selftests/vm/userfaultfd.c
> > +++ b/tools/testing/selftests/vm/userfaultfd.c
> > @@ -197,8 +197,10 @@ static int anon_release_pages(char *rel_
> >
> >  static void anon_allocate_area(void **alloc_area)
> >  {
> > -       if (posix_memalign(alloc_area, page_size, nr_pages * page_size)) {
> > -               fprintf(stderr, "out of memory\n");
> > +       *alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
> > +                          MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> > +       if (*alloc_area == MAP_FAILED)
> 
> Hi Greg,
> 
> It looks like your backport of this patch (and the backports to stable
> kernels) are missing a left brace here.

Already fixed up in the latest -rc releases, right?

thanks,

greg k-h
