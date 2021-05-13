Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFE337FAD2
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhEMPf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234919AbhEMPf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECCA6611AC;
        Thu, 13 May 2021 15:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920087;
        bh=0yCacCO/B2IoL6j3pdAHlguv5iW9GsDKZFZbkVy3Iy4=;
        h=Subject:To:From:Date:From;
        b=ZI/THMr7nd0PcOu0i3oIU6rgJSLnQc7fn3Tb6zfO/YGOGPmOHqaBVOJ3VEk4KJRqA
         0PfjGsX46HP3SfiZXVuQAchLQZqVr3r7qaSGQy/vJhCFamrSiwpCmf6GajVFbfI4kI
         k9eILfX0ShNpNk8O6l8fsMnpGPEuKvumy2xjNVms=
Subject: patch "video: hgafb: fix potential NULL pointer dereference" added to char-misc-linus
To:     igormtorrente@gmail.com, b.zolnierkie@samsung.com,
        fero@drama.obuda.kando.hu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:20 +0200
Message-ID: <162092006022267@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    video: hgafb: fix potential NULL pointer dereference

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From dc13cac4862cc68ec74348a80b6942532b7735fa Mon Sep 17 00:00:00 2001
From: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Date: Mon, 3 May 2021 13:57:06 +0200
Subject: video: hgafb: fix potential NULL pointer dereference

The return of ioremap if not checked, and can lead to a NULL to be
assigned to hga_vram. Potentially leading to a NULL pointer
dereference.

The fix adds code to deal with this case in the error label and
changes how the hgafb_probe handles the return of hga_card_detect.

Cc: Ferenc Bakonyi <fero@drama.obuda.kando.hu>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-40-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hgafb.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
index fca29f219f8b..cc8e62ae93f6 100644
--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -285,6 +285,8 @@ static int hga_card_detect(void)
 	hga_vram_len  = 0x08000;
 
 	hga_vram = ioremap(0xb0000, hga_vram_len);
+	if (!hga_vram)
+		return -ENOMEM;
 
 	if (request_region(0x3b0, 12, "hgafb"))
 		release_io_ports = 1;
@@ -344,13 +346,18 @@ static int hga_card_detect(void)
 			hga_type_name = "Hercules";
 			break;
 	}
-	return 1;
+	return 0;
 error:
 	if (release_io_ports)
 		release_region(0x3b0, 12);
 	if (release_io_port)
 		release_region(0x3bf, 1);
-	return 0;
+
+	iounmap(hga_vram);
+
+	pr_err("hgafb: HGA card not detected.\n");
+
+	return -EINVAL;
 }
 
 /**
@@ -548,13 +555,11 @@ static const struct fb_ops hgafb_ops = {
 static int hgafb_probe(struct platform_device *pdev)
 {
 	struct fb_info *info;
+	int ret;
 
-	if (! hga_card_detect()) {
-		printk(KERN_INFO "hgafb: HGA card not detected.\n");
-		if (hga_vram)
-			iounmap(hga_vram);
-		return -EINVAL;
-	}
+	ret = hga_card_detect();
+	if (!ret)
+		return ret;
 
 	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",
 		hga_type_name, hga_vram_len/1024);
-- 
2.31.1


