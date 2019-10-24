Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8D0E34D2
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 15:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389590AbfJXNz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 09:55:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46838 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727811AbfJXNz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 09:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kg4p9QmhdYnEgh5fEIpCK0L9e+qEFrZicmEw63GMdL4=; b=N6vNRt713Eoqm74U78+NNGSdn
        Ca5QDmEc0clEfBPYdPqUqLA/TFXSOfH0EUVQQMLN9RE6Cda7w+xR5hOmrB8BQ1xpsys6G6mydq2RY
        SBIRFhAWG1MmBtv8JPiuxCVKNWEWL3IC77HhcOnD/reExSF7qr3aOw5P7I2OHGfUALECXl0+c9K4K
        aA6+Z1QFehO7Ng/YR55OIHKDvPsXeGQ1QbcDZXqc//4SWbkjFslRgbpkX5NFAFS95UsSfxPhKoroe
        O13CVMb0FKJ5EK1CcwogvlT/ZwY+SRXoBEPHIkbzvxdnU4EDnhvBUN73MN/OXoVYnJeMdNEF2DAiO
        6n3r8rgdw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNdad-0005C2-Dp; Thu, 24 Oct 2019 13:55:47 +0000
Date:   Thu, 24 Oct 2019 06:55:47 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     hughd@google.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, gavin.dg@linux.alibaba.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v4 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
Message-ID: <20191024135547.GH2963@bombadil.infradead.org>
References: <1571865575-42913-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571865575-42913-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 05:19:35AM +0800, Yang Shi wrote:
> We have usecase to use tmpfs as QEMU memory backend and we would like to
> take the advantage of THP as well.  But, our test shows the EPT is not
> PMD mapped even though the underlying THP are PMD mapped on host.
> The number showed by /sys/kernel/debug/kvm/largepage is much less than
> the number of PMD mapped shmem pages as the below:
> 
> 7f2778200000-7f2878200000 rw-s 00000000 00:14 262232 /dev/shm/qemu_back_mem.mem.Hz2hSf (deleted)
> Size:            4194304 kB
> [snip]
> AnonHugePages:         0 kB
> ShmemPmdMapped:   579584 kB
> [snip]
> Locked:                0 kB
> 
> cat /sys/kernel/debug/kvm/largepages
> 12
> 
> And some benchmarks do worse than with anonymous THPs.
> 
> By digging into the code we figured out that commit 127393fbe597 ("mm:
> thp: kvm: fix memory corruption in KVM with THP enabled") checks if
> there is a single PTE mapping on the page for anonymous THP when
> setting up EPT map.  But, the _mapcount < 0 check doesn't fit to page
> cache THP since every subpage of page cache THP would get _mapcount
> inc'ed once it is PMD mapped, so PageTransCompoundMap() always returns
> false for page cache THP.  This would prevent KVM from setting up PMD
> mapped EPT entry.
> 
> So we need handle page cache THP correctly.  However, when page cache
> THP's PMD gets split, kernel just remove the map instead of setting up
> PTE map like what anonymous THP does.  Before KVM calls get_user_pages()
> the subpages may get PTE mapped even though it is still a THP since the
> page cache THP may be mapped by other processes at the mean time.
> 
> Checking its _mapcount and whether the THP has PTE mapped or not.
> Although this may report some false negative cases (PTE mapped by other
> processes), it looks not trivial to make this accurate.

I don't understand why you care how it's mapped into userspace.  If there
is a PMD-sized page in the page cache, then you can use a PMD mapping
in the EPT tables to map it.  Why would another process having a PTE
mapping on the page cause you to not use a PMD mapping?
