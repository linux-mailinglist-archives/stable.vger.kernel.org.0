Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720645688B1
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 14:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiGFMvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 08:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiGFMvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 08:51:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8055314090;
        Wed,  6 Jul 2022 05:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16E7CB81CE2;
        Wed,  6 Jul 2022 12:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2632BC341C0;
        Wed,  6 Jul 2022 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657111904;
        bh=RvVF+pX2pQJvhQhl3VwMAq7Yr6W0YSgKG1Uay6bdLjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XfFiAmi5S0vNcOt2j2FYsW6jko6n9fjj+ir6pftjgIIqnIbhTcuEgIR1GCgifE9nl
         3Wfxs5XPgLG7vKDGGEoAxr1+B3oGq4MIJrj7Y1X+4Y5u62Z5S0yTXPK9AR961rgg7+
         WP+MINhmRV+VolBioKdDJYbdvqKsg/apqn6ykPPA=
Date:   Wed, 6 Jul 2022 14:51:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Varad Gautam <varadgautam@google.com>
Cc:     Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] thermal: sysfs: Perform bounds check when storing
 thermal states
Message-ID: <YsWFXVALpyedoeYt@kroah.com>
References: <20220705150002.2016207-1-varadgautam@google.com>
 <YsRkPUcrMj+JU0Om@kroah.com>
 <CAOLDJOJ_v75WqGt2mZa0h-GgF+NThFBY5DvasH+9LLVgLrrvog@mail.gmail.com>
 <YsUvgWmrk+ZfUy3t@kroah.com>
 <CAOLDJOJug5jYpaSjY1tAYWNo0QRM4NB+wM2Vd2=Lf_O7TRjVCg@mail.gmail.com>
 <6eed01c90fafe681cccba2f227d65f2e9bfb8348.camel@intel.com>
 <YsVUB76c2b0EkRBb@kroah.com>
 <CAOLDJOJLvSUMqF37H13aiH59Pm4_t6esRxy7Ej3Grhr4fmSGQA@mail.gmail.com>
 <YsViJpAnkqW1QTwW@kroah.com>
 <CAOLDJOK0Ti2hyskS68LRrd=G5opMz4fnzduj5-d3MF0JLwxS6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOLDJOK0Ti2hyskS68LRrd=G5opMz4fnzduj5-d3MF0JLwxS6w@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 06, 2022 at 02:30:21PM +0200, Varad Gautam wrote:
