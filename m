Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A683DFEE4
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 12:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbhHDKFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 06:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237375AbhHDKFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 06:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8DEC61004;
        Wed,  4 Aug 2021 10:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628071496;
        bh=k3LqIh7WmygExsaYiICBd+md8eg9IPVoWz97p7hp8qo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sHG6EnRvleLDE61AO+j4tBSSrZNk8acuco+XVYWh9F/V5Mxcb1L8hxqnisWJJU7W8
         5ncBCKpy+7JXJ6XNkvXGbNq/tjm4idnlnDQ4CVcUdG58T3ntlQ6W5RWoPWG9ZGWhEm
         or2UekZpFB2lRzolzIfJjliagsaPuh7hChlzWtPI=
Date:   Wed, 4 Aug 2021 12:04:53 +0200
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
Message-ID: <YQpmRSI+04noKhtV@kroah.com>
References: <20210726153846.245305071@linuxfoundation.org>
 <20210726153852.445207631@linuxfoundation.org>
 <CAMn1gO42sPYDajZN7MuysTeGJmxvby=sFuU1eXt0APo_Y5FFSQ@mail.gmail.com>
 <YQOCUu0nALesF1HB@kroah.com>
 <CAMn1gO4TqPccK6GqiB8zzm=CzQd-kqGBh0HrVf_2W_VpaSq_+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMn1gO4TqPccK6GqiB8zzm=CzQd-kqGBh0HrVf_2W_VpaSq_+A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 01:10:47PM -0700, Peter Collingbourne wrote:
> On Thu, Jul 29, 2021 at 9:38 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jul 29, 2021 at 10:58:11AM -0700, Peter Collingbourne wrote:
> > > On Mon, Jul 26, 2021 at 9:16 AM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > From: Peter Collingbourne <pcc@google.com>
> > > >
> > > > commit 0db282ba2c12c1515d490d14a1ff696643ab0f1b upstream.
> > > >
> > > > This test passes pointers obtained from anon_allocate_area to the
> > > > userfaultfd and mremap APIs.  This causes a problem if the system
> > > > allocator returns tagged pointers because with the tagged address ABI
> > > > the kernel rejects tagged addresses passed to these APIs, which would
> > > > end up causing the test to fail.  To make this test compatible with such
> > > > system allocators, stop using the system allocator to allocate memory in
> > > > anon_allocate_area, and instead just use mmap.
> > > >
> > > > Link: https://lkml.kernel.org/r/20210714195437.118982-3-pcc@google.com
> > > > Link: https://linux-review.googlesource.com/id/Icac91064fcd923f77a83e8e133f8631c5b8fc241
> > > > Fixes: c47174fc362a ("userfaultfd: selftest")
> > > > Co-developed-by: Lokesh Gidra <lokeshgidra@google.com>
> > > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > > > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > > > Cc: Dave Martin <Dave.Martin@arm.com>
> > > > Cc: Will Deacon <will@kernel.org>
> > > > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > > > Cc: Alistair Delva <adelva@google.com>
> > > > Cc: William McVicker <willmcvicker@google.com>
> > > > Cc: Evgenii Stepanov <eugenis@google.com>
> > > > Cc: Mitch Phillips <mitchp@google.com>
> > > > Cc: Andrey Konovalov <andreyknvl@gmail.com>
> > > > Cc: <stable@vger.kernel.org>    [5.4]
> > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  tools/testing/selftests/vm/userfaultfd.c |    6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > --- a/tools/testing/selftests/vm/userfaultfd.c
> > > > +++ b/tools/testing/selftests/vm/userfaultfd.c
> > > > @@ -197,8 +197,10 @@ static int anon_release_pages(char *rel_
> > > >
> > > >  static void anon_allocate_area(void **alloc_area)
> > > >  {
> > > > -       if (posix_memalign(alloc_area, page_size, nr_pages * page_size)) {
> > > > -               fprintf(stderr, "out of memory\n");
> > > > +       *alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
> > > > +                          MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> > > > +       if (*alloc_area == MAP_FAILED)
> > >
> > > Hi Greg,
> > >
> > > It looks like your backport of this patch (and the backports to stable
> > > kernels) are missing a left brace here.
> >
> > Already fixed up in the latest -rc releases, right?
> 
> It looks like you fixed it on linux-4.19.y and linux-5.4.y, but not
> linux-4.14.y, linux-5.10.y or linux-5.13.y.

4.14 had not had a release with this in it yet (it is in the queue), I
missed that I also broke this on 5.10 and 5.13 so will go add it there
as well.

thanks!

greg k-h
