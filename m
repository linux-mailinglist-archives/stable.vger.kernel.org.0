Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D14E310548
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 07:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhBEG6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 01:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhBEG6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 01:58:12 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E2DC0613D6
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 22:57:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id l12so7560889edt.3
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 22:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IPIIOrxlUFnyuGn9q7w4ROYFiJXPl+h3A3KkYxKrnx4=;
        b=Uqz363feZGjjPs3GuP633cm1qHWGRVNVYsbPq/tdP+OU+rHdgmou6zXbbcklkGuENQ
         f7guWFjs5GAcd3YTVCPTqtzDTCIhkqvaKvveRyOtrGZxbGDW1hhBNBRX5/5lYIsB9PVp
         3OFq+lxoU3dMGsb21fWyUvswp6jHt8K8W5nClKiKGnx+79ERpdyoeOpsLzxj22BkT95J
         kIuuxVWJbynP4jdLBMTmLjLVQarzjc/3ZqHO8v3+yADtLSMD6AZBCgl9izoUuQOFvPvi
         YrKtd+a5LNi5Qjia753JEUjd8Q2SizZlkOY7Gomsenu/TQZwswCi59h5Uwp+4um6QoWM
         EJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IPIIOrxlUFnyuGn9q7w4ROYFiJXPl+h3A3KkYxKrnx4=;
        b=Rs8ysbW+cQBT+KXGRa9WQRcbvHNYC/49JuUOkxnVltQ7mF3g04QzKDzLR7TltW/HgF
         qy/VeggFcb2w++BkaSUiYweg66O/FOhT0DwvSYACG/Pf921zemRUIV7ZhoMbctr3WDmt
         o9FBoimIDOEH0rNJ3FlWUssysKcq3gpX2T1S0MsWVSCRPwnoTzPz35N1Yvw9rQcIFoxt
         /jV0oUwJ6nX+2qsoqNJeidJdqbf+FV2sOL1fAfmzElvdpQZYz5Mm1M4CpG01HR8I8wr1
         ddtL8XG07cEAPKkjdgiuKet2HCPEjbcPEYze9EWfk3bqa75LmF1Wp+uElO6eSpPfn9Vu
         +Kig==
X-Gm-Message-State: AOAM531t8Hwtzc52JaO6jz/eSSVeHh6tZeTkf1nymWWkSlNLfauZ4lOZ
        MYFa4xI3nWAzCbfGfKLqebBP/kynzZ/MhXP0XmAC9vF9sZ0=
X-Google-Smtp-Source: ABdhPJwB46XyqTBV1WbbCZ0M5wa5D2QQxhD5WYyeo9pCssi9uUGTV1cgQrNbqlOOogz4TEDN6HIpAtDroYD+rzv7+OU=
X-Received: by 2002:a05:6402:3514:: with SMTP id b20mr2160025edd.100.1612508250264;
 Thu, 04 Feb 2021 22:57:30 -0800 (PST)
MIME-Version: 1.0
References: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
 <20210203132022.92406-9-jinpu.wang@cloud.ionos.com> <YBwO7EsBfljWNliY@kroah.com>
In-Reply-To: <YBwO7EsBfljWNliY@kroah.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 5 Feb 2021 07:57:19 +0100
Message-ID: <CAMGffEmTLeOSD+0WZ_Ayg_cqYFO=UswKR_EnxYqLsR5bVBZQew@mail.gmail.com>
Subject: Re: [stable-4.19 8/8] md: Set prev_flush_start and flush_bio in an
 atomic way
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Xiao Ni <xni@redhat.com>, David Jeffery <djeffery@redhat.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 4, 2021 at 4:12 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Feb 03, 2021 at 02:20:22PM +0100, Jack Wang wrote:
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
>
> I can not take patches backported to older kernels that "skip" kernel
> releases.
>
> For example, if I take this into 4.19.y, and then someone moves to 5.4
> or 5.10, they will hit the same issue.
>
> So please provide a backported series for all affected releases, back as
> far as you want, but never skip releases.
>
> I can't take this series, I'll drop it for now and wait for an updated
> set of patches.
>
> thanks,
>
> greg k-h
Hi Greg,

Thanks for reply, only this patch should be backported also to
5.4/5.10, this backport can be applied cleanly to stable/linux-5.4.y
and stable/linux-5.10.y,

I will send the backport for them later today!

Thanks!

J
