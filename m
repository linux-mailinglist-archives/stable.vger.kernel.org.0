Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069751D4AE1
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 12:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgEOK0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 06:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgEOK0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 06:26:21 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704AFC061A0C;
        Fri, 15 May 2020 03:26:21 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id v192so446500vkd.3;
        Fri, 15 May 2020 03:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aMr6yoMCs38gQht1Q+DpQUXerErR+hPcKVQWVKr1Hes=;
        b=LHEtd14wpQ/xvWY0nqjoWZ0YY9SmVwQnPrbF+0apmeD++I78lItVhGT1UcqscnpnWx
         ntK8wfJX2BH+8NwNMVAMh2NcWXaqqcd9hAPCKw56r3AAI+GTF2ZQVNEkAuoYB5AEZA/t
         hZuZt9t+5gRlJHsCvX8BGnLVPayTEGIenUkwZs4fSeMdKsFIStxjIDqSCrI948yIgQpO
         SLe2hhAmno33uYTFdQLRHRtyVJGjzVipU/+iNrdwNAGoPwIakWI8Ti5/I51TkLA8/Apl
         psxtoaRmCh6SYhQ1ZyD1j9yLP+fkx3jqNi6k6LSoJikka6WqNBcHqV0xxPJctBim2/Qu
         mXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aMr6yoMCs38gQht1Q+DpQUXerErR+hPcKVQWVKr1Hes=;
        b=Gzrnxi3ec5JrJqJiTKIKXzPu7EyuyWyBcbHL5aUlVvxOrcQwUTYHVqYsIxWJ2EIf4V
         PoeplsZNGh4f6JDJNieVSzfQW+94S/yvE5+5LF7j8/oj6hvhkr7WxPySzW21oVQ6dEYv
         eRJ3HfKZJQCBEdGfrpxFcJBN1tevN41BdcQ6yxRm5HXJ4Dg41auLHWrMS/0fjKPNosSC
         HCZSItIVKvYHM/8bNWD8wlXjnEgbUPCGM8S6vdKfdvC6Z2n/OjujmUi1u3NivRIEiL+/
         dg3k24d1ymIxZdFwT3uGOLQUHgNtYRwZif7l+FFF6JkGouM8Abn1FiGdyELe0L4qBGQk
         mB4A==
X-Gm-Message-State: AOAM530oD0lEmrRkb7su8QQLPanHG7z9mvaFbLsTy5Yphmxe3d03w2le
        O3lJIDEkVFYRCpJvgZyGc8svTbc/O0ft8jbtfyE=
X-Google-Smtp-Source: ABdhPJzmtQKzGpjXUkr9+/boRd3M8JqTHwX9p5GOdA5Yt+P4VvYy+uJALJLFu1sI+rl3gWZYfXMVYNZz7LZ8EDXJj+o=
X-Received: by 2002:a1f:24ce:: with SMTP id k197mr2045827vkk.13.1589538380663;
 Fri, 15 May 2020 03:26:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200511123846.96594-1-christian.gmeiner@gmail.com>
 <CAH9NwWcJNhUVkzd0KAfJyxNZJ9a71KLzipW+qRwhgEWUmnnxmg@mail.gmail.com> <X0BDAQ.L99CTJZCDEJE3@crapouillou.net>
In-Reply-To: <X0BDAQ.L99CTJZCDEJE3@crapouillou.net>
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
Date:   Fri, 15 May 2020 12:26:09 +0200
Message-ID: <CAH9NwWcjrd2cNrVpMaHQPyrwzKASetGXcb=sjA4VDThyV6h5Vg@mail.gmail.com>
Subject: Re: [PATCH] drm/etnaviv: fix perfmon domain interation
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        The etnaviv authors <etnaviv@lists.freedesktop.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul

Am Fr., 15. Mai 2020 um 12:12 Uhr schrieb Paul Cercueil <paul@crapouillou.n=
et>:
>
> Hi Christian,
>
> Le ven. 15 mai 2020 =C3=A0 12:09, Christian Gmeiner
> <christian.gmeiner@gmail.com> a =C3=A9crit :
> > Am Mo., 11. Mai 2020 um 14:38 Uhr schrieb Christian Gmeiner
> > <christian.gmeiner@gmail.com>:
> >>
> >>  The GC860 has one GPU device which has a 2d and 3d core. In this
> >> case
> >>  we want to expose perfmon information for both cores.
> >>
> >>  The driver has one array which contains all possible perfmon domains
> >>  with some meta data - doms_meta. Here we can see that for the GC860
> >>  two elements of that array are relevant:
> >>
> >>    doms_3d: is at index 0 in the doms_meta array with 8 perfmon
> >> domains
> >>    doms_2d: is at index 1 in the doms_meta array with 1 perfmon
> >> domain
> >>
> >>  The userspace driver wants to get a list of all perfmon domains and
> >>  their perfmon signals. This is done by iterating over all domains
> >> and
> >>  their signals. If the userspace driver wants to access the domain
> >> with
> >>  id 8 the kernel driver fails and returns invalid data from doms_3d
> >> with
> >>  and invalid offset.
> >>
> >>  This results in:
> >>    Unable to handle kernel paging request at virtual address 00000000
> >>
> >>  On such a device it is not possible to use the userspace driver at
> >> all.
> >>
> >>  The fix for this off-by-one error is quite simple.
> >>
> >>  Reported-by: Paul Cercueil <paul@crapouillou.net>
> >>  Tested-by: Paul Cercueil <paul@crapouillou.net>
> >>  Fixes: ed1dd899baa3 ("drm/etnaviv: rework perfmon query
> >> infrastructure")
> >>  Cc: stable@vger.kernel.org
> >>  Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> >>  ---
> >>   drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >>  diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> >> b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> >>  index e6795bafcbb9..35f7171e779a 100644
> >>  --- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> >>  +++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> >>  @@ -453,7 +453,7 @@ static const struct etnaviv_pm_domain
> >> *pm_domain(const struct etnaviv_gpu *gpu,
> >>                  if (!(gpu->identity.features & meta->feature))
> >>                          continue;
> >>
> >>  -               if (meta->nr_domains < (index - offset)) {
> >>  +               if ((meta->nr_domains - 1) < (index - offset)) {
> >>                          offset +=3D meta->nr_domains;
> >>                          continue;
> >>                  }
> >>  --
> >>  2.26.2
> >>
> >
> > ping
>
> I'll merge it tomorrow if there's no further feedback.
>

Works for me too.. as far as Lucas (the maintainer) is happy with it.

--=20
greets
--
Christian Gmeiner, MSc

https://christian-gmeiner.info/privacypolicy
