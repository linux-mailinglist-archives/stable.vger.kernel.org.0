Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29EF22B4BC
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 19:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbgGWRVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 13:21:24 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:49675 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728600AbgGWRVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 13:21:24 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21910647-1500050 
        for multiple; Thu, 23 Jul 2020 18:21:21 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        CQ Tang <cq.tang@intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] drm: Restore driver.preclose() for all to use
Date:   Thu, 23 Jul 2020 18:21:17 +0100
Message-Id: <20200723172119.17649-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An unfortunate sequence of events, but it turns out there is a valid
usecase for being able to free/decouple the driver objects before they
are freed by the DRM core. In particular, if we have a pointer into a
drm core object from inside a driver object, that pointer needs to be
nerfed *before* it is freed so that concurrent access (e.g. debugfs)
does not following the dangling pointer.

The legacy marker was adding in the code movement from drp_fops.c to
drm_file.c

References: 9acdac68bcdc ("drm: rename drm_fops.c to drm_file.c")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: CQ Tang <cq.tang@intel.com>
Cc: <stable@vger.kernel.org> # v4.12+
---
 drivers/gpu/drm/drm_file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index 0ac4566ae3f4..7b4258d6f7cc 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -258,8 +258,7 @@ void drm_file_free(struct drm_file *file)
 		  (long)old_encode_dev(file->minor->kdev->devt),
 		  atomic_read(&dev->open_count));
 
-	if (drm_core_check_feature(dev, DRIVER_LEGACY) &&
-	    dev->driver->preclose)
+	if (dev->driver->preclose)
 		dev->driver->preclose(dev, file);
 
 	if (drm_core_check_feature(dev, DRIVER_LEGACY))
-- 
2.20.1

