Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30DD019EC20
	for <lists+stable@lfdr.de>; Sun,  5 Apr 2020 16:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgDEOsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Apr 2020 10:48:02 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:36189 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgDEOsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Apr 2020 10:48:02 -0400
Received: by mail-yb1-f196.google.com with SMTP id i4so7302084ybl.3;
        Sun, 05 Apr 2020 07:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v+dqDvCPt/897rtlW7rn+HRZ8CXQjFzk7KCjChk3k24=;
        b=hNmVs66K30OIgjszWm08ENcKBGYBbmyqTsytRVdgaU8hiMRMsvs0UocE6U+1o2Cl9u
         UnhOtihY/4/dKGac5lGPw2uhsev2IFZLr7nh2SltrUZ/CEAjruNVEfJAu1xwfNj89yBo
         t6jqrh7D/AQWONdkAxfjoefdWy3JE2k1LgViJTxsqnKI8oqBHB3zDgVFJOdcN1e4HtKk
         S97UpoclL3VkZmeu2lhj3ko0vuHsCsOvnFaCraRWl7n0FiLQvAsO10Lhq/40WB0j27Cp
         rgtvjVLmOEJk+wJemh3IsBHV8fOnQ9E62iI/1KmyZP/yKFeKVUQI+nziwePMYfUfqQnE
         jRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v+dqDvCPt/897rtlW7rn+HRZ8CXQjFzk7KCjChk3k24=;
        b=IdxxZSGg0Ugz65z5KHTOrDJ+41hRP+hwWq/ruKoh0FGIvZEdi+FkLKKnaguiGqg3M/
         IXhU2oI9YGaHJo70+pjrTVwmEV5NSYeSnhxzmTkFLUAcbVhCEjtK2/GA9Gm5b6OYQCk4
         i52/0IhjzMFZlkcoRd7QNhp8MK7ty5TIYfrucLTiiBy/fsAZqHL+cp0rV8ycj+LCKLMp
         TMc1xB4oHRedctYlDz3VkW9mEMun+k5ulscFo47MhEKD3NChP/2j8s/kMJF9yz1z06uY
         NtjsOeTbzU9y9R6WTWAzxgYq7VBu9j0m8P6yB4z0g6yqH4gXrfbzK657YI4/lddFiDNm
         +pdA==
X-Gm-Message-State: AGi0PuZTfne1x3c1CgeYhBEEdw7WYWEzd5bKBOllqYzYPVoNjJXLTVU4
        BPfXqlkYGAEzs5Szn7V0pmAe/hgIbV7KRWvaJcsWng==
X-Google-Smtp-Source: APiQypLStyXEBg4fQEvKQp6utKnlk02OoH8tD0TAXmioeqlnHxkn0X/oq14OJ5qqcj+o7yJGUusu0tV5/tVYB2+d+RU=
X-Received: by 2002:a25:dcd4:: with SMTP id y203mr30504136ybe.483.1586098080938;
 Sun, 05 Apr 2020 07:48:00 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd@eucas1p1.samsung.com>
 <20200327162126.29705-1-m.szyprowski@samsung.com>
In-Reply-To: <20200327162126.29705-1-m.szyprowski@samsung.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Sun, 5 Apr 2020 10:47:49 -0400
Message-ID: <CADnq5_NpHvmRvzvh1aF293UDUXiHF4Dg1rRNkt7XbM_VB98JCg@mail.gmail.com>
Subject: Re: [PATCH v2] drm/prime: fix extracting of the DMA addresses from a scatterlist
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        linux-samsung-soc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        David Airlie <airlied@linux.ie>,
        Shane Francis <bigbeeshane@gmail.com>,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>,
        "for 3.8" <stable@vger.kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 12:23 PM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Scatterlist elements contains both pages and DMA addresses, but one
> should not assume 1:1 relation between them. The sg->length is the size
> of the physical memory chunk described by the sg->page, while
> sg_dma_len(sg) is the size of the DMA (IO virtual) chunk described by
> the sg_dma_address(sg).
>
> The proper way of extracting both: pages and DMA addresses of the whole
> buffer described by a scatterlist it to iterate independently over the
> sg->pages/sg->length and sg_dma_address(sg)/sg_dma_len(sg) entries.
>
> Fixes: 42e67b479eab ("drm/prime: use dma length macro when mapping sg")
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

Applied.  Thanks and sorry for the breakage.

Alex

> ---
>  drivers/gpu/drm/drm_prime.c | 37 +++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 1de2cde2277c..282774e469ac 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -962,27 +962,40 @@ int drm_prime_sg_to_page_addr_arrays(struct sg_table *sgt, struct page **pages,
>         unsigned count;
>         struct scatterlist *sg;
>         struct page *page;
> -       u32 len, index;
> +       u32 page_len, page_index;
>         dma_addr_t addr;
> +       u32 dma_len, dma_index;
>
> -       index = 0;
> +       /*
> +        * Scatterlist elements contains both pages and DMA addresses, but
> +        * one shoud not assume 1:1 relation between them. The sg->length is
> +        * the size of the physical memory chunk described by the sg->page,
> +        * while sg_dma_len(sg) is the size of the DMA (IO virtual) chunk
> +        * described by the sg_dma_address(sg).
> +        */
> +       page_index = 0;
> +       dma_index = 0;
>         for_each_sg(sgt->sgl, sg, sgt->nents, count) {
> -               len = sg_dma_len(sg);
> +               page_len = sg->length;
>                 page = sg_page(sg);
> +               dma_len = sg_dma_len(sg);
>                 addr = sg_dma_address(sg);
>
> -               while (len > 0) {
> -                       if (WARN_ON(index >= max_entries))
> +               while (pages && page_len > 0) {
> +                       if (WARN_ON(page_index >= max_entries))
>                                 return -1;
> -                       if (pages)
> -                               pages[index] = page;
> -                       if (addrs)
> -                               addrs[index] = addr;
> -
> +                       pages[page_index] = page;
>                         page++;
> +                       page_len -= PAGE_SIZE;
> +                       page_index++;
> +               }
> +               while (addrs && dma_len > 0) {
> +                       if (WARN_ON(dma_index >= max_entries))
> +                               return -1;
> +                       addrs[dma_index] = addr;
>                         addr += PAGE_SIZE;
> -                       len -= PAGE_SIZE;
> -                       index++;
> +                       dma_len -= PAGE_SIZE;
> +                       dma_index++;
>                 }
>         }
>         return 0;
> --
> 2.17.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
