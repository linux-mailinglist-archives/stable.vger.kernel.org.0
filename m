Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4451445E2
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 21:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgAUUYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 15:24:20 -0500
Received: from mga05.intel.com ([192.55.52.43]:39948 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727847AbgAUUYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 15:24:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 12:24:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; 
   d="scan'208";a="215661910"
Received: from unknown (HELO skalakox.lm.intel.com) ([10.232.116.60])
  by orsmga007.jf.intel.com with ESMTP; 21 Jan 2020 12:24:19 -0800
From:   Sushma Kalakota <sushmax.kalakota@intel.com>
To:     stable@vger.kernel.org
Cc:     Jonathan Derrick <jonathan.derrick@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sushma Kalakota <sushmax.kalakota@intel.com>
Subject: [BACKPORT v4.19 3/3] drm/nouveau/mmu: qualify vmm during dtor
Date:   Tue, 21 Jan 2020 13:28:28 -0700
Message-Id: <20200121202828.16590-4-sushmax.kalakota@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121202828.16590-1-sushmax.kalakota@intel.com>
References: <20200121202828.16590-1-sushmax.kalakota@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit 15516bf9abaa41421a6ded79a5a2fee86f9594e5 upstream

This fix is a case where a nv50 or gf100 graphics card is used on a VMD
Domain that results in a null-pointer dereference.

If the BAR initialization failed it may leave the vmm structure in an
unitialized state, leading to a null-pointer-dereference when the vmm is
dereferenced during teardown.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sushma Kalakota <sushmax.kalakota@intel.com>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c
index 7459def78d50..5f8b8b399b97 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c
@@ -1423,7 +1423,7 @@ nvkm_vmm_get(struct nvkm_vmm *vmm, u8 page, u64 size, struct nvkm_vma **pvma)
 void
 nvkm_vmm_part(struct nvkm_vmm *vmm, struct nvkm_memory *inst)
 {
-	if (inst && vmm->func->part) {
+	if (inst && vmm && vmm->func->part) {
 		mutex_lock(&vmm->mutex);
 		vmm->func->part(vmm, inst);
 		mutex_unlock(&vmm->mutex);
-- 
2.17.1

