Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BD131359A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 15:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhBHOuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 09:50:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232929AbhBHOtt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 09:49:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E4B364DD5;
        Mon,  8 Feb 2021 14:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612795746;
        bh=Y6fziRpW9V/TdLpks4xbZW/OLBoVJsPuYzoRRPrtiD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uZTmzx/bCNB/tlwETj5IOMa18yKjIIQRTh/sbyF9ccYh9ATk8H1bhNZ7dXHtU6r8D
         ERotQXmyI7PbczpWoL1O/Q8/Dh+68LKgzPV+y2rA8hmReqqdln8V5YGgIysQy42Sct
         UXRZa9YC3+nJs/j5kwVqd/2HLHgsB3K0AlXPFyFQ=
Date:   Mon, 8 Feb 2021 15:49:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Xiao Ni <xni@redhat.com>, David Jeffery <djeffery@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [stable-5.10] md: Set prev_flush_start and flush_bio in an
 atomic way
Message-ID: <YCFPX8/SyQB6R4LO@kroah.com>
References: <20210205141301.71682-1-jinpu.wang@cloud.ionos.com>
 <YCEyWvFdF6PYkKD/@kroah.com>
 <CAMGffE=QKjFxH2Frn5oeOz_PR0-3gx-jsWBPyDN-R2OWRz3DbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGffE=QKjFxH2Frn5oeOz_PR0-3gx-jsWBPyDN-R2OWRz3DbA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 03:38:48PM +0100, Jinpu Wang wrote:
> On Mon, Feb 8, 2021 at 1:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Feb 05, 2021 at 03:13:01PM +0100, Jack Wang wrote:
> > > From: Xiao Ni <xni@redhat.com>
> > >
> > > One customer reports a crash problem which causes by flush request. It
> > > triggers a warning before crash.
> > >
> > >         /* new request after previous flush is completed */
> > >         if (ktime_after(req_start, mddev->prev_flush_start)) {
> > >                 WARN_ON(mddev->flush_bio);
> > >                 mddev->flush_bio = bio;
> > >                 bio = NULL;
> > >         }
> > >
> > > The WARN_ON is triggered. We use spin lock to protect prev_flush_start and
> > > flush_bio in md_flush_request. But there is no lock protection in
> > > md_submit_flush_data. It can set flush_bio to NULL first because of
> > > compiler reordering write instructions.
> > >
> > > For example, flush bio1 sets flush bio to NULL first in
> > > md_submit_flush_data. An interrupt or vmware causing an extended stall
> > > happen between updating flush_bio and prev_flush_start. Because flush_bio
> > > is NULL, flush bio2 can get the lock and submit to underlayer disks. Then
> > > flush bio1 updates prev_flush_start after the interrupt or extended stall.
> > >
> > > Then flush bio3 enters in md_flush_request. The start time req_start is
> > > behind prev_flush_start. The flush_bio is not NULL(flush bio2 hasn't
> > > finished). So it can trigger the WARN_ON now. Then it calls INIT_WORK
> > > again. INIT_WORK() will re-initialize the list pointers in the
> > > work_struct, which then can result in a corrupted work list and the
> > > work_struct queued a second time. With the work list corrupted, it can
> > > lead in invalid work items being used and cause a crash in
> > > process_one_work.
> > >
> > > We need to make sure only one flush bio can be handled at one same time.
> > > So add spin lock in md_submit_flush_data to protect prev_flush_start and
> > > flush_bio in an atomic way.
> > >
> > > Reviewed-by: David Jeffery <djeffery@redhat.com>
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > Signed-off-by: Song Liu <songliubraving@fb.com>
> > > [jwang: backport dc5d17a3c39b06aef866afca19245a9cfb533a79 to 4.19]
> > > Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > > ---
> > >  drivers/md/md.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index ea139d0c0bc3..2bd60bd9e2ca 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -639,8 +639,10 @@ static void md_submit_flush_data(struct work_struct *ws)
> > >        * could wait for this and below md_handle_request could wait for those
> > >        * bios because of suspend check
> > >        */
> > > +     spin_lock_irq(&mddev->lock);
> > >       mddev->last_flush = mddev->start_flush;
> > >       mddev->flush_bio = NULL;
> > > +     spin_unlock_irq(&mddev->lock);
> > >       wake_up(&mddev->sb_wait);
> > >
> > >       if (bio->bi_iter.bi_size == 0) {
> > > --
> > > 2.25.1
> >
> > Now queued up, thanks.
> >
> > greg k-h
> Thanks, I see only this patch got applied. Do you have concern
> regarding first 7 patches?

I only see this one patch.  Please resend anything else you wish to have
applied as I think I said that I dropped everything you submitted
before, right?

thanks,

greg k-h
