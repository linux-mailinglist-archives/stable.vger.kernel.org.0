Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C626965F7
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 15:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbjBNOJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 09:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbjBNOJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 09:09:44 -0500
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6276E2203C;
        Tue, 14 Feb 2023 06:09:07 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id dr8so40272796ejc.12;
        Tue, 14 Feb 2023 06:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p7hlSNqIh/Sna2kEiZvGWoB1aXxpevaYTwBOmCsTko4=;
        b=VQhEXrJCClXlTMVNlCv6k10DCH92MxLpaMSlvWwbjtVae3qS3cNwQgeAVYBviuU7Yn
         CVrJCkXVIcdcLCGmqRbZkFaQhvVuEr5hxzmM0tZN0sDNKarno1aQs2/9x2Caimp5KZVt
         62wU+p9URpngfpXIJnTaO5usOM03PsVEyse9ne86RnZCb9ZcEBA0RgmWWR4ROEZYjSH4
         IyVk/TEIdorq44jWadIQ9iydvdZ1NYndc5VSj1F2IAuaGyyrzy0LaCMtPoyBKy4lPboZ
         2oFkMEQQcfKw8dqVddV42X2WUXPOEzEvolkkocsynZHRjCK89y/kOghpFRu2eABZ2mwY
         3TSg==
X-Gm-Message-State: AO0yUKWM3g51Zo0twbdNTwVK1WD3xqSiM0BEEbeVQgracy+Vt6g7sl0J
        +s0Hq4jmLZvy77ZspNuBDoE1aFD0abtqatNPCuw=
X-Google-Smtp-Source: AK7set+1uGQfF1O93l4l2QxjShVpBRHJC5I5JTqL8wOB2fyUeCuafm+Tc+pvZllJxQbEAbLdUrPoB0rt+WbmOkOKcl8=
X-Received: by 2002:a17:906:b310:b0:8b1:2d36:a58e with SMTP id
 n16-20020a170906b31000b008b12d36a58emr1154572ejz.2.1676383662806; Tue, 14 Feb
 2023 06:07:42 -0800 (PST)
MIME-Version: 1.0
References: <20230214094115.23338-1-manivannan.sadhasivam@linaro.org> <20230214095300.pv3e73r36poth5w4@vireshk-i7>
In-Reply-To: <20230214095300.pv3e73r36poth5w4@vireshk-i7>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 14 Feb 2023 15:07:31 +0100
Message-ID: <CAJZ5v0ip_OHkSjQwNh5o+p2T2utXozH7DV6DFVp23bw5tzShtQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: qcom-hw: Add missing null pointer check
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     rafael@kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
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

On Tue, Feb 14, 2023 at 10:53 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> On 14-02-23, 15:11, Manivannan Sadhasivam wrote:
> > of_device_get_match_data() may return NULL, so add a check to prevent
> > potential null pointer dereference.
> >
> > Issue reported by Qualcomm's internal static analysis tool.
> >
> > Cc: stable@vger.kernel.org # v6.2
> > Fixes: 4f7961706c63 ("cpufreq: qcom-hw: Move soc_data to struct qcom_cpufreq")
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  drivers/cpufreq/qcom-cpufreq-hw.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
> > index 340fed35e45d..6425c6b6e393 100644
> > --- a/drivers/cpufreq/qcom-cpufreq-hw.c
> > +++ b/drivers/cpufreq/qcom-cpufreq-hw.c
> > @@ -689,6 +689,8 @@ static int qcom_cpufreq_hw_driver_probe(struct platform_device *pdev)
> >               return -ENOMEM;
> >
> >       qcom_cpufreq.soc_data = of_device_get_match_data(dev);
> > +     if (!qcom_cpufreq.soc_data)
> > +             return -ENODEV;
> >
> >       clk_data = devm_kzalloc(dev, struct_size(clk_data, hws, num_domains), GFP_KERNEL);
> >       if (!clk_data)
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Rafael,
>
> Can you still send this for 6.2 ?

Yes, I can.
