Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E101328FC5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242428AbhCAT6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235677AbhCATot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 508956500F;
        Mon,  1 Mar 2021 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618577;
        bh=K+OjDIPYCbxWk0EUBLNudxD/OFd+ePHa1hMiMN+nUjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjSjIz/Ar/E99XNe6KnibG9ON5py6fmOecz6dvqln6nUwRIl1ibrpDe5/iib+le28
         M6u9SNntGZfF/mOKQa6EtjK4vtoaWd+jLVbBza2iA6UZRDPtM2F3UU7gc6SDVeO3tM
         dCpKCezVQod21iNSpBKvcMiTvN0L+Yx4rfdIUhZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/663] fbdev: aty: SPARC64 requires FB_ATY_CT
Date:   Mon,  1 Mar 2021 17:06:26 +0100
Message-Id: <20210301161148.585856050@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c6c90c70db4d9a0989111d6b994d545659410f7a ]

It looks like SPARC64 requires FB_ATY_CT to build without errors,
so have FB_ATY select FB_ATY_CT if both SPARC64 and PCI are enabled
instead of using "default y if SPARC64 && PCI", which is not strong
enough to prevent build errors.

As it currently is, FB_ATY_CT can be disabled, resulting in build
errors:

ERROR: modpost: "aty_postdividers" [drivers/video/fbdev/aty/atyfb.ko] undefined!
ERROR: modpost: "aty_ld_pll_ct" [drivers/video/fbdev/aty/atyfb.ko] undefined!

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: f7018c213502 ("video: move fbdev to drivers/video/fbdev")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20201127031752.10371-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index cfb7f5612ef0f..4f02db65dedec 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1269,6 +1269,7 @@ config FB_ATY
 	select FB_CFB_IMAGEBLIT
 	select FB_BACKLIGHT if FB_ATY_BACKLIGHT
 	select FB_MACMODES if PPC
+	select FB_ATY_CT if SPARC64 && PCI
 	help
 	  This driver supports graphics boards with the ATI Mach64 chips.
 	  Say Y if you have such a graphics board.
@@ -1279,7 +1280,6 @@ config FB_ATY
 config FB_ATY_CT
 	bool "Mach64 CT/VT/GT/LT (incl. 3D RAGE) support"
 	depends on PCI && FB_ATY
-	default y if SPARC64 && PCI
 	help
 	  Say Y here to support use of ATI's 64-bit Rage boards (or other
 	  boards based on the Mach64 CT, VT, GT, and LT chipsets) as a
-- 
2.27.0



