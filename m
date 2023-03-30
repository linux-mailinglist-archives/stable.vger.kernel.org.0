Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208806D0D5D
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 20:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjC3SGc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 30 Mar 2023 14:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjC3SGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 14:06:31 -0400
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E70EB45;
        Thu, 30 Mar 2023 11:06:30 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id i5so80063690eda.0;
        Thu, 30 Mar 2023 11:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680199589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7F4u3rCMjafVAuTWZMNvDvBPl2JPGH003KSSvYrUvUA=;
        b=UaTfOSDXrA/5lIzXML9ibTHnR1S3VdmshOz/0WXAKL4YB2qU1DdorBoYUqLCPukXss
         ADFIsW4EAfVmOTVGG0KGJBAwV09SaKN3A42RkbD1yIWK3aMgH1q41VLZcL/Fzl4CYuVU
         LV0XDLnBMChve5S3Ow+PlXUW4Sv64WVbnp4sdCY2z+6tkQYbw2S1WItEY0EkkHc7Fpet
         1L09ca1vyhyWTa6jTVCruzLCCcHXKdYZtZmRRyFXfmN0+weu3YwhIXLwII5NmuF4ji6Y
         eW6yyJo0t1sssP0W53Abbu5z1lai5yaQwoNzyb+SjL5oI5zEV5k5kz5uYERxVjGUguLz
         IWUg==
X-Gm-Message-State: AAQBX9ftCoNmyTGeoudufNkh3xs0mVxND8CH/LWeZ6NprClBWXgfoP6Q
        t8EfCxh5ue2Oer/fdYyGF40zcJT8j6VTlB7n0yk=
X-Google-Smtp-Source: AKy350Z6HF7PmiHYO+7t+TSE8NwKCvaGewpS6+5eQaAzgiFfJZPXfW2S3RtVvKGGvm/vJcmSN73VcXfyP0Eyo3g3ugU=
X-Received: by 2002:a17:906:9f0b:b0:8b1:38d6:9853 with SMTP id
 fy11-20020a1709069f0b00b008b138d69853mr10988057ejc.2.1680199589088; Thu, 30
 Mar 2023 11:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230330134218.1897786-1-darcari@redhat.com> <9e65a37b8220943a540cc3aaf660a79cef4041dc.camel@linux.intel.com>
In-Reply-To: <9e65a37b8220943a540cc3aaf660a79cef4041dc.camel@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 30 Mar 2023 20:06:18 +0200
Message-ID: <CAJZ5v0jsS6YkbCovEt3nTPkcaQF7yvexOrR0iSwGoeht6orGjA@mail.gmail.com>
Subject: Re: [PATCH] thermal: intel: powerclamp: Fix cpumask and max_idle
 module parameters
To:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Arcari <darcari@redhat.com>
Cc:     linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Chen Yu <yu.c.chen@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 7:36 PM srinivas pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> On Thu, 2023-03-30 at 09:42 -0400, David Arcari wrote:
> Reviewed-by: Srinivas Pandruvada <>> When cpumask is specified as a module parameter the value is
> > overwritten by the module init routine.  This can easily be fixed
> > by checking to see if the mask has already been allocated in the
> > init routine.
> >
> > When max_idle is specified as a module parameter a panic will occur.
> > The problem is that the idle_injection_cpu_mask is not allocated
> > until
> > the module init routine executes. This can easily be fixed by
> > allocating
> > the cpumask if it's not already allocated.
> >
> > Fixes: ebf519710218 ("thermal: intel: powerclamp: Add two module
> > parameters")
> >
> > Signed-off-by: David Arcari <darcari@redhat.com>
> Reviewed-by: Srinivas Pandruvada<srinivas.pandruvada@linux.intel.com>

Applied as 6.3-rc material, thanks!

> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Cc: Amit Kucheria <amitk@kernel.org>
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> > Cc: David Arcari <darcari@redhat.com>
> > Cc: Chen Yu <yu.c.chen@intel.com>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
> >
> > ---
> >  drivers/thermal/intel/intel_powerclamp.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/thermal/intel/intel_powerclamp.c
> > b/drivers/thermal/intel/intel_powerclamp.c
> > index c7ba5680cd48..91fc7e239497 100644
> > --- a/drivers/thermal/intel/intel_powerclamp.c
> > +++ b/drivers/thermal/intel/intel_powerclamp.c
> > @@ -235,6 +235,12 @@ static int max_idle_set(const char *arg, const
> > struct kernel_param *kp)
> >                 goto skip_limit_set;
> >         }
> >
> > +       if (!cpumask_available(idle_injection_cpu_mask)) {
> > +               ret =
> > allocate_copy_idle_injection_mask(cpu_present_mask);
> > +               if (ret)
> > +                       goto skip_limit_set;
> > +       }
> > +
> >         if (check_invalid(idle_injection_cpu_mask, new_max_idle)) {
> >                 ret = -EINVAL;
> >                 goto skip_limit_set;
> > @@ -791,7 +797,8 @@ static int __init powerclamp_init(void)
> >                 return retval;
> >
> >         mutex_lock(&powerclamp_lock);
> > -       retval = allocate_copy_idle_injection_mask(cpu_present_mask);
> > +       if (!cpumask_available(idle_injection_cpu_mask))
> > +               retval =
> > allocate_copy_idle_injection_mask(cpu_present_mask);
> >         mutex_unlock(&powerclamp_lock);
> >
> >         if (retval)
>
