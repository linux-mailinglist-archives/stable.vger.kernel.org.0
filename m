Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D2C258FBB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 16:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgIAOCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 10:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728228AbgIAOBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 10:01:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6242E20684;
        Tue,  1 Sep 2020 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598968905;
        bh=/N8nHavQMwb1Q9MG1292ynTkA5Sd/Itzgyiq3Mb3uxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQPmSxPgimwG78UEqzuF6YeEg0SeElwP+0SU6ICChsYBc8UVWfFfu/+c2MhUY42uh
         rVkEdBLw/M9ptU+qu+/wW1bKif4cCV3MSm5y246UkpP4HOne9NIlZJMpOxkHSBUNyE
         2iDgfU+3+oVNKMhUqzavSuZQSmt66+qoEvSBxHIo=
Date:   Tue, 1 Sep 2020 16:02:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcmu: fix size in calls to
 tcmu_flush_dcache_range
Message-ID: <20200901140212.GE397411@kroah.com>
References: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
 <159114947916.26776.943125808891892721.b4-ty@oracle.com>
 <79f7119f-fda7-64cc-b617-d49a23f2e628@ts.fujitsu.com>
 <28862cd1-e7f2-d161-1bab-4d2ff73cf6a1@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28862cd1-e7f2-d161-1bab-4d2ff73cf6a1@ts.fujitsu.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 28, 2020 at 12:03:38PM +0200, Bodo Stroesser wrote:
> Hi,
> I'm adding stable@vger.kernel.org
> 
> Once again, this time really adding stable.
> 
> On 2020-06-03 04:31, Martin K. Petersen wrote:
> > On Thu, 28 May 2020 21:31:08 +0200, Bodo Stroesser wrote:
> > 
> > > 1) If remaining ring space before the end of the ring is
> > >      smaller then the next cmd to write, tcmu writes a padding
> > >      entry which fills the remaining space at the end of the
> > >      ring.
> > >      Then tcmu calls tcmu_flush_dcache_range() with the size
> > >      of struct tcmu_cmd_entry as data length to flush.
> > >      If the space filled by the padding was smaller then
> > >      tcmu_cmd_entry, tcmu_flush_dcache_range() is called for
> > >      an address range reaching behind the end of the vmalloc'ed
> > >      ring.
> > >      tcmu_flush_dcache_range() in a loop calls
> > >         flush_dcache_page(virt_to_page(start));
> > >      for every page being part of the range. On x86 the line is
> > >      optimized out by the compiler, as flush_dcache_page() is
> > >      empty on x86.
> > >      But I assume the above can cause trouble on other
> > >      architectures that really have a flush_dcache_page().
> > >      For paddings only the header part of an entry is relevant
> > >      Due to alignment rules the header always fits in the
> > >      remaining space, if padding is needed.
> > >      So tcmu_flush_dcache_range() can safely be called with
> > >      sizeof(entry->hdr) as the length here.
> > > 
> > > [...]
> > 
> > Applied to 5.8/scsi-queue, thanks!
> > 
> > [1/1] scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
> >         https://git.kernel.org/mkp/scsi/c/8c4e0f212398
> > 
> 
> The full commit of this patch is:
>      8c4e0f212398cdd1eb4310a5981d06a723cdd24f
> 
> This patch is the first of four patches that are necessary to run tcmu
> on ARM without crash. For details please see
>      https://bugzilla.kernel.org/show_bug.cgi?id=208045
> Upsteam commits of patches 2,3, and 4 are:
>    2: 3c58f737231e "scsi: target: tcmu: Optimize use of flush_dcache_page"
>    3: 3145550a7f8b "scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range
> on ARM"
>    4: 5a0c256d96f0 "scsi: target: tcmu: Fix crash on ARM during cmd
> completion"
> 
> Since patches 3 and 4 already were accepted for 5.8, 5.4, and 4.19, and
> I sent a request to add patch 2 about 1 hour ago, please consider adding
> this patch to 5.4 and 4.19, because without it tcmu on ARM will still
> crash.

I don't see such a request, and am confused now.

What exact commits do you want backported, and to what trees?

thanks,

greg k-h
