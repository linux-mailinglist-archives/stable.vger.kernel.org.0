Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E6944E7CD
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 14:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhKLNuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 08:50:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235079AbhKLNuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 08:50:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35CB560F93;
        Fri, 12 Nov 2021 13:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636724861;
        bh=tzR1zz/QIlY8cKoU6Cu7kiPj1FGauiZuMueFbriZ+rk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eTK5ovxnRNtcmIIyMjcwezKI0SM5gsn1mvL5xOnIX4KY0GT/FMnNg+VrjpCLL9SQE
         sKAcDKt1mBDNnItvlxIV8A6+NoUVEOeO+W+RH9+4LyGogILThDM1K+M1O6sQzXPsNa
         5e3wNMhWQf8WOo+jqn9SLcIB4jquWAc7phhW9/30=
Date:   Fri, 12 Nov 2021 14:47:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>, f.fainelli@gmail.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        lkft-triage@lists.linaro.org, patches@kernelci.org,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        jonathanh@nvidia.com, shuah@kernel.org, linux@roeck-us.net,
        Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
Message-ID: <YY5we7CKKS0g4d/s@kroah.com>
References: <20211110182002.964190708@linuxfoundation.org>
 <YY0UQAQ54Vq4vC3z@debian>
 <CA+G9fYvu9VQY=_NgR6-UCFOZ+57pSy1xsPkCgJuQsAS-P62Umg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvu9VQY=_NgR6-UCFOZ+57pSy1xsPkCgJuQsAS-P62Umg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 08:24:42PM +0530, Naresh Kamboju wrote:
> On Thu, 11 Nov 2021 at 18:32, Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Wed, Nov 10, 2021 at 07:43:46PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.79 release.
> > > There are 21 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> > > Anything received after that time might be too late.
> >
> > systemd-journal-flush.service failed due to a timeout resulting in a very very
> > slow boot on my test laptop. qemu test on openqa failed due to the same problem.
> >
> > https://openqa.qa.codethink.co.uk/tests/365
> >
> > A bisect showed the problem to be 8615ff6dd1ac ("mm: filemap: check if THP has
> > hwpoisoned subpage for PMD page fault"). Reverting it on top of 5.10.79-rc1
> > fixed the problem.
> > Incidentally, I was having similar problem with Linus's tree
> > for last few days and was failing since 20211106 (did not get the time to check).
> > I will test mainline again with this commit reverted.
> 
> I have also noticed this problem and Anders bisected and found this
> first bad commit.
> 
> Failed test log link,
> A start job is running for Journal Service (5s / 1min 27s)
> https://lkft.validation.linaro.org/scheduler/job/3901980#L2234
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Bisect log:
> 
> # bad: [b85617a6291f710807d0cd078c230626dee60b16] Linux 5.10.79-rc1
> # good: [5040520482a594e92d4f69141229a6dd26173511] Linux 5.10.78
> git bisect start 'b85617a6291f710807d0cd078c230626dee60b16'
> '5040520482a594e92d4f69141229a6dd26173511'
> # bad: [7ceeda856035991a6c9804916987a03759745fb0] staging: rtl8712:
> fix use-after-free in rtl8712_dl_fw
> git bisect bad 7ceeda856035991a6c9804916987a03759745fb0
> # bad: [8615ff6dd1ac9e01b6fcf0fc0652353f79f524ed] mm: filemap: check
> if THP has hwpoisoned subpage for PMD page fault
> git bisect bad 8615ff6dd1ac9e01b6fcf0fc0652353f79f524ed
> # good: [e9cb6ce4690749d42013f1d56874c624d7241740] Revert "x86/kvm:
> fix vcpu-id indexed array sizes"
> git bisect good e9cb6ce4690749d42013f1d56874c624d7241740
> # good: [dc385dfc126d51d7a93db694f8e151afe60eb06a] mm: hwpoison:
> remove the unnecessary THP check
> git bisect good dc385dfc126d51d7a93db694f8e151afe60eb06a
> # first bad commit: [8615ff6dd1ac9e01b6fcf0fc0652353f79f524ed] mm:
> filemap: check if THP has hwpoisoned subpage for PMD page fault
> commit 8615ff6dd1ac9e01b6fcf0fc0652353f79f524ed
> Author: Yang Shi <shy828301@gmail.com>
> Date:   Thu Oct 28 14:36:11 2021 -0700
> 
>     mm: filemap: check if THP has hwpoisoned subpage for PMD page fault
> 
>     commit eac96c3efdb593df1a57bb5b95dbe037bfa9a522 upstream.
> 
>     When handling shmem page fault the THP with corrupted subpage could be
>     PMD mapped if certain conditions are satisfied.  But kernel is supposed
>     to send SIGBUS when trying to map hwpoisoned page.
> 
>     There are two paths which may do PMD map: fault around and regular
>     fault.
> 
>     Before commit f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault()
>     codepaths") the thing was even worse in fault around path.  The THP
>     could be PMD mapped as long as the VMA fits regardless what subpage is
>     accessed and corrupted.  After this commit as long as head page is not
>     corrupted the THP could be PMD mapped.
> 
>     In the regular fault path the THP could be PMD mapped as long as the
>     corrupted page is not accessed and the VMA fits.
> 
>     This loophole could be fixed by iterating every subpage to check if any
>     of them is hwpoisoned or not, but it is somewhat costly in page fault
>     path.
> 
>     So introduce a new page flag called HasHWPoisoned on the first tail
>     page.  It indicates the THP has hwpoisoned subpage(s).  It is set if any
>     subpage of THP is found hwpoisoned by memory failure and after the
>     refcount is bumped successfully, then cleared when the THP is freed or
>     split.
> 
>     The soft offline path doesn't need this since soft offline handler just
>     marks a subpage hwpoisoned when the subpage is migrated successfully.
>     But shmem THP didn't get split then migrated at all.
> 
>     Link: https://lkml.kernel.org/r/20211020210755.23964-3-shy828301@gmail.com
>     Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>     Signed-off-by: Yang Shi <shy828301@gmail.com>
>     Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
>     Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>     Cc: Hugh Dickins <hughd@google.com>
>     Cc: Matthew Wilcox <willy@infradead.org>
>     Cc: Oscar Salvador <osalvador@suse.de>
>     Cc: Peter Xu <peterx@redhat.com>
>     Cc: <stable@vger.kernel.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
>  include/linux/page-flags.h | 23 +++++++++++++++++++++++
>  mm/huge_memory.c           |  2 ++
>  mm/memory-failure.c        | 14 ++++++++++++++
>  mm/memory.c                |  9 +++++++++
>  mm/page_alloc.c            |  4 +++-
>  5 files changed, 51 insertions(+), 1 deletion(-)
> 

Thanks, I'm going to go drop this patch again.

This has been the second time we have tried to add it.  Yang, are you
_SURE_ it needs to be in the 5.10.y tree?  So far it's been nothing but
build and boot failures :(

thanks,

greg k-h
