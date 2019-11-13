Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918FBFA502
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfKMByZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbfKMByY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C72D420674;
        Wed, 13 Nov 2019 01:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610063;
        bh=Pa5fKk6CHyK6RI2MGsaLXHeaFP6X1ftK/j9elCp552A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKBDy4lsTgrpfaJ7g42DI+nLxT77alvzNTRtWVNGRdyE7Ekf4tK8RvSH4iNEaoB1R
         tXPISHjaq3N8xqS9FShQjfIGkFtig32ioj1YibJav9ck3h0hHJn6Z4xADnBc2INVW4
         Eg3155VnjF70gEsnE1j9JNwwwqhaUcUtlKrvKEmQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alexander Shiyan <shc_work@mail.ru>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 143/209] fbdev: fix broken menu dependencies
Date:   Tue, 12 Nov 2019 20:49:19 -0500
Message-Id: <20191113015025.9685-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit aae3394ef0ef90cf00a21133357448385f13a5d4 ]

The framebuffer options and devices menu is unintentionally split
or broken because some items in it do not depend on FB (including
several under omap and mmp).
Fix this by moving FB_CMDLINE, FB_NOTIFY, and FB_CLPS711X_OLD to
just before the FB Kconfig symbol definition and by moving the
omap, omap2, and mmp menus to last, following FB_SM712.

Also, the FB_VIA dependencies are duplicated by both being inside
an "if FB_VIA/endif" block and "depends on FB_VIA", so drop the
"depends on FB_VIA" lines since they are redundant.

Fixes: ea6763c104c9 ("video/fbdev: Always built-in video= cmdline parsing")
Fixes: 5ec9653806ba ("fbdev: Make fb-notify a no-op if CONFIG_FB=n")
Fixes: ef74d46a4ef3 ("video: clps711x: Add new Cirrus Logic CLPS711X framebuffer driver")

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/Kconfig | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 591a13a597874..f99558d006bf4 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2,6 +2,18 @@
 # fbdev configuration
 #
 
+config FB_CMDLINE
+	bool
+
+config FB_NOTIFY
+	bool
+
+config FB_CLPS711X_OLD
+	tristate
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+
 menuconfig FB
 	tristate "Support for frame buffer devices"
 	select FB_CMDLINE
@@ -54,12 +66,6 @@ config FIRMWARE_EDID
 	 combination with certain motherboards and monitors are known to
 	 suffer from this problem.
 
-config FB_CMDLINE
-	bool
-
-config FB_NOTIFY
-	bool
-
 config FB_DDC
        tristate
        depends on FB
@@ -329,12 +335,6 @@ config FB_ACORN
 	  hardware found in Acorn RISC PCs and other ARM-based machines.  If
 	  unsure, say N.
 
-config FB_CLPS711X_OLD
-	tristate
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-
 config FB_CLPS711X
 	tristate "CLPS711X LCD support"
 	depends on FB && (ARCH_CLPS711X || COMPILE_TEST)
@@ -1456,7 +1456,6 @@ if FB_VIA
 
 config FB_VIA_DIRECT_PROCFS
 	bool "direct hardware access via procfs (DEPRECATED)(DANGEROUS)"
-	depends on FB_VIA
 	default n
 	help
 	  Allow direct hardware access to some output registers via procfs.
@@ -1466,7 +1465,6 @@ config FB_VIA_DIRECT_PROCFS
 
 config FB_VIA_X_COMPATIBILITY
 	bool "X server compatibility"
-	depends on FB_VIA
 	default n
 	help
 	  This option reduces the functionality (power saving, ...) of the
@@ -2308,10 +2306,6 @@ config FB_SIMPLE
 	  Configuration re: surface address, size, and format must be provided
 	  through device tree, or plain old platform data.
 
-source "drivers/video/fbdev/omap/Kconfig"
-source "drivers/video/fbdev/omap2/Kconfig"
-source "drivers/video/fbdev/mmp/Kconfig"
-
 config FB_SSD1307
 	tristate "Solomon SSD1307 framebuffer support"
 	depends on FB && I2C
@@ -2341,3 +2335,7 @@ config FB_SM712
 	  This driver is also available as a module. The module will be
 	  called sm712fb. If you want to compile it as a module, say M
 	  here and read <file:Documentation/kbuild/modules.txt>.
+
+source "drivers/video/fbdev/omap/Kconfig"
+source "drivers/video/fbdev/omap2/Kconfig"
+source "drivers/video/fbdev/mmp/Kconfig"
-- 
2.20.1

