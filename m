Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07292686EC6
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 20:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjBATTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 14:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjBATTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 14:19:48 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ED51E5F0;
        Wed,  1 Feb 2023 11:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675279187; x=1706815187;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=biIGiOmjt67LaekM9gvPsbL3EOt6ge0EZRh1FVz4hlE=;
  b=CfQPZ9Q2w4gCfWUj1+LP8TyxQueValFNffXKi+NyBzLDQdzHoRylHRBG
   61x8lMSFARhCMFJCrLaHcV+kKWFwFppjCZDB43/Fu+SYwaMJhCR5C2jHk
   s1X6atQuOP0sVziYxZkkp+qAa9rYWpRaACHgFYPgD6vmQDcZEoXWupKIR
   Pg2RzCfPF5cjfQVHFAAI8fZdQbJBuBj6VT9t7N6JCHVCO5jdyckJ+DBVp
   VH8278BpUQRAvtTtJHj0SbTSJ7m0Px2hhdW8gqFWQgfQhPOU5rax6Mff6
   QfSUD6tFIqGV7PG1ZZA+WTEm+/vi0XJGUXlWhUcdUe5lbq2L+HDCzqnSZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="414454385"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="414454385"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 11:19:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="910420177"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="910420177"
Received: from aolabode-mobl.amr.corp.intel.com (HELO spandruv-desk1.amr.corp.intel.com) ([10.255.230.22])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 11:19:46 -0800
Message-ID: <120794f5f4a0a091cf04366cc6e23ec5387a3b54.camel@linux.intel.com>
Subject: Re: [PATCH] thermal: intel_powerclamp: Fix cur_state for multi
 package system
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, rui.zhang@intel.com,
        stable@vger.kernel.org
Date:   Wed, 01 Feb 2023 11:19:45 -0800
In-Reply-To: <CAJZ5v0jQn7ON8XRk1zH_wWbwXJdKZFwR_Op=a4AO8kWp2jm8Aw@mail.gmail.com>
References: <20230201180625.2156520-1-srinivas.pandruvada@linux.intel.com>
         <CAJZ5v0jQn7ON8XRk1zH_wWbwXJdKZFwR_Op=a4AO8kWp2jm8Aw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2023-02-01 at 20:10 +0100, Rafael J. Wysocki wrote:
> On Wed, Feb 1, 2023 at 7:06 PM Srinivas Pandruvada
> <srinivas.pandruvada@linux.intel.com> wrote:
> > 
> > The powerclamp cooling device cur_state shows actual idle observed
> > by
> > package C-state idle counters. But the implementation is not
> > sufficient
> > for multi package or multi die system. The cur_state value is
> > incorrect.
> > On these systems, these counters must be read from each package/die
> > and
> > somehow aggregate them. But there is no good method for
> > aggregation.
> > 
> > It was not a problem when explicit CPU model addition was required
> > to
> > enable intel powerclamp. In this way certain CPU models could have
> > been avoided. But with the removal of CPU model check with the
> > availability of Package C-state counters, the driver is loaded on
> > most
> > of the recent systems.
> > 
> > For multi package/die systems, just show the actual target idle
> > state,
> > the system is trying to achieve. In powerclamp this is the user set
> > state minus one.
> > 
> > Also there is no use of starting a worker thread for polling
> > package
> > C-state counters and applying any compensation.
> 
> I think that the last paragraph applies to systems with multiple
> dies/packages?
Yes.

> 
> > Fixes: b721ca0d1927 ("thermal/powerclamp: remove cpu whitelist")
> 
> 
> 
> > Signed-off-by: Srinivas Pandruvada
> > <srinivas.pandruvada@linux.intel.com>
> > Cc: stable@vger.kernel.org # 4.14+
> > ---
> >  drivers/thermal/intel/intel_powerclamp.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/thermal/intel/intel_powerclamp.c
> > b/drivers/thermal/intel/intel_powerclamp.c
> > index b80e25ec1261..64f082c584b2 100644
> > --- a/drivers/thermal/intel/intel_powerclamp.c
> > +++ b/drivers/thermal/intel/intel_powerclamp.c
> > @@ -57,6 +57,7 @@
> > 
> >  static unsigned int target_mwait;
> >  static struct dentry *debug_dir;
> > +static bool poll_pkg_cstate_enable;
> > 
> >  /* user selected target */
> >  static unsigned int set_target_ratio;
> > @@ -261,6 +262,9 @@ static unsigned int get_compensation(int ratio)
> >  {
> >         unsigned int comp = 0;
> > 
> > +       if (!poll_pkg_cstate_enable)
> > +               return 0;
> > +
> >         /* we only use compensation if all adjacent ones are good
> > */
> >         if (ratio == 1 &&
> >                 cal_data[ratio].confidence >= CONFIDENCE_OK &&
> > @@ -519,7 +523,8 @@ static int start_power_clamp(void)
> >         control_cpu = cpumask_first(cpu_online_mask);
> > 
> >         clamping = true;
> > -       schedule_delayed_work(&poll_pkg_cstate_work, 0);
> > +       if (poll_pkg_cstate_enable)
> > +               schedule_delayed_work(&poll_pkg_cstate_work, 0);
> > 
> >         /* start one kthread worker per online cpu */
> >         for_each_online_cpu(cpu) {
> > @@ -585,11 +590,15 @@ static int powerclamp_get_max_state(struct
> > thermal_cooling_device *cdev,
> >  static int powerclamp_get_cur_state(struct thermal_cooling_device
> > *cdev,
> >                                  unsigned long *state)
> >  {
> > -       if (true == clamping)
> > -               *state = pkg_cstate_ratio_cur;
> > -       else
> > +       if (true == clamping) {
> 
> This really should be
I can change that, just kept the old style.
I will send an update.

> 
>         if (clamping) {
> 
> > +               if (poll_pkg_cstate_enable)
> > +                       *state = pkg_cstate_ratio_cur;
> > +               else
> > +                       *state = set_target_ratio;
> > +       } else {
> >                 /* to save power, do not poll idle ratio while not
> > clamping */
> >                 *state = -1; /* indicates invalid state */
> > +       }
> > 
> >         return 0;
> >  }
> > @@ -712,6 +721,9 @@ static int __init powerclamp_init(void)
> >                 goto exit_unregister;
> >         }
> > 
> > +       if (topology_max_packages() == 1 &&
> > topology_max_die_per_package() == 1)
> > +               poll_pkg_cstate_enable = true;
> > +
> >         cooling_dev =
> > thermal_cooling_device_register("intel_powerclamp", NULL,
> >                                                
> > &powerclamp_cooling_ops);
> >         if (IS_ERR(cooling_dev)) {
> > --
> 
> This fixes a rather old bug and we are late in the cycle, so I'm a
> bit
> reluctant to push it for -rc7 or -rc8.  I would prefer to apply it
> for
> 6.3, but let it go before the other powerclamp driver changes from
> you. 
Yes, that's why I rebased other patches on top of this.

>  This way, if anyone needs to backport it or put it into
> -stable, they will be able to do that without pulling in the more
> intrusive material.
> 
> Now, I do realize that this avoids changing the current behavior too
> much, but I think that it is plain confusing to return
> pkg_cstate_ratio_cur from powerclamp_get_cur_state() in any case.  It
> should always return set_target_ratio IMV.
It should. It in unnecessary complications. When I use in thermald, I
don't look at the returned value from cur_state as this doesn't matter
if the temperature is not under control. I will change this for all
cases.

Thanks,
Srinivas

