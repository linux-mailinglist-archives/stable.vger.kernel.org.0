Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7201A25D81A
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgIDLzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729897AbgIDLzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 07:55:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA13E214F1;
        Fri,  4 Sep 2020 11:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599220538;
        bh=3gjh72ssf9Q4cLyUZJiBs6BnZ4iUD7PvuTcSLsrMwQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X251CJuI/Ywhpc5U5mJzTiW8MI5Lom7mP/1kes/9EHNa5BrvU6C9iZY+0B8WSTJwT
         7wYGHJHR0QJHbjLPsTHnLnhIHZllV1kZ2TrHE2al4VL/7ubptyXuu0hWE+8NhTwaAj
         8Hl9zy/6MzMqjPFzYE7XSQE9H9JEnDauJ1fMK4xw=
Date:   Fri, 4 Sep 2020 13:55:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcmu: fix size in calls to
 tcmu_flush_dcache_range
Message-ID: <20200904115559.GC2964473@kroah.com>
References: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
 <159114947916.26776.943125808891892721.b4-ty@oracle.com>
 <79f7119f-fda7-64cc-b617-d49a23f2e628@ts.fujitsu.com>
 <28862cd1-e7f2-d161-1bab-4d2ff73cf6a1@ts.fujitsu.com>
 <20200901140212.GE397411@kroah.com>
 <8ced4335-dcae-96c8-7c14-3eeb5c97324b@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ced4335-dcae-96c8-7c14-3eeb5c97324b@ts.fujitsu.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 05:58:29PM +0200, Bodo Stroesser wrote:
> On 2020-09-01 16:02, Greg KH wrote:
> > On Fri, Aug 28, 2020 at 12:03:38PM +0200, Bodo Stroesser wrote:
> >> Hi,
> >> I'm adding stable@vger.kernel.org
> >>
> >> Once again, this time really adding stable.
> >>
> >> On 2020-06-03 04:31, Martin K. Petersen wrote:
> >>> On Thu, 28 May 2020 21:31:08 +0200, Bodo Stroesser wrote:
> >>>
> >>>> 1) If remaining ring space before the end of the ring is
> >>>>       smaller then the next cmd to write, tcmu writes a padding
> >>>>       entry which fills the remaining space at the end of the
> >>>>       ring.
> >>>>       Then tcmu calls tcmu_flush_dcache_range() with the size
> >>>>       of struct tcmu_cmd_entry as data length to flush.
> >>>>       If the space filled by the padding was smaller then
> >>>>       tcmu_cmd_entry, tcmu_flush_dcache_range() is called for
> >>>>       an address range reaching behind the end of the vmalloc'ed
> >>>>       ring.
> >>>>       tcmu_flush_dcache_range() in a loop calls
> >>>>          flush_dcache_page(virt_to_page(start));
> >>>>       for every page being part of the range. On x86 the line is
> >>>>       optimized out by the compiler, as flush_dcache_page() is
> >>>>       empty on x86.
> >>>>       But I assume the above can cause trouble on other
> >>>>       architectures that really have a flush_dcache_page().
> >>>>       For paddings only the header part of an entry is relevant
> >>>>       Due to alignment rules the header always fits in the
> >>>>       remaining space, if padding is needed.
> >>>>       So tcmu_flush_dcache_range() can safely be called with
> >>>>       sizeof(entry->hdr) as the length here.
> >>>>
> >>>> [...]
> >>>
> >>> Applied to 5.8/scsi-queue, thanks!
> >>>
> >>> [1/1] scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
> >>>          https://git.kernel.org/mkp/scsi/c/8c4e0f212398
> >>>
> >>
> >> The full commit of this patch is:
> >>       8c4e0f212398cdd1eb4310a5981d06a723cdd24f
> >>
> >> This patch is the first of four patches that are necessary to run tcmu
> >> on ARM without crash. For details please see
> >>       https://bugzilla.kernel.org/show_bug.cgi?id=208045
> >> Upsteam commits of patches 2,3, and 4 are:
> >>     2: 3c58f737231e "scsi: target: tcmu: Optimize use of flush_dcache_page"
> >>     3: 3145550a7f8b "scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range
> >> on ARM"
> >>     4: 5a0c256d96f0 "scsi: target: tcmu: Fix crash on ARM during cmd
> >> completion"
> >>
> >> Since patches 3 and 4 already were accepted for 5.8, 5.4, and 4.19, and
> >> I sent a request to add patch 2 about 1 hour ago, please consider adding
> >> this patch to 5.4 and 4.19, because without it tcmu on ARM will still
> >> crash.
> > 
> > I don't see such a request, and am confused now.
> > 
> > What exact commits do you want backported, and to what trees?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Sorry for the confusion.
> 
> The subject of the request I mentioned is
>     "Re: [PATCH v2 0/2] scsi: target: tcmu: fix crashes on ARM"
> because it is for the first patch of a small series of two.
> 
> Please backport to kernels 4.19 and 5.4 (it is part of 5.8 from beginning):
>   8c4e0f212398 "scsi: target: tcmu: fix size in calls to tcmu_flush_dcache_range"
> 
> Please backport to kernels 4.19, 5.4 and 5.8:
>   3c58f737231e "scsi: target: tcmu: Optimize use of flush_dcache_page"
> 
> Backporting to 4.14 or earlier AFAICS would need more work, especially testing.
> I don't think that its worth it.

Thanks, both now queued up.

greg k-h
