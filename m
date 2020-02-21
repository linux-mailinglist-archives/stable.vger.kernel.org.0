Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D37167580
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387696AbgBUI2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:28:20 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:34285 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388432AbgBUI2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 03:28:18 -0500
Received: by mail-ua1-f68.google.com with SMTP id 1so374570uao.1;
        Fri, 21 Feb 2020 00:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kpZqkjJzq7maU5wRD/SzaYqTKkPoc6vJaalUsryW+8I=;
        b=RWVYOsnefJ75cq6QAR9uBhrSY2wGv/IxxoO4tFK384goCjUffuRjVzizn58R9YvaW7
         X31yruFrt6MSw7clKgt3OEMjdI5ShxL4K0YTbH5Ev0+WURhB/7lqvARcxgGxLiwCez/A
         a034X2eq+189Iip0KOY7CbfjU8yQ10KCa/N8afzgU4F0HtIdeQh+Cz7oOWbg9n2YkfvT
         IrZoeMlGPqk3uSUW1wdg/roL8/1BRqxR+UpPfbWMu7IVJAgT3ghT1TRxn59CgD53xBIQ
         EJZ4o2oteTWqO68IOwZc6gMq2B2gIadDTXUEXU+G/TnheC3jxEeatzIbdYddSgIJQxoB
         3DMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kpZqkjJzq7maU5wRD/SzaYqTKkPoc6vJaalUsryW+8I=;
        b=bPg3/OZhaV4spZRR30uBM8XqX6LsesHQvcPsoW8E5zLmx3EqBXFxl/6s88IyDgStNr
         2DU2OAIokVFD96PuQVynO5Xm1U6Qrog8ctqQ9XvVnoJNmD+sZV9LPe7HyM7g1kGafZNX
         3V3b9+N79Pb9ZmJGRPFrh8f5ENfjEg0RCchEctK4HFPIcmq3TltUhq9oj6Ux3DxOcYKe
         nY79sbEwWQIsZ00El8FgTOle34hOf+cBom+/P+rjsgE4a9YlycHoaPDDtoWFlHY0J92x
         WwN9mC154kdagl/SH2MggqqhomxT8KXAVr3YFFCsEqNVLE+oik2IKA6QFdYyMYUZ3ax0
         04qw==
X-Gm-Message-State: APjAAAXtsTkcg1RW8W5Jn1BnAUD4MyhRUICTa7CjdYMBFpACL3gIYD0l
        cBwVnMtCaWzd4W0BheUhhoq+wjRa2FbrG318voppVCbB
X-Google-Smtp-Source: APXvYqxmLNkqW8mBwz0Iwb261cEY9aqyNNS8+/2m7CnN8EFRUA4/6WuhWMOyAGVA8CFlptNzcQE7DsGzQPkFHHDQR/k=
X-Received: by 2002:ab0:3395:: with SMTP id y21mr9862260uap.124.1582273697648;
 Fri, 21 Feb 2020 00:28:17 -0800 (PST)
