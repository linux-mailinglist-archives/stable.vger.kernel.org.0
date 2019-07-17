Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D536B861
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 10:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfGQIfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 04:35:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:14439 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfGQIfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 04:35:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 01:35:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,273,1559545200"; 
   d="scan'208";a="342970661"
Received: from vca-bj102.bj.intel.com ([10.240.193.76])
  by orsmga005.jf.intel.com with ESMTP; 17 Jul 2019 01:35:21 -0700
From:   Xiaolin Zhang <xiaolin.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     Xiaolin Zhang <xiaolin.zhang@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gvt: fix incorrect cache entry for guest page mapping
Date:   Thu, 18 Jul 2019 01:10:24 +0800
Message-Id: <1563383424-23315-1-git-send-email-xiaolin.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

GPU hang observed during the guest OCL conformance test which is caused
by THP GTT feature used durning the test.

It was observed the same GFN with different size (4K and 2M) requested
from the guest in GVT. So during the guest page dma map stage, it is
required to unmap first with orginal size and then remap again with
requested size.

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index a68addf..4a7cf86 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1911,6 +1911,18 @@ static int kvmgt_dma_map_guest_page(unsigned long handle, unsigned long gfn,
 		ret = __gvt_cache_add(info->vgpu, gfn, *dma_addr, size);
 		if (ret)
 			goto err_unmap;
+	} else if (entry->size != size) {
+		/* the same gfn with different size: unmap and re-map */
+		gvt_dma_unmap_page(vgpu, gfn, entry->dma_addr, entry->size);
+		__gvt_cache_remove_entry(vgpu, entry);
+
+		ret = gvt_dma_map_page(vgpu, gfn, dma_addr, size);
+		if (ret)
+			goto err_unlock;
+
+		ret = __gvt_cache_add(info->vgpu, gfn, *dma_addr, size);
+		if (ret)
+			goto err_unmap;
 	} else {
 		kref_get(&entry->ref);
 		*dma_addr = entry->dma_addr;
-- 
1.8.3.1

