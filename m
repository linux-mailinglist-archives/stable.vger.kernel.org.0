Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C48B56821D
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 10:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiGFIwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 04:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbiGFIwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 04:52:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3883B248EC;
        Wed,  6 Jul 2022 01:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657097529; x=1688633529;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rrbZGLkCmOqSgzRms+ImBGiKNcOdYZiidZ/LIuBdEGU=;
  b=O5Sn4Dt4Yqz1OBzA+686FnOo7t/Sli2YMhkKs8Dbwpr5spmH+gr81WCi
   q3mqaqPEGKZTMxuj/SfhkA/zpzs0nKodapi56noV/2Q9wa+6uzir9E/PH
   C4xVgtR4isnjRO1LMvRTNQBnhOuBTWjf5k74fHeXnrq1eEJHVQb0uZ+GY
   c+1CtzhErbM5vkxA6JTmFgNp/DxCDkxdhspKyg9moiiIImPzy1DGKSALC
   dFptH9cZXOdsUnvVsUX6UgwZzrwDE7zQbrl3LN7DKr410xtoOiG6F2cKt
   LGW4fwGDFUxPrQomRrm2Iykslf4yq3aa1OuymVM++hnRhWGSLQaJBcnWz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="283710640"
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="283710640"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 01:52:08 -0700
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="620220665"
Received: from lilicui-mobl.ccr.corp.intel.com ([10.255.29.244])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 01:52:03 -0700
Message-ID: <6eed01c90fafe681cccba2f227d65f2e9bfb8348.camel@intel.com>
Subject: Re: [PATCH] thermal: sysfs: Perform bounds check when storing
 thermal states
From:   Zhang Rui <rui.zhang@intel.com>
To:     Varad Gautam <varadgautam@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Date:   Wed, 06 Jul 2022 16:51:59 +0800
In-Reply-To: <CAOLDJOJug5jYpaSjY1tAYWNo0QRM4NB+wM2Vd2=Lf_O7TRjVCg@mail.gmail.com>
References: <20220705150002.2016207-1-varadgautam@google.com>
         <YsRkPUcrMj+JU0Om@kroah.com>
         <CAOLDJOJ_v75WqGt2mZa0h-GgF+NThFBY5DvasH+9LLVgLrrvog@mail.gmail.com>
         <YsUvgWmrk+ZfUy3t@kroah.com>
         <CAOLDJOJug5jYpaSjY1tAYWNo0QRM4NB+wM2Vd2=Lf_O7TRjVCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-07-06 at 09:16 +0200, Varad Gautam wrote:
> On Wed, Jul 6, 2022 at 8:45 AM Greg KH <gregkh@linuxfoundation.org>
> wrote:
> > 
> > On Tue, Jul 05, 2022 at 11:02:50PM +0200, Varad Gautam wrote:
> > > On Tue, Jul 5, 2022 at 6:18 PM Greg KH <
> > > gregkh@linuxfoundation.org> wrote:
> > > > 
> > > > On Tue, Jul 05, 2022 at 03:00:02PM +0000, Varad Gautam wrote:
> > > > > Check that a user-provided thermal state is within the
> > > > > maximum
> > > > > thermal states supported by a given driver before attempting
> > > > > to
> > > > > apply it. This prevents a subsequent OOB access in
> > > > > thermal_cooling_device_stats_update() while performing
> > > > > state-transition accounting on drivers that do not have this
> > > > > check
> > > > > in their set_cur_state() handle.
> > > > > 
> > > > > Signed-off-by: Varad Gautam <varadgautam@google.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > >  drivers/thermal/thermal_sysfs.c | 12 +++++++++++-
> > > > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/thermal/thermal_sysfs.c
> > > > > b/drivers/thermal/thermal_sysfs.c
> > > > > index 1c4aac8464a7..0c6b0223b133 100644
> > > > > --- a/drivers/thermal/thermal_sysfs.c
> > > > > +++ b/drivers/thermal/thermal_sysfs.c
> > > > > @@ -607,7 +607,7 @@ cur_state_store(struct device *dev,
> > > > > struct device_attribute *attr,
> > > > >               const char *buf, size_t count)
> > > > >  {
> > > > >       struct thermal_cooling_device *cdev =
> > > > > to_cooling_device(dev);
> > > > > -     unsigned long state;
> > > > > +     unsigned long state, max_state;
> > > > >       int result;
> > > > > 
> > > > >       if (sscanf(buf, "%ld\n", &state) != 1)
> > > > > @@ -618,10 +618,20 @@ cur_state_store(struct device *dev,
> > > > > struct device_attribute *attr,
> > > > > 
> > > > >       mutex_lock(&cdev->lock);
> > > > > 
> > > > > +     result = cdev->ops->get_max_state(cdev, &max_state);
> > > > > +     if (result)
> > > > > +             goto unlock;
> > > > > +
> > > > > +     if (state > max_state) {
> > > > > +             result = -EINVAL;
> > > > > +             goto unlock;
> > > > > +     }
> > > > > +
> > > > >       result = cdev->ops->set_cur_state(cdev, state);
> > > > 
> > > > Why doesn't set_cur_state() check the max state before setting
> > > > it?  Why
> > > > are the callers forced to always check it before?  That feels
> > > > wrong...
> > > > 
> > > 
> > > The problem lies in thermal_cooling_device_stats_update(), not
> > > set_cur_state().
> > > 
> > > If ->set_cur_state() doesn't error out on invalid state,
> > > thermal_cooling_device_stats_update() does a:
> > > 
> > > stats->trans_table[stats->state * stats->max_states +
> > > new_state]++;
> > > 
> > > stats->trans_table reserves space depending on max_states, but
> > > we'd end up
> > > reading/writing outside it. cur_state_store() can prevent this
> > > regardless of
> > > the driver's ->set_cur_state() implementation.
> > 
> > Why wouldn't cur_state_store() check for an out-of-bounds condition
> > by
> > calling get_max_state() and then return an error if it is invalid,
> > preventing thermal_cooling_device_stats_update() from ever being
> > called?
> > 
> 
> That's what this patch does, it adds the out-of-bounds check.

No, I think Greg' question is
why cdev->ops->set_cur_state() return 0 when setting a cooling state
that exceeds the maximum cooling state?

thanks,
rui
> 
> > thanks,
> > 
> > greg k-h

