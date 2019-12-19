Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 951E2126BA5
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfLSSzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729849AbfLSSzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC2B1222C2;
        Thu, 19 Dec 2019 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781702;
        bh=lxiLAwc3bq7yRsFDpS8Y/vXlzk3A1s79z7n/XxmpgZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M04HltVi8w1WzySTFYCLneYGnfUjHaeOgfGU4jXb075J3ZmGFIkKipVVZuMFlMeqS
         Shpd4BYLSo5gvTwCaJ1xSE008COi+3g+5EUt9+1KojMB0RTCADeWWJyr+YgLuzkRlv
         BpEX40ap6iWS1dfdblQ4NdEdxvqHHpI7YjVhc6GA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Sam Ravnborg <sam@ravnborg.org>,
        Emil Velikov <emil.velikov@collabora.com>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.4 46/80] drm/mgag200: Extract device type from flags
Date:   Thu, 19 Dec 2019 19:34:38 +0100
Message-Id: <20191219183113.297293802@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 3a8a5aba142a44eaeba0cb0ec1b4a8f177b5e59a upstream.

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
Link: https://patchwork.freedesktop.org/patch/msgid/20191126101529.20356-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_drv.h  |    7 +++++++
 drivers/gpu/drm/mgag200/mgag200_main.c |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -159,6 +159,8 @@ enum mga_type {
 	G200_EW3,
 };
 
+#define MGAG200_TYPE_MASK	(0x000000ff)
+
 #define IS_G200_SE(mdev) (mdev->type == G200_SE_A || mdev->type == G200_SE_B)
 
 struct mga_device {
@@ -188,6 +190,11 @@ struct mga_device {
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
--- a/drivers/gpu/drm/mgag200/mgag200_main.c
+++ b/drivers/gpu/drm/mgag200/mgag200_main.c
@@ -94,7 +94,7 @@ static int mgag200_device_init(struct dr
 	struct mga_device *mdev = dev->dev_private;
 	int ret, option;
 
-	mdev->type = flags;
+	mdev->type = mgag200_type_from_driver_data(flags);
 
 	/* Hardcode the number of CRTCs to 1 */
 	mdev->num_crtc = 1;


