Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B6149101B
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 19:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238213AbiAQSNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 13:13:44 -0500
Received: from letterbox.kde.org ([46.43.1.242]:33798 "EHLO letterbox.kde.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbiAQSNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jan 2022 13:13:44 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2022 13:13:43 EST
Received: from vertex.localdomain (pool-108-36-85-85.phlapa.fios.verizon.net [108.36.85.85])
        (Authenticated sender: zack)
        by letterbox.kde.org (Postfix) with ESMTPSA id E9AFB2803BE;
        Mon, 17 Jan 2022 18:04:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kde.org; s=users;
        t=1642442643; bh=33eQEETxfERBMS7qtT+2wI7RlDlwhQOJPaA8rO+sDYw=;
        h=From:To:Cc:Subject:Date:From;
        b=Mjhjhu/r3cFlAQsKztuxXBoIlu2wxQHROCV5M/mIM7DQstTk0rz+4T7ZZzBj7oOZm
         zpXBRtebFNIuZ38jC9eyBWD92dKIcl9JQMZImC1ZFT6snMxgi+qZXe17CLfaIJwHIN
         h040F++kyAC05uVoYCCj7bmk9tHtyVVZ0IjqPhACnJbe0N4aOYHDxxe1ukYLjmR3mo
         Tm9JeC25WKNfUWVft9QJJ6EgbQq5REeyp9hxwy4r+ykpqIM4r8iMLigP3m7d54aDlV
         E8p2/Qp7hcKdtrswhGj/htWouFZqrNc+fpO/23Z5v+KGtl3GX+Zn3AvbyqpHYpWTXZ
         m69e6WYJ6SCtg==
From:   Zack Rusin <zack@kde.org>
To:     dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, mombasawalam@vmware.com,
        Zack Rusin <zackr@vmware.com>, stable@vger.kernel.org
Subject: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Date:   Mon, 17 Jan 2022 13:03:59 -0500
Message-Id: <20220117180359.18114-1-zack@kde.org>
X-Mailer: git-send-email 2.32.0
Reply-To: Zack Rusin <zackr@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

When sysfb_simple is enabled loading vmwgfx fails because the regions
are held by the platform. In that case remove_conflicting*_framebuffers
only removes the simplefb but not the regions held by sysfb.

Like the other drm drivers we need to stop requesting all the pci regions
to let the driver load with platform code enabled.
This allows vmwgfx to load correctly on systems with sysfb_simple enabled.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 523375c943e5 ("drm/vmwgfx: Port vmwgfx to arm64")
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index fe36efdb7ff5..27feb19f3324 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -724,10 +724,6 @@ static int vmw_setup_pci_resources(struct vmw_private *dev,
 
 	pci_set_master(pdev);
 
-	ret = pci_request_regions(pdev, "vmwgfx probe");
-	if (ret)
-		return ret;
-
 	dev->pci_id = pci_id;
 	if (pci_id == VMWGFX_PCI_ID_SVGA3) {
 		rmmio_start = pci_resource_start(pdev, 0);
-- 
2.32.0

