Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8645C10307B
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 01:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfKTACU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 19:02:20 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33086 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfKTACU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 19:02:20 -0500
Received: by mail-il1-f196.google.com with SMTP id m5so2150613ilq.0;
        Tue, 19 Nov 2019 16:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XRuRyFkUCUOdWjwJNkpxkVE1L+haL5tEbBGbuI6HeJc=;
        b=Dqbh8o1j67JQZPE49aQOSNgQranyZAi7jBL5zHRpSSRxfSbmz/uv/Mvo3ujDaEmaKc
         pJgBKlY2K3rA9dkFyNw5iW23GHEibQA/isdNIWVDDxsF5qmYQkxtWwwTnmJ+H+oOqBET
         6R2wkSZToOd7C25l1QyosTQs7j7ZhYE8FGNeQDR5HHQIucNWp21rM9edY73fTBuxVclA
         WR4ucWcGN3CWcIlcnUnrjtvzzBsrClHF9HEwcpUXOMjOl/Oj3EIElvOH9HpwVZ5fsIRH
         j4spZ0MsAbXKZTIyx4xr2Un0QSx2EXd5Rp4SyqJBYcfiyzf9gkXod++7v5I0tJUFlagU
         7p3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XRuRyFkUCUOdWjwJNkpxkVE1L+haL5tEbBGbuI6HeJc=;
        b=YzVZdpVgq0+d0k6N1KFEYYI1pJfQk/W3zglLcZuZq0dYBUKuDe08L6jU4cAT0tveDG
         0SSwkOXi91FKUa4oXLrNcRJsGmP0dBen9s3fz/6XkCgZ+imp71O8QhkD0s1OrkUywAyt
         +waCyYQwj2rjgH2Jksz+A+mWdeRB5eSlk4nV3yvvWe2W8NiNaYzHc0SYKTPgTZlXkPpN
         0LXgDh/I8KQyH+RjEiGiVEzh/4yuQcSyayKCxeEps/eBnXmZUKKTTNMtTVou2q4b+m5m
         S6SN0FUHa2tHUlkljnpP58JrfMPJhhlrK96VT3GN0BukSCBkVZKsSTceMSvd82AolfZU
         Iuow==
X-Gm-Message-State: APjAAAVL9t1W4xh+FQHBOWUCNa32iyt/FcKgMmRywVjpJgp7s4tYmsPM
        5+WnZ7eNTYB3NzUy5pCch4Bb55gfs+d/nNsdzDk=
X-Google-Smtp-Source: APXvYqzllv9hd/SyZA8krBsksyfbdkhS7M7f8nY7mdQHtRo/mS4gY+0ta4t4ecyCyC9LyDUdaLBbuqY5kZQWez+0iXg=
X-Received: by 2002:a92:9e90:: with SMTP id s16mr464341ilk.237.1574208139514;
 Tue, 19 Nov 2019 16:02:19 -0800 (PST)
MIME-Version: 1.0
References: <157418493888.1639105.6922809760655305210.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <157418493888.1639105.6922809760655305210.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 19 Nov 2019 16:02:07 -0800
Message-ID: <CAKgT0UfGCzfMqM_GdYsfsowAasW7-awYjSp=FBmB99rDuZpc8g@mail.gmail.com>
Subject: Re: [PATCH] dma/debug: Fix dma vs cow-page collision detection
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Don Dutile <ddutile@redhat.com>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 9:49 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> The debug_dma_assert_idle() infrastructure was put in place to catch a
> data corruption scenario first identified by the now defunct NET_DMA
> receive offload feature. It caught cases where dma was in flight to a
> stale page because the dma raced the cpu writing the page, and the cpu
> write triggered cow_user_page().
>
> However, the dma-debug tracking is overeager and also triggers in cases
> where the dma device is reading from a page that is also undergoing
> cow_user_page().
>
> The fix proposed was originally posted in 2016, and Russell reported
> "Yes, that seems to avoid the warning for me from an initial test", and
> now Don is also reporting that this fix is addressing a similar false
> positive report that he is seeing.
>
> Link: https://lore.kernel.org/r/CAPcyv4j8fWqwAaX5oCdg5atc+vmp57HoAGT6AfBFwaCiv0RbAQ@mail.gmail.com
> Reported-by: Russell King <linux@armlinux.org.uk>
> Reported-by: Don Dutile <ddutile@redhat.com>
> Fixes: 0abdd7a81b7e ("dma-debug: introduce debug_dma_assert_idle()")
> Cc: <stable@vger.kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  kernel/dma/debug.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> index 099002d84f46..11a6db53d193 100644
> --- a/kernel/dma/debug.c
> +++ b/kernel/dma/debug.c
> @@ -587,7 +587,7 @@ void debug_dma_assert_idle(struct page *page)
>         }
>         spin_unlock_irqrestore(&radix_lock, flags);
>
> -       if (!entry)
> +       if (!entry || entry->direction != DMA_FROM_DEVICE)
>                 return;
>
>         cln = to_cacheline_number(entry);

If I am understanding right DMA_TO_DEVICE is fine, but won't  you also
need to cover the DMA_BIDIRECTIONAL case since it is possible for a
device to also write the memory in that case?
