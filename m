Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9AC4457A5
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 17:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhKDQ4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 12:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhKDQ4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 12:56:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7FD2611EE;
        Thu,  4 Nov 2021 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636044837;
        bh=Dhz9FmjLT35R+67iV11heDU4QCFq3O0PsHTKRHXxvYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bD635h5tby1U32S9rZycwUOGE2sFSOJdE30TJHVecwR3f0K/iqHJvG0Z1DHn2WPCR
         d1MSR9HdZgfMpS0Tib7e++/wJr+G4UqWrc52qUd3PsRyCDOuNssC81vMFoSxxWZI/v
         hfh/Jny08QeDasR0aeGoeUCuF2Ol0mTzeI2eRPF8=
Date:   Thu, 4 Nov 2021 17:53:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     naoya.horiguchi@nec.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org,
        osalvador@suse.de, peterx@redhat.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable 5.10 PATCH] mm: hwpoison: remove the unnecessary THP
 check
Message-ID: <YYQQIu6Xi/iEEb7f@kroah.com>
References: <20211101194856.305642-1-shy828301@gmail.com>
 <YYJacGTst7dceD8K@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYJacGTst7dceD8K@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 10:46:24AM +0100, Greg KH wrote:
> On Mon, Nov 01, 2021 at 12:48:56PM -0700, Yang Shi wrote:
> > commit c7cb42e94473aafe553c0f2a3d8ca904599399ed upstream.
> > 
> > When handling THP hwpoison checked if the THP is in allocation or free
> > stage since hwpoison may mistreat it as hugetlb page.  After commit
> > 415c64c1453a ("mm/memory-failure: split thp earlier in memory error
> > handling") the problem has been fixed, so this check is no longer
> > needed.  Remove it.  The side effect of the removal is hwpoison may
> > report unsplit THP instead of unknown error for shmem THP.  It seems not
> > like a big deal.
> > 
> > The following patch "mm: filemap: check if THP has hwpoisoned subpage
> > for PMD page fault" depends on this, which fixes shmem THP with
> > hwpoisoned subpage(s) are mapped PMD wrongly.  So this patch needs to be
> > backported to -stable as well.
> > 
> > Link: https://lkml.kernel.org/r/20211020210755.23964-2-shy828301@gmail.com
> > Signed-off-by: Yang Shi <shy828301@gmail.com>
> > Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> > Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> > mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
> > depends on this one.
> 
> Both now queued up, thanks.

This breaks the build, see:
	https://lore.kernel.org/r/acabc414-164b-cd65-6a1a-cf912d8621d7@roeck-us.net

so I'm going to drop both of these now.  Please fix this up and resend a
tested series.

thanks,

greg k-h
