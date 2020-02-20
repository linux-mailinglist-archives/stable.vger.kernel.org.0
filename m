Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F44D1667E1
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 21:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgBTUBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 15:01:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728556AbgBTUBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 15:01:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 036E124650;
        Thu, 20 Feb 2020 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582228907;
        bh=HmI/fQ1CTkYnKRxG/BHRZ/wExiUnQ0GpijZHX7xjyg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qen3W6NIEaj1Ry3wbDGSZ6H/aI4eYf++1PWgQuAy7o09fLYsSKVHexbiti+if/ZaM
         Fkc9kbXAA3piTj+poXgVSAwyxkgWwlmvSKhAfVa61MNDVVR1NbOyXAF8qn1fACe//j
         OmaXSFak9N7hWLoBDgpOnnBuZcsLl8M4FyuGcqMs=
Date:   Thu, 20 Feb 2020 21:01:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Orson Zhai <orson.unisoc@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, mingmin.ling@unisoc.com,
        orsonzhai@gmail.com, jingchao.ye@unisoc.com,
        Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Revert "PM / devfreq: Modify the device name as
 devfreq(X) for sysfs"
Message-ID: <20200220200145.GA3455749@kroah.com>
References: <1582220224-1904-1-git-send-email-orson.unisoc@gmail.com>
 <20200220191513.GA3450796@kroah.com>
 <CALAqxLViRgGE8FsukCJL+doqk_GqabLDCtXBWem+VOGf9xXZdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLViRgGE8FsukCJL+doqk_GqabLDCtXBWem+VOGf9xXZdg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 11:47:41AM -0800, John Stultz wrote:
> On Thu, Feb 20, 2020 at 11:15 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Feb 21, 2020 at 01:37:04AM +0800, Orson Zhai wrote:
> > > This reverts commit 4585fbcb5331fc910b7e553ad3efd0dd7b320d14.
> > >
> > > The name changing as devfreq(X) breaks some user space applications,
> > > such as Android HAL from Unisoc and Hikey [1].
> > > The device name will be changed unexpectly after every boot depending
> > > on module init sequence. It will make trouble to setup some system
> > > configuration like selinux for Android.
> > >
> > > So we'd like to revert it back to old naming rule before any better
> > > way being found.
> > >
> > > [1] https://lkml.org/lkml/2018/5/8/1042
> > >
> > > Cc: John Stultz <john.stultz@linaro.org>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Orson Zhai <orson.unisoc@gmail.com>
> > >
> > > ---
> > >  drivers/devfreq/devfreq.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> > > index cceee8b..7dcf209 100644
> > > --- a/drivers/devfreq/devfreq.c
> > > +++ b/drivers/devfreq/devfreq.c
> > > @@ -738,7 +738,6 @@ struct devfreq *devfreq_add_device(struct device *dev,
> > >  {
> > >       struct devfreq *devfreq;
> > >       struct devfreq_governor *governor;
> > > -     static atomic_t devfreq_no = ATOMIC_INIT(-1);
> > >       int err = 0;
> > >
> > >       if (!dev || !profile || !governor_name) {
> > > @@ -800,8 +799,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
> > >       devfreq->suspend_freq = dev_pm_opp_get_suspend_opp_freq(dev);
> > >       atomic_set(&devfreq->suspend_count, 0);
> > >
> > > -     dev_set_name(&devfreq->dev, "devfreq%d",
> > > -                             atomic_inc_return(&devfreq_no));
> > > +     dev_set_name(&devfreq->dev, "%s", dev_name(dev));
> > >       err = device_register(&devfreq->dev);
> > >       if (err) {
> > >               mutex_unlock(&devfreq->lock);
> > > --
> > > 2.7.4
> > >
> >
> > Thanks for this, I agree, this needs to get back to the way things were
> > as it seems to break too many existing systems as-is.
> >
> > I'll queue this up in my tree now, thanks.
> 
> Oof this old thing. I unfortunately didn't get back to look at the
> devfreq name node issue or the compatibility links, since the impact
> of the regression (breaking the powerHAL's interactions with the gpu)
> wasn't as big as other problems we had. While the regression was
> frustrating, my only hesitancy at this point is that its been this way
> since 4.10, so reverting the problematic patch is likely to break any
> new users since then.

4.11 :)

