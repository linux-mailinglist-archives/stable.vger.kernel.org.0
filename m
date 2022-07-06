Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87491567EDF
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 08:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiGFGp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 02:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiGFGp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 02:45:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583C418384;
        Tue,  5 Jul 2022 23:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6C4961D89;
        Wed,  6 Jul 2022 06:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C478AC3411C;
        Wed,  6 Jul 2022 06:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657089924;
        bh=vQICsFQqcsaq2kWATV7iI594WeUqIbbCj2oxRSUPcys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g9Yl06NtLmHle14xehgyZ1GcsieFSxpvS+qraRzcVEP9HQxYNBO4iB2odlZmR437k
         UmPCumxj1DdoODSBZESqTB2BElcXR0QDdLBEjZ0LXqqJ5lyb4w1QqL8QxbNCxs47lf
         vYilhfVk2ZaNUUHqcJk5EoDPBZulXDopeEr751tA=
Date:   Wed, 6 Jul 2022 08:45:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Varad Gautam <varadgautam@google.com>
Cc:     linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] thermal: sysfs: Perform bounds check when storing
 thermal states
Message-ID: <YsUvgWmrk+ZfUy3t@kroah.com>
References: <20220705150002.2016207-1-varadgautam@google.com>
 <YsRkPUcrMj+JU0Om@kroah.com>
 <CAOLDJOJ_v75WqGt2mZa0h-GgF+NThFBY5DvasH+9LLVgLrrvog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOLDJOJ_v75WqGt2mZa0h-GgF+NThFBY5DvasH+9LLVgLrrvog@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 11:02:50PM +0200, Varad Gautam wrote:
> On Tue, Jul 5, 2022 at 6:18 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jul 05, 2022 at 03:00:02PM +0000, Varad Gautam wrote:
> > > Check that a user-provided thermal state is within the maximum
> > > thermal states supported by a given driver before attempting to
> > > apply it. This prevents a subsequent OOB access in
> > > thermal_cooling_device_stats_update() while performing
> > > state-transition accounting on drivers that do not have this check
> > > in their set_cur_state() handle.
> > >
> > > Signed-off-by: Varad Gautam <varadgautam@google.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/thermal/thermal_sysfs.c | 12 +++++++++++-
> > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> > > index 1c4aac8464a7..0c6b0223b133 100644
> > > --- a/drivers/thermal/thermal_sysfs.c
> > > +++ b/drivers/thermal/thermal_sysfs.c
> > > @@ -607,7 +607,7 @@ cur_state_store(struct device *dev, struct device_attribute *attr,
> > >               const char *buf, size_t count)
> > >  {
> > >       struct thermal_cooling_device *cdev = to_cooling_device(dev);
> > > -     unsigned long state;
> > > +     unsigned long state, max_state;
> > >       int result;
> > >
> > >       if (sscanf(buf, "%ld\n", &state) != 1)
> > > @@ -618,10 +618,20 @@ cur_state_store(struct device *dev, struct device_attribute *attr,
> > >
> > >       mutex_lock(&cdev->lock);
> > >
> > > +     result = cdev->ops->get_max_state(cdev, &max_state);
> > > +     if (result)
> > > +             goto unlock;
> > > +
> > > +     if (state > max_state) {
> > > +             result = -EINVAL;
> > > +             goto unlock;
> > > +     }
> > > +
> > >       result = cdev->ops->set_cur_state(cdev, state);
> >
> > Why doesn't set_cur_state() check the max state before setting it?  Why
> > are the callers forced to always check it before?  That feels wrong...
> >
> 
> The problem lies in thermal_cooling_device_stats_update(), not set_cur_state().
> 
> If ->set_cur_state() doesn't error out on invalid state,
> thermal_cooling_device_stats_update() does a:
> 
> stats->trans_table[stats->state * stats->max_states + new_state]++;
> 
> stats->trans_table reserves space depending on max_states, but we'd end up
> reading/writing outside it. cur_state_store() can prevent this regardless of
> the driver's ->set_cur_state() implementation.

Why wouldn't cur_state_store() check for an out-of-bounds condition by
calling get_max_state() and then return an error if it is invalid,
preventing thermal_cooling_device_stats_update() from ever being called?

thanks,

greg k-h
