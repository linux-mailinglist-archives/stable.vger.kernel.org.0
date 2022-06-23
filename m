Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9901155891D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiFWThm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiFWThP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:37:15 -0400
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1D32D1CE;
        Thu, 23 Jun 2022 12:24:55 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-317710edb9dso4732607b3.0;
        Thu, 23 Jun 2022 12:24:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QhlK/YJnZQeAv5E4yCNpLUiuZLQywWAhQUI+Q4Vp0+o=;
        b=6Ush0fIA8DvnuZfE1fM3b9QNQ13eJ5RxlocOlhHxV5VO46c67SOTfIaUIK/2XhfIHs
         fg4ReyYaz+FYPYFmzAcp8JfYGgKUKstNKxqqrbAtt405699rrmDRNoaWe8CRmrOjxs35
         Qb6b5MMrvYKe+rmO5EZpBPHphFcS3G5UDcgOyi69/NYnVa4m8xE6VAMQNn8Xr/4/cfE1
         Xc0WY1CWFgR5rhJr5VSvkGSrq5v6cBzKzSbwzjbFUbJz/ojdS+Z3lFTyfUNonlrRWm0Z
         zDFoZ/zOrRt1GsI+2oZND+i/hKVuSaAWI+Qc/smrWZrRWV5yURdJKXNuda02pUD3tEM5
         JQig==
X-Gm-Message-State: AJIora9HAXbz9kozwm4QGZHwf1kddgnGdcIrTDUD/lv2LR2G1PsVc4+m
        bLYJrOBW2De/0vd/wMmasXrIS3JwwcFBNJEcElpGEBey
X-Google-Smtp-Source: AGRyM1s/CzlAf52iBA8Dw4sOVjz6mvyhybudD2ImBh7j8RyoQGrGueJuJ+HMZyddeqaWsf/Ougr75V+Q6Mr+9BaurD0=
X-Received: by 2002:a81:a049:0:b0:318:8da9:4f with SMTP id x70-20020a81a049000000b003188da9004fmr533276ywg.515.1656012294900;
 Thu, 23 Jun 2022 12:24:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220623031509.555269-1-Jinzhou.Su@amd.com> <YrQbxvyl6ZT2T3wh@amd.com>
In-Reply-To: <YrQbxvyl6ZT2T3wh@amd.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 23 Jun 2022 21:24:43 +0200
Message-ID: <CAJZ5v0jnur-2vejKT-b9NMXp1qhh0CSL4-yLRK786TfL0nb8AQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: amd-pstate: Add resume and suspend callback for amd-pstate
To:     Huang Rui <ray.huang@amd.com>,
        "Su, Jinzhou (Joe)" <Jinzhou.Su@amd.com>
Cc:     "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Du, Xiaojian" <Xiaojian.Du@amd.com>,
        "Yuan, Perry" <Perry.Yuan@amd.com>,
        "Meng, Li (Jassmine)" <Li.Meng@amd.com>,
        "Liang, Richard qi" <Richardqi.Liang@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 9:53 AM Huang Rui <ray.huang@amd.com> wrote:
>
> On Thu, Jun 23, 2022 at 11:15:09AM +0800, Su, Jinzhou (Joe) wrote:
> > When system resumes from S3, the CPPC enable register will be
> > cleared and reset to 0. So sets this bit to enable CPPC
> > interface by writing 1 to this register.
> >
> > Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>
>
> Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>
> Cc: stable@vger.kernel.org
>
> You can add one line below your commit description to Cc stable mailing
> list. And next time in V2, it's better to use subject-prefix optional to
> mark it as v2 like below:
>
> git format-patch --subject-prefix="PATCH v2" HEAD~
>
> Other looks good for me, patch is
>
> Acked-by: Huang Rui <ray.huang@amd.com>
>
> > ---
> >  drivers/cpufreq/amd-pstate.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
> > index 7be38bc6a673..9ac75c1cde9c 100644
> > --- a/drivers/cpufreq/amd-pstate.c
> > +++ b/drivers/cpufreq/amd-pstate.c
> > @@ -566,6 +566,28 @@ static int amd_pstate_cpu_exit(struct cpufreq_policy *policy)
> >       return 0;
> >  }
> >
> > +static int amd_pstate_cpu_resume(struct cpufreq_policy *policy)
> > +{
> > +     int ret;
> > +
> > +     ret = amd_pstate_enable(true);
> > +     if (ret)
> > +             pr_err("failed to enable amd-pstate during resume, return %d\n", ret);
> > +
> > +     return ret;
> > +}
> > +
> > +static int amd_pstate_cpu_suspend(struct cpufreq_policy *policy)
> > +{
> > +     int ret;
> > +
> > +     ret = amd_pstate_enable(false);
> > +     if (ret)
> > +             pr_err("failed to disable amd-pstate during suspend, return %d\n", ret);
> > +
> > +     return ret;
> > +}
> > +
> >  /* Sysfs attributes */
> >
> >  /*
> > @@ -636,6 +658,8 @@ static struct cpufreq_driver amd_pstate_driver = {
> >       .target         = amd_pstate_target,
> >       .init           = amd_pstate_cpu_init,
> >       .exit           = amd_pstate_cpu_exit,
> > +     .suspend        = amd_pstate_cpu_suspend,
> > +     .resume         = amd_pstate_cpu_resume,
> >       .set_boost      = amd_pstate_set_boost,
> >       .name           = "amd-pstate",
> >       .attr           = amd_pstate_attr,
> > --

Applied with some edits in the subject and changelog, and a CC:stable
tag added, as 5.19-rc material.

Thanks!
