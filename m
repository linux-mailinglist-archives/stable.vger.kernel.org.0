Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D7A109C17
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 11:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfKZKPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 05:15:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:37090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727388AbfKZKPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 05:15:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CCCB3B9FD;
        Tue, 26 Nov 2019 10:15:31 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, daniel@ffwll.ch, john.p.donnelly@oracle.com,
        kraxel@redhat.com, sam@ravnborg.org
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Emil Velikov <emil.velikov@collabora.com>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/3] drm/mgag200: Extract device type from flags
Date:   Tue, 26 Nov 2019 11:15:27 +0100
Message-Id: <20191126101529.20356-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191126101529.20356-1-tzimmermann@suse.de>
References: <20191126101529.20356-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adds a conversion function that extracts the device type from the
PCI id-table flags. Allows for storing additional information in the
other flag bits.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 81da87f63a1e ("drm: Replace drm_gem_vram_push_to_system() with kunmap + unpin")
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: John Donnelly <john.p.donnelly@oracle.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "José Roberto de Souza" <jose.souza@intel.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.3+
---
 drivers/gpu/drm/mgag200/mgag200_drv.h  | 7 +++++++
 drivers/gpu/drm/mgag200/mgag200_main.c | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index 0ea9a525e57d..976404634092 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -150,6 +150,8 @@ enum mga_type {
 	G200_EW3,
 };
 
+#define MGAG200_TYPE_MASK	(0x000000ff)
+
 #define IS_G200_SE(mdev) (mdev->type == G200_SE_A || mdev->type == G200_SE_B)
 
 struct mga_device {
@@ -181,6 +183,11 @@ struct mga_device {
 	u32 unique_rev_id;
 };
 
+static inline enum mga_type
+mgag200_type_from_driver_data(kernel_ulong_t driver_data)
+{
+	return (enum mga_type)(driver_data & MGAG200_TYPE_MASK);
+}
 				/* mgag200_mode.c */
 int mgag200_modeset_init(struct mga_device *mdev);
 void mgag200_modeset_fini(struct mga_device *mdev);
diff --git a/drivers/gpu/drm/mgag200/mgag200_main.c b/drivers/gpu/drm/mgag200/mgag200_main.c
index 5f74aabcd3df..517c5693ad69 100644
--- a/drivers/gpu/drm/mgag200/mgag200_main.c
+++ b/drivers/gpu/drm/mgag200/mgag200_main.c
@@ -94,7 +94,7 @@ static int mgag200_device_init(struct drm_device *dev,
 	struct mga_device *mdev = dev->dev_private;
 	int ret, option;
 
-	mdev->type = flags;
+	mdev->type = mgag200_type_from_driver_data(flags);
 
 	/* Hardcode the number of CRTCs to 1 */
 	mdev->num_crtc = 1;
-- 
2.23.0

