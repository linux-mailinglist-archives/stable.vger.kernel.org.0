Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD604FF98D
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbiDMPBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 11:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiDMPBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 11:01:19 -0400
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0CFE0DD;
        Wed, 13 Apr 2022 07:58:58 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id m132so4250374ybm.4;
        Wed, 13 Apr 2022 07:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ICXFv2vFTWA/EfToNSXNFej0aDLg/UzwH2y+FUBsnf8=;
        b=ucIfUPnhBBucUyxJsRIMkWlhPT+08Y0+VrishMUN8nPab1K9E9FNLRfMIZL4UmA9NI
         UpqDWU9M/AlkR+8F96trf371dMVK5zVRxHfs1Y2fjvdHZ3lE/sBDhvXPTRUCdO0B3+HV
         vc7b7w9RAv8JeNj/kNpSO4swPPKqPjvcRYj3ZaK2sVp5g5egMtUqLIrtPqrygGwNHwq3
         XMvlcWHCXtmTUk4KDOa91Zuo5Vw+XVwySf8MdNj5HqUrEGjQ5PoxUb2bzZlRoRZEFgXy
         wlYrkIO+O07Bqlw78P+15UAUMZL85x1OYIfAg9T5nM4AqGpqSmdNnxUaHgqwOmsnFQt3
         9ZkA==
X-Gm-Message-State: AOAM531qWG859WEmlLFuR84KWzdhPM9EjqK0uHkx9FrAcfqQfYyZXJKx
        Y8BqGVxXtsf/G/zDO9UBlxv0q8pIAsn2lG5FDG4=
X-Google-Smtp-Source: ABdhPJwhNhjILTyonCwIgTOvkt4W+DqQjlYGmtX7ajI4SbcsIQhtTDyxJTnK5iHWVJydm2nWxnq4HLeNnvFojeev2io=
X-Received: by 2002:a05:6902:352:b0:63e:94c:883c with SMTP id
 e18-20020a056902035200b0063e094c883cmr28647821ybs.365.1649861937643; Wed, 13
 Apr 2022 07:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220325073030.91919-1-kant@allwinnertech.com> <c881de5f-5a1e-19ff-0ae6-f68032c79f03@arm.com>
In-Reply-To: <c881de5f-5a1e-19ff-0ae6-f68032c79f03@arm.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 13 Apr 2022 16:58:46 +0200
Message-ID: <CAJZ5v0j9O4mnUtNNtaQ7SZ1_N8GUOJ0CeSzZOwcJ18BKU9yKqQ@mail.gmail.com>
Subject: Re: [PATCH v2] thermal: devfreq_cooling: use local ops instead of
 global ops
To:     Lukasz Luba <lukasz.luba@arm.com>,
        Kant Fan <kant@allwinnertech.com>
Cc:     Amit Kucheria <amitk@kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        allwinner-opensource-support@allwinnertech.com,
        Stable <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ionela Voinescu <ionela.voinescu@arm.com>
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

