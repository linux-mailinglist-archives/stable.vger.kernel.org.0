Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11DA44E1A4
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 06:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhKLFq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 00:46:57 -0500
Received: from verein.lst.de ([213.95.11.211]:60108 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhKLFq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 00:46:57 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1C2FC68AA6; Fri, 12 Nov 2021 06:44:05 +0100 (CET)
Date:   Fri, 12 Nov 2021 06:44:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [5.15 REGRESSION v2] iomap: Fix inline extent handling in
 iomap_readpage
Message-ID: <20211112054404.GB27605@lst.de>
References: <20211111161714.584718-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111161714.584718-1-agruenba@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 05:17:14PM +0100, Andreas Gruenbacher wrote:
> Before commit 740499c78408 ("iomap: fix the iomap_readpage_actor return
> value for inline data"), when hitting an IOMAP_INLINE extent,
> iomap_readpage_actor would report having read the entire page.  Since
> then, it only reports having read the inline data (iomap->length).
> 
> This will force iomap_readpage into another iteration, and the
> filesystem will report an unaligned hole after the IOMAP_INLINE extent.
> But iomap_readpage_actor (now iomap_readpage_iter) isn't prepared to
> deal with unaligned extents, it will get things wrong on filesystems
> with a block size smaller than the page size, and we'll eventually run
> into the following warning in iomap_iter_advance:
> 
>   WARN_ON_ONCE(iter->processed > iomap_length(iter));
> 
> Fix that by changing iomap_readpage_iter to return 0 when hitting an
> inline extent; this will cause iomap_iter to stop immediately.
> 
> To fix readahead as well, change iomap_readahead_iter to pass on
> iomap_readpage_iter return values less than or equal to zero.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
