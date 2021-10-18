Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4F431D21
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhJRNsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232717AbhJRNqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:46:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22779613D2;
        Mon, 18 Oct 2021 13:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564159;
        bh=hgMGe4nzlQLDBy/snzkJQDmTs3EaaYatJgM75VBBZQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rHYgbfeUellYgUYXIsPyDd/41Vy7R+svF5suxy4ySkCqYWQp4Q+YcKl/lUFvy6ts
         EtkrEycpvywDESXJX60Z17hJHpOfz6vdG2inK/vdAOdekPivCzhojbdbzb2/nftcdh
         vW4OcGrXG1gljdpeAKcs86Hha+bKi/OINzrongGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.10 088/103] drm/panel: olimex-lcd-olinuxino: select CRC32
Date:   Mon, 18 Oct 2021 15:25:04 +0200
Message-Id: <20211018132337.709354324@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

commit a14bc107edd0c108bda2245e50daa22f91c95d20 upstream.

Fix the following build/link error by adding a dependency on the CRC32
routines:

  ld: drivers/gpu/drm/panel/panel-olimex-lcd-olinuxino.o: in function `lcd_olinuxino_probe':
  panel-olimex-lcd-olinuxino.c:(.text+0x303): undefined reference to `crc32_le'

Fixes: 17fd7a9d324fd ("drm/panel: Add support for Olimex LCD-OLinuXino panel")
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211012115242.10325-1-vegard.nossum@oracle.com
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -233,6 +233,7 @@ config DRM_PANEL_OLIMEX_LCD_OLINUXINO
 	depends on OF
 	depends on I2C
 	depends on BACKLIGHT_CLASS_DEVICE
+	select CRC32
 	help
 	  The panel is used with different sizes LCDs, from 480x272 to
 	  1280x800, and 24 bit per pixel.


