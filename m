Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598EE3135B0
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 15:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhBHOv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 09:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbhBHOvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 09:51:51 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FCCC0617AA
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 06:50:49 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id lg21so25175810ejb.3
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 06:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Rx+X6ej2+JeamSi/P6QvWkmLTv46QEpARWs9xb0g5w=;
        b=czCqI9fXGUkLf7gym4+xF/R9pRR+lM48LiByJ0hRibDDJH+e69VVTM3qcyBDp7tGtF
         xv/KsDGgPoiPjls+CbdrcVkGQDtZQCcdERiivHF+qv4G+kqIRj/1cDyPpEqLjcr8/tmJ
         lE1p9svBa50vacJwl/fNYS5Xln3yESGaJWyHgvhaeWSl13Qyg6MX/nb33MVcUShb5BQ2
         BlMeZ0wuD7ke/RboXiLmIKjjRYT0GJhRqDayBaU4K4TSXO0j0QpWrwoOot9f3Q/plTxR
         QtGbfV6peaOjB1PQPgWACCX8jGCHqRC+vVR1UgalN5bvC18iKuEneo77OUdOzWpXzkzM
         nPTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Rx+X6ej2+JeamSi/P6QvWkmLTv46QEpARWs9xb0g5w=;
        b=AzSwq1eq8HM7oQ/1MIVxCAwOD/VAb9ztOxvlCfDH9kN0gOyNXrdJaXaPio3REDLNlX
         3GpejEWMvOARCoIA4lB8mo172fDUZ4v40SeX5Mx5qqSTQnv57jJGsPAeElzH6+0xwUpS
         dHwbxfhAYLriZsK78gYvUaukWMq5cIdgJwL5qifHxXGg43ZrfTAQhyQOpiWqoJzaX8IM
         eCy9P16dyE7thRq2qozPh7je1JViJLtg09zVQ/gRGh/HCRlAewNTGMjTEngYSi1EEGzQ
         x4IgpmEAzwERKSeiUiZy5BKCQ5jtRgbEiX4oX26+o4M9tPx6RLJ/Bqwwmug7Q+KaIOMY
         x5Sw==
X-Gm-Message-State: AOAM530H9NC2bCxAjzd5jaZ4LUMUdHUSKuEobQ61B+7AtMph/RiX8LM/
        NxsNQe9WHf0Q1rpa9j8Piwz29KwqMCbRbBDpZtX2iQ==
X-Google-Smtp-Source: ABdhPJwqfZNHcpNj5kiXITTwySDQcvTi+RJEn4THMYxhl+FYfrylguIjdwQwGHAQ7rR8mAzfywoAhyyqtNvvFHhpbzk=
X-Received: by 2002:a17:906:3801:: with SMTP id v1mr17535787ejc.353.1612795847880;
 Mon, 08 Feb 2021 06:50:47 -0800 (PST)
MIME-Version: 1.0
References: <20210205141301.71682-1-jinpu.wang@cloud.ionos.com>
 <YCEyWvFdF6PYkKD/@kroah.com> <CAMGffE=QKjFxH2Frn5oeOz_PR0-3gx-jsWBPyDN-R2OWRz3DbA@mail.gmail.com>
 <YCFPX8/SyQB6R4LO@kroah.com>
In-Reply-To: <YCFPX8/SyQB6R4LO@kroah.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 8 Feb 2021 15:50:37 +0100
Message-ID: <CAMGffE=Cuw7__krOj=vnVKF=JkMoKdVcQMLkn13L=99vuaWAkA@mail.gmail.com>
Subject: Re: [stable-5.10] md: Set prev_flush_start and flush_bio in an atomic way
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Xiao Ni <xni@redhat.com>, David Jeffery <djeffery@redhat.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 8, 2021 at 3:49 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Feb 08, 2021 at 03:38:48PM +0100, Jinpu Wang wrote:
> > On Mon, Feb 8, 2021 at 1:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Fri, Feb 05, 2021 at 03:13:01PM +0100, Jack Wang wrote:
> > > > From: Xiao Ni <xni@redhat.com>
> > > >
> > > > One customer reports a crash problem which causes by flush request. It
> > > > triggers a warning before crash.
> > > >
> > > >         /* new request after previous flush is completed */
> > > >         if (ktime_after(req_start, mddev->prev_flush_start)) {
> > > >                 WARN_ON(mddev->flush_bio);
> > > >                 mddev->flush_bio = bio;
> > > >                 bio = NULL;
> > > >         }
> > > >
> > > > The WARN_ON is triggered. We use spin lock to protect prev_flush_start and
> > > > flush_bio in md_flush_request. But there is no lock protection in
> > > > md_submit_flush_data. It can set flush_bio to NULL first because of
> > > > compiler reordering write instructions.
> > > >
> > > > For example, flush bio1 sets flush bio to NULL first in
> > > > md_submit_flush_data. An interrupt or vmware causing an extended stall
> > > > happen between updating flush_bio and prev_flush_start. Because flush_bio
> > > > is NULL, flush bio2 can get the lock and submit to underlayer disks. Then
> > > > flush bio1 updates prev_flush_start after the interrupt or extended stall.
> > > >
> > > > Then flush bio3 enters in md_flush_request. The start time req_start is
> > > > behind prev_flush_start. The flush_bio is not NULL(flush bio2 hasn't
> > > > finished). So it can trigger the WARN_ON now. Then it calls INIT_WORK
> > > > again. INIT_WORK() will re-initialize the list pointers in the
> > > > work_struct, which then can result in a corrupted work list and the
> > > > work_struct queued a second time. With the work list corrupted, it can
> > > > lead in invalid work items being used and cause a crash in
> > > > process_one_work.
> > > >
> > > > We need to make sure only one flush bio can be handled at one same time.
> > > > So add spin lock in md_submit_flush_data to protect prev_flush_start and
> > > > flush_bio in an atomic way.
> > > >
> > > > Reviewed-by: David Jeffery <djeffery@redhat.com>
> > > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > > Signed-off-by: Song Liu <songliubraving@fb.com>
> > > > [jwang: backport dc5d17a3c39b06aef866afca19245a9cfb533a79 to 4.19]
> > > > Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > > > ---
> > > >  drivers/md/md.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > index ea139d0c0bc3..2bd60bd9e2ca 100644
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -639,8 +639,10 @@ static void md_submit_flush_data(struct work_struct *ws)
> > > >        * could wait for this and below md_handle_request could wait for those
> > > >        * bios because of suspend check
> > > >        */
> > > > +     spin_lock_irq(&mddev->lock);
> > > >       mddev->last_flush = mddev->start_flush;
> > > >       mddev->flush_bio = NULL;
> > > > +     spin_unlock_irq(&mddev->lock);
> > > >       wake_up(&mddev->sb_wait);
> > > >
> > > >       if (bio->bi_iter.bi_size == 0) {
> > > > --
> > > > 2.25.1
> > >
> > > Now queued up, thanks.
> > >
> > > greg k-h
> > Thanks, I see only this patch got applied. Do you have concern
> > regarding first 7 patches?
>
> I only see this one patch.  Please resend anything else you wish to have
> applied as I think I said that I dropped everything you submitted
> before, right?
Ah, ok, I misunderstood your comments, I will resend them.

>
> thanks,
>
> greg k-h
Thanks.
