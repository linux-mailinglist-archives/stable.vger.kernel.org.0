Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DD623BF3B
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 20:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHDSUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 14:20:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39193 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDSUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 14:20:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596565242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PzrZsRQ4J1oSBPN640V0xgV/2mOlKDiGJWkKLAGuzzE=;
        b=K8i9KulQkBMR13BUMmXQfyz16z/a9/WSFkgFJAa3mRHkElsKWnhGSc4twSv4izxCEEmy7x
        WfL5lrty33Ispx3Fw7xxAC5abPoDvRJ6xTMXqYh0PhtHgUhvK8Hzvcr9/4NnD9Q60KvHlN
        xJ2aRQutc6syXJ0l0ymR8u7xB2esRak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-0rbPJK2zN_CQYw_9AQMoNA-1; Tue, 04 Aug 2020 14:20:40 -0400
X-MC-Unique: 0rbPJK2zN_CQYw_9AQMoNA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30903100AA21;
        Tue,  4 Aug 2020 18:20:39 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE2A01001B2B;
        Tue,  4 Aug 2020 18:20:38 +0000 (UTC)
Date:   Tue, 4 Aug 2020 14:20:38 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     John Donnelly <john.p.donnelly@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [(resend) PATCH v3: {linux-4.14.y} ] dm cache: submit
 writethrough writes in parallel to origin and cache
Message-ID: <20200804182037.GA15453@redhat.com>
References: <8CFF8DA9-C105-461C-8F5A-DA2BF448A135@oracle.com>
 <20200804124735.GA219143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804124735.GA219143@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04 2020 at  8:47am -0400,
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Aug 04, 2020 at 07:33:05AM -0500, John Donnelly wrote:
> > From: Mike Snitzer <snitzer@redhat.com>
> > 
> > Discontinue issuing writethrough write IO in series to the origin and
> > then cache.
> > 
> > Use bio_clone_fast() to create a new origin clone bio that will be
> > mapped to the origin device and then bio_chain() it to the bio that gets
> > remapped to the cache device.  The origin clone bio does _not_ have a
> > copy of the per_bio_data -- as such check_if_tick_bio_needed() will not
> > be called.
> > 
> > The cache bio (parent bio) will not complete until the origin bio has
> > completed -- this fulfills bio_clone_fast()'s requirements as well as
> > the requirement to not complete the original IO until the write IO has
> > completed to both the origin and cache device.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > (cherry picked from commit 2df3bae9a6543e90042291707b8db0cbfbae9ee9)
> > 
> > Fixes: 4ec34f2196d125ff781170ddc6c3058c08ec5e73 (dm bio record:
> > save/restore bi_end_io and bi_integrity )
> > 
> > 4ec34f21 introduced a mkfs.ext4 hang on a LVM device that has been
> > modified with lvconvert --cachemode=writethrough.
> > 
> > CC:stable@vger.kernel.org for 4.14.y
> > 
> > Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> > Reviewed-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
> > 
> > conflicts:
> > 	drivers/md/dm-cache-target.c. -  Corrected usage of
> > 	writethrough_mode(&cache->feature) that was caught by
> > 	compiler, and removed unused static functions : writethrough_endio(),
> > 	defer_writethrough_bio(), wake_deferred_writethrough_worker()
> > 	that generated warnings.
> 
> What is this "conflicts nonsense"?  You don't see that in any other
> kernel patch changelog, do you?
> 
> > ---
> > drivers/md/dm-cache-target.c | 92 ++++++++++++++++++--------------------------
> > 1 file changed, 37 insertions(+), 55 deletions(-)
> 
> Please fix your email client up, it's totally broken and this does not
> work at all and is getting frustrating from my side here.
> 
> Try sending emails to yourself and see if you can apply the patches, as
> the one you sent here does not work, again:

John's inability to submit a patch that can apply aside: I do not like
how this patch header is constructed (yet attributed "From" me).  It is
devoid of detail as it relates to stable@.

Greg, please don't apply the v4 of this patch either.  I'll craft a
proper stable@ patch that explains the reason for change and why we're
left having to resolve conflicts in stable@.

But first I need to focus on sending DM changes to Linus for v5.9 merge.

Thanks,
Mike