> On Wed, Jul 6, 2022 at 12:21 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Jul 06, 2022 at 12:01:19PM +0200, Varad Gautam wrote:
> > > On Wed, Jul 6, 2022 at 11:21 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Wed, Jul 06, 2022 at 04:51:59PM +0800, Zhang Rui wrote:
> > > > > On Wed, 2022-07-06 at 09:16 +0200, Varad Gautam wrote:
> > > > > > On Wed, Jul 6, 2022 at 8:45 AM Greg KH <gregkh@linuxfoundation.org>
> > > > > > wrote:
> > > > > > >
> > > > > > > On Tue, Jul 05, 2022 at 11:02:50PM +0200, Varad Gautam wrote:
> > > > > > > > On Tue, Jul 5, 2022 at 6:18 PM Greg KH <
> > > > > > > > gregkh@linuxfoundation.org> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Jul 05, 2022 at 03:00:02PM +0000, Varad Gautam wrote:
> > > > > > > > > > Check that a user-provided thermal state is within the
> > > > > > > > > > maximum
> > > > > > > > > > thermal states supported by a given driver before attempting
> > > > > > > > > > to
> > > > > > > > > > apply it. This prevents a subsequent OOB access in
> > > > > > > > > > thermal_cooling_device_stats_update() while performing
> > > > > > > > > > state-transition accounting on drivers that do not have this
> > > > > > > > > > check
> > > > > > > > > > in their set_cur_state() handle.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Varad Gautam <varadgautam@google.com>
> > > > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > > > ---
> > > > > > > > > >  drivers/thermal/thermal_sysfs.c | 12 +++++++++++-
> > > > > > > > > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/drivers/thermal/thermal_sysfs.c
> > > > > > > > > > b/drivers/thermal/thermal_sysfs.c
> > > > > > > > > > index 1c4aac8464a7..0c6b0223b133 100644
> > > > > > > > > > --- a/drivers/thermal/thermal_sysfs.c
> > > > > > > > > > +++ b/drivers/thermal/thermal_sysfs.c
> > > > > > > > > > @@ -607,7 +607,7 @@ cur_state_store(struct device *dev,
> > > > > > > > > > struct device_attribute *attr,
> > > > > > > > > >               const char *buf, size_t count)
> > > > > > > > > >  {
> > > > > > > > > >       struct thermal_cooling_device *cdev =
> > > > > > > > > > to_cooling_device(dev);
> > > > > > > > > > -     unsigned long state;
> > > > > > > > > > +     unsigned long state, max_state;
> > > > > > > > > >       int result;
> > > > > > > > > >
> > > > > > > > > >       if (sscanf(buf, "%ld\n", &state) != 1)
> > > > > > > > > > @@ -618,10 +618,20 @@ cur_state_store(struct device *dev,
> > > > > > > > > > struct device_attribute *attr,
> > > > > > > > > >
> > > > > > > > > >       mutex_lock(&cdev->lock);
> > > > > > > > > >
> > > > > > > > > > +     result = cdev->ops->get_max_state(cdev, &max_state);
> > > > > > > > > > +     if (result)
> > > > > > > > > > +             goto unlock;
> > > > > > > > > > +
> > > > > > > > > > +     if (state > max_state) {
> > > > > > > > > > +             result = -EINVAL;
> > > > > > > > > > +             goto unlock;
> > > > > > > > > > +     }
> > > > > > > > > > +
> > > > > > > > > >       result = cdev->ops->set_cur_state(cdev, state);
> > > > > > > > >
> > > > > > > > > Why doesn't set_cur_state() check the max state before setting
> > > > > > > > > it?  Why
> > > > > > > > > are the callers forced to always check it before?  That feels
> > > > > > > > > wrong...
> > > > > > > > >
> > > > > > > >
> > > > > > > > The problem lies in thermal_cooling_device_stats_update(), not
> > > > > > > > set_cur_state().
> > > > > > > >
> > > > > > > > If ->set_cur_state() doesn't error out on invalid state,
> > > > > > > > thermal_cooling_device_stats_update() does a:
> > > > > > > >
> > > > > > > > stats->trans_table[stats->state * stats->max_states +
> > > > > > > > new_state]++;
> > > > > > > >
> > > > > > > > stats->trans_table reserves space depending on max_states, but
> > > > > > > > we'd end up
> > > > > > > > reading/writing outside it. cur_state_store() can prevent this
> > > > > > > > regardless of
> > > > > > > > the driver's ->set_cur_state() implementation.
> > > > > > >
> > > > > > > Why wouldn't cur_state_store() check for an out-of-bounds condition
> > > > > > > by
> > > > > > > calling get_max_state() and then return an error if it is invalid,
> > > > > > > preventing thermal_cooling_device_stats_update() from ever being
> > > > > > > called?
> > > > > > >
> > > > > >
> > > > > > That's what this patch does, it adds the out-of-bounds check.
> > > > >
> > > > > No, I think Greg' question is
> > > > > why cdev->ops->set_cur_state() return 0 when setting a cooling state
> > > > > that exceeds the maximum cooling state?
> > > >
> > > > Yes, that is what I am asking, it should not allow a state to be
> > > > exceeded.
> > > >
> > >
> > > Indeed, it is upto the driver to return !0 from cdev->ops->set_cur_state()
> > > when setting state > max - and it is a driver bug for not doing so.
> > >
> > > But a buggy driver should not lead to cur_state_store() performing an OOB
> > > access.
> >
> > Agreed, which is why the code that does the access should check before
> > it does so.  Right now you are relying on the sysfs code to do so, which
> > seems very wrong.
> >
> 
> I see the point.
> 
> The OOB access happens in thermal_cooling_device_stats_update().
> 
> By placing the check in cur_state_store(), I'm trying to ensure
> two things for a buggy driver:

What in-kernel driver has this problem, and why not just fix it there?

> 1. The driver's cdev->ops->set_cur_state() doesn't get called if
> the new state is > max state. This is to prevent the driver
> from storing the new (invalid) state internally. If the driver
> didn't realise/reject an invalid state, chances are it will try
> to propagate it internally and take actions according to that,
> which can have side effects on system stability.

Again, set_cur_state() should check for max values, if not, it is broken
and that needs to be fixed in the driver.

> 2. The kernel doesn't do an OOB access in
> thermal_cooling_device_stats_update().

Then don't allow thermal_cooling_device_stats_update() to do an out of
band access by fixing it there too.  But again, your patch does not
solve that directly.

thanks,

greg k-h
