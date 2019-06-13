Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280CE43F3D
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390202AbfFMPzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731534AbfFMIvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7B292147A;
        Thu, 13 Jun 2019 08:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415894;
        bh=NdppzMid5r0anaN4f9V/2pAbCIJRpDkSOphAccyUNqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9hihTwiSxJoac6erMAdOSaTWIVseA6ut5bxPnQFXL/as8imXbgzmck+7vi7N+6X0
         qIQkR3S9LkfuaA1QCoKNqfcg4+i8QsNArvCo93tXCcokOukh5VfzaW/XKz+IEE3Dvd
         1GCireSzGuTMitHZ+cETat4a3MyGaH+jGSYyJ+OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Joachim <svenjoac@gmx.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Thomas Backlund <tmb@mageia.org>
Subject: [PATCH 5.1 153/155] Revert "drm/nouveau: add kconfig option to turn off nouveau legacy contexts. (v3)"
Date:   Thu, 13 Jun 2019 10:34:25 +0200
Message-Id: <20190613075701.342454408@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 1e07d637497788971018d9e9e5a184940b1ade0f which is
commit b30a43ac7132cdda833ac4b13dd1ebd35ace14b7 upstream.

Sven reports:
	Commit 1e07d63749 ("drm/nouveau: add kconfig option to turn off nouveau
	legacy contexts. (v3)") has caused a build failure for me when I
	actually tried that option (CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n):

	,----
	| Kernel: arch/x86/boot/bzImage is ready  (#1)
	|   Building modules, stage 2.
	|   MODPOST 290 modules
	| ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
	| scripts/Makefile.modpost:91: recipe for target '__modpost' failed
	`----

	Upstream does not have that problem, as commit bed2dd8421 ("drm/ttm:
	Quick-test mmap offset in ttm_bo_mmap()") has removed the use of
	drm_legacy_mmap from nouveau_ttm.c.  Unfortunately that commit does not
	apply in 5.1.9.

The ensuing discussion proposed a number of one-off patches, but no
solid agreement was made, so just revert the commit for now to get
people's systems building again.

Reported-by: Sven Joachim <svenjoac@gmx.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Thomas Backlund <tmb@mageia.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/Kconfig       |   13 +------------
 drivers/gpu/drm/nouveau/nouveau_drm.c |    7 ++-----
 2 files changed, 3 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -17,20 +17,9 @@ config DRM_NOUVEAU
 	select INPUT if ACPI && X86
 	select THERMAL if ACPI && X86
 	select ACPI_VIDEO if ACPI && X86
-	help
-	  Choose this option for open-source NVIDIA support.
-
-config NOUVEAU_LEGACY_CTX_SUPPORT
-	bool "Nouveau legacy context support"
-	depends on DRM_NOUVEAU
 	select DRM_VM
-	default y
 	help
-	  There was a version of the nouveau DDX that relied on legacy
-	  ctx ioctls not erroring out. But that was back in time a long
-	  ways, so offer a way to disable it now. For uapi compat with
-	  old nouveau ddx this should be on by default, but modern distros
-	  should consider turning it off.
+	  Choose this option for open-source NVIDIA support.
 
 config NOUVEAU_PLATFORM_DRIVER
 	bool "Nouveau (NVIDIA) SoC GPUs"
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -1094,11 +1094,8 @@ nouveau_driver_fops = {
 static struct drm_driver
 driver_stub = {
 	.driver_features =
-		DRIVER_GEM | DRIVER_MODESET | DRIVER_PRIME | DRIVER_RENDER
-#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
-		| DRIVER_KMS_LEGACY_CONTEXT
-#endif
-		,
+		DRIVER_GEM | DRIVER_MODESET | DRIVER_PRIME | DRIVER_RENDER |
+		DRIVER_KMS_LEGACY_CONTEXT,
 
 	.open = nouveau_drm_open,
 	.postclose = nouveau_drm_postclose,


