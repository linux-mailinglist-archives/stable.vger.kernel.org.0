Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B88E4D2D
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 15:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505519AbfJYN6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732654AbfJYN6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:58:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFAB7222CD;
        Fri, 25 Oct 2019 13:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011896;
        bh=iBDissv+RAFwCtToVRjoa9uFXuIcswIIMG6AChOrBYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWcwYswdRTKyDUCIkheulVQKAdujauAFH3DEluDyxVaNWsCISfGAZkg/OKfn6j28d
         rQf/bFcQETsaUXy8TDa5krPKlSWrstQPJOEfpvCnvULZts88tSwcdx8ZAhHN3Sp+LB
         0FfJxxSH7ErvU27FWqlPOawzO0Vfs4hUlDuUtpkY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 08/20] drm/msm: Use the correct dma_sync calls in msm_gem
Date:   Fri, 25 Oct 2019 09:57:48 -0400
Message-Id: <20191025135801.25739-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135801.25739-1-sashal@kernel.org>
References: <20191025135801.25739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 3de433c5b38af49a5fc7602721e2ab5d39f1e69c ]

[subject was: drm/msm: shake fist angrily at dma-mapping]

So, using dma_sync_* for our cache needs works out w/ dma iommu ops, but
it falls appart with dma direct ops.  The problem is that, depending on
display generation, we can have either set of dma ops (mdp4 and dpu have
iommu wired to mdss node, which maps to toplevel drm device, but mdp5
has iommu wired up to the mdp sub-node within mdss).

Fixes this splat on mdp5 devices:

   Unable to handle kernel paging request at virtual address ffffffff80000000
   Mem abort info:
     ESR = 0x96000144
     Exception class = DABT (current EL), IL = 32 bits
     SET = 0, FnV = 0
     EA = 0, S1PTW = 0
   Data abort info:
     ISV = 0, ISS = 0x00000144
     CM = 1, WnR = 1
   swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000810e4000
   [ffffffff80000000] pgd=0000000000000000
   Internal error: Oops: 96000144 [#1] SMP
   Modules linked in: btqcomsmd btqca bluetooth cfg80211 ecdh_generic ecc rfkill libarc4 panel_simple msm wcnss_ctrl qrtr_smd drm_kms_helper venus_enc venus_dec videobuf2_dma_sg videobuf2_memops drm venus_core ipv6 qrtr qcom_wcnss_pil v4l2_mem2mem qcom_sysmon videobuf2_v4l2 qmi_helpers videobuf2_common crct10dif_ce mdt_loader qcom_common videodev qcom_glink_smem remoteproc bmc150_accel_i2c bmc150_magn_i2c bmc150_accel_core bmc150_magn snd_soc_lpass_apq8016 snd_soc_msm8916_analog mms114 mc nf_defrag_ipv6 snd_soc_lpass_cpu snd_soc_apq8016_sbc industrialio_triggered_buffer kfifo_buf snd_soc_lpass_platform snd_soc_msm8916_digital drm_panel_orientation_quirks
   CPU: 2 PID: 33 Comm: kworker/2:1 Not tainted 5.3.0-rc2 #1
   Hardware name: Samsung Galaxy A5U (EUR) (DT)
   Workqueue: events deferred_probe_work_func
   pstate: 80000005 (Nzcv daif -PAN -UAO)
   pc : __clean_dcache_area_poc+0x20/0x38
   lr : arch_sync_dma_for_device+0x28/0x30
   sp : ffff0000115736a0
   x29: ffff0000115736a0 x28: 0000000000000001
   x27: ffff800074830800 x26: ffff000011478000
   x25: 0000000000000000 x24: 0000000000000001
   x23: ffff000011478a98 x22: ffff800009fd1c10
   x21: 0000000000000001 x20: ffff800075ad0a00
   x19: 0000000000000000 x18: ffff0000112b2000
   x17: 0000000000000000 x16: 0000000000000000
   x15: 00000000fffffff0 x14: ffff000011455d70
   x13: 0000000000000000 x12: 0000000000000028
   x11: 0000000000000001 x10: ffff00001106c000
   x9 : ffff7e0001d6b380 x8 : 0000000000001000
   x7 : ffff7e0001d6b380 x6 : ffff7e0001d6b382
   x5 : 0000000000000000 x4 : 0000000000001000
   x3 : 000000000000003f x2 : 0000000000000040
   x1 : ffffffff80001000 x0 : ffffffff80000000
   Call trace:
    __clean_dcache_area_poc+0x20/0x38
    dma_direct_sync_sg_for_device+0xb8/0xe8
    get_pages+0x22c/0x250 [msm]
    msm_gem_get_and_pin_iova+0xdc/0x168 [msm]
    ...

Fixes the combination of two patches:

Fixes: 0036bc73ccbe (drm/msm: stop abusing dma_map/unmap for cache)
Fixes: 449fa54d6815 (dma-direct: correct the physical addr in dma_direct_sync_sg_for_cpu/device)
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Rob Clark <robdclark@chromium.org>
[seanpaul changed subject to something more desriptive]
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190730214633.17820-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c | 47 +++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index a472d4d902dde..569e8c45a59aa 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -40,6 +40,46 @@ static bool use_pages(struct drm_gem_object *obj)
 	return !msm_obj->vram_node;
 }
 
