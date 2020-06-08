Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB611F311D
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgFIBF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727820AbgFHXHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2B7320842;
        Mon,  8 Jun 2020 23:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657632;
        bh=asHvb1M4yJnWpzR6XeynGk7s5pr0sNh85tnSYRIZyVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bxB2fj6AmupA8MqEdRE5Um4Jq+W7F/sgw1z6t++Dgbx1Gr3sTo9yIp6QoHf0Alsel
         ryuEUlm2PHJyGpZ7KI3QZ1E+dtDJfTw5XFqhfJKo1HuxQfD2szANLFql7vpgjNxJxY
         abes/FiBRDQAvZMMSqo+8CWvvmxDNvw8BO7NfITs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 051/274] MIPS: Loongson: Build ATI Radeon GPU driver as module
Date:   Mon,  8 Jun 2020 19:02:24 -0400
Message-Id: <20200608230607.3361041-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 51675f5000d6..b0c24bd292b2 100644
--- a/arch/mips/configs/loongson3_defconfig
+++ b/arch/mips/configs/loongson3_defconfig
@@ -229,7 +229,7 @@ CONFIG_MEDIA_CAMERA_SUPPORT=y
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

