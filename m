Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760E4686ED4
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 20:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjBATWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 14:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBATW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 14:22:29 -0500
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6196180033;
        Wed,  1 Feb 2023 11:22:28 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id lu11so17150809ejb.3;
        Wed, 01 Feb 2023 11:22:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0pdZLD78O+lLByjRagDEfqWVxnQITFbxpRDn3WNwAtE=;
        b=8LISFKQ6ongnMOYWdSIaRlwETAW+SD7pM9ua0+5VZy9jbiwk4QJSfnuiuo525FAs7i
         5q7vgNFHKE0bHJqjeZtMyODbwNFoaEsnjKvO+v7n3QxWK/ZC1gxLor0UIVENticG4Z+y
         Wbgp6/mWDFb66biQjkA37eMn+NLyMKIK9A1fvLyhYC9grBHmjNHCBTj1JBnV2dM0+BI6
         JXB/A+tfj4W9B0dOJK5YfE8boD9o9I/bWxwwpBOk1XV09tzEAGcc+ZPi3wRsADhyVAeU
         PPY3hWiJuzhdXX1PjgM274cSAr4Uf30q+JD9ny68JASVbdCKZgapdwgUYvQZhoBToapg
         8wTA==
X-Gm-Message-State: AO0yUKUZFkrvNlmwvKj4x3X9KQM5TYV5EeqGkXWV14KrOs/NEYZs2rdA
        kWSIqpTnXCwrmWN/VDtscvnbziFjr2ccBmnthLc=
X-Google-Smtp-Source: AK7set9BbRfaOQZszywkBGlPblazq6xuxUD5r1eByOJzKJq2iwtkM4W8KF2wjf2s/c/coRelxYw98pfPM8MsH0kwh2k=
X-Received: by 2002:a17:906:2f88:b0:844:44e0:1c4e with SMTP id
 w8-20020a1709062f8800b0084444e01c4emr1103696eji.291.1675279346876; Wed, 01
 Feb 2023 11:22:26 -0800 (PST)
MIME-Version: 1.0
References: <20230201180625.2156520-1-srinivas.pandruvada@linux.intel.com>
 <CAJZ5v0jQn7ON8XRk1zH_wWbwXJdKZFwR_Op=a4AO8kWp2jm8Aw@mail.gmail.com> <120794f5f4a0a091cf04366cc6e23ec5387a3b54.camel@linux.intel.com>
In-Reply-To: <120794f5f4a0a091cf04366cc6e23ec5387a3b54.camel@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 1 Feb 2023 20:22:15 +0100
Message-ID: <CAJZ5v0hDgjTOnCYdOuqgq3kWyUCpaezvRpCfWA9Gw3+cnJmfJA@mail.gmail.com>
Subject: Re: [PATCH] thermal: intel_powerclamp: Fix cur_state for multi
 package system
To:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        rui.zhang@intel.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 1, 2023 at 8:19 PM srinivas pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> On Wed, 2023-02-01 at 20:10 +0100, Rafael J. Wysocki wrote:
> > On Wed, Feb 1, 2023 at 7:06 PM Srinivas Pandruvada
> > <srinivas.pandruvada@linux.intel.com> wrote:
> > >
> > > The powerclamp cooling device cur_state shows actual idle observed
> > > by
> > > package C-state idle counters. But the implementation is not
> > > sufficient
> > > for multi package or multi die system. The cur_state value is
> > > incorrect.
> > > On these systems, these counters must be read from each package/die
> > > and
> > > somehow aggregate them. But there is no good method for
> > > aggregation.
> > >
> > > It was not a problem when explicit CPU model addition was required
> > > to
> > > enable intel powerclamp. In this way certain CPU models could have
> > > been avoided. But with the removal of CPU model check with the
> > > availability of Package C-state counters, the driver is loaded on
> > > most
> > > of the recent systems.
> > >
> > > For multi package/die systems, just show the actual target idle
> > > state,
> > > the system is trying to achieve. In powerclamp this is the user set
> > > state minus one.
> > >
> > > Also there is no use of starting a worker thread for polling
> > > package
> > > C-state counters and applying any compensation.
> >
> > I think that the last paragraph applies to systems with multiple
> > dies/packages?
> Yes.
>
> >
> > > Fixes: b721ca0d1927 ("thermal/powerclamp: remove cpu whitelist")
> >
> >
> >
> > > Signed-off-by: Srinivas Pandruvada
> > > <srinivas.pandruvada@linux.intel.com>
> > > Cc: stable@vger.kernel.org # 4.14+
> > > ---
> > >  drivers/thermal/intel/intel_powerclamp.c | 20 ++++++++++++++++----
> > >  1 file changed, 16 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/thermal/intel/intel_powerclamp.c
> > > b/drivers/thermal/intel/intel_powerclamp.c
> > > index b80e25ec1261..64f082c584b2 100644
> > > --- a/drivers/thermal/intel/intel_powerclamp.c
> > > +++ b/drivers/thermal/intel/intel_powerclamp.c
> > > @@ -57,6 +57,7 @@
> > >
> > >  static unsigned int target_mwait;
> > >  static struct dentry *debug_dir;
> > > +static bool poll_pkg_cstate_enable;
> > >
> > >  /* user selected target */
> > >  static unsigned int set_target_ratio;
> > > @@ -261,6 +262,9 @@ static unsigned int get_compensation(int ratio)
> > >  {
> > >         unsigned int comp = 0;
> > >
> > > +       if (!poll_pkg_cstate_enable)
> > > +               return 0;
> > > +
> > >         /* we only use compensation if all adjacent ones are good
> > > */
> > >         if (ratio == 1 &&
> > >                 cal_data[ratio].confidence >= CONFIDENCE_OK &&
> > > @@ -519,7 +523,8 @@ static int start_power_clamp(void)
> > >         control_cpu = cpumask_first(cpu_online_mask);
> > >
> > >         clamping = true;
> > > -       schedule_delayed_work(&poll_pkg_cstate_work, 0);
> > > +       if (poll_pkg_cstate_enable)
> > > +               schedule_delayed_work(&poll_pkg_cstate_work, 0);
> > >
> > >         /* start one kthread worker per online cpu */
> > >         for_each_online_cpu(cpu) {
> > > @@ -585,11 +590,15 @@ static int powerclamp_get_max_state(struct
> > > thermal_cooling_device *cdev,
> > >  static int powerclamp_get_cur_state(struct thermal_cooling_device
> > > *cdev,
> > >                                  unsigned long *state)
> > >  {
> > > -       if (true == clamping)
> > > -               *state = pkg_cstate_ratio_cur;
> > > -       else
> > > +       if (true == clamping) {
> >
> > This really should be
> I can change that, just kept the old style.
> I will send an update.
>
> >
> >         if (clamping) {
> >
> > > +               if (poll_pkg_cstate_enable)
> > > +                       *state = pkg_cstate_ratio_cur;
> > > +               else
> > > +                       *state = set_target_ratio;
> > > +       } else {
> > >                 /* to save power, do not poll idle ratio while not
> > > clamping */
> > >                 *state = -1; /* indicates invalid state */
> > > +       }
> > >
> > >         return 0;
> > >  }
> > > @@ -712,6 +721,9 @@ static int __init powerclamp_init(void)
> > >                 goto exit_unregister;
> > >         }
> > >
> > > +       if (topology_max_packages() == 1 &&
> > > topology_max_die_per_package() == 1)
> > > +               poll_pkg_cstate_enable = true;
> > > +
> > >         cooling_dev =
> > > thermal_cooling_device_register("intel_powerclamp", NULL,
> > >
> > > &powerclamp_cooling_ops);
> > >         if (IS_ERR(cooling_dev)) {
> > > --
> >
> > This fixes a rather old bug and we are late in the cycle, so I'm a
> > bit
> > reluctant to push it for -rc7 or -rc8.  I would prefer to apply it
> > for
> > 6.3, but let it go before the other powerclamp driver changes from
> > you.
> Yes, that's why I rebased other patches on top of this.
>
> >  This way, if anyone needs to backport it or put it into
> > -stable, they will be able to do that without pulling in the more
> > intrusive material.
> >
> > Now, I do realize that this avoids changing the current behavior too
> > much, but I think that it is plain confusing to return
> > pkg_cstate_ratio_cur from powerclamp_get_cur_state() in any case.  It
> > should always return set_target_ratio IMV.
> It should. It in unnecessary complications. When I use in thermald, I
> don't look at the returned value from cur_state as this doesn't matter
> if the temperature is not under control. I will change this for all
> cases.

I think that this should be a separate patch, though, not to be
confused with the fix.
