Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2149A169936
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 18:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBWRy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 12:54:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbgBWRy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 12:54:26 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EC5A206E0;
        Sun, 23 Feb 2020 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582480465;
        bh=M3NMimfAZ1sgL3y3XjG68/hxflxXlHu+b3pf9l5741Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=arTf2rniNYwRgk5352xBxhz3unJzzzguYAuguqqA8We+q2uIukINzyk6wPvcdwoNN
         S591q9RMxibHIi2k0oY8zdrXSKRnaI6ZQJyvi2axuTnaNJoe6FwuteRGgt2wuDUg+w
         NQmUIY53jzgnn4T+s3BT2GPhWoC8mR6e/jgBp7AI=
Date:   Sun, 23 Feb 2020 18:54:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chanwoo Choi <chanwoo@kernel.org>
Cc:     Chanwoo Choi <cw00.choi@samsung.com>,
        John Stultz <john.stultz@linaro.org>,
        Orson Zhai <orson.unisoc@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        mingmin.ling@unisoc.com, orsonzhai@gmail.com,
        jingchao.ye@unisoc.com, Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Revert "PM / devfreq: Modify the device name as
 devfreq(X) for sysfs"
Message-ID: <20200223175422.GD488486@kroah.com>
References: <1582220224-1904-1-git-send-email-orson.unisoc@gmail.com>
 <20200220191513.GA3450796@kroah.com>
 <CALAqxLViRgGE8FsukCJL+doqk_GqabLDCtXBWem+VOGf9xXZdg@mail.gmail.com>
 <CGME20200221070652epcas1p11e82863794f130373055c0b7bdedff23@epcas1p1.samsung.com>
 <20200221070646.GA4103708@kroah.com>
 <1b9e510a-71bb-5aa8-ef85-a9a9c623f313@samsung.com>
 <20200221111313.GA110504@kroah.com>
 <CAGTfZH0Ev2sCH073WdUjZJS5MNnJ9vzgsc_ApYkg+na2Fk4J+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGTfZH0Ev2sCH073WdUjZJS5MNnJ9vzgsc_ApYkg+na2Fk4J+g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 22, 2020 at 08:55:22AM +0900, Chanwoo Choi wrote:
> On Fri, Feb 21, 2020 at 8:13 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Feb 21, 2020 at 05:11:02PM +0900, Chanwoo Choi wrote:
> > > On 2/21/20 4:06 PM, Greg Kroah-Hartman wrote:
> > > > On Thu, Feb 20, 2020 at 11:47:41AM -0800, John Stultz wrote:
> > > >> On Thu, Feb 20, 2020 at 11:15 AM Greg Kroah-Hartman
> > > >> <gregkh@linuxfoundation.org> wrote:
> > > >>>
> > > >>> On Fri, Feb 21, 2020 at 01:37:04AM +0800, Orson Zhai wrote:
> > > >>>> This reverts commit 4585fbcb5331fc910b7e553ad3efd0dd7b320d14.
> > > >>>>
> > > >>>> The name changing as devfreq(X) breaks some user space applications,
> > > >>>> such as Android HAL from Unisoc and Hikey [1].
> > > >>>> The device name will be changed unexpectly after every boot depending
> > > >>>> on module init sequence. It will make trouble to setup some system
> > > >>>> configuration like selinux for Android.
> > > >>>>
> > > >>>> So we'd like to revert it back to old naming rule before any better
> > > >>>> way being found.
> > > >>>>
> > > >>>> [1] https://protect2.fireeye.com/url?k=00fa721e-5d2a7af6-00fbf951-000babff32e3-95e4b92259b05656&u=https://lkml.org/lkml/2018/5/8/1042
> > > >>>>
> > > >>>> Cc: John Stultz <john.stultz@linaro.org>
> > > >>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >>>> Cc: stable@vger.kernel.org
> > > >>>> Signed-off-by: Orson Zhai <orson.unisoc@gmail.com>
> > > >>>>
> > > >>>> ---
> > > >>>>  drivers/devfreq/devfreq.c | 4 +---
> > > >>>>  1 file changed, 1 insertion(+), 3 deletions(-)
> > > >>>>
> > > >>>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> > > >>>> index cceee8b..7dcf209 100644
> > > >>>> --- a/drivers/devfreq/devfreq.c
> > > >>>> +++ b/drivers/devfreq/devfreq.c
> > > >>>> @@ -738,7 +738,6 @@ struct devfreq *devfreq_add_device(struct device *dev,
> > > >>>>  {
> > > >>>>       struct devfreq *devfreq;
> > > >>>>       struct devfreq_governor *governor;
> > > >>>> -     static atomic_t devfreq_no = ATOMIC_INIT(-1);
> > > >>>>       int err = 0;
> > > >>>>
> > > >>>>       if (!dev || !profile || !governor_name) {
> > > >>>> @@ -800,8 +799,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
> > > >>>>       devfreq->suspend_freq = dev_pm_opp_get_suspend_opp_freq(dev);
> > > >>>>       atomic_set(&devfreq->suspend_count, 0);
> > > >>>>
> > > >>>> -     dev_set_name(&devfreq->dev, "devfreq%d",
> > > >>>> -                             atomic_inc_return(&devfreq_no));
> > > >>>> +     dev_set_name(&devfreq->dev, "%s", dev_name(dev));
> > > >>>>       err = device_register(&devfreq->dev);
> > > >>>>       if (err) {
> > > >>>>               mutex_unlock(&devfreq->lock);
> > > >>>> --
> > > >>>> 2.7.4
> > > >>>>
> > > >>>
> > > >>> Thanks for this, I agree, this needs to get back to the way things were
> > > >>> as it seems to break too many existing systems as-is.
> > > >>>
> > > >>> I'll queue this up in my tree now, thanks.
> > > >>
> > > >> Oof this old thing. I unfortunately didn't get back to look at the
> > > >> devfreq name node issue or the compatibility links, since the impact
> > > >> of the regression (breaking the powerHAL's interactions with the gpu)
> > > >> wasn't as big as other problems we had. While the regression was
> > > >> frustrating, my only hesitancy at this point is that its been this way
> > > >> since 4.10, so reverting the problematic patch is likely to break any
> > > >> new users since then.
> > > >
> > > > Looks like most users just revert that commit in their trees:
> > > >     https://protect2.fireeye.com/url?k=1012ad0f-4dc2a5e7-10132640-000babff32e3-35779c5ed675ef0f&u=https://source.codeaurora.org/quic/la/kernel/msm-4.14/commit/drivers/devfreq?h=msm-4.14&id=ccf273f6d89ad0fa8032e9225305ad6f62c7770c
> > > >
> > > > So we should be ok here.
> > >
> > > I'm sorry about changing the devfreq node name.
> > >
> > > OK. Do you pick this patch to your tree?
> >
> > Yes, I can do that.
> 
> If you agree, how about merging it to devfreq.git
> for preventing the potential merge conflict with other devfreq patches?

Sure, but it should go for 5.6-final, right?

> > > or If not, I'll apply it to devfreq-next branch for v5.7-rc1.
> > >
> > > And do you apply it to kernel of linux-stable tree since 4.11?
> >
> > Yeah, I'll mark it for stable.
> 
> Thanks.
> 
> >
> > Can I get an ack from you for this?
> 
> OK. but, if it will be merged to devfreq.git,
> can I get an ack from you?

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
