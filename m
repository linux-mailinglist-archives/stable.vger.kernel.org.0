Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27451D4A7F
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 12:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgEOKKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 06:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgEOKKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 06:10:10 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F48C061A0C;
        Fri, 15 May 2020 03:10:10 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id p139so430964vkd.7;
        Fri, 15 May 2020 03:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lhigMlxhzrJnKPEuZs499FlSgqJIMriFF+MKS12l+uA=;
        b=gp63hVTHYVuojW36b06JYhiTReOtH2+pg7/v0FgV+Ta6hcdtZGvwPDyvoqSOxSGDtN
         oP4ZHdDKFOvyHJR10A/6nYElof0kMVJDPAoNTgKZxEIGa+nCyCfwHCiI7lFXwc0qaMzA
         QAfKbSJ13sKqc8f+OXYJ9n35j/TnMdw1ZWoDyj9c/ixU0QS+YJHW8nSU546+3aSOA6Ux
         XF8IKhCQyLoOHK9JXy+j+yExcJ6wrEbHiSh9Z0DxkEif/uCZ5Z55ljyO0QHaypYZ3Us0
         8oC9LXlPJzcj52ZMtS73p+KmzpCK5aGkyR/IadwzfCicaErtAohw9QYfP8bff+OpX50s
         iKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lhigMlxhzrJnKPEuZs499FlSgqJIMriFF+MKS12l+uA=;
        b=tCtS09q3p1KPLZFo5ean+FzflpaS5ZMSZrFl+Hr71WC/6ZqWQxWuSdGFHzNgQBv3Px
         DMNtk7NidJQui8a5ShAk/BOY6ASPH2NvuRD2i4lE/8DLzp6/DwUnGe5xhK7mkRW5G1DU
         XMDIUp1APsVnezb/fdUj3XOKCh4Uo4kyoV2t9ATTOCLtoTifmu5hzHiPVxrLKUap7HIt
         s4CaTO/uUQ3kblCukEG+mxgMxpiTKzZas4l+200MvUbHtDyCUOce6LGNTP5N7LgkIm16
         xRcwhpFjiAt46ZHwDPOv7UmBZ3DRa72M1TVL/JjoqmJOD9x4RQevSMSTcq8YdrAIsp1M
         8vWQ==
X-Gm-Message-State: AOAM533npPTX10LG3yKsZsqZxlAcABMDJ+CIoQT8trB4sIYtHn7ll9vs
        C3o3f1GTFkIOpIvkQBs8eN8KqAVeNcviL3LJC63F+GtI3nA=
X-Google-Smtp-Source: ABdhPJzaNbylRYStH6B+ZztSv24YNQNGSipyPFdD8gsTBnMBMP46eaL7d0io05RZRZvcuJ3Mg3DYYVRNdgElHQ0yNRE=
X-Received: by 2002:a1f:cd06:: with SMTP id d6mr1918886vkg.94.1589537408919;
 Fri, 15 May 2020 03:10:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200511123846.96594-1-christian.gmeiner@gmail.com>
In-Reply-To: <20200511123846.96594-1-christian.gmeiner@gmail.com>
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
Date:   Fri, 15 May 2020 12:09:57 +0200
Message-ID: <CAH9NwWcJNhUVkzd0KAfJyxNZJ9a71KLzipW+qRwhgEWUmnnxmg@mail.gmail.com>
Subject: Re: [PATCH] drm/etnaviv: fix perfmon domain interation
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org,
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

Am Mo., 11. Mai 2020 um 14:38 Uhr schrieb Christian Gmeiner
<christian.gmeiner@gmail.com>:
>
> The GC860 has one GPU device which has a 2d and 3d core. In this case
> we want to expose perfmon information for both cores.
>
> The driver has one array which contains all possible perfmon domains
> with some meta data - doms_meta. Here we can see that for the GC860
> two elements of that array are relevant:
>
>   doms_3d: is at index 0 in the doms_meta array with 8 perfmon domains
>   doms_2d: is at index 1 in the doms_meta array with 1 perfmon domain
>
> The userspace driver wants to get a list of all perfmon domains and
> their perfmon signals. This is done by iterating over all domains and
> their signals. If the userspace driver wants to access the domain with
> id 8 the kernel driver fails and returns invalid data from doms_3d with
> and invalid offset.
>
> This results in:
>   Unable to handle kernel paging request at virtual address 00000000
>
> On such a device it is not possible to use the userspace driver at all.
>
> The fix for this off-by-one error is quite simple.
>
> Reported-by: Paul Cercueil <paul@crapouillou.net>
> Tested-by: Paul Cercueil <paul@crapouillou.net>
> Fixes: ed1dd899baa3 ("drm/etnaviv: rework perfmon query infrastructure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> ---
>  drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> index e6795bafcbb9..35f7171e779a 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> @@ -453,7 +453,7 @@ static const struct etnaviv_pm_domain *pm_domain(const struct etnaviv_gpu *gpu,
>                 if (!(gpu->identity.features & meta->feature))
>                         continue;
>
> -               if (meta->nr_domains < (index - offset)) {
> +               if ((meta->nr_domains - 1) < (index - offset)) {
>                         offset += meta->nr_domains;
>                         continue;
>                 }
> --
> 2.26.2
>

ping

-- 
greets
--
Christian Gmeiner, MSc

https://christian-gmeiner.info/privacypolicy
