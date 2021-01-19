Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6F62FC486
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 00:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbhASXNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 18:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729879AbhASXNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 18:13:18 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F14BC0613C1
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:12:38 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id c127so1200773wmf.5
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kJdfqz839OeseYYkmWz4yh6z5zvAjLz0yxVJ3bu4P2g=;
        b=smpsCbyHn0NnsknFBhgrLWNcTjBC2cOujZNIGIWjZUwrWZr3wtfLtSfdNEpdyXlrFc
         bTnGqluXpZ5/C8tyKdBVD8q8yX29bHUL0CJAiinunPPHQIT/VDNVd1npwF1v0r5N6rcn
         fdS2dswwTfgbBiZbKXJc4TKbqE+RxWFUXpITUA8fARK/B1Nms2Ct0O88BnZtQ6Z6rz0J
         G/xWFWFvwy4ovmUHlmdAy0LkdYk5hcBUEW+NCq4RtP2I72tbXzc10XJsoV9zzh9Db5QH
         OAQsUCrcgydDrGNAGLr35SVdRUcfL+AuY3/SxCyx5KaWst19r6ci+s73/8AtGMcZjU0e
         5O3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kJdfqz839OeseYYkmWz4yh6z5zvAjLz0yxVJ3bu4P2g=;
        b=mhQRWn4y66Sr6nPh6OWc3WWu9au6tjd6X+nJyVYeT+xmID1myjxtrxYWdfTtyovkaB
         I51JVwZlnQ3RVkqHaW4VF5F7rTQt7J2k8q38qR/IW53v59KbS7+qbOT11C5PiVcMFWFR
         NDTE7qHBdJdj+M3fgTV3w6u2L0T61Wx5QWUYF2VsvCpDKAbqhG988ME2qUQWoB/UHzHW
         +aXVtLCVDA4u1hj67/7Kf9qz+oFhUWbYiXRmms2n38M2O/Ws6Xb1VQISnUqV0SOqRoXl
         oXbiGZkwJbz1nBzdr+bTFsKe9Iyeptop3K3Wln4pIEjAWlBbzgUVVuKgkeHt4lwlT8tn
         IFYg==
X-Gm-Message-State: AOAM532ALfT+cLrp8++rNQJaCZpzlsDDRq64+zToqvDKGqLsoS9dEOr9
        zH/QllvAJfwHx7sZhwiZfSPyhlLE6omiuw9XJgS1xw==
X-Google-Smtp-Source: ABdhPJxTe6K+eqd0wxGdLv0AWWP9UYN9ZNOZKj8crhBvfDwZyzy2FzLxMxXw8Y7IY7riTOkOJecfM8Rcy1ApAJBqhCE=
X-Received: by 2002:a05:600c:2110:: with SMTP id u16mr1621013wml.65.1611097956708;
 Tue, 19 Jan 2021 15:12:36 -0800 (PST)
MIME-Version: 1.0
References: <20210119175336.4016923-1-marcorr@google.com> <20210119180024.GA28024@lst.de>
In-Reply-To: <20210119180024.GA28024@lst.de>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 19 Jan 2021 15:12:25 -0800
Message-ID: <CAA03e5GeGRLcLzp8d6pOC7UnQq9mZYzgW9rQgV3XHMb5gfsLWQ@mail.gmail.com>
Subject: Re: [PATCH] nvme: fix handling mapping failure
To:     Christoph Hellwig <hch@lst.de>
Cc:     kbusch@kernel.org, axboe@fb.com, sagi@grimberg.me,
        Jianxiong Gao <jxgao@google.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 10:00 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Jan 19, 2021 at 09:53:36AM -0800, Marc Orr wrote:
> > This patch ensures that when `nvme_map_data()` fails to map the
> > addresses in a scatter/gather list:
> >
> > * The addresses are not incorrectly unmapped. The underlying
> > scatter/gather code unmaps the addresses after detecting a failure.
> > Thus, unmapping them again in the driver is a bug.
> > * The DMA pool allocations are not deallocated when they were never
> > allocated.
> >
> > The bug that motivated this patch was the following sequence, which
> > occurred within the NVMe driver, with the kernel flag `swiotlb=force`.
> >
> > * NVMe driver calls dma_direct_map_sg()
> > * dma_direct_map_sg() fails part way through the scatter gather/list
> > * dma_direct_map_sg() calls dma_direct_unmap_sg() to unmap any entries
> >   succeeded.
> > * NVMe driver calls dma_direct_unmap_sg(), redundantly, leading to a
> >   double unmap, which is a bug.
> >
> > Before this patch, I observed intermittent application- and VM-level
> > failures when running a benchmark, fio, in an AMD SEV guest. This patch
> > resolves the failures.
>
> I think the right way to fix this is to just do a proper unwind insted
> of calling a catchall function.  Can you try this patch?

Done. It works great, thanks! Shall I send out a v2 with what you've proposed?

> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 25456d02eddb8c..47d7075053b6b2 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -842,7 +842,7 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
>         sg_init_table(iod->sg, blk_rq_nr_phys_segments(req));
>         iod->nents = blk_rq_map_sg(req->q, req, iod->sg);
>         if (!iod->nents)
> -               goto out;
> +               goto out_free_sg;
>
>         if (is_pci_p2pdma_page(sg_page(iod->sg)))
>                 nr_mapped = pci_p2pdma_map_sg_attrs(dev->dev, iod->sg,
> @@ -851,16 +851,25 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
>                 nr_mapped = dma_map_sg_attrs(dev->dev, iod->sg, iod->nents,
>                                              rq_dma_dir(req), DMA_ATTR_NO_WARN);
>         if (!nr_mapped)
> -               goto out;
> +               goto out_free_sg;
>
>         iod->use_sgl = nvme_pci_use_sgls(dev, req);
>         if (iod->use_sgl)
>                 ret = nvme_pci_setup_sgls(dev, req, &cmnd->rw, nr_mapped);
>         else
>                 ret = nvme_pci_setup_prps(dev, req, &cmnd->rw);
> -out:
>         if (ret != BLK_STS_OK)
> -               nvme_unmap_data(dev, req);
> +               goto out_dma_unmap;
> +       return BLK_STS_OK;
> +
> +out_dma_unmap:
> +       if (is_pci_p2pdma_page(sg_page(iod->sg)))
> +               pci_p2pdma_unmap_sg(dev->dev, iod->sg, iod->nents,
> +                                   rq_dma_dir(req));
> +       else
> +               dma_unmap_sg(dev->dev, iod->sg, iod->nents, rq_dma_dir(req));

Do you think it's worth hoisting this sg unmap snippet into a helper
that can be called from both here, as well as nvme_unmap_data()?

> +out_free_sg:
> +       mempool_free(iod->sg, dev->iod_mempool);
>         return ret;
>  }
>
