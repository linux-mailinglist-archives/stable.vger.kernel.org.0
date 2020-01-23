Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30224146B33
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 15:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgAWOYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 09:24:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbgAWOYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 09:24:47 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66C9D20663;
        Thu, 23 Jan 2020 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579789486;
        bh=FXMHCzfblQSaazF04KLGVQsmdscRSSrLM040Oxupdy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VA5SuN0jD3VO5BGR4RXK/DpcCaImVp5KSUT7SAcT2hl/0RbAXWrUZnCgJL3wpRuF0
         56vtK+xBXXQA68N24ekUvq0ZzufFyCgiT/2db7Iqrna3XJ+b9UdxNDOAeRL50gx8hN
         zAqzfGlXHrA7Y+giVk3b3PvEXGT0z8htDLNJO07w=
Date:   Thu, 23 Jan 2020 16:24:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Alexander Matushevsky <matua@amazon.com>,
        stable@vger.kernel.org, "Leybovich, Yossi" <sleybo@amazon.com>
Subject: Re: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous
 memory blocks aligned to device supported page size"
Message-ID: <20200123142443.GN7018@unreal>
References: <20200120141001.63544-1-galpress@amazon.com>
 <0557a917-b6ad-1be7-e46b-cbe08f2ee4d3@amazon.com>
 <20200121162436.GL51881@unreal>
 <47c20471-2251-b93b-053d-87880fa0edf5@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47c20471-2251-b93b-053d-87880fa0edf5@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 09:57:07AM +0200, Gal Pressman wrote:
> On 21/01/2020 18:24, Leon Romanovsky wrote:
> > On Tue, Jan 21, 2020 at 11:07:21AM +0200, Gal Pressman wrote:
> >> On 20/01/2020 16:10, Gal Pressman wrote:
> >>> The cited commit leads to register MR failures and random hangs when
> >>> running different MPI applications. The exact root cause for the issue
> >>> is still not clear, this revert brings us back to a stable state.
> >>>
> >>> This reverts commit 40ddb3f020834f9afb7aab31385994811f4db259.
> >>>
> >>> Fixes: 40ddb3f02083 ("RDMA/efa: Use API to get contiguous memory blocks aligned to device supported page size")
> >>> Cc: Shiraz Saleem <shiraz.saleem@intel.com>
> >>> Cc: stable@vger.kernel.org # 5.3
> >>> Signed-off-by: Gal Pressman <galpress@amazon.com>
> >>
> >> Shiraz, I think I found the root cause here.
> >> I'm noticing a register MR of size 32k, which is constructed from two sges, the
> >> first sge of size 12k and the second of 20k.
> >>
> >> ib_umem_find_best_pgsz returns page shift 13 in the following way:
> >>
> >> 0x103dcb2000      0x103dcb5000       0x103dd5d000           0x103dd62000
> >>           +----------+                      +------------------+
> >>           |          |                      |                  |
> >>           |  12k     |                      |     20k          |
> >>           +----------+                      +------------------+
> >>
> >>           +------+------+                 +------+------+------+
> >>           |      |      |                 |      |      |      |
> >>           | 8k   | 8k   |                 | 8k   | 8k   | 8k   |
> >>           +------+------+                 +------+------+------+
> >> 0x103dcb2000       0x103dcb6000   0x103dd5c000              0x103dd62000
> >>
> >>
> >> The top row is the original umem sgl, and the bottom is the sgl constructed by
> >> rdma_for_each_block with page size of 8k.
> >>
> >> Is this the expected output? The 8k pages cover addresses which aren't part of
> >> the MR. This breaks some of the assumptions in the driver (for example, the way
> >> we calculate the number of pages in the MR) and I'm not sure our device can
> >> handle such sgl.
> >
> > Artemy wrote this fix that can help you.
> >
> > commit 60c9fe2d18b657df950a5f4d5a7955694bd08e63
> > Author: Artemy Kovalyov <artemyko@mellanox.com>
> > Date:   Sun Dec 15 12:43:13 2019 +0200
> >
> >     RDMA/umem: Fix ib_umem_find_best_pgsz()
> >
> >     Except for the last entry, the ending iova alignment sets the maximum
> >     possible page size as the low bits of the iova must be zero when
> >     starting the next chunk.
> >
> >     Fixes: 4a35339958f1 ("RDMA/umem: Add API to find best driver supported page size in an MR")
> >     Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
> >     Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >
> > diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> > index c3769a5f096d..06b6125b5ae1 100644
> > --- a/drivers/infiniband/core/umem.c
> > +++ b/drivers/infiniband/core/umem.c
> > @@ -166,10 +166,13 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
> >                  * for any address.
> >                  */
> >                 mask |= (sg_dma_address(sg) + pgoff) ^ va;
> > -               if (i && i != (umem->nmap - 1))
> > -                       /* restrict by length as well for interior SGEs */
> > -                       mask |= sg_dma_len(sg);
> >                 va += sg_dma_len(sg) - pgoff;
> > +               /* Except for the last entry, the ending iova alignment sets
> > +                * the maximum possible page size as the low bits of the iova
> > +                * must be zero when starting the next chunk.
> > +                */
> > +               if (i != (umem->nmap - 1))
> > +                       mask |= va;
> >                 pgoff = 0;
> >         }
> >         best_pg_bit = rdma_find_pg_bit(mask, pgsz_bitmap);
>
> Thanks Leon, I'll test this and let you know if it fixes the issue.
> When are you planning to submit this?

If it fixes your issues, I will be happy to do it.

Thanks
