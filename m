Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7930443F8D
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 10:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhKCJtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 05:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231278AbhKCJtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 05:49:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D3FD6113B;
        Wed,  3 Nov 2021 09:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635932792;
        bh=JCi57Xe87vMD6it97QtxyVClRxGWin28JiPQM/PNxXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bneuEKaAdHECFDnx94bbIp260s+LI+jR0VcjtwrIrBlTxKQ3z3me+H9bNobVOJiIo
         0VtywvsFq0zscmyMoWDeqVNAD9bxKXSg7Ag6ISx8FxNcMxtIKHXEQpi/iGneEtfn5a
         UAka8oAggOnnbugDBD2ZfshujS28F41Eu5D4hAbg=
Date:   Wed, 3 Nov 2021 10:46:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     naoya.horiguchi@nec.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org,
        osalvador@suse.de, peterx@redhat.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable 5.10 PATCH] mm: hwpoison: remove the unnecessary THP
 check
Message-ID: <YYJacGTst7dceD8K@kroah.com>
References: <20211101194856.305642-1-shy828301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101194856.305642-1-shy828301@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 12:48:56PM -0700, Yang Shi wrote:
> commit c7cb42e94473aafe553c0f2a3d8ca904599399ed upstream.
> 
> When handling THP hwpoison checked if the THP is in allocation or free
> stage since hwpoison may mistreat it as hugetlb page.  After commit
> 415c64c1453a ("mm/memory-failure: split thp earlier in memory error
> handling") the problem has been fixed, so this check is no longer
> needed.  Remove it.  The side effect of the removal is hwpoison may
> report unsplit THP instead of unknown error for shmem THP.  It seems not
> like a big deal.
> 
> The following patch "mm: filemap: check if THP has hwpoisoned subpage
> for PMD page fault" depends on this, which fixes shmem THP with
> hwpoisoned subpage(s) are mapped PMD wrongly.  So this patch needs to be
> backported to -stable as well.
> 
> Link: https://lkml.kernel.org/r/20211020210755.23964-2-shy828301@gmail.com
> Signed-off-by: Yang Shi <shy828301@gmail.com>
> Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
> depends on this one.

Both now queued up, thanks.

greg k-h
