Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1814819D68C
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403911AbgDCMS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46820 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgDCMS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id j17so8185621wru.13
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DnkAuvHhRnj2l3DQmuWpIsKhX/U8TBhWcn7YJvtGsoE=;
        b=UBLkL6O0tH0woYHbbRUx0q4gII4caoWxObZvsTK47w1ng4/svVWSudHWpe0+wE3CYR
         48iKuMlscs71LtSXM36AVG7JLw66JYsbVRPXas1YbVmC4F9DxROrdGsAZ7RygdYKdwmA
         l3V3W6BvbZOJ0rZJzxneLzYTdZyAR7s2/CA5ELqhtG6eMFF7Ij87nN3BBC5aWjNAtePJ
         Kt/ufqmfwe7mg+AHgpv0PQhwh3qFy0zqlDLTUzcfE26W2gJf8LWaWhYIJFGQXxrbxtjE
         rF4VSBNniUiIaF38IQaRQ3TxqUfxBtIpBhiLiCGPQAK2ptk67Zm6DeiiHgagJGpnQusD
         cK9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DnkAuvHhRnj2l3DQmuWpIsKhX/U8TBhWcn7YJvtGsoE=;
        b=aq0QzPzc/L+o5ASracxsQJDz+PepjYH2vASRAj/Eu6FCdA4ugnO7i6sXnT9tl0Fz3H
         PNUzkOnZ31NelEvceJsqlXje7n834uC+e9+kxR+gTL5MsoAakuVQyCH3MuBJiQuEPq+H
         xnBaSJ7/D0lsJcRChGnWsi+q+RIxQEglS1T0lRnRMFQJTnz3Mo+9efoMQpgJ2qeQ/gCA
         dKXtpinanhCObatL0a2N22zcgtYSz2kyYUqKnsXlgReru70A0eWZOpmbdtac+hchizI9
         fTT4Hw24mdccCQpyLUd4DplPRZGSrTW6FPtMOC4AhYaY/mNxn7YRxjgsHw8pMQMcZgFL
         1/7g==
X-Gm-Message-State: AGi0PuYqM5U48cEEERqvzJVquVcNluL3cLZPusOLrmUa9GOYKlWC5UAs
        fbXNrvcyuohmmUHadWdRpsmcMTqhZhQ=
X-Google-Smtp-Source: APiQypKndvT9XG1baSwqubuIcRbQ6CBOnMR7hbJNU26FDoRqVt5b3bq5KqFsOUzkXomFcyYRyJjWCQ==
X-Received: by 2002:a5d:51cf:: with SMTP id n15mr8210570wrv.195.1585916307467;
        Fri, 03 Apr 2020 05:18:27 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:26 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 02/13] drm/msm: stop abusing dma_map/unmap for cache
Date:   Fri,  3 Apr 2020 13:18:48 +0100
Message-Id: <20200403121859.901838-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 0036bc73ccbe7e600a3468bf8e8879b122252274 ]

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
index f59ca27a4a357..93b20ad23c23f 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -108,7 +108,7 @@ static struct page **get_pages(struct drm_gem_object *obj)
 		 * because display controller, GPU, etc. are not coherent:
 		 */
 		if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
-			dma_map_sg(dev->dev, msm_obj->sgt->sgl,
+			dma_sync_sg_for_device(dev->dev, msm_obj->sgt->sgl,
 					msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
 	}
 
@@ -138,7 +138,7 @@ static void put_pages(struct drm_gem_object *obj)
 			 * GPU, etc. are not coherent:
 			 */
 			if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
-				dma_unmap_sg(obj->dev->dev, msm_obj->sgt->sgl,
+				dma_sync_sg_for_cpu(obj->dev->dev, msm_obj->sgt->sgl,
 					     msm_obj->sgt->nents,
 					     DMA_BIDIRECTIONAL);
 
-- 
2.25.1

