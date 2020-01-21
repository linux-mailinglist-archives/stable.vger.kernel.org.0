Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B1B1445E0
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 21:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgAUUYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 15:24:19 -0500
Received: from mga05.intel.com ([192.55.52.43]:39948 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727847AbgAUUYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 15:24:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 12:24:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; 
   d="scan'208";a="215661903"
Received: from unknown (HELO skalakox.lm.intel.com) ([10.232.116.60])
  by orsmga007.jf.intel.com with ESMTP; 21 Jan 2020 12:24:18 -0800
From:   Sushma Kalakota <sushmax.kalakota@intel.com>
To:     stable@vger.kernel.org
Cc:     Jonathan Derrick <jonathan.derrick@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sushma Kalakota <sushmax.kalakota@intel.com>
Subject: [BACKPORT v4.19 1/3] drm/nouveau/bar/nv50: check bar1 vmm return value
Date:   Tue, 21 Jan 2020 13:28:26 -0700
Message-Id: <20200121202828.16590-2-sushmax.kalakota@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121202828.16590-1-sushmax.kalakota@intel.com>
References: <20200121202828.16590-1-sushmax.kalakota@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit 307a312df9c43fdea286ad17f748aaf777cc434a upstream

This fix is a case where a nv50 or gf100 graphics card is used on a VMD
Domain that results in a null-pointer dereference.

Check bar1's new vmm creation return value for errors.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sushma Kalakota <sushmax.kalakota@intel.com>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c
index 38c9c086754b..f23a0ccc2bec 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c
@@ -174,6 +174,8 @@ nv50_bar_oneinit(struct nvkm_bar *base)
 
 	ret = nvkm_vmm_new(device, start, limit-- - start, NULL, 0,
 			   &bar1_lock, "bar1", &bar->bar1_vmm);
+	if (ret)
+		return ret;
 
 	atomic_inc(&bar->bar1_vmm->engref[NVKM_SUBDEV_BAR]);
 	bar->bar1_vmm->debug = bar->base.subdev.debug;
-- 
2.17.1

