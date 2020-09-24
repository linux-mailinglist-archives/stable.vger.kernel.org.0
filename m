Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413F8276779
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 06:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIXEDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 00:03:30 -0400
Received: from verein.lst.de ([213.95.11.211]:50684 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgIXEDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 00:03:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B9BFD68AFE; Thu, 24 Sep 2020 06:03:27 +0200 (CEST)
Date:   Thu, 24 Sep 2020 06:03:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH STABLE] xfs: trim IO to found COW exent limit
Message-ID: <20200924040327.GA8078@lst.de>
References: <e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 05:35:44PM -0500, Eric Sandeen wrote:
> A bug existed in the XFS reflink code between v5.1 and v5.5 in which
> the mapping for a COW IO was not trimmed to the mapping of the COW
> extent that was found.  This resulted in a too-short copy, and
> corruption of other files which shared the original extent.
> 
> (This happened only when extent size hints were set, which bypasses
> delalloc and led to this code path.)
> 
> This was (inadvertently) fixed upstream with
> 
> 36adcbace24e "xfs: fill out the srcmap in iomap_begin"
> 
> and related patches which moved lots of this functionality to
> the iomap subsystem.
> 
> Hence, this is a -stable only patch, targeted to fix this
> corruption vector without other major code changes.
> 
> Fixes: 78f0cc9d55cb ("xfs: don't use delalloc extents for COW on files with extsize hints")
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

and as Darrick said we'll want to wire up the reproducer for xfstests.
