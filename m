Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40943D7570
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 14:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbhG0M6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 08:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236320AbhG0M6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 08:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5C54610D0;
        Tue, 27 Jul 2021 12:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627390681;
        bh=upwwg6+mtRT400miON1xGrEGEisD4k2v28v1j+AGpgk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rw/J9LN5ZJi6FHPU0vYJRZoIqMhSvG1QeCOj60BHUE7+SJtZye8gyJEYrRz5EtlNC
         tNWc1WCz//hQlth7tKzJHPdH/1GTYUjV5Hy1EwYpE3ptni29hD3gYAmgmXwnsS/wGk
         cuFdxRNV/LuSNGQbJQMHybqlrl4e37lEUMg7dOfw3Z42qaU+AgqSzKIgcNqeroEKHe
         8I8GXS0LxK+uzm70wggraYVKBq9FwLrh16CDsIaWb5u6jzcMkjv4bed25MeufxnXjD
         5rsLHSY3ZH4c3GBzvnqGLWMHFR6qS7H3hSLV9EVmz+VbpjNOZ3bVlEjBjJO1xaqU3T
         DVtgQq1zSL2Bg==
Date:   Tue, 27 Jul 2021 13:57:55 +0100
From:   Will Deacon <will@kernel.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Heiko Carstens <hca@linux.ibm.com>, stable@vger.kernel.org,
        Claire Chang <tientzu@chromium.org>,
        Christoph Hellwig <hch@lst.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/1] s390/pv: fix the forcing of the swiotlb
Message-ID: <20210727125755.GA18586@willie-the-truck>
References: <20210723231746.3964989-1-pasic@linux.ibm.com>
 <YPtejB62iu+iNrM+@fedora>
 <a89f1add-b0fb-1069-cb30-78864e399b19@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a89f1add-b0fb-1069-cb30-78864e399b19@de.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 02:54:14PM +0200, Christian Borntraeger wrote:
> 
> On 24.07.21 02:27, Konrad Rzeszutek Wilk wrote:
> > On Sat, Jul 24, 2021 at 01:17:46AM +0200, Halil Pasic wrote:
> > > Since commit 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for
> > > swiotlb data bouncing") if code sets swiotlb_force it needs to do so
> > > before the swiotlb is initialised. Otherwise
> > > io_tlb_default_mem->force_bounce will not get set to true, and devices
> > > that use (the default) swiotlb will not bounce despite switolb_force
> > > having the value of SWIOTLB_FORCE.
> > > 
> > > Let us restore swiotlb functionality for PV by fulfilling this new
> > > requirement.
> > > 
> > > This change addresses what turned out to be a fragility in
> > > commit 64e1f0c531d1 ("s390/mm: force swiotlb for protected
> > > virtualization"), which ain't exactly broken in its original context,
> > > but could give us some more headache if people backport the broken
> > > change and forget this fix.
> > > 
> > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > > Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > > Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > > Fixes: 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for swiotlb data bouncing")
> > > Fixes: 64e1f0c531d1 ("s390/mm: force swiotlb for protected virtualization")
> > > Cc: stable@vger.kernel.org #5.3+
> > > 
> > > ---
> > 
> > Picked it up and stuck it in linux-next with the other set of patches (Will's fixes).
> 
> Can you push out to kernel.org?

It's pushed to the swiotlb tree:

https://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git/log/?h=devel/for-linus-5.15

Since none of the restricted DMA series is in mainline yet, I don't think
it's needed anywhere else.

Will