+/*
+ * Cache sync.. this is a bit over-complicated, to fit dma-mapping
+ * API.  Really GPU cache is out of scope here (handled on cmdstream)
+ * and all we need to do is invalidate newly allocated pages before
+ * mapping to CPU as uncached/writecombine.
+ *
+ * On top of this, we have the added headache, that depending on
+ * display generation, the display's iommu may be wired up to either
+ * the toplevel drm device (mdss), or to the mdp sub-node, meaning
+ * that here we either have dma-direct or iommu ops.
+ *
+ * Let this be a cautionary tail of abstraction gone wrong.
+ */
+
+static void sync_for_device(struct msm_gem_object *msm_obj)
+{
+	struct device *dev = msm_obj->base.dev->dev;
+
+	if (get_dma_ops(dev)) {
+		dma_sync_sg_for_device(dev, msm_obj->sgt->sgl,
+			msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
+	} else {
+		dma_map_sg(dev, msm_obj->sgt->sgl,
+			msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
+	}
+}
+
+static void sync_for_cpu(struct msm_gem_object *msm_obj)
+{
+	struct device *dev = msm_obj->base.dev->dev;
+
+	if (get_dma_ops(dev)) {
+		dma_sync_sg_for_cpu(dev, msm_obj->sgt->sgl,
+			msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
+	} else {
+		dma_unmap_sg(dev, msm_obj->sgt->sgl,
+			msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
+	}
+}
+
 /* allocate pages from VRAM carveout, used when no IOMMU: */
 static struct page **get_pages_vram(struct drm_gem_object *obj,
 		int npages)
@@ -106,8 +146,7 @@ static struct page **get_pages(struct drm_gem_object *obj)
 		 * because display controller, GPU, etc. are not coherent:
 		 */
 		if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
-			dma_sync_sg_for_device(dev->dev, msm_obj->sgt->sgl,
-					msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
+			sync_for_device(msm_obj);
 	}
 
 	return msm_obj->pages;
@@ -124,9 +163,7 @@ static void put_pages(struct drm_gem_object *obj)
 			 * GPU, etc. are not coherent:
 			 */
 			if (msm_obj->flags & (MSM_BO_WC|MSM_BO_UNCACHED))
-				dma_sync_sg_for_cpu(obj->dev->dev, msm_obj->sgt->sgl,
-					     msm_obj->sgt->nents,
-					     DMA_BIDIRECTIONAL);
+				sync_for_cpu(msm_obj);
 
 			sg_free_table(msm_obj->sgt);
 			kfree(msm_obj->sgt);
-- 
2.20.1

