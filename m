Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3CF2867B1
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 20:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgJGSre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 14:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbgJGSre (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 14:47:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D2CC061755;
        Wed,  7 Oct 2020 11:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Fd9c7NnGlZlQsPoX32Y7E0H7T+E2rrcfUhUeaY9NVV4=; b=ZTQCinhxmjer2B4rWKjYH5Zt45
        jkp9CrbpI7giGfDFPrQO8yS1DANnlbqytLhjgJ6zCKxt4PPjzryYAjRdzaIjwIqteaaegdVmBd3rh
        7l2GniIcTZNK7ZOgUdn8kgeSejFLP89v0sDQhBWa0B+LyRp8CYVQzwzreuLIG8oa5X+HzvwVn+qaD
        NwkEw5W7uMFUQTWmuuNHkHtJjIyJWCRIET5Rf5PfhTb4wBbqN/64JntPZtIkBQ7TPsh4vfIUgqVsx
        7qdChRAM994JJ0YjxFO5EKOdi3LaeniRItdUqu9KH5Q0BRuHkEErw5JKLkv9RZ67yFfYET6J96ebw
        oesKFOSQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQETK-0004O9-Q8; Wed, 07 Oct 2020 18:47:30 +0000
Date:   Wed, 7 Oct 2020 19:47:30 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, ericvh@gmail.com, lucho@ionkov.net,
        viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com,
        mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/7] 9P: Cast to loff_t before multiplying
Message-ID: <20201007184730.GW20115@casper.infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
 <20201004180428.14494-2-willy@infradead.org>
 <20201007054849.GA16556@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007054849.GA16556@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 07, 2020 at 06:48:49AM +0100, Christoph Hellwig wrote:
> > -		.range_start = vma->vm_pgoff * PAGE_SIZE,
> > +		.range_start = (loff_t)vma->vm_pgoff * PAGE_SIZE,
> 
> Given the may places where this issue shows up I think we really need
> a vma_offset or similar helper for it.  Much better than chasing missing
> casts everywhere.

Good point.  I think these patches need to go in to fix the bugs in
the various stable releases, but we should definitely have a helper
for the future.  Also, several of these patches are for non-VMA
pgoff_t.

vma_offset() is a bit weird for me -- vmas have all kinds of offsets.
vma_file_offset() would work or vma_fpos().  I tend to prefer the shorter
function name ;-)

A quick grep shows we probably want a vmf_fpos() too:

arch/powerpc/platforms/cell/spufs/file.c:       unsigned long area, offset = vmf->pgoff << PAGE_SHIFT;
arch/x86/entry/vdso/vma.c:      sym_offset = (long)(vmf->pgoff << PAGE_SHIFT) +
drivers/gpu/drm/gma500/framebuffer.c:   address = vmf->address - (vmf->pgoff << PAGE_SHIFT);
drivers/scsi/cxlflash/ocxl_hw.c:        offset = vmf->pgoff << PAGE_SHIFT;

I'm sure a lot of this will never run on a 32-bit kernel or with a 4GB
file, but it's not good to have bad code around for people to copy from.

