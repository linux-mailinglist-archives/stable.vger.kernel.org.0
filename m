Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D9D80003
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 20:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405601AbfHBSHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 14:07:07 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:44219 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731545AbfHBSHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 14:07:06 -0400
Received: by mail-yb1-f193.google.com with SMTP id a14so27166846ybm.11
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 11:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bBn8yXU4CODJjYnhf7GV8IhJVIfOc9c4zo4swZ/RpwM=;
        b=GUAJxq/57p+FbGnnyKgH4ckcS+4Gar7Xb5JyinSlH3oQYwgDI/Up5w6xlTo4PpnWX0
         RR9uqukm4jRlFAO+4NVHCNAluAZuXLORoqM0NAObocnJ+OsCaM6Pqa/MK0kARq1U7Fcd
         a2yENTc1JirjM/hV53s0lDrizQw6/7/fAulvHqAbswm5/v1EHLA1Jmq8elbhlAW8yVA1
         yExFSdT9fETyaGa3eymRP0joKRInvAzBxg3eLFL49F1FQbfYwe2lh+LKGVVpBoXGlmqb
         PpgMAco6vDcHtS3t6Q6XYg13hmAA1RbfJzP+r+eS9O1MtmoUl+mZFP89JGBOI7R1ezBi
         aIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bBn8yXU4CODJjYnhf7GV8IhJVIfOc9c4zo4swZ/RpwM=;
        b=NUymg8ARLkKvsFmrwdzUyxlddpGyZF4/hFVStsektpYRocLHd0Lo8ZnILZv1hpd2EF
         UHJppWr9SqMOzijHYmyRBNOCMRBY2UkIGogAbXpperG+e5bNDdJp+lOljB+pQs3JNL5G
         feubMSqkrNHF/8imtJbow/FLxtSs6UTndeabWZihncYCVz3wG4dgIHSTxvaR8/O3OrPD
         vny4QFdmKBGRkr+gHT+6K1rWgCUFDKLM6pNK5sOhRIrVZNGPuLMstSqCF46vGnG19FQK
         usd9p0WFHyJB1LnluuytdfJ6KTrsDpRUI4EayeK9nEAXXp7HilsbdfdXT3rwtGTJUV74
         BXqQ==
X-Gm-Message-State: APjAAAXoBrrpDxF0ow4uQ8Ul9zeu9jT8319HV1cmA88sJrp2Fh/ETJeT
        +96PTHqPz2nGogTm3PmymZhOteTWagxCmEx6gfjqCQ==
X-Google-Smtp-Source: APXvYqyZUNSB3dDoqUhXvtopbmcotnb2jOfF8yNKP88uWWILbMsk39JGIk7khT5TSyEOaynqeMOVMuxRK2BjmKQt6CY=
X-Received: by 2002:a25:2d43:: with SMTP id s3mr60055319ybe.209.1564769225561;
 Fri, 02 Aug 2019 11:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190802132422.13963-1-sashal@kernel.org> <20190802132422.13963-11-sashal@kernel.org>
In-Reply-To: <20190802132422.13963-11-sashal@kernel.org>
From:   Sean Paul <sean@poorly.run>
Date:   Fri, 2 Aug 2019 14:06:29 -0400
Message-ID: <CAMavQKK_DrnefqK4ZP=7yGdjX0q-p=v9Hy4DOvcggma11pLHiA@mail.gmail.com>
Subject: Re: [Freedreno] [PATCH AUTOSEL 4.14 11/30] drm/msm: stop abusing
 dma_map/unmap for cache
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Rob Clark <robdclark@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        freedreno <freedreno@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 2, 2019 at 9:24 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Rob Clark <robdclark@chromium.org>
>
> [ Upstream commit 0036bc73ccbe7e600a3468bf8e8879b122252274 ]
>

Hi Sasha,
FYI, this commit should be paired with
https://cgit.freedesktop.org/drm/drm/commit/?h=drm-fixes&id=3de433c5b38af49a5fc7602721e2ab5d39f1e69c

Sean

