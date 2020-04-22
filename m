Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9891B4307
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgDVLUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbgDVLUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:04 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BB9C03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:04 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g13so1912324wrb.8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1SJ5d+30z1PQd4sziGyTinDdqrD1wQKYs9aKQLJxWIk=;
        b=KMHJgj+d2SyAtwEbuzKRPh5MJK4Q+5QhwUpYEFUdAkrFSmDEN843+6F9a4Nl0thL9P
         0PTR4BfYBx4KXkpMr1ZybO5/E8NJ7OLAmgeJgGxOrvO3xPxl8qpRzSiGPVCh5YN8TB7g
         et54GSeOcL0BYXnEDTMfyIZxm8EiSuTwPQdw3wa2rdAjh2Kq17GSjsDwudrGLiwF4Wps
         dfoNPDkotwkYMgd8OOPamqj3yj+957b9H4yFDZOOcdI3cJqc8RZZ5OutnMeJnJ3axpHv
         DCSxIXjLGUTRnpUZhkxb1Wo6fdC6YfY3mYnX7QtOyyVGKa/Pns8ViG6l/GolHDx/0cmP
         nsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1SJ5d+30z1PQd4sziGyTinDdqrD1wQKYs9aKQLJxWIk=;
        b=qEh69zTM/u1714nbWhKXDnr+MzU6CvSaIpFYQJ9YQXGik61t7G9h3ZEJR/oSNwFgvB
         aDqbZj7lZgNxT7KWCYyWfYjJvxWg3hjofZvP4uZlLakNq3dT2qRs5A33ZhazDGMOXEtF
         lh+pX6LwCqplg2wcB+MjuBd0EQSe+vLGlQn+X8OakDxLK+BtwMTPKUqKKF6os7jo5w9G
         9jYzqBAJmXPEhWthR1L54zsdFvEUW4L7NZzITGJdmY2ErSQDdvPLWGMP9tDkPRFGeAOZ
         v5Ul7gr/Acu73Rob+Bx3fbC4M8+Z7Ib5HJxUEm49q0ikFHiXE/zj8xzyEMRtFUxaxUnX
         dk4w==
X-Gm-Message-State: AGi0PuaTy9/8tcCKr0HCLb/d4VT3RZ7lYF8mqMVOD3WFDgqbBJTbipyJ
        158iCRSM5bCIt4yAAaAD6wSwD0dn5F4=
X-Google-Smtp-Source: APiQypIQiGOqN1pnszKdlLD8AX/4MJlmyW+gUJDiqwV42UstCSqwV9WlC6nL+6TCd3jLX8xaQRdkqw==
X-Received: by 2002:adf:df01:: with SMTP id y1mr28872715wrl.401.1587554402509;
        Wed, 22 Apr 2020 04:20:02 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 02/21] drm/msm: stop abusing dma_map/unmap for cache
Date:   Wed, 22 Apr 2020 12:19:38 +0100
Message-Id: <20200422111957.569589-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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
index 795660e29b2ce..a472d4d902dde 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -106,7 +106,7 @@ static struct page **get_pages(struct drm_gem_object *obj)
 		 * because display controller, GPU, etc. are not coherent:
 		 */
 		if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
-			dma_map_sg(dev->dev, msm_obj->sgt->sgl,
+			dma_sync_sg_for_device(dev->dev, msm_obj->sgt->sgl,
 					msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
 	}
 
@@ -124,7 +124,7 @@ static void put_pages(struct drm_gem_object *obj)
 			 * GPU, etc. are not coherent:
 			 */
 			if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
-				dma_unmap_sg(obj->dev->dev, msm_obj->sgt->sgl,
+				dma_sync_sg_for_cpu(obj->dev->dev, msm_obj->sgt->sgl,
 					     msm_obj->sgt->nents,
 					     DMA_BIDIRECTIONAL);
 
-- 
2.25.1

