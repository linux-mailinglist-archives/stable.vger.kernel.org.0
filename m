Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07EB23A714
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfFIQqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730268AbfFIQqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:46:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5964B2081C;
        Sun,  9 Jun 2019 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098765;
        bh=lJfIZCFFMQ+3+weqOMdFEChPc+m93c73yWsmP5nWl4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8rV+1k0IH7EmLMTj5EeDaELrP+QkI43UVgmavQOxh1iLCzzM+vpbdeuC4WAojnLT
         S/D8Ea1IVxy0a2Ds2GQfg2eawh8m9OKydvB4eUmY6uJzBCAknkzyQCxozk7e9Qvbmc
         VCfBZgtfBTq69hYJzDSoZqEjO8Uv9g7CUqCjK5nU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.1 54/70] drm/nouveau: add kconfig option to turn off nouveau legacy contexts. (v3)
Date:   Sun,  9 Jun 2019 18:42:05 +0200
Message-Id: <20190609164131.995076251@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

commit b30a43ac7132cdda833ac4b13dd1ebd35ace14b7 upstream.

There was a nouveau DDX that relied on legacy context ioctls to work,
but we fixed it years ago, give distros that have a modern DDX the
option to break the uAPI and close the mess of holes that legacy
context support is.

Full context of the story:

commit 0e975980d435d58df2d430d688b8c18778b42218
Author: Peter Antoine <peter.antoine@intel.com>
Date:   Tue Jun 23 08:18:49 2015 +0100

    drm: Turn off Legacy Context Functions

    The context functions are not used by the i915 driver and should not
    be used by modeset drivers. These driver functions contain several bugs
    and security holes. This change makes these functions optional can be
    turned on by a setting, they are turned off by default for modeset
    driver with the exception of the nouvea driver that may require them with
    an old version of libdrm.

    The previous attempt was

    commit 7c510133d93dd6f15ca040733ba7b2891ed61fd1
    Author: Daniel Vetter <daniel.vetter@ffwll.ch>
    Date:   Thu Aug 8 15:41:21 2013 +0200

        drm: mark context support as a legacy subsystem

    but this had to be reverted

    commit c21eb21cb50d58e7cbdcb8b9e7ff68b85cfa5095
    Author: Dave Airlie <airlied@redhat.com>
    Date:   Fri Sep 20 08:32:59 2013 +1000

        Revert "drm: mark context support as a legacy subsystem"

    v2: remove returns from void function, and formatting (Daniel Vetter)

    v3:
    - s/Nova/nouveau/ in the commit message, and add references to the
      previous attempts
    - drop the part touching the drm hw lock, that should be a separate
      patch.

    Signed-off-by: Peter Antoine <peter.antoine@intel.com> (v2)
    Cc: Peter Antoine <peter.antoine@intel.com> (v2)
    Reviewed-by: Peter Antoine <peter.antoine@intel.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

v2: move DRM_VM dependency into legacy config.
v3: fix missing dep (kbuild robot)

Cc: stable@vger.kernel.org
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/Kconfig       |   13 ++++++++++++-
 drivers/gpu/drm/nouveau/nouveau_drm.c |    7 +++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -17,10 +17,21 @@ config DRM_NOUVEAU
 	select INPUT if ACPI && X86
 	select THERMAL if ACPI && X86
 	select ACPI_VIDEO if ACPI && X86
-	select DRM_VM
 	help
 	  Choose this option for open-source NVIDIA support.
 
+config NOUVEAU_LEGACY_CTX_SUPPORT
+	bool "Nouveau legacy context support"
+	depends on DRM_NOUVEAU
+	select DRM_VM
+	default y
+	help
+	  There was a version of the nouveau DDX that relied on legacy
+	  ctx ioctls not erroring out. But that was back in time a long
+	  ways, so offer a way to disable it now. For uapi compat with
+	  old nouveau ddx this should be on by default, but modern distros
+	  should consider turning it off.
+
 config NOUVEAU_PLATFORM_DRIVER
 	bool "Nouveau (NVIDIA) SoC GPUs"
 	depends on DRM_NOUVEAU && ARCH_TEGRA
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -1094,8 +1094,11 @@ nouveau_driver_fops = {
 static struct drm_driver
 driver_stub = {
 	.driver_features =
-		DRIVER_GEM | DRIVER_MODESET | DRIVER_PRIME | DRIVER_RENDER |
-		DRIVER_KMS_LEGACY_CONTEXT,
+		DRIVER_GEM | DRIVER_MODESET | DRIVER_PRIME | DRIVER_RENDER
+#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
+		| DRIVER_KMS_LEGACY_CONTEXT
+#endif
+		,
 
 	.open = nouveau_drm_open,
 	.postclose = nouveau_drm_postclose,


