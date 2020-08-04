Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0804723BAAF
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 14:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgHDMr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 08:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHDMrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 08:47:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60B862067D;
        Tue,  4 Aug 2020 12:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596545275;
        bh=HQdWsBUMcWk0XAvFfhB9slWoCiSqMyM9l3UqhNyhGKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QvgHeKpoKhPkVMhNF+slMOCNRLYusfHQ7oFeHTxJ+KFq8TM4iQrBk2JnTuLCoHJeL
         oga/wcPaJXanVl0kCPlpB0cd/vT0kUzKSLAWsgFdbiSwnpt3BCf4Sj21xbFbr21D9k
         7gJvltixRePRmm67bFUVDR+2rPwv9TupeC7HqH2Q=
Date:   Tue, 4 Aug 2020 14:47:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Donnelly <john.p.donnelly@oracle.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [(resend) PATCH v3: {linux-4.14.y} ] dm cache: submit
 writethrough writes in parallel to origin and cache
Message-ID: <20200804124735.GA219143@kroah.com>
References: <8CFF8DA9-C105-461C-8F5A-DA2BF448A135@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8CFF8DA9-C105-461C-8F5A-DA2BF448A135@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 07:33:05AM -0500, John Donnelly wrote:
> From: Mike Snitzer <snitzer@redhat.com>
> 
> Discontinue issuing writethrough write IO in series to the origin and
> then cache.
> 
> Use bio_clone_fast() to create a new origin clone bio that will be
> mapped to the origin device and then bio_chain() it to the bio that gets
> remapped to the cache device.  The origin clone bio does _not_ have a
> copy of the per_bio_data -- as such check_if_tick_bio_needed() will not
> be called.
> 
> The cache bio (parent bio) will not complete until the origin bio has
> completed -- this fulfills bio_clone_fast()'s requirements as well as
> the requirement to not complete the original IO until the write IO has
> completed to both the origin and cache device.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> (cherry picked from commit 2df3bae9a6543e90042291707b8db0cbfbae9ee9)
> 
> Fixes: 4ec34f2196d125ff781170ddc6c3058c08ec5e73 (dm bio record:
> save/restore bi_end_io and bi_integrity )
> 
> 4ec34f21 introduced a mkfs.ext4 hang on a LVM device that has been
> modified with lvconvert --cachemode=writethrough.
> 
> CC:stable@vger.kernel.org for 4.14.y
> 
> Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> Reviewed-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
> 
> conflicts:
> 	drivers/md/dm-cache-target.c. -  Corrected usage of
> 	writethrough_mode(&cache->feature) that was caught by
> 	compiler, and removed unused static functions : writethrough_endio(),
> 	defer_writethrough_bio(), wake_deferred_writethrough_worker()
> 	that generated warnings.

What is this "conflicts nonsense"?  You don't see that in any other
kernel patch changelog, do you?

> ---
> drivers/md/dm-cache-target.c | 92 ++++++++++++++++++--------------------------
> 1 file changed, 37 insertions(+), 55 deletions(-)

Please fix your email client up, it's totally broken and this does not
work at all and is getting frustrating from my side here.

Try sending emails to yourself and see if you can apply the patches, as
the one you sent here does not work, again:

------------
~/linux/stable/linux-4.14.y $ b4 am https://lore.kernel.org/r/8CFF8DA9-C105-461C-8F5A-DA2BF448A135@oracle.com
Looking up https://lore.kernel.org/r/8CFF8DA9-C105-461C-8F5A-DA2BF448A135%40oracle.com
Grabbing thread from lore.kernel.org/lkml
Analyzing 1 messages in the thread
---
Writing ./20200804_john_p_donnelly_dm_cache_submit_writethrough_writes_in_parallel_to_origin_and_cache.mbx
  [(resend) PATCH v3: {linux-4.14.y} ] dm cache: submit writethrough writes in parallel to origin and cache
---
Total patches: 1
---
 Link: https://lore.kernel.org/r/8CFF8DA9-C105-461C-8F5A-DA2BF448A135@oracle.com
 Base: not found (applies clean to current tree)
       git am ./20200804_john_p_donnelly_dm_cache_submit_writethrough_writes_in_parallel_to_origin_and_cache.mbx
~/linux/stable/linux-4.14.y $ patch -p1 < 20200804_john_p_donnelly_dm_cache_submit_writethrough_writes_in_parallel_to_origin_and_cache.mbx
checking file drivers/md/dm-cache-target.c
patch: **** malformed patch at line 70: }

------------

{sigh}

You can do better.

greg k-h
