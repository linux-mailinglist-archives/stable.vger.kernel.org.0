Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C636A462D1C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 07:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbhK3GzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 01:55:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50464 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbhK3GzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 01:55:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4B67CE16B4;
        Tue, 30 Nov 2021 06:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50335C53FCD;
        Tue, 30 Nov 2021 06:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638255100;
        bh=OthBuHhfpZ4/HumyxwCHFcZfepI57tWKm7cCN1XPAcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CFnEY0cPq0R4fUZR6llZkhp1qmSxqaz8Sxu2VW3Brvryg2l+UT6W5S8Nh57QovOet
         KdFc1wKs/HNeUwcWWjzsHXs7jzzkZMUOvcAissyPMI2bB7U5e3LEQBPwu2OCvaKZP8
         rtb37/hENcTMR0aDB5njxbnRpwz2CiMm3aMDC3Q8=
Date:   Tue, 30 Nov 2021 07:51:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Evan Green <evgreen@chromium.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] PM / hibernate: Fix snapshot partial write lengths
Message-ID: <YaXJ+LqbmlKJ21Ja@kroah.com>
References: <20211029122359.1.I1e23f382fbd8beb19fe1c06d70798b292012c57a@changeid>
 <CAE=gft4MRvq-VCBW4EX4dGfPi4s7Lco8h6Z_ejRH5A1e-K2-yA@mail.gmail.com>
 <CAJZ5v0hsGFHxcTb8PUkGSm9oas1wdquB=euofS19zriRc1CXYw@mail.gmail.com>
 <CAE=gft6CjUhkcrmcjVEOp5S+rgqN1_ZGTKbK0DierTanu0d16A@mail.gmail.com>
 <CAJZ5v0gamixc4dkBEXJjjw5zQynuz8BkQ9xv8YpbjkTkdMb2TQ@mail.gmail.com>
 <CAE=gft6o0JxhDgazPA5DVbL6hQ+36D_GkzgN-AuR3YA43NSqaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE=gft6o0JxhDgazPA5DVbL6hQ+36D_GkzgN-AuR3YA43NSqaw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 08:50:06AM -0800, Evan Green wrote:
> On Wed, Nov 24, 2021 at 4:54 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Tue, Nov 16, 2021 at 9:22 PM Evan Green <evgreen@chromium.org> wrote:
> > >
> > > On Tue, Nov 16, 2021 at 9:54 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > >
> > > > On Mon, Nov 15, 2021 at 6:13 PM Evan Green <evgreen@chromium.org> wrote:
> > > > >
> > > > > Gentle bump.
> > > > >
> > > > >
> > > > > On Fri, Oct 29, 2021 at 12:24 PM Evan Green <evgreen@chromium.org> wrote:
> > > > > >
> > > > > > snapshot_write() is inappropriately limiting the amount of data that can
> > > > > > be written in cases where a partial page has already been written. For
> > > > > > example, one would expect to be able to write 1 byte, then 4095 bytes to
> > > > > > the snapshot device, and have both of those complete fully (since now
> > > > > > we're aligned to a page again). But what ends up happening is we write 1
> > > > > > byte, then 4094/4095 bytes complete successfully.
> > > > > >
> > > > > > The reason is that simple_write_to_buffer()'s second argument is the
> > > > > > total size of the buffer, not the size of the buffer minus the offset.
> > > > > > Since simple_write_to_buffer() accounts for the offset in its
> > > > > > implementation, snapshot_write() can just pass the full page size
> > > > > > directly down.
> > > > > >
> > > > > > Signed-off-by: Evan Green <evgreen@chromium.org>
> > > > > > ---
> > > > > >
> > > > > >  kernel/power/user.c | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/kernel/power/user.c b/kernel/power/user.c
> > > > > > index 740723bb388524..ad241b4ff64c58 100644
> > > > > > --- a/kernel/power/user.c
> > > > > > +++ b/kernel/power/user.c
> > > > > > @@ -177,7 +177,7 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
> > > > > >                 if (res <= 0)
> > > > > >                         goto unlock;
> > > > > >         } else {
> > > > > > -               res = PAGE_SIZE - pg_offp;
> > > > > > +               res = PAGE_SIZE;
> > > > > >         }
> > > > > >
> > > > > >         if (!data_of(data->handle)) {
> > > > > > --
> > > >
> > > > Do you actually see this problem in practice?
> > >
> > > Yes. I may fire up another thread to explain why I'm stuck doing a
> > > partial page write, and how I might be able to stop doing that in the
> > > future with some kernel help. But either way, this is a bug.
> >
> > OK, patch applied as 5.16-rc material.
> >
> > I guess it should go into -stable kernels too?
> 
> Yes, putting it into -stable would make sense also. I should have CCed
> them originally, doing that now.


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