On Fri, Mar 25, 2022 at 10:02 AM Lukasz Luba <lukasz.luba@arm.com> wrote:
>
> Hi Kant,
>
> On 3/25/22 07:30, Kant Fan wrote:
> > Fix access illegal address problem in following condition:
> > There are muti devfreq cooling devices in system, some of them has
> > em model but other does not, energy model ops such as state2power will
> > append to global devfreq_cooling_ops when the cooling device with
> > em model register. It makes the cooling device without em model
> > also use devfreq_cooling_ops after appending when register later by
> > of_devfreq_cooling_register_power() or of_devfreq_cooling_register().
> >
> > IPA governor regards the cooling devices without em model as a power actor
> > because they also have energy model ops, and will access illegal address
> > at dfc->em_pd when execute cdev->ops->get_requested_power,
> > cdev->ops->state2power or cdev->ops->power2state.
> >
> > Fixes: 615510fe13bd2 ("thermal: devfreq_cooling: remove old power model and use EM")
> > Cc: stable@vger.kernel.org # 5.13+
> > Signed-off-by: Kant Fan <kant@allwinnertech.com>
> > ---
> >   drivers/thermal/devfreq_cooling.c | 25 ++++++++++++++++++-------
> >   1 file changed, 18 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/thermal/devfreq_cooling.c b/drivers/thermal/devfreq_cooling.c
> > index 4310cb342a9f..d38a80adec73 100644
> > --- a/drivers/thermal/devfreq_cooling.c
> > +++ b/drivers/thermal/devfreq_cooling.c
> > @@ -358,21 +358,28 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
> >       struct thermal_cooling_device *cdev;
> >       struct device *dev = df->dev.parent;
> >       struct devfreq_cooling_device *dfc;
> > +     struct thermal_cooling_device_ops *ops;
> >       char *name;
> >       int err, num_opps;
> >
> > -     dfc = kzalloc(sizeof(*dfc), GFP_KERNEL);
> > -     if (!dfc)
> > +     ops = kmemdup(&devfreq_cooling_ops, sizeof(*ops), GFP_KERNEL);
> > +     if (!ops)
> >               return ERR_PTR(-ENOMEM);
> >
> > +     dfc = kzalloc(sizeof(*dfc), GFP_KERNEL);
> > +     if (!dfc) {
> > +             err = -ENOMEM;
> > +             goto free_ops;
> > +     }
> > +
> >       dfc->devfreq = df;
> >
> >       dfc->em_pd = em_pd_get(dev);
> >       if (dfc->em_pd) {
> > -             devfreq_cooling_ops.get_requested_power =
> > +             ops->get_requested_power =
> >                       devfreq_cooling_get_requested_power;
> > -             devfreq_cooling_ops.state2power = devfreq_cooling_state2power;
> > -             devfreq_cooling_ops.power2state = devfreq_cooling_power2state;
> > +             ops->state2power = devfreq_cooling_state2power;
> > +             ops->power2state = devfreq_cooling_power2state;
> >
> >               dfc->power_ops = dfc_power;
> >
> > @@ -407,8 +414,7 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
> >       if (!name)
> >               goto remove_qos_req;
> >
> > -     cdev = thermal_of_cooling_device_register(np, name, dfc,
> > -                                               &devfreq_cooling_ops);
> > +     cdev = thermal_of_cooling_device_register(np, name, dfc, ops);
> >       kfree(name);
> >
> >       if (IS_ERR(cdev)) {
> > @@ -429,6 +435,8 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
> >       kfree(dfc->freq_table);
> >   free_dfc:
> >       kfree(dfc);
> > +free_ops:
> > +     kfree(ops);
> >
> >       return ERR_PTR(err);
> >   }
> > @@ -510,11 +518,13 @@ EXPORT_SYMBOL_GPL(devfreq_cooling_em_register);
> >   void devfreq_cooling_unregister(struct thermal_cooling_device *cdev)
> >   {
> >       struct devfreq_cooling_device *dfc;
> > +     const struct thermal_cooling_device_ops *ops;
> >       struct device *dev;
> >
> >       if (IS_ERR_OR_NULL(cdev))
> >               return;
> >
> > +     ops = cdev->ops;
> >       dfc = cdev->devdata;
> >       dev = dfc->devfreq->dev.parent;
> >
> > @@ -525,5 +535,6 @@ void devfreq_cooling_unregister(struct thermal_cooling_device *cdev)
> >
> >       kfree(dfc->freq_table);
> >       kfree(dfc);
> > +     kfree(ops);
> >   }
> >   EXPORT_SYMBOL_GPL(devfreq_cooling_unregister);
>
>
> Thank you for updating it, LGTM
>
> Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>

Applied as 5.19 material.

Lukasz, this had a conflict with your EM series, please double check
if my resolution in the bleeding-edge branch is correct.

Thanks!
