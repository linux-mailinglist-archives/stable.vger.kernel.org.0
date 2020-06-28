Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3BE20CAF8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 00:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgF1Wkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 18:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgF1Wkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 18:40:36 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F93DC03E979;
        Sun, 28 Jun 2020 15:40:36 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id o4so7547848ybp.0;
        Sun, 28 Jun 2020 15:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=coaSMhmb1rnGuqJBzIF97ldJoVfPljIOjdLaUOmjyJU=;
        b=irANrFIsBhZkj09kMLPwMz4+kSpIlnGrWyjCx0QAgZwuR1Lt2hBaViB4sqhQWEkjmc
         to9bNMUOJaHScT32FQF2VQCKXShlls5UIKSD0/r08xQHQ5kIucQnMwBLd1T7/1u61Zl+
         oGDKVtQy4lXc3/UxXGQYAT1A4/+lTP7nu7g6587ApeIQsGNfrNVbAD7KISx8OHyXiU6o
         unC/9xddYs0w4QTonNhyZ8qO0+rz2aPoTS82DRk/FQJ3T5mqV61YrPlSvzojOKygrK+g
         0rGEe4OuAffa6wwcfv+Szhno3tlM7U0SKu+cSQaFL7t4FBGZfyMLgHZP7q9QuaUJZnge
         9PxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=coaSMhmb1rnGuqJBzIF97ldJoVfPljIOjdLaUOmjyJU=;
        b=SMJjSK44FdAel5etrQEEmq+6pQdLzLuLlZUE2gLc+jjWnCRMli3DqP1J/e2cfOgzIB
         oKwpOBVmlJaoJCVzmxOmowHURR/G36+ZApwEylJFPnd5epoXRa4xkuUx9b82xL2823zo
         qZ9zQsUheC+fgS96d+IlX2VAskg4IEX3BQGXgMdKfbcxootAgvIeDFXERmjhrjADAiR7
         c5rmibzdGZmE+sK9hIzp4DnizXA4XIkS7FnO+GjjK6xFQdoDM5zSb2yd4xZG/VBxQrmb
         k4/9UzwxH3JG4U/WZvaFP/kns8uDDXR0hl8KIBdcZvUMuEHiG0raOIYe8VBntQ5axdcu
         hr5w==
X-Gm-Message-State: AOAM531ZBTb3ek2sKaUtajQed/XgNtS2qQHAb9K+l2jFt/UmuHoxLt/z
        DLpwNkEVOw4szU0p2T2v3wAD3nYPx/yaE6LHuLI=
X-Google-Smtp-Source: ABdhPJxSEYgMgAKzF/ouhNsjt/4IssbdrLDq/6F8NVGeqgsOR9G06asdGgffL8B0zUIg0uAFhbXmTg+dZ0D6lZ/pJs0=
X-Received: by 2002:a25:b992:: with SMTP id r18mr21123478ybg.283.1593384034471;
 Sun, 28 Jun 2020 15:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200626210337.20089-1-rcampbell@nvidia.com>
In-Reply-To: <20200626210337.20089-1-rcampbell@nvidia.com>
From:   Ben Skeggs <skeggsb@gmail.com>
Date:   Mon, 29 Jun 2020 08:40:22 +1000
Message-ID: <CACAvsv4Oho1pKzPU7er2Sed5qyy0d2JZKsNoHvrZhvhtBygPjg@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH v2] nouveau: fix page fault on device private memory
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     ML nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Jason Gunthorpe <jgg@mellanox.com>,
        Ben Skeggs <bskeggs@redhat.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 27 Jun 2020 at 07:04, Ralph Campbell <rcampbell@nvidia.com> wrote:
>
> If system memory is migrated to device private memory and no GPU MMU
> page table entry exists, the GPU will fault and call hmm_range_fault()
> to get the PFN for the page. Since the .dev_private_owner pointer in
> struct hmm_range is not set, hmm_range_fault returns an error which
> results in the GPU program stopping with a fatal fault.
> Fix this by setting .dev_private_owner appropriately.
>
> Fixes: 08ddddda667b ("mm/hmm: check the device private page owner in hmm_range_fault()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> ---
>
> This is based on Linux-5.8.0-rc2 and is for Ben Skeggs nouveau tree.
> It doesn't depend on any of the other nouveau/HMM changes I have
> recently posted.
>
> Resending to include stable@vger.org and adding Jason's reviewed-by.
Thanks Ralph,

I've got the patch locally, and will push it out later on today.

Ben.

>
>  drivers/gpu/drm/nouveau/nouveau_svm.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
> index ba9f9359c30e..6586d9d39874 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_svm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
> @@ -562,6 +562,7 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
>                 .end = notifier->notifier.interval_tree.last + 1,
>                 .pfn_flags_mask = HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WRITE,
>                 .hmm_pfns = hmm_pfns,
> +               .dev_private_owner = drm->dev,
>         };
>         struct mm_struct *mm = notifier->notifier.mm;
>         int ret;
> --
> 2.20.1
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/nouveau
