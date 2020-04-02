Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34DF19C9AF
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbgDBTQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:16:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37730 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbgDBTQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:16:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id j19so4951449wmi.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1SJ5d+30z1PQd4sziGyTinDdqrD1wQKYs9aKQLJxWIk=;
        b=V2ZAXBEnoWGdoBt+m3/gF/x9YbQIz6UcspZUge0Mnq79utXiM/JvkkJ5WFipviZ2oc
         BftYxHaS1J6735yOAVog0Cdq/xA4Mr/oJxTwYqr/f5e++9/UyjMWg5uDLGdXRQfWglAQ
         ImZZI2vcB8Q3mfI3v9JWbZsUxc3ZDwIgXs9n1nc9BtQmAA73JqfDKNBggDG2lPgNXmll
         IDf5W5pOxoqNN5seDAW3d0NUzJufwbNgw/lmdVMtlbB9B0c1mWkt2wWLOPFMDts7cKll
         wEuHiFztqfXJxkK9I9vwkk+ihDp0/fKtGALNEBtN7xrptsRA0cXWNmGyTbFbh0MOeCVV
         UH3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1SJ5d+30z1PQd4sziGyTinDdqrD1wQKYs9aKQLJxWIk=;
        b=XUkIYt7+8qse7Lgfj4TenM7S47TyVMtM2PrWDyiJKn/6ULE5Oi+gVmfPxhOY6YX3Mz
         7RWLuz23RcW1MiYZzsyTPmFE5z01cWs6QAexN1vpkBlCQapAuKhspyRPsjlbCNZldyAy
         417CnOWzvEqJ3YGuvYRpQlWpFJf40KHZPCL/wy4tpUx+/fQHvTKwIxw/IJmw2lybZrak
         IilpS+58yftW7vMXoTygcp+1BRzv9CdyyS0FVMiT4R1TiOBvb8mZDR5CvcKq+RIci2ZB
         X/9sVeqXMnGiB25HQIoQPIjYh6pP1SC3wagvTSgYUF+CrqzB5Q5jmjl/FTxLVH0rojsD
         dbtg==
X-Gm-Message-State: AGi0PuYuTDZcyBq5vFyZb+wCnBmB8nADSlKJyqnn8FySiKcu2Mo5G0oE
        8oyenMWw/BeTigFFru+rQAOBgbJ1Mn+Knw==
X-Google-Smtp-Source: APiQypKHRWw7bdgTFmgGn3321EuSsPKMTeHoLwDtCxsbfqsT/aVywyq1IkRYLsF7aj9UE99KuAsf+g==
X-Received: by 2002:a1c:6146:: with SMTP id v67mr5066510wmb.78.1585855016049;
        Thu, 02 Apr 2020 12:16:56 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:16:55 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 02/24] drm/msm: stop abusing dma_map/unmap for cache
Date:   Thu,  2 Apr 2020 20:17:25 +0100
Message-Id: <20200402191747.789097-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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

