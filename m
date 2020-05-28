Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D381E5CFB
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 12:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbgE1KTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 06:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387727AbgE1KTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 06:19:38 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485DFC08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 03:19:37 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id z12so9499728uap.6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 03:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f5eLdtnXoyYrMReynJ8g23vP6dcjH2deBArK9MBPsOA=;
        b=E0SfhFNxQyV6Kh+9tWKDRG4U5sfqRQI5rDSruFXsJJLQLir/rQrwWI5QcOYlJwuQCk
         Ruo3Kc+DPz+HBMfcM6GbV1XHVkZe0rw+E3qMRvnSVOqNyTHAsbH4p/KTS1HBOOyY9OJ7
         gwSQCv7QRvOw0nYZID/1WqcBILuTP0HvtDQukSUUyNfedVG/STJ3rno6I2hz2ReBDWHw
         TQbImKFmrPZG+EeG4rcQ/ueL0EJitzGg+WJkdcT92NegsshP3LkwQE2Tr6QoLqS0dwdB
         CnyZcA32OQkkzto7OzjPl15fgpmq/ebuhyHafa6nfguLRUeHUbwTA0LatnSm5j1cLqbG
         BPYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f5eLdtnXoyYrMReynJ8g23vP6dcjH2deBArK9MBPsOA=;
        b=iYwUypf26b2UGP2dhvBRUM+PTJP+OAFt8CZ3NUMWyfVoPdVJ4ahI9odM85O06yfFvs
         cfCojTXEkpVM71ArSlcN7UrnxQA9eRnImOErgG8Fg59j7E7ss5iVx0Wf2qjL79LLrThQ
         NDyjIpAm8eL7FZ/OpxjAAqmtts3Z/fj8NoqMxiX48xq+h2LLpOYzJQ0Clmj4v8I1zkOX
         9znkgnjry7/wsw6q6qA2uycszGFPJzHedW1PV7UCdxikhZ14My4OJTZRdVqWc5VvRwCK
         nMOuTPOMvn45jModrMThbpNRKTB6Clqnrj3OnrbrIjzXCYgrOI7Mkx9KR6SmQNraouXZ
         C6xg==
X-Gm-Message-State: AOAM533Y0UVraER1V+R19nXihqTZVzCONCa34BMUCxaHSGngqfHseIV5
        mqU3S6znUb7/sHj3tsbtOXXKUi9z/El9uwOpNRzdYg==
X-Google-Smtp-Source: ABdhPJwU4FQfKxI8zbZS6DJQ0er77d6//XOhOdE8ysvkLwNHc++5I8kqqLBnsndpoGGUHLv4GXHsMapzXESGeGZ950s=
X-Received: by 2002:ab0:70c9:: with SMTP id r9mr1364877ual.15.1590661175270;
 Thu, 28 May 2020 03:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200527082334.20774-1-tomi.valkeinen@ti.com> <CGME20200528091458eucas1p13645743b402f161dfa2fcd2b1e0e3b60@eucas1p1.samsung.com>
 <CAPDyKFqRa81q9EYFKB52kr6+EPJBK5u+4_hC0+ZnxU_axbxAZQ@mail.gmail.com> <53acbff5-ccb2-1f26-c1e3-54a540ac537f@samsung.com>
In-Reply-To: <53acbff5-ccb2-1f26-c1e3-54a540ac537f@samsung.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 28 May 2020 12:18:59 +0200
Message-ID: <CAPDyKFqgf=G3U3wRkiZaskVGYVzM=HBfuZwfsQA7N48Su7-NPg@mail.gmail.com>
Subject: Re: [PATCHv2] media: videobuf2-dma-contig: fix bad kfree in vb2_dma_contig_clear_max_seg_size
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 May 2020 at 11:24, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>
> Hi Ulf,
>
> On 28.05.2020 11:14, Ulf Hansson wrote:
> > On Wed, 27 May 2020 at 10:23, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> >> Commit 9495b7e92f716ab2bd6814fab5e97ab4a39adfdd ("driver core: platform:
> >> Initialize dma_parms for platform devices") in v5.7-rc5 causes
> >> vb2_dma_contig_clear_max_seg_size() to kfree memory that was not
> >> allocated by vb2_dma_contig_set_max_seg_size().
> >>
> >> The assumption in vb2_dma_contig_set_max_seg_size() seems to be that
> >> dev->dma_parms is always NULL when the driver is probed, and the case
> >> where dev->dma_parms has bee initialized by someone else than the driver
> >> (by calling vb2_dma_contig_set_max_seg_size) will cause a failure.
> >>
> >> All the current users of these functions are platform devices, which now
> >> always have dma_parms set by the driver core. To fix the issue for v5.7,
> >> make vb2_dma_contig_set_max_seg_size() return an error if dma_parms is
> >> NULL to be on the safe side, and remove the kfree code from
> >> vb2_dma_contig_clear_max_seg_size().
> >>
> >> For v5.8 we should remove the two functions and move the
> >> dma_set_max_seg_size() calls into the drivers.
> >>
> >> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> >> Fixes: 9495b7e92f71 ("driver core: platform: Initialize dma_parms for platform devices")
> >> Cc: stable@vger.kernel.org
> > Thanks for fixing this!
> >
> > However, as I tried to point out in v1, don't you need to care about
> > drivers/media/platform/s5p-mfc/s5p_mfc.c, which allocates its own type
> > of struct device (non-platform). No?
>
> I will send a patch for the S5P MFC driver separately. It is not so
> critical, because the mentioned 2port memory case is not used on any
> board with the default exynos_defconfig from mainline. On Exynos4-based
> boards it is only used when IOMMU is disabled. It is mainly for
> S5PV210/S5PC110 boards, which are still not fully functional after
> conversion to device-tree.

Okay, makes sense to me. Feel free to add:

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

For the s5p_mfc issue, here's how I would have done it (just pick the
code if you want).

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 5c2a23b953a4..7acf2a03812d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1070,6 +1070,7 @@ static const struct v4l2_file_operations s5p_mfc_fops = {
 /* DMA memory related helper functions */
 static void s5p_mfc_memdev_release(struct device *dev)
 {
+       kfree(dev->dma_parms);
        of_reserved_mem_device_release(dev);
 }

@@ -1090,6 +1091,10 @@ static struct device
*s5p_mfc_alloc_memdev(struct device *dev,
        child->dma_mask = dev->dma_mask;
        child->release = s5p_mfc_memdev_release;

+       child->dma_parms = kzalloc(sizeof(*child->dma_parms), GFP_KERNEL);
+       if (!child->dma_parms)
+               goto err;
+
        /*
         * The memdevs are not proper OF platform devices, so in order for them
         * to be treated as valid DMA masters we need a bit of a hack to force
@@ -1105,6 +1110,7 @@ static struct device
*s5p_mfc_alloc_memdev(struct device *dev,
                device_del(child);
        }

+err:
        put_device(child);
        return NULL;
 }

Kind regards
Uffe
