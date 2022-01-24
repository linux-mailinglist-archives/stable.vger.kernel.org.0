Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEE8499D84
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380205AbiAXWYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583334AbiAXWRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A661C0613A9;
        Mon, 24 Jan 2022 12:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF2EE60B1A;
        Mon, 24 Jan 2022 20:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C80C340E5;
        Mon, 24 Jan 2022 20:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057331;
        bh=RCV48ZSlTzuCqmHvJn71DlSzI5sKqDQyg1UX/Fny5Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3vs+ANjhIVT2D1B1O5nO6qtfKvz0h5O5jC4d4XCR5deAl8RsTExNrvMA1fIOuZa/
         UkjOEMZX4GbOkIjHAAPOfvm3dy4aH7M6h6BbrdAF6KLGYSQN9iXCK4OfZPx++M1kQx
         wG6ZsYqevxh9ioy7PY5QGSHhtJ9HEww30FDbz/jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.15 777/846] drm/vmwgfx: Remove unused compile options
Date:   Mon, 24 Jan 2022 19:44:54 +0100
Message-Id: <20220124184127.762091443@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

commit 50ca8cc7c0fdd9ab16b8b66ffb301fface101fac upstream.

Before the driver had screen targets support we had to disable explicit
bringup of its infrastructure because it was breaking screen objects
support.
Since the implementation of screen targets landed there hasn't been a
reason to explicitly disable it and the options were never used.
Remove of all that unused code.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: d80efd5cb3de ("drm/vmwgfx: Initial DX support")
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211215184147.3688785-3-zack@kde.org
(cherry picked from commit 11343099d5ae6c7411da1425b6b162c89fb5bf10)
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h  |    3 ---
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c  |   12 +++---------
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c |    4 ++--
 3 files changed, 5 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -59,11 +59,8 @@
 #define VMWGFX_DRIVER_MINOR 19
 #define VMWGFX_DRIVER_PATCHLEVEL 0
 #define VMWGFX_FIFO_STATIC_SIZE (1024*1024)
-#define VMWGFX_MAX_RELOCATIONS 2048
-#define VMWGFX_MAX_VALIDATIONS 2048
 #define VMWGFX_MAX_DISPLAYS 16
 #define VMWGFX_CMD_BOUNCE_INIT_SIZE 32768
-#define VMWGFX_ENABLE_SCREEN_TARGET_OTABLE 1
 
 #define VMWGFX_PCI_ID_SVGA2              0x0405
 #define VMWGFX_PCI_ID_SVGA3              0x0406
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR MIT
 /**************************************************************************
  *
- * Copyright 2012-2015 VMware, Inc., Palo Alto, CA., USA
+ * Copyright 2012-2021 VMware, Inc., Palo Alto, CA., USA
  *
  * Permission is hereby granted, free of charge, to any person obtaining a
  * copy of this software and associated documentation files (the
@@ -29,12 +29,6 @@
 
 #include "vmwgfx_drv.h"
 
-/*
- * If we set up the screen target otable, screen objects stop working.
- */
-
-#define VMW_OTABLE_SETUP_SUB ((VMWGFX_ENABLE_SCREEN_TARGET_OTABLE ? 0 : 1))
-
 #ifdef CONFIG_64BIT
 #define VMW_PPN_SIZE 8
 #define VMW_MOBFMT_PTDEPTH_0 SVGA3D_MOBFMT_PT64_0
@@ -75,7 +69,7 @@ static const struct vmw_otable pre_dx_ta
 	{VMWGFX_NUM_GB_CONTEXT * sizeof(SVGAOTableContextEntry), NULL, true},
 	{VMWGFX_NUM_GB_SHADER * sizeof(SVGAOTableShaderEntry), NULL, true},
 	{VMWGFX_NUM_GB_SCREEN_TARGET * sizeof(SVGAOTableScreenTargetEntry),
-	 NULL, VMWGFX_ENABLE_SCREEN_TARGET_OTABLE}
+	 NULL, true}
 };
 
 static const struct vmw_otable dx_tables[] = {
@@ -84,7 +78,7 @@ static const struct vmw_otable dx_tables
 	{VMWGFX_NUM_GB_CONTEXT * sizeof(SVGAOTableContextEntry), NULL, true},
 	{VMWGFX_NUM_GB_SHADER * sizeof(SVGAOTableShaderEntry), NULL, true},
 	{VMWGFX_NUM_GB_SCREEN_TARGET * sizeof(SVGAOTableScreenTargetEntry),
-	 NULL, VMWGFX_ENABLE_SCREEN_TARGET_OTABLE},
+	 NULL, true},
 	{VMWGFX_NUM_DXCONTEXT * sizeof(SVGAOTableDXContextEntry), NULL, true},
 };
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
@@ -1872,8 +1872,8 @@ int vmw_kms_stdu_init_display(struct vmw
 	int i, ret;
 
 
-	/* Do nothing if Screen Target support is turned off */
-	if (!VMWGFX_ENABLE_SCREEN_TARGET_OTABLE || !dev_priv->has_mob)
+	/* Do nothing if there's no support for MOBs */
+	if (!dev_priv->has_mob)
 		return -ENOSYS;
 
 	if (!(dev_priv->capabilities & SVGA_CAP_GBOBJECTS))


