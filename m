Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93A3E502A
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 17:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394101AbfJYPcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 11:32:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731226AbfJYPcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 11:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+/gvmWPLED77Ax/dLgOjX8mNE1xoFxjC6a1H8EDfWLI=; b=DI7Heg3Rzw+oStT3b/lEoSSFU
        hZUtuX0mKVr3jNZkkAZE/ptp6HYkT5GkRd1yaOAJwpTmEVIr14js9eAdoPF90102RlY+y6GSupnKV
        FgUi5TK00zzM0kNJrIiNuswOq1UkVjLXMCTmvzqMkXutsJyta4VE+7reWjmy9nqXD70GrkYUfjIFG
        67FXpRJD0V+qltjeOFImhWTnNBac2c+aaISiU0qB9/gatrM5xbSLVszuOGfXsc+5K5DEbqcj9HqWu
        +KSG29Sjk/lefD5Pd/SoyL5KBdx/d4zvpjMFdQzr4siCPMttMDq9mqXyJH4z5usGzfXihXZO+aEEG
        RcF61RLIQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO1ZN-0003Wd-Ux; Fri, 25 Oct 2019 15:32:05 +0000
Date:   Fri, 25 Oct 2019 08:32:05 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     hughd@google.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, gavin.dg@linux.alibaba.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v4 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
Message-ID: <20191025153205.GQ2963@bombadil.infradead.org>
References: <1571865575-42913-1-git-send-email-yang.shi@linux.alibaba.com>
 <20191024135547.GH2963@bombadil.infradead.org>
 <c3932146-1b91-fa90-b947-9d4ebe5c5135@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3932146-1b91-fa90-b947-9d4ebe5c5135@linux.alibaba.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 09:33:11AM -0700, Yang Shi wrote:
> On 10/24/19 6:55 AM, Matthew Wilcox wrote:
> > On Thu, Oct 24, 2019 at 05:19:35AM +0800, Yang Shi wrote:
> > > We have usecase to use tmpfs as QEMU memory backend and we would like to
> > > take the advantage of THP as well.  But, our test shows the EPT is not
> > > PMD mapped even though the underlying THP are PMD mapped on host.
> > > The number showed by /sys/kernel/debug/kvm/largepage is much less than
> > > the number of PMD mapped shmem pages as the below:
> > > 
> > > 7f2778200000-7f2878200000 rw-s 00000000 00:14 262232 /dev/shm/qemu_back_mem.mem.Hz2hSf (deleted)
> > > Size:            4194304 kB
> > > [snip]
> > > AnonHugePages:         0 kB
> > > ShmemPmdMapped:   579584 kB
> > > [snip]
> > > Locked:                0 kB
> > > 
> > > cat /sys/kernel/debug/kvm/largepages
> > > 12
> > > 
> > > And some benchmarks do worse than with anonymous THPs.
> > > 
> > > By digging into the code we figured out that commit 127393fbe597 ("mm:
> > > thp: kvm: fix memory corruption in KVM with THP enabled") checks if
> > > there is a single PTE mapping on the page for anonymous THP when
> > > setting up EPT map.  But, the _mapcount < 0 check doesn't fit to page
> > > cache THP since every subpage of page cache THP would get _mapcount
> > > inc'ed once it is PMD mapped, so PageTransCompoundMap() always returns
> > > false for page cache THP.  This would prevent KVM from setting up PMD
> > > mapped EPT entry.
> > > 
> > > So we need handle page cache THP correctly.  However, when page cache
> > > THP's PMD gets split, kernel just remove the map instead of setting up
> > > PTE map like what anonymous THP does.  Before KVM calls get_user_pages()
> > > the subpages may get PTE mapped even though it is still a THP since the
> > > page cache THP may be mapped by other processes at the mean time.
> > > 
> > > Checking its _mapcount and whether the THP has PTE mapped or not.
> > > Although this may report some false negative cases (PTE mapped by other
> > > processes), it looks not trivial to make this accurate.
> > I don't understand why you care how it's mapped into userspace.  If there
> > is a PMD-sized page in the page cache, then you can use a PMD mapping
> > in the EPT tables to map it.  Why would another process having a PTE
> > mapping on the page cause you to not use a PMD mapping?
> 
> We don't care if the THP is PTE mapped by other process, but either
> PageDoubleMap flag or _mapcount/compound_mapcount can't tell us if the PTE
> map comes from the current process or other process unless gup could return
> pmd's status.

But why do you care if the THP is PTE mapped by _this_ process?
This process has a reference to the page; the page is PMD sized and PMD
aligned, so you can use a PMD mapping in the guest, regardless of how
it's mapped by userspace.  Maybe this process doesn't even have the page
mapped at all?

