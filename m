Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287CE2893F
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391967AbfEWTcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391945AbfEWTcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:32:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2345B21881;
        Thu, 23 May 2019 19:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639921;
        bh=9tqMZWqEHULiuOWDI2seNvJ1xyybwcMj/Ewo4lbLsvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkPtJD7J6OzuNymBw+KpEimKMm42fmkrHghKQX04XFdmZhB41EfAgiAaYrXsi90RB
         bLDF5i+TiOKS0GISv+LZc3YhHxgk6XHGsrkREXmhNRLmvhrs2DoZ8ywEvQaV+owOr/
         Q0Q3X0yetCCgnNB/3NsUtY2SadDHMbZ47pXwsH68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifeng Li <tomli@tomli.me>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.1 092/122] fbdev: sm712fb: use 1024x768 by default on non-MIPS, fix garbled display
Date:   Thu, 23 May 2019 21:06:54 +0200
Message-Id: <20190523181717.258003900@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifeng Li <tomli@tomli.me>

commit 4ed7d2ccb7684510ec5f7a8f7ef534bc6a3d55b2 upstream.

Loongson MIPS netbooks use 1024x600 LCD panels, which is the original
target platform of this driver, but nearly all old x86 laptops have
1024x768. Lighting 768 panels using 600's timings would partially
garble the display. Since it's not possible to distinguish them reliably,
we change the default to 768, but keep 600 as-is on MIPS.

Further, earlier laptops, such as IBM Thinkpad 240X, has a 800x600 LCD
panel, this driver would probably garbled those display. As we don't
have one for testing, the original behavior of the driver is kept as-is,
but the problem has been documented is the comments.

Signed-off-by: Yifeng Li <tomli@tomli.me>
Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Teddy Wang <teddy.wang@siliconmotion.com>
Cc: <stable@vger.kernel.org>  # v4.4+
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/sm712.h   |    7 +++--
 drivers/video/fbdev/sm712fb.c |   53 +++++++++++++++++++++++++++++++-----------
 2 files changed, 44 insertions(+), 16 deletions(-)

--- a/drivers/video/fbdev/sm712.h
+++ b/drivers/video/fbdev/sm712.h
@@ -15,9 +15,10 @@
 
 #define FB_ACCEL_SMI_LYNX 88
 
-#define SCREEN_X_RES      1024
-#define SCREEN_Y_RES      600
-#define SCREEN_BPP        16
+#define SCREEN_X_RES          1024
+#define SCREEN_Y_RES_PC       768
+#define SCREEN_Y_RES_NETBOOK  600
+#define SCREEN_BPP            16
 
 #define dac_reg	(0x3c8)
 #define dac_val	(0x3c9)
--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1463,6 +1463,43 @@ static u_long sm7xx_vram_probe(struct sm
 	return 0;  /* unknown hardware */
 }
 
+static void sm7xx_resolution_probe(struct smtcfb_info *sfb)
+{
+	/* get mode parameter from smtc_scr_info */
+	if (smtc_scr_info.lfb_width != 0) {
+		sfb->fb->var.xres = smtc_scr_info.lfb_width;
+		sfb->fb->var.yres = smtc_scr_info.lfb_height;
+		sfb->fb->var.bits_per_pixel = smtc_scr_info.lfb_depth;
+		goto final;
+	}
+
+	/*
+	 * No parameter, default resolution is 1024x768-16.
+	 *
+	 * FIXME: earlier laptops, such as IBM Thinkpad 240X, has a 800x600
+	 * panel, also see the comments about Thinkpad 240X above.
+	 */
+	sfb->fb->var.xres = SCREEN_X_RES;
+	sfb->fb->var.yres = SCREEN_Y_RES_PC;
+	sfb->fb->var.bits_per_pixel = SCREEN_BPP;
+
+#ifdef CONFIG_MIPS
+	/*
+	 * Loongson MIPS netbooks use 1024x600 LCD panels, which is the original
+	 * target platform of this driver, but nearly all old x86 laptops have
+	 * 1024x768. Lighting 768 panels using 600's timings would partially
+	 * garble the display, so we don't want that. But it's not possible to
+	 * distinguish them reliably.
+	 *
+	 * So we change the default to 768, but keep 600 as-is on MIPS.
+	 */
+	sfb->fb->var.yres = SCREEN_Y_RES_NETBOOK;
+#endif
+
+final:
+	big_pixel_depth(sfb->fb->var.bits_per_pixel, smtc_scr_info.lfb_depth);
+}
+
 static int smtcfb_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
@@ -1508,19 +1545,6 @@ static int smtcfb_pci_probe(struct pci_d
 
 	sm7xx_init_hw();
 
-	/* get mode parameter from smtc_scr_info */
-	if (smtc_scr_info.lfb_width != 0) {
-		sfb->fb->var.xres = smtc_scr_info.lfb_width;
-		sfb->fb->var.yres = smtc_scr_info.lfb_height;
-		sfb->fb->var.bits_per_pixel = smtc_scr_info.lfb_depth;
-	} else {
-		/* default resolution 1024x600 16bit mode */
-		sfb->fb->var.xres = SCREEN_X_RES;
-		sfb->fb->var.yres = SCREEN_Y_RES;
-		sfb->fb->var.bits_per_pixel = SCREEN_BPP;
-	}
-
-	big_pixel_depth(sfb->fb->var.bits_per_pixel, smtc_scr_info.lfb_depth);
 	/* Map address and memory detection */
 	mmio_base = pci_resource_start(pdev, 0);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &sfb->chip_rev_id);
@@ -1582,6 +1606,9 @@ static int smtcfb_pci_probe(struct pci_d
 		goto failed_fb;
 	}
 
+	/* probe and decide resolution */
+	sm7xx_resolution_probe(sfb);
+
 	/* can support 32 bpp */
 	if (sfb->fb->var.bits_per_pixel == 15)
 		sfb->fb->var.bits_per_pixel = 16;


