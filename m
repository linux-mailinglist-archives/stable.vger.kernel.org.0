Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FD1445A00
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 19:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhKDSxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 14:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230109AbhKDSxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 14:53:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36E7060EBD;
        Thu,  4 Nov 2021 18:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636051852;
        bh=neeyNxkuI99HaYVUJyM0NkweIy5VQIlUtanbkesCaL8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pD6sXSSIH34QdxUdpLgNTVFDwxFMNTSnvBAjo5xd9a7q29h9WuNCIRyAdFwR1Q7h2
         Fyznb7S4RU0uDaYb/MihAGk56g+k37fxw6Adg45bdSIcpHTfdnLNl88qbPPKVDQYzD
         DspIGM2sGXiY0SCs1V/cSPrBd4iaXRyBhPwXRerM=
Date:   Thu, 4 Nov 2021 19:50:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     HORIGUCHI =?utf-8?B?TkFPWUEo5aCA5Y+jIOebtOS5nyk=?= 
        <naoya.horiguchi@nec.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable 5.10 PATCH] mm: hwpoison: remove the unnecessary THP
 check
Message-ID: <YYQriRRkWrL0efLY@kroah.com>
References: <20211101194856.305642-1-shy828301@gmail.com>
 <YYJacGTst7dceD8K@kroah.com>
 <YYQQIu6Xi/iEEb7f@kroah.com>
 <CAHbLzkrZKkS92St-AR-jL8HJYXKOm3EjKkbsaBY58LERh3-_qA@mail.gmail.com>
 <CAHbLzkq6Egjv3=DYXVWC23EQH++an1QN=QtZmz88f1k9-NKODQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbLzkq6Egjv3=DYXVWC23EQH++an1QN=QtZmz88f1k9-NKODQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 11:07:05AM -0700, Yang Shi wrote:
> On Thu, Nov 4, 2021 at 10:43 AM Yang Shi <shy828301@gmail.com> wrote:
> >
> > On Thu, Nov 4, 2021 at 9:53 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Nov 03, 2021 at 10:46:24AM +0100, Greg KH wrote:
> > > > On Mon, Nov 01, 2021 at 12:48:56PM -0700, Yang Shi wrote:
> > > > > commit c7cb42e94473aafe553c0f2a3d8ca904599399ed upstream.
> > > > >
> > > > > When handling THP hwpoison checked if the THP is in allocation or free
> > > > > stage since hwpoison may mistreat it as hugetlb page.  After commit
> > > > > 415c64c1453a ("mm/memory-failure: split thp earlier in memory error
> > > > > handling") the problem has been fixed, so this check is no longer
> > > > > needed.  Remove it.  The side effect of the removal is hwpoison may
> > > > > report unsplit THP instead of unknown error for shmem THP.  It seems not
> > > > > like a big deal.
> > > > >
> > > > > The following patch "mm: filemap: check if THP has hwpoisoned subpage
> > > > > for PMD page fault" depends on this, which fixes shmem THP with
> > > > > hwpoisoned subpage(s) are mapped PMD wrongly.  So this patch needs to be
> > > > > backported to -stable as well.
> > > > >
> > > > > Link: https://lkml.kernel.org/r/20211020210755.23964-2-shy828301@gmail.com
> > > > > Signed-off-by: Yang Shi <shy828301@gmail.com>
> > > > > Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> > > > > Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> > > > > Cc: Hugh Dickins <hughd@google.com>
> > > > > Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > > Cc: Matthew Wilcox <willy@infradead.org>
> > > > > Cc: Oscar Salvador <osalvador@suse.de>
> > > > > Cc: Peter Xu <peterx@redhat.com>
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > ---
> > > > > mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
> > > > > depends on this one.
> > > >
> > > > Both now queued up, thanks.
> > >
> > > This breaks the build, see:
> > >         https://lore.kernel.org/r/acabc414-164b-cd65-6a1a-cf912d8621d7@roeck-us.net
> > >
> > > so I'm going to drop both of these now.  Please fix this up and resend a
> > > tested series.
> >
> > Thanks for catching this. It is because I accidentally left the
> > PAGEFLAG_* macros into CONFIG_TRANSHUGE_PAGE section, so it is:
> >
> > #ifdef CONFIG_TRANSHUGE_PAGE
> > ...
> > #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSHUGE_PAGE)
> > PAGEFLAG_xxx
> > #else
> > PAGEFLAG_FALSE_xxx
> > #endif
> > ...
> > #endif
> >
> > So when THP is disabled the PAGEFLAG_FALSE_xxx macro is actually absent.
> >
> > The upstream has the same issue, will send a patch to fix it soon, and
> > send fixes (folded the new fix in) to -stable later. Sorry for the
> > inconvenience.
> 
> Further looking shows the upstream is good. I did *NOT* add the code
> in CONFIG_TRANSHUGE_PAGE section. It seems the code section was moved
> around when the patch was applied to 5.10.
> 
> Could you please fold the below patch into
> mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch?
> Or I could prepare a patch for you.

I need a working patch series please.

thanks,

greg k-h
