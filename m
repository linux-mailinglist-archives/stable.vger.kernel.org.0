Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9A51D7516
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 12:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgERKX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 06:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgERKX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 06:23:57 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1128DC061A0C
        for <stable@vger.kernel.org>; Mon, 18 May 2020 03:23:57 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u188so9702287wmu.1
        for <stable@vger.kernel.org>; Mon, 18 May 2020 03:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9t0OslWmYlXxXMmtuOQAAnVpwXrDtCGbJWofLiBEsWQ=;
        b=Mahh/Xfusc834alOYaImAqxArcInmjUAdkXGEpWM90YWq+Z4sdkRUbg46W7uJXYYpb
         kUo84qRIWEt7rlujdoCGdibJIYpVDkJdCQ/Di5ATtws/jzdtC4/HgfFfrlNuPXymLlXL
         nj+4om2SImfdyGgJ/MWQZfqWVFqRUwaS9iRYQxH/XnxTAY1LIB2uB2AVVa+VuJACPge9
         TPd1XxlomcsxABnZq2dfGqTCOjq+VMKlN6F5+IOugHdghM6lK21yWaDKOBnwsdapvBLT
         kmeqYLBzp7N5+vzD2nE8gQuTEky079nkpOnPnftS9EwcuG3lboIc2NUnIveERDpHtuE6
         beRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9t0OslWmYlXxXMmtuOQAAnVpwXrDtCGbJWofLiBEsWQ=;
        b=HtilWIVbTql9AyCwhwn8rOrmvQ0RZkTjM9OKgdgNqpRiMyySAnUEC3WLniUyXgx33L
         idWwHdg7+V2tGv8v5Y/UajY+I6XaU149hf3nzmh3+OUG346qcRvVzGemSw8Yo+C3ieRP
         KrjXvMBWsoB5lQvn9jOHUSr62XVz8tS87mFRkbzVvlTorHtFkoLQSapucmNAEYXabX8R
         4Dhu3ai8GEcaNTvxFXMrdjljhZBxKTLAltOe9KgqoMLCULehbHPWr96aF4fNiyYOSrKT
         qS89sc3svntUyCq+3xdfzf8hGcotIs8ifA7RKSUYeAwxSuiX3MwHeViTwpU3H2oGaFGq
         qP3g==
X-Gm-Message-State: AOAM533i48KMh/OmSw2agV15crHDeirRvFFIkptWfvH0lUMUv6Xk0ya+
        Ix2MGmQJBlSeishSqFBwKAgtYYW1kME=
X-Google-Smtp-Source: ABdhPJyeAdhxxHhD3SKB1l5DKVVRfDKcNXnLGaahi+EkQZ5gM1BgFoHkkAJLRxr4AO23df6lBig7/Q==
X-Received: by 2002:a1c:a793:: with SMTP id q141mr18341864wme.70.1589797435490;
        Mon, 18 May 2020 03:23:55 -0700 (PDT)
Received: from dell ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id s15sm15697483wro.80.2020.05.18.03.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 03:23:54 -0700 (PDT)
Date:   Mon, 18 May 2020 11:23:53 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.4 02/16 (v2)] gpiolib: Fix references to
 gpiod_[gs]et_*value_cansleep() variants
Message-ID: <20200518102353.GR271301@dell>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-3-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423204014.784944-3-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


[ Upstream commit 3285170f28a850638794cdfe712eb6d93e51e706 ]

Recently splats like this started showing up:

   WARNING: CPU: 4 PID: 251 at drivers/iommu/dma-iommu.c:451 __iommu_dma_unmap+0xb8/0xc0
   Modules linked in: ath10k_snoc ath10k_core fuse msm ath mac80211 uvcvideo cfg80211 videobuf2_vmalloc videobuf2_memops vide
   CPU: 4 PID: 251 Comm: kworker/u16:4 Tainted: G        W         5.2.0-rc5-next-20190619+ #2317
   Hardware name: LENOVO 81JL/LNVNB161216, BIOS 9UCN23WW(V1.06) 10/25/2018
   Workqueue: msm msm_gem_free_work [msm]
   pstate: 80c00005 (Nzcv daif +PAN +UAO)
   pc : __iommu_dma_unmap+0xb8/0xc0
   lr : __iommu_dma_unmap+0x54/0xc0
   sp : ffff0000119abce0
   x29: ffff0000119abce0 x28: 0000000000000000
   x27: ffff8001f9946648 x26: ffff8001ec271068
   x25: 0000000000000000 x24: ffff8001ea3580a8
   x23: ffff8001f95ba010 x22: ffff80018e83ba88
   x21: ffff8001e548f000 x20: fffffffffffff000
   x19: 0000000000001000 x18: 00000000c00001fe
   x17: 0000000000000000 x16: 0000000000000000
   x15: ffff000015b70068 x14: 0000000000000005
   x13: 0003142cc1be1768 x12: 0000000000000001
   x11: ffff8001f6de9100 x10: 0000000000000009
   x9 : ffff000015b78000 x8 : 0000000000000000
   x7 : 0000000000000001 x6 : fffffffffffff000
   x5 : 0000000000000fff x4 : ffff00001065dbc8
   x3 : 000000000000000d x2 : 0000000000001000
   x1 : fffffffffffff000 x0 : 0000000000000000
   Call trace:
    __iommu_dma_unmap+0xb8/0xc0
    iommu_dma_unmap_sg+0x98/0xb8
    put_pages+0x5c/0xf0 [msm]
    msm_gem_free_work+0x10c/0x150 [msm]
    process_one_work+0x1e0/0x330
    worker_thread+0x40/0x438
    kthread+0x12c/0x130
    ret_from_fork+0x10/0x18
   ---[ end trace afc0dc5ab81a06bf ]---

Not quite sure what triggered that, but we really shouldn't be abusing
dma_{map,unmap}_sg() for cache maint.

Cc: Stephen Boyd <sboyd@kernel.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190630124735.27786-1-robdclark@gmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpu/drm/msm/msm_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index 644faf3ae93a3..055859095cf01 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -104,7 +104,7 @@ static struct page **get_pages(struct drm_gem_object *obj)
 		 * because display controller, GPU, etc. are not coherent:
 		 */
 		if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
-			dma_map_sg(dev->dev, msm_obj->sgt->sgl,
+			dma_sync_sg_for_device(dev->dev, msm_obj->sgt->sgl,
 					msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
 	}
 
@@ -120,7 +120,7 @@ static void put_pages(struct drm_gem_object *obj)
 		 * because display controller, GPU, etc. are not coherent:
 		 */
 		if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
-			dma_unmap_sg(obj->dev->dev, msm_obj->sgt->sgl,
+			dma_sync_sg_for_cpu(obj->dev->dev, msm_obj->sgt->sgl,
 					msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
 
 		if (msm_obj->sgt)
-- 
2.25.1
