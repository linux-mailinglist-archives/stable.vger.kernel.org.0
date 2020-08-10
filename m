Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6F42410C9
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgHJTch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728592AbgHJTJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 499AE221E2;
        Mon, 10 Aug 2020 19:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086578;
        bh=WlMHZGrHsTRRURnOEQgp8HWwE6YoZ6gLYbRbIFTqfN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOWh4hRKlob95hYcgIOM9is94CRATnUUOrbl+N28OvzjPOX9IeY950N97qWad39FR
         T5q3qg3tRdiq6aEJMBg+VaDyj85UQo2MincxvpwaJw/F0zMPkNzVVtw7PH8dwP0Bv1
         wLhl/cdKMILE98ZiEkV7SX0yIPBrtGvIj46Ul8C4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 28/64] drm/msm: Fix a null pointer access in msm_gem_shrinker_count()
Date:   Mon, 10 Aug 2020 15:08:23 -0400
Message-Id: <20200810190859.3793319-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akhil P Oommen <akhilpo@codeaurora.org>

[ Upstream commit 3cbdc8d8b7f39a7af3ea7b8dfa75caaebfda4e56 ]

Adding an msm_gem_object object to the inactive_list before completing
its initialization is a bad idea because shrinker may pick it up from the
inactive_list. Fix this by making sure that the initialization is complete
before moving the msm_obj object to the inactive list.

This patch fixes the below error:
[10027.553044] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000068
[10027.573305] Mem abort info:
[10027.590160]   ESR = 0x96000006
[10027.597905]   EC = 0x25: DABT (current EL), IL = 32 bits
[10027.614430]   SET = 0, FnV = 0
[10027.624427]   EA = 0, S1PTW = 0
[10027.632722] Data abort info:
[10027.638039]   ISV = 0, ISS = 0x00000006
[10027.647459]   CM = 0, WnR = 0
[10027.654345] user pgtable: 4k pages, 39-bit VAs, pgdp=00000001e3a6a000
[10027.672681] [0000000000000068] pgd=0000000198c31003, pud=0000000198c31003, pmd=0000000000000000
[10027.693900] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[10027.738261] CPU: 3 PID: 214 Comm: kswapd0 Tainted: G S                5.4.40 #1
[10027.745766] Hardware name: Qualcomm Technologies, Inc. SC7180 IDP (DT)
[10027.752472] pstate: 80c00009 (Nzcv daif +PAN +UAO)
[10027.757409] pc : mutex_is_locked+0x14/0x2c
[10027.761626] lr : msm_gem_shrinker_count+0x70/0xec
[10027.766454] sp : ffffffc011323ad0
[10027.769867] x29: ffffffc011323ad0 x28: ffffffe677e4b878
[10027.775324] x27: 0000000000000cc0 x26: 0000000000000000
[10027.780783] x25: ffffff817114a708 x24: 0000000000000008
[10027.786242] x23: ffffff8023ab7170 x22: 0000000000000001
[10027.791701] x21: ffffff817114a080 x20: 0000000000000119
[10027.797160] x19: 0000000000000068 x18: 00000000000003bc
[10027.802621] x17: 0000000004a34210 x16: 00000000000000c0
[10027.808083] x15: 0000000000000000 x14: 0000000000000000
[10027.813542] x13: ffffffe677e0a3c0 x12: 0000000000000000
[10027.819000] x11: 0000000000000000 x10: ffffff8174b94340
[10027.824461] x9 : 0000000000000000 x8 : 0000000000000000
[10027.829919] x7 : 00000000000001fc x6 : ffffffc011323c88
[10027.835373] x5 : 0000000000000001 x4 : ffffffc011323d80
[10027.840832] x3 : ffffffff0477b348 x2 : 0000000000000000
[10027.846290] x1 : ffffffc011323b68 x0 : 0000000000000068
[10027.851748] Call trace:
[10027.854264]  mutex_is_locked+0x14/0x2c
[10027.858121]  msm_gem_shrinker_count+0x70/0xec
[10027.862603]  shrink_slab+0xc0/0x4b4
[10027.866187]  shrink_node+0x4a8/0x818
[10027.869860]  kswapd+0x624/0x890
[10027.873097]  kthread+0x11c/0x12c
[10027.876424]  ret_from_fork+0x10/0x18
[10027.880102] Code: f9000bf3 910003fd aa0003f3 d503201f (f9400268)
[10027.886362] ---[ end trace df5849a1a3543251 ]---
[10027.891518] Kernel panic - not syncing: Fatal exception