> Recently splats like this started showing up:
>
>    WARNING: CPU: 4 PID: 251 at drivers/iommu/dma-iommu.c:451 __iommu_dma_unmap+0xb8/0xc0
>    Modules linked in: ath10k_snoc ath10k_core fuse msm ath mac80211 uvcvideo cfg80211 videobuf2_vmalloc videobuf2_memops vide
>    CPU: 4 PID: 251 Comm: kworker/u16:4 Tainted: G        W         5.2.0-rc5-next-20190619+ #2317
>    Hardware name: LENOVO 81JL/LNVNB161216, BIOS 9UCN23WW(V1.06) 10/25/2018
>    Workqueue: msm msm_gem_free_work [msm]
>    pstate: 80c00005 (Nzcv daif +PAN +UAO)
>    pc : __iommu_dma_unmap+0xb8/0xc0
>    lr : __iommu_dma_unmap+0x54/0xc0
>    sp : ffff0000119abce0
>    x29: ffff0000119abce0 x28: 0000000000000000
>    x27: ffff8001f9946648 x26: ffff8001ec271068
>    x25: 0000000000000000 x24: ffff8001ea3580a8
>    x23: ffff8001f95ba010 x22: ffff80018e83ba88
>    x21: ffff8001e548f000 x20: fffffffffffff000
>    x19: 0000000000001000 x18: 00000000c00001fe
>    x17: 0000000000000000 x16: 0000000000000000
>    x15: ffff000015b70068 x14: 0000000000000005
>    x13: 0003142cc1be1768 x12: 0000000000000001
>    x11: ffff8001f6de9100 x10: 0000000000000009
>    x9 : ffff000015b78000 x8 : 0000000000000000
>    x7 : 0000000000000001 x6 : fffffffffffff000
>    x5 : 0000000000000fff x4 : ffff00001065dbc8
>    x3 : 000000000000000d x2 : 0000000000001000
>    x1 : fffffffffffff000 x0 : 0000000000000000
>    Call trace:
>     __iommu_dma_unmap+0xb8/0xc0
>     iommu_dma_unmap_sg+0x98/0xb8
>     put_pages+0x5c/0xf0 [msm]
>     msm_gem_free_work+0x10c/0x150 [msm]
>     process_one_work+0x1e0/0x330
>     worker_thread+0x40/0x438
>     kthread+0x12c/0x130
>     ret_from_fork+0x10/0x18
>    ---[ end trace afc0dc5ab81a06bf ]---
>
> Not quite sure what triggered that, but we really shouldn't be abusing
> dma_{map,unmap}_sg() for cache maint.
>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Tested-by: Stephen Boyd <swboyd@chromium.org>
> Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
> Signed-off-by: Rob Clark <robdclark@chromium.org>
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190630124735.27786-1-robdclark@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/msm/msm_gem.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
> index f2df718af370d..3a91ccd92c473 100644
> --- a/drivers/gpu/drm/msm/msm_gem.c
> +++ b/drivers/gpu/drm/msm/msm_gem.c
> @@ -108,7 +108,7 @@ static struct page **get_pages(struct drm_gem_object *obj)
>                  * because display controller, GPU, etc. are not coherent:
>                  */
>                 if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
> -                       dma_map_sg(dev->dev, msm_obj->sgt->sgl,
> +                       dma_sync_sg_for_device(dev->dev, msm_obj->sgt->sgl,
>                                         msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
>         }
>
> @@ -138,7 +138,7 @@ static void put_pages(struct drm_gem_object *obj)
>                          * GPU, etc. are not coherent:
>                          */
>                         if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
> -                               dma_unmap_sg(obj->dev->dev, msm_obj->sgt->sgl,
> +                               dma_sync_sg_for_cpu(obj->dev->dev, msm_obj->sgt->sgl,
>                                              msm_obj->sgt->nents,
>                                              DMA_BIDIRECTIONAL);
>
> --
> 2.20.1
>
> _______________________________________________
> Freedreno mailing list
> Freedreno@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/freedreno
