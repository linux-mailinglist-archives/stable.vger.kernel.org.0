Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FED313568
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 15:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhBHOl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 09:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbhBHOkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 09:40:14 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3724C061794
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 06:39:00 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id f14so25059743ejc.8
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 06:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ps/JHrdtshpg0Cp0O0Y5BO+10ok1H2TlvgL82u0mdKQ=;
        b=hM4+IN1OFCfu3/TtG+FR7z5L0Rmi40nQxtMiG3jxvEEJu/h+xl/sxbotvKnXoaWuXM
         v0kZ1P/ee2A80LBcJKh/FgXQT9P760pzhQvH/8CN1gDA7kdGndnVBKe7E8xViDyu66Zr
         /kFwkJfnX53a0/e/dMLl80zQrjxCRHtDuUO/M8QLxaQWDS04CbNCQQKPQ7UKcQQFwZAD
         q3QJ8iUJVonxNmMvbTSqVCkXV7lLqTRwfAlxdhS4tX+S0gZTAvu63h9zuW7sRili0y4h
         qIfC/KPNwMyPGk9OTF44PpGZcpnrsauBBirN69lr7Qu7FhyQ2Rnup/Vh76bdWWjlAEj9
         qETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ps/JHrdtshpg0Cp0O0Y5BO+10ok1H2TlvgL82u0mdKQ=;
        b=MLBEIyMKJlNvw0S+ADd7yOzCbLu0eeFEPDfS8tuUkOzYIbqrYD2btxrL6c4AuFg7mW
         mLl3qs4H+DhlkMAufIuu96uA8FzBJbkST4YmyEHCW/2dVrquEqPTlvPy4vH+cQZJwOvO
         Cq/33TbQKwnn1Isru/9nKsczFoZMIlPEWrbp3Lqm0MVrHFR2THP3nbdZp3Wf/YYIOhlj
         lJwN3UyDt+P0H/yMde7DTkWtZ3V/HCRwegbRgqFam7LepbX9YkRGZKpjYtBDn90iu+Rc
         Ca7ae5TQND6W/nw50Tk/prgwIY069SCTEbHDUln9kEi5E8VLIJub1DJowP5e2PQ5v/bA
         IJIQ==
X-Gm-Message-State: AOAM530FHoK2jWx1TlMv4goeicxOSjIGwSrXpsqFpXbjmQRWM4je3n6R
        q7+vjtdJ1l1l0vP2+TyllJSQeMTSOezz/de9T/HWoQ==
X-Google-Smtp-Source: ABdhPJzZPYE7yhYdIkfAQ1xDY1pIX26v1JlvHIH0Fa/jq2VNglnkxEh4U7CMyqyqMA9+SFnEG7BoKZwYtxBgzGa9U4Q=
X-Received: by 2002:a17:906:3f96:: with SMTP id b22mr4871896ejj.478.1612795139538;
 Mon, 08 Feb 2021 06:38:59 -0800 (PST)
MIME-Version: 1.0
References: <20210205141301.71682-1-jinpu.wang@cloud.ionos.com> <YCEyWvFdF6PYkKD/@kroah.com>
In-Reply-To: <YCEyWvFdF6PYkKD/@kroah.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 8 Feb 2021 15:38:48 +0100
Message-ID: <CAMGffE=QKjFxH2Frn5oeOz_PR0-3gx-jsWBPyDN-R2OWRz3DbA@mail.gmail.com>
Subject: Re: [stable-5.10] md: Set prev_flush_start and flush_bio in an atomic way
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Xiao Ni <xni@redhat.com>, David Jeffery <djeffery@redhat.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 8, 2021 at 1:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 05, 2021 at 03:13:01PM +0100, Jack Wang wrote:
> > From: Xiao Ni <xni@redhat.com>
> >
> > One customer reports a crash problem which causes by flush request. It
> > triggers a warning before crash.
> >
> >         /* new request after previous flush is completed */
> >         if (ktime_after(req_start, mddev->prev_flush_start)) {
> >                 WARN_ON(mddev->flush_bio);
> >                 mddev->flush_bio = bio;
> >                 bio = NULL;
> >         }
> >
> > The WARN_ON is triggered. We use spin lock to protect prev_flush_start and
> > flush_bio in md_flush_request. But there is no lock protection in
> > md_submit_flush_data. It can set flush_bio to NULL first because of
> > compiler reordering write instructions.
> >
> > For example, flush bio1 sets flush bio to NULL first in
> > md_submit_flush_data. An interrupt or vmware causing an extended stall
> > happen between updating flush_bio and prev_flush_start. Because flush_bio
> > is NULL, flush bio2 can get the lock and submit to underlayer disks. Then
> > flush bio1 updates prev_flush_start after the interrupt or extended stall.
> >
> > Then flush bio3 enters in md_flush_request. The start time req_start is
> > behind prev_flush_start. The flush_bio is not NULL(flush bio2 hasn't
> > finished). So it can trigger the WARN_ON now. Then it calls INIT_WORK
> > again. INIT_WORK() will re-initialize the list pointers in the
> > work_struct, which then can result in a corrupted work list and the
> > work_struct queued a second time. With the work list corrupted, it can
> > lead in invalid work items being used and cause a crash in
> > process_one_work.
> >
> > We need to make sure only one flush bio can be handled at one same time.
> > So add spin lock in md_submit_flush_data to protect prev_flush_start and
> > flush_bio in an atomic way.
> >
> > Reviewed-by: David Jeffery <djeffery@redhat.com>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > [jwang: backport dc5d17a3c39b06aef866afca19245a9cfb533a79 to 4.19]
> > Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > ---
> >  drivers/md/md.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index ea139d0c0bc3..2bd60bd9e2ca 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -639,8 +639,10 @@ static void md_submit_flush_data(struct work_struct *ws)
> >        * could wait for this and below md_handle_request could wait for those
> >        * bios because of suspend check
> >        */
> > +     spin_lock_irq(&mddev->lock);
> >       mddev->last_flush = mddev->start_flush;
> >       mddev->flush_bio = NULL;
> > +     spin_unlock_irq(&mddev->lock);
> >       wake_up(&mddev->sb_wait);
> >
> >       if (bio->bi_iter.bi_size == 0) {
> > --
> > 2.25.1
>
> Now queued up, thanks.
>
> greg k-h
Thanks, I see only this patch got applied. Do you have concern
regarding first 7 patches?

Regards!