Signed-off-by: Akhil P Oommen <akhilpo@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c | 36 ++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index 6277fde13df91..f63bb7e452d2a 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -994,10 +994,8 @@ int msm_gem_new_handle(struct drm_device *dev, struct drm_file *file,
 
 static int msm_gem_new_impl(struct drm_device *dev,
 		uint32_t size, uint32_t flags,
-		struct drm_gem_object **obj,
-		bool struct_mutex_locked)
+		struct drm_gem_object **obj)
 {
-	struct msm_drm_private *priv = dev->dev_private;
 	struct msm_gem_object *msm_obj;
 
 	switch (flags & MSM_BO_CACHE_MASK) {
@@ -1023,15 +1021,6 @@ static int msm_gem_new_impl(struct drm_device *dev,
 	INIT_LIST_HEAD(&msm_obj->submit_entry);
 	INIT_LIST_HEAD(&msm_obj->vmas);
 
-	if (struct_mutex_locked) {
-		WARN_ON(!mutex_is_locked(&dev->struct_mutex));
-		list_add_tail(&msm_obj->mm_list, &priv->inactive_list);
-	} else {
-		mutex_lock(&dev->struct_mutex);
-		list_add_tail(&msm_obj->mm_list, &priv->inactive_list);
-		mutex_unlock(&dev->struct_mutex);
-	}
-
 	*obj = &msm_obj->base;
 
 	return 0;
@@ -1041,6 +1030,7 @@ static struct drm_gem_object *_msm_gem_new(struct drm_device *dev,
 		uint32_t size, uint32_t flags, bool struct_mutex_locked)
 {
 	struct msm_drm_private *priv = dev->dev_private;
+	struct msm_gem_object *msm_obj;
 	struct drm_gem_object *obj = NULL;
 	bool use_vram = false;
 	int ret;
@@ -1061,14 +1051,15 @@ static struct drm_gem_object *_msm_gem_new(struct drm_device *dev,
 	if (size == 0)
 		return ERR_PTR(-EINVAL);
 
-	ret = msm_gem_new_impl(dev, size, flags, &obj, struct_mutex_locked);
+	ret = msm_gem_new_impl(dev, size, flags, &obj);
 	if (ret)
 		goto fail;
 
+	msm_obj = to_msm_bo(obj);
+
 	if (use_vram) {
 		struct msm_gem_vma *vma;
 		struct page **pages;
-		struct msm_gem_object *msm_obj = to_msm_bo(obj);
 
 		mutex_lock(&msm_obj->lock);
 
@@ -1103,6 +1094,15 @@ static struct drm_gem_object *_msm_gem_new(struct drm_device *dev,
 		mapping_set_gfp_mask(obj->filp->f_mapping, GFP_HIGHUSER);
 	}
 
+	if (struct_mutex_locked) {
+		WARN_ON(!mutex_is_locked(&dev->struct_mutex));
+		list_add_tail(&msm_obj->mm_list, &priv->inactive_list);
+	} else {
+		mutex_lock(&dev->struct_mutex);
+		list_add_tail(&msm_obj->mm_list, &priv->inactive_list);
+		mutex_unlock(&dev->struct_mutex);
+	}
+
 	return obj;
 
 fail:
@@ -1125,6 +1125,7 @@ struct drm_gem_object *msm_gem_new(struct drm_device *dev,
 struct drm_gem_object *msm_gem_import(struct drm_device *dev,
 		struct dma_buf *dmabuf, struct sg_table *sgt)
 {
+	struct msm_drm_private *priv = dev->dev_private;
 	struct msm_gem_object *msm_obj;
 	struct drm_gem_object *obj;
 	uint32_t size;
@@ -1138,7 +1139,7 @@ struct drm_gem_object *msm_gem_import(struct drm_device *dev,
 
 	size = PAGE_ALIGN(dmabuf->size);
 
-	ret = msm_gem_new_impl(dev, size, MSM_BO_WC, &obj, false);
+	ret = msm_gem_new_impl(dev, size, MSM_BO_WC, &obj);
 	if (ret)
 		goto fail;
 
@@ -1163,6 +1164,11 @@ struct drm_gem_object *msm_gem_import(struct drm_device *dev,
 	}
 
 	mutex_unlock(&msm_obj->lock);
+
+	mutex_lock(&dev->struct_mutex);
+	list_add_tail(&msm_obj->mm_list, &priv->inactive_list);
+	mutex_unlock(&dev->struct_mutex);
+
 	return obj;
 
 fail:
-- 
2.25.1

