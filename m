Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0659E151213
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 22:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgBCVuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 16:50:01 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32966 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgBCVuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 16:50:01 -0500
Received: by mail-wm1-f66.google.com with SMTP id m10so802745wmc.0
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 13:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bz9H+rEoz42N2PohEklI4SsWSqfVLbtbYz6f4dlWqHo=;
        b=XGoDm4C7Ws0L6899IO4mI2wTFfMnh2NrICZh4Oix8pkovjle7RGdl5wTXqF5cBNXLn
         HVCrk1A7SWTs2MuCsgoDLl6kewc5yGJviw9sEaYNstVqguBv3EumaC+QUZonn4WiRw59
         L6YJJhB3Ss47Movu5i3OMEKFpYkC8N1rfnyxtcFccfVINeWPD7k64nTH4/81lPG0iYo2
         qSD6O62eCD2LC7Q26R4gJs/FSCt80zBkEGd3xahN9+yzMy+kvueE+F/RLtEpcA6e9BvH
         XWiRVtzvE6upcKVdr8Wy3KiU7tHE4Xg9Qa+d4UVA0hN6KVHGOKBx/FXGJC6GTYLKJdTm
         oJJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bz9H+rEoz42N2PohEklI4SsWSqfVLbtbYz6f4dlWqHo=;
        b=B4qKkGtAMJdz5fPpq3n4D7lx0uMFqN6+9yKIPtckYyX+elYFAa8k3xYK9ITXOAGNjD
         V8Uf8Kpk6kfWyOwA2GqGNdHuUR+sEFERwwBU3C/GV7RLFLM0/WBPe/TExBioxOnPZOOq
         +u54cXO6releEsf0psNv/5Dz0rEVicOYFsj1AJBD6bZpUi/CY9u7u8j4aKErGtKZWLZc
         +ZIipog4MYtVEhO2t3VyNS0aUx0nqVP3fEjijBEfn69CqcelL7MlQu7qa7pB5wA+h2GV
         Q5wuQ7/MPNHI+x+n4R3wktDJghzIa1VPT1+xYe0n5fsLyRnfX/TYIJp4/a0RW95Sb8Kn
         tGVA==
X-Gm-Message-State: APjAAAWuTh+hjIvdMjNuXtrDdSaaEwYkiHac4Vi/fgx3v8iAhaObyoIE
        JKlum9OkcK7HSf3Iz+6YKVAc5IK3oVhDkzLfs3tJR/IZ
X-Google-Smtp-Source: APXvYqyfoL3COtXhpTnhOUXZO+tkz1VpE8SA5wR1Bis4thbGX3S9VMZLXkKBQqgF1m53SOrLdMLOQmfMZhgL1gJ+njc=
X-Received: by 2002:a05:600c:218b:: with SMTP id e11mr1105264wme.56.1580766599264;
 Mon, 03 Feb 2020 13:49:59 -0800 (PST)
MIME-Version: 1.0
References: <20200202171635.4039044-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200202171635.4039044-1-chris@chris-wilson.co.uk>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 3 Feb 2020 16:49:48 -0500
Message-ID: <CADnq5_N7azVKP0iB1NMWz7KM79cU7HvR7Ssh1nbLDyBP946hxw@mail.gmail.com>
Subject: Re: [PATCH 1/5] drm: Remove PageReserved manipulation from drm_pci_alloc
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 2, 2020 at 12:16 PM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> drm_pci_alloc/drm_pci_free are very thin wrappers around the core dma
> facilities, and we have no special reason within the drm layer to behave
> differently. In particular, since
>
> commit de09d31dd38a50fdce106c15abd68432eebbd014
> Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Date:   Fri Jan 15 16:51:42 2016 -0800
>
>     page-flags: define PG_reserved behavior on compound pages
>
>     As far as I can see there's no users of PG_reserved on compound pages.
>     Let's use PF_NO_COMPOUND here.
>
> it has been illegal to combine GFP_COMP with SetPageReserved, so lets
> stop doing both and leave the dma layer to its own devices.
>
> Reported-by: Taketo Kabe

Needs an email address.

> Closes: https://gitlab.freedesktop.org/drm/intel/issues/1027

Should be Bug: rather than Closes:

> Fixes: de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: <stable@vger.kernel.org> # v4.5+

With those fixed:
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/drm_pci.c | 23 ++---------------------
>  1 file changed, 2 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
> index f2e43d341980..d16dac4325f9 100644
> --- a/drivers/gpu/drm/drm_pci.c
> +++ b/drivers/gpu/drm/drm_pci.c
> @@ -51,8 +51,6 @@
>  drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t align)
>  {
>         drm_dma_handle_t *dmah;
> -       unsigned long addr;
> -       size_t sz;
>
>         /* pci_alloc_consistent only guarantees alignment to the smallest
>          * PAGE_SIZE order which is greater than or equal to the requested size.
> @@ -68,20 +66,13 @@ drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t ali
>         dmah->size = size;
>         dmah->vaddr = dma_alloc_coherent(&dev->pdev->dev, size,
>                                          &dmah->busaddr,
> -                                        GFP_KERNEL | __GFP_COMP);
> +                                        GFP_KERNEL);
>
>         if (dmah->vaddr == NULL) {
>                 kfree(dmah);
>                 return NULL;
>         }
>
> -       /* XXX - Is virt_to_page() legal for consistent mem? */
> -       /* Reserve */
> -       for (addr = (unsigned long)dmah->vaddr, sz = size;
> -            sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
> -               SetPageReserved(virt_to_page((void *)addr));
> -       }
> -
>         return dmah;
>  }
>
> @@ -94,19 +85,9 @@ EXPORT_SYMBOL(drm_pci_alloc);
>   */
>  void __drm_legacy_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
>  {
> -       unsigned long addr;
> -       size_t sz;
> -
> -       if (dmah->vaddr) {
> -               /* XXX - Is virt_to_page() legal for consistent mem? */
> -               /* Unreserve */
> -               for (addr = (unsigned long)dmah->vaddr, sz = dmah->size;
> -                    sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
> -                       ClearPageReserved(virt_to_page((void *)addr));
> -               }
> +       if (dmah->vaddr)
>                 dma_free_coherent(&dev->pdev->dev, dmah->size, dmah->vaddr,
>                                   dmah->busaddr);
> -       }
>  }
>
>  /**
> --
> 2.25.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
