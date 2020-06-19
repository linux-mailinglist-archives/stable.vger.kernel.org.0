Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B3420175D
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388765AbgFSQhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389072AbgFSOs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:48:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67E77217A0;
        Fri, 19 Jun 2020 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578105;
        bh=1NwQk1K6lLsrqLB6IY13pY0x8Cx6AXaH8S5+lSyieKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuYk3HuI20oFyyuHAtw2CUJZ22QUJGZ/gbt1/FVylZJx9IvIVdJli6JuYkuob3UoN
         w8fyeLqE4ZGg8YigtXhXXMM26UM85Wyj97oEs3/qYLPbSKEz3AgJPClmh/6jku9pUi
         hm7nJTYloCf5MhbzAvIxhw2AEVCxngFMRsXkjuY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/190] MIPS: Loongson: Build ATI Radeon GPU driver as module
Date:   Fri, 19 Jun 2020 16:32:09 +0200
Message-Id: <20200619141637.791403611@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit a44de7497f91834df0b8b6d459e259788ba66794 ]

When ATI Radeon GPU driver has been compiled directly into the kernel
instead of as a module, we should make sure the firmware for the model
(check available ones in /lib/firmware/radeon) is built-in to the kernel
as well, otherwise there exists the following fatal error during GPU init,
change CONFIG_DRM_RADEON=y to CONFIG_DRM_RADEON=m to fix it.

[    1.900997] [drm] Loading RS780 Microcode
[    1.905077] radeon 0000:01:05.0: Direct firmware load for radeon/RS780_pfp.bin failed with error -2
[    1.914140] r600_cp: Failed to load firmware "radeon/RS780_pfp.bin"
[    1.920405] [drm:r600_init] *ERROR* Failed to load firmware!
[    1.926069] radeon 0000:01:05.0: Fatal error during GPU init
[    1.931729] [drm] radeon: finishing device.

Fixes: 024e6a8b5bb1 ("MIPS: Loongson: Add a Loongson-3 default config file")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/configs/loongson3_defconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/configs/loongson3_defconfig b/arch/mips/configs/loongson3_defconfig
index 324dfee23dfb..c871e40b8878 100644
--- a/arch/mips/configs/loongson3_defconfig
+++ b/arch/mips/configs/loongson3_defconfig
@@ -250,7 +250,7 @@ CONFIG_MEDIA_CAMERA_SUPPORT=y
 CONFIG_MEDIA_USB_SUPPORT=y
 CONFIG_USB_VIDEO_CLASS=m
 CONFIG_DRM=y
-CONFIG_DRM_RADEON=y
+CONFIG_DRM_RADEON=m
 CONFIG_FB_RADEON=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_LCD_PLATFORM=m
-- 
2.25.1



