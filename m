Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F71126BA6
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbfLSSzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbfLSSzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F132465E;
        Thu, 19 Dec 2019 18:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781704;
        bh=I4FicGF1nduQhWKADf+S3DKjlXW9oqIQD8OotutLefg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wSHA+3p2yCqgBTvysPl5M0dF6auMbTECHKj4jiCODJQhPoLNDsEEssHaePUO6Kq/
         pwflQ6I4+lH9SxZ6tinWN+0v32c78VVkOzGMP9m2vi7Zw9Zy+jg2ASLedryfFuyAER
         Hc1er0BWoYyLOEPAIVh6kfHoMd02q/+oen/ZZ2lI=
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
        "Y.C. Chen" <yc_chen@aspeedtech.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.4 47/80] drm/mgag200: Store flags from PCI driver data in device structure
Date:   Thu, 19 Dec 2019 19:34:39 +0100
Message-Id: <20191219183114.978179449@linuxfoundation.org>
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

commit d6d437d97d54c85a1a93967b2745e31dff03365a upstream.

The flags field in struct mga_device has been unused so far. We now
use it to store flag bits from the PCI driver.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Fixes: 81da87f63a1e ("drm: Replace drm_gem_vram_push_to_system() with kunmap + unpin")
Cc: John Donnelly <john.p.donnelly@oracle.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "José Roberto de Souza" <jose.souza@intel.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.3+
Link: https://patchwork.freedesktop.org/patch/msgid/20191126101529.20356-3-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_drv.h  |    8 ++++++++
 drivers/gpu/drm/mgag200/mgag200_main.c |    1 +
 2 files changed, 9 insertions(+)

--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -160,6 +160,7 @@ enum mga_type {
 };
 
 #define MGAG200_TYPE_MASK	(0x000000ff)
+#define MGAG200_FLAG_MASK	(0x00ffff00)
 
 #define IS_G200_SE(mdev) (mdev->type == G200_SE_A || mdev->type == G200_SE_B)
 
@@ -195,6 +196,13 @@ mgag200_type_from_driver_data(kernel_ulo
 {
 	return (enum mga_type)(driver_data & MGAG200_TYPE_MASK);
 }
+
+static inline unsigned long
+mgag200_flags_from_driver_data(kernel_ulong_t driver_data)
+{
+	return driver_data & MGAG200_FLAG_MASK;
+}
+
 				/* mgag200_mode.c */
 int mgag200_modeset_init(struct mga_device *mdev);
 void mgag200_modeset_fini(struct mga_device *mdev);
--- a/drivers/gpu/drm/mgag200/mgag200_main.c
+++ b/drivers/gpu/drm/mgag200/mgag200_main.c
@@ -94,6 +94,7 @@ static int mgag200_device_init(struct dr
 	struct mga_device *mdev = dev->dev_private;
 	int ret, option;
 
+	mdev->flags = mgag200_flags_from_driver_data(flags);
 	mdev->type = mgag200_type_from_driver_data(flags);
 
 	/* Hardcode the number of CRTCs to 1 */