MIME-Version: 1.0
References: <20200106104339.215511-1-christian.gmeiner@gmail.com>
In-Reply-To: <20200106104339.215511-1-christian.gmeiner@gmail.com>
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
Date:   Fri, 21 Feb 2020 09:28:06 +0100
Message-ID: <CAH9NwWcW-kq_GzhsfZboLKfGZj6=40Qi6Pf8-WoO4J6VOqzgoQ@mail.gmail.com>
Subject: Re: [PATCH] drm/etnaviv: rework perfmon query infrastructure
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        The etnaviv authors <etnaviv@lists.freedesktop.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Mo., 6. Jan. 2020 um 11:43 Uhr schrieb Christian Gmeiner
<christian.gmeiner@gmail.com>:
>
> Report the correct perfmon domains and signals depending
> on the supported feature flags.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 9e2c2e273012 ("drm/etnaviv: add infrastructure to query perf counter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> ---
>  drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 57 ++++++++++++++++++++---
>  1 file changed, 50 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> index 8adbf2861bff..7ae8f347ca06 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> @@ -32,6 +32,7 @@ struct etnaviv_pm_domain {
>  };
>
>  struct etnaviv_pm_domain_meta {
> +       unsigned int feature;
>         const struct etnaviv_pm_domain *domains;
>         u32 nr_domains;
>  };
> @@ -410,36 +411,78 @@ static const struct etnaviv_pm_domain doms_vg[] = {
>
>  static const struct etnaviv_pm_domain_meta doms_meta[] = {
>         {
> +               .feature = chipFeatures_PIPE_3D,
>                 .nr_domains = ARRAY_SIZE(doms_3d),
>                 .domains = &doms_3d[0]
>         },
>         {
> +               .feature = chipFeatures_PIPE_2D,
>                 .nr_domains = ARRAY_SIZE(doms_2d),
>                 .domains = &doms_2d[0]
>         },
>         {
> +               .feature = chipFeatures_PIPE_VG,
>                 .nr_domains = ARRAY_SIZE(doms_vg),
>                 .domains = &doms_vg[0]
>         }
>  };
>
> +static unsigned int num_pm_domains(const struct etnaviv_gpu *gpu)
> +{
> +       unsigned int num = 0, i;
> +
> +       for (i = 0; i < ARRAY_SIZE(doms_meta); i++) {
> +               const struct etnaviv_pm_domain_meta *meta = &doms_meta[i];
> +
> +               if (gpu->identity.features & meta->feature)
> +                       num += meta->nr_domains;
> +       }
> +
> +       return num;
> +}
> +
> +static const struct etnaviv_pm_domain *pm_domain(const struct etnaviv_gpu *gpu,
> +       unsigned int index)
> +{
> +       const struct etnaviv_pm_domain *domain = NULL;
> +       unsigned int offset = 0, i;
> +
> +       for (i = 0; i < ARRAY_SIZE(doms_meta); i++) {
> +               const struct etnaviv_pm_domain_meta *meta = &doms_meta[i];
> +
> +               if (!(gpu->identity.features & meta->feature))
> +                       continue;
> +
> +               if (meta->nr_domains < (index - offset)) {
> +                       offset += meta->nr_domains;
> +                       continue;
> +               }
> +
> +               domain = meta->domains + (index - offset);
> +       }
> +
> +       BUG_ON(!domain);
> +
> +       return domain;
> +}
> +
>  int etnaviv_pm_query_dom(struct etnaviv_gpu *gpu,
>         struct drm_etnaviv_pm_domain *domain)
>  {
> -       const struct etnaviv_pm_domain_meta *meta = &doms_meta[domain->pipe];
> +       const unsigned int nr_domains = num_pm_domains(gpu);
>         const struct etnaviv_pm_domain *dom;
>
> -       if (domain->iter >= meta->nr_domains)
> +       if (domain->iter >= nr_domains)
>                 return -EINVAL;
>
> -       dom = meta->domains + domain->iter;
> +       dom = pm_domain(gpu, domain->iter);
>
>         domain->id = domain->iter;
>         domain->nr_signals = dom->nr_signals;
>         strncpy(domain->name, dom->name, sizeof(domain->name));
>
>         domain->iter++;
> -       if (domain->iter == meta->nr_domains)
> +       if (domain->iter == nr_domains)
>                 domain->iter = 0xff;
>
>         return 0;
> @@ -448,14 +491,14 @@ int etnaviv_pm_query_dom(struct etnaviv_gpu *gpu,
>  int etnaviv_pm_query_sig(struct etnaviv_gpu *gpu,
>         struct drm_etnaviv_pm_signal *signal)
>  {
> -       const struct etnaviv_pm_domain_meta *meta = &doms_meta[signal->pipe];
> +       const unsigned int nr_domains = num_pm_domains(gpu);
>         const struct etnaviv_pm_domain *dom;
>         const struct etnaviv_pm_signal *sig;
>
> -       if (signal->domain >= meta->nr_domains)
> +       if (signal->domain >= nr_domains)
>                 return -EINVAL;
>
> -       dom = meta->domains + signal->domain;
> +       dom = pm_domain(gpu, signal->domain);
>
>         if (signal->iter >= dom->nr_signals)
>                 return -EINVAL;
> --
> 2.24.1
>

ping

-- 
greets
--
Christian Gmeiner, MSc

https://christian-gmeiner.info/privacypolicy
